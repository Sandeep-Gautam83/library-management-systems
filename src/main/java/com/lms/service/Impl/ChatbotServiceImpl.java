package com.lms.service.Impl;

import com.lms.dto.ChatHistoryDto;
import com.lms.dto.ChatbotRequestDto;
import com.lms.dto.ChatbotResponseDto;
import com.lms.entity.Chatbot;
import com.lms.entity.Book;
import com.lms.entity.Fine;
import com.lms.entity.IssueBook;
import com.lms.Enum.ChatbotMessageType;
import com.lms.Enum.ChatbotStatus;
import com.lms.repository.ChatbotRepository;
import com.lms.repository.BookRepository;
import com.lms.repository.FineRepository;
import com.lms.repository.IssueBookRepository;
import com.lms.repository.BookPurchaseRepository;
import com.lms.service.ChatbotService;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class ChatbotServiceImpl implements ChatbotService {

    private final ChatbotRepository chatbotRepository;
    private final BookRepository bookRepository;
    private final FineRepository fineRepository;
    private final IssueBookRepository issueBookRepository;
    private final RestTemplate restTemplate;

    @Value("${gemini.url}")
    private String geminiUrl;

    @Value("${gemini.api.key}")
    private String apiKey;

    public ChatbotServiceImpl(ChatbotRepository chatbotRepository,
                              BookRepository bookRepository,
                              FineRepository fineRepository,
                              IssueBookRepository issueBookRepository,
                              BookPurchaseRepository bookPurchaseRepository) {
        this.chatbotRepository = chatbotRepository;
        this.bookRepository = bookRepository;
        this.fineRepository = fineRepository;
        this.issueBookRepository = issueBookRepository;
        this.restTemplate = new RestTemplate();
    }


    @Override
    public ChatbotResponseDto askQuestion(Long userId, ChatbotRequestDto requestDto) {
        if (userId == null || requestDto == null || requestDto.getQuestion() == null || requestDto.getQuestion().trim().isEmpty()) {
            return new ChatbotResponseDto("Invalid request parameters.", ChatbotStatus.FAILED);
        }

        String question = requestDto.getQuestion();
        String answer;
        ChatbotStatus status;

        try {
            String contextualPrompt = buildAdvancedRagPrompt(userId, question);
            answer = callGeminiApi(contextualPrompt);
            status = ChatbotStatus.ANSWERED;
        } catch (Exception e) {
            answer = "Sorry, AI Assistant could not process your request at this moment. Please check back later.";
            status = ChatbotStatus.FAILED;
        }

        Chatbot chatbot = new Chatbot(
                null,
                userId,
                ChatbotMessageType.USER,
                question,
                answer,
                status,
                LocalDateTime.now()
        );

        chatbotRepository.save(chatbot);
        return new ChatbotResponseDto(answer, status);
    }


    private String buildAdvancedRagPrompt(Long userId, String userQuestion) {
        List<Book> books = bookRepository.findAll();
        String inventoryContext = books.stream()
                .map(b -> String.format("- '%s' by %s | Stock Left: %d | Cost: %s",
                        b.getBookName(), b.getAuthorName(), b.getAvailableQuantity(), b.getPrice()))
                .collect(Collectors.joining("\n"));

        List<IssueBook> issues = issueBookRepository.findAll();
        String activeIssuesContext = issues.stream()
                .filter(i -> userId.toString().equals(i.getRollNumber()))
                .map(i -> String.format("- Book: %s | Issue Date: %s | Due Date: %s | Status: %s",
                        i.getBookName(), i.getIssueDate(), i.getDueDate(), i.getStatus()))
                .collect(Collectors.joining("\n"));

        List<Fine> fines = fineRepository.findAll();
        String fineContext = fines.stream()
                .filter(f -> userId.toString().equals(f.getRollNumber()))
                .map(f -> String.format("- Book: %s | Fine Amt: ₹%s | Due Date: %s | Payment Status: %s",
                        f.getBookName(), f.getFineAmount(), f.getFineDate(), f.getFineStatus()))
                .collect(Collectors.joining("\n"));

        // Optimized System constraints for short & precise output mapping
        return "You are an expert AI Library Assistant built for an APEX Library Management System.\n"
                + "CRITICAL INSTRUCTIONS:\n"
                + "1. Keep responses highly focused, clear, standard, and short. Avoid long-winded introductions or verbose filler.\n"
                + "2. If a query is general technical, coding, academic, or historical, provide a brief, structured, high-density summary answer.\n"
                + "3. If a question concerns library details (books, outstanding fines, or due schedules), instantly verify utilizing the live contextual parameters provided below.\n"
                + "4. FORMATTING: Use markdown points ('- item') for direct lists, bold elements ('**text**') for vital parameters, and line spacing dynamically.\n\n"
                + "=== LIVE SYSTEM DATABASE CONTEXT ===\n"
                + "INVENTORY STATE:\n" + (inventoryContext.isEmpty() ? "None" : inventoryContext) + "\n"
                + "STUDENT ACTIVE ISSUES:\n" + (activeIssuesContext.isEmpty() ? "None" : activeIssuesContext) + "\n"
                + "STUDENT OUTSTANDING FINES:\n" + (fineContext.isEmpty() ? "None" : fineContext) + "\n\n"
                + "=== USER QUERY MESSAGE ===\n"
                + userQuestion;
    }

    @Override
    public List<ChatHistoryDto> getChatHistory(Long userId) {
        if (userId == null) return List.of();
        return chatbotRepository.findByUserIdOrderByCreatedAsc(userId).stream()
                .map(chat -> new ChatHistoryDto(chat.getId(), chat.getQuestion(), chat.getAnswer(), chat.getCreated()))
                .collect(Collectors.toList());
    }

    @Override
    public ChatbotResponseDto getLatestChat(Long userId) {
        if (userId == null) return null;
        Chatbot latestChat = chatbotRepository.findTopByUserIdOrderByCreatedDesc(userId);
        if (latestChat == null) return new ChatbotResponseDto("No conversation history found.", ChatbotStatus.PENDING);
        return new ChatbotResponseDto(latestChat.getAnswer(), latestChat.getStatus());
    }

    @Override
    public void deleteChat(Long userId) {
        if (userId == null) return;
        List<Chatbot> userChats = chatbotRepository.findByUserIdOrderByCreatedAsc(userId);
        if (userChats != null && !userChats.isEmpty()) {
            chatbotRepository.deleteAll(userChats);
        }
    }

    private String callGeminiApi(String prompt) {
        String fullUrl = geminiUrl + "?key=" + apiKey;
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        Map<String, Object> textMap = Map.of("text", prompt);
        Map<String, Object> partsMap = Map.of("parts", List.of(textMap));
        Map<String, Object> contentsMap = Map.of("contents", List.of(partsMap));

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(contentsMap, headers);
        Map<String, Object> response = restTemplate.postForObject(fullUrl, entity, Map.class);

        if (response != null && response.containsKey("candidates")) {
            List<?> candidates = (List<?>) response.get("candidates");
            if (!candidates.isEmpty()) {
                Map<?, ?> candidate = (Map<?, ?>) candidates.get(0);
                Map<?, ?> content = (Map<?, ?>) candidate.get("content");
                List<?> parts = (List<?>) content.get("parts");
                Map<?, ?> part = (Map<?, ?>) parts.get(0);
                return (String) part.get("text");
            }
        }
        throw new RuntimeException("Failed to pull payload from API server context.");
    }
}
