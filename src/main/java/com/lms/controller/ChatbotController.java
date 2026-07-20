package com.lms.controller;

import com.lms.dto.ChatHistoryDto;
import com.lms.dto.ChatbotRequestDto;
import com.lms.dto.ChatbotResponseDto;
import com.lms.service.ChatbotService;
import jakarta.servlet.http.HttpSession;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/chatbot")
public class ChatbotController {

    private final ChatbotService chatbotService;

    public ChatbotController(ChatbotService chatbotService) {
        this.chatbotService = chatbotService;
    }

    @PostMapping("/ask")
    public ResponseEntity<ChatbotResponseDto> askAiAssistant(@RequestBody ChatbotRequestDto requestDto, HttpSession session) {
        // Session se automatic logged-in userId extract karenge
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            userId = 1L;
        }

        if (requestDto.getQuestion() == null || requestDto.getQuestion().trim().isEmpty()) {
            return ResponseEntity.badRequest().body(new ChatbotResponseDto("Question cannot be empty.", com.lms.Enum.ChatbotStatus.FAILED));
        }

        ChatbotResponseDto responseDto = chatbotService.askQuestion(userId, requestDto);
        return ResponseEntity.ok(responseDto);
    }

    @GetMapping("/history")
    public ResponseEntity<List<ChatHistoryDto>> getChatHistory(HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            userId = 1L;
        }
        List<ChatHistoryDto> history = chatbotService.getChatHistory(userId);
        return ResponseEntity.ok(history);
    }

    @DeleteMapping("/clear")
    public ResponseEntity<String> clearChat(HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId != null) {
            chatbotService.deleteChat(userId);
        }
        return ResponseEntity.ok("Chat history deleted successfully.");
    }
}

