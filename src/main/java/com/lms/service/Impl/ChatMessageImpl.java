package com.lms.service.Impl;

import com.lms.Enum.MessageType;
import com.lms.Enum.Role;
import com.lms.dto.ChatMessageDto;
import com.lms.entity.ChatMessage;
import com.lms.entity.FileUploads;
import com.lms.entity.User;
import com.lms.repository.ChatMessageRepository;
import com.lms.repository.FileUploadRepository;
import com.lms.repository.UserRepository;
import com.lms.service.ChatMessageService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import jakarta.transaction.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class ChatMessageImpl implements ChatMessageService {

    private final ChatMessageRepository chatMessageRepository;
    private final UserRepository userRepository;
    private final FileUploadRepository fileUploadRepository;

    public ChatMessageImpl(ChatMessageRepository chatMessageRepository,
                           UserRepository userRepository,
                           FileUploadRepository fileUploadRepository) {
        this.chatMessageRepository = chatMessageRepository;
        this.userRepository = userRepository;
        this.fileUploadRepository = fileUploadRepository;
    }

    @Override
    public ChatMessageDto createComplain(ChatMessageDto dto) {
        if (dto == null || dto.getSenderId() == null) {
            throw new IllegalArgumentException("Complaint creation failed: Invalid chat message data payload.");
        }

        Optional<User> senderOpt = userRepository.findById(dto.getSenderId());
        if (senderOpt.isEmpty()) {
            throw new EntityNotFoundException("Sender profile not found for ID: " + dto.getSenderId());
        }
        User sender = senderOpt.get();

        MessageType finalType = MessageType.TEXT;
        if (dto.getMessageType() != null) {
            finalType = dto.getMessageType();
        }

        // Initialize Builder
        ChatMessage.ChatMessageBuilder builder = ChatMessage.builder()
                .content(dto.getContent())
                .messageType(finalType)
                .sender(sender)
                .user(sender)
                .timestamp(LocalDateTime.now())
                .deletedByAdmin(false)
                .deletedByUser(false);

        // 1. Handling Recipient using if-else
        if (dto.getRecipientId() != null) {
            Optional<User> recipientOpt = userRepository.findById(dto.getRecipientId());
            if (recipientOpt.isPresent()) {
                builder.recipient(recipientOpt.get());
            }
        }

        // 2. Handling Attachments using if-else
        if (dto.getAttachmentId() != null) {
            Optional<FileUploads> fileOpt = fileUploadRepository.findById(dto.getAttachmentId());
            if (fileOpt.isPresent()) {
                builder.attachment(fileOpt.get());
            }
        }

//        // 3. Handling Parent Message (Reply feature) using if-else
//        if (dto.getParentMessageId() != null) {
//            Optional<ChatMessage> parentOpt = chatMessageRepository.findById(dto.getParentMessageId());
//            if (parentOpt.isPresent()) {
//                builder.parentMessage(parentOpt.get());
//            }
//        }

        ChatMessage savedMessage = chatMessageRepository.save(builder.build());
        return ChatMessageDto.fromEntity(savedMessage);
    }

    @Override
    public ChatMessageDto saveAndBroadcastMessage(Long senderId, Long recipientId, String content, MessageType type) {
        if (senderId == null) {
            throw new IllegalArgumentException("Transmission aborted: Sender ID is mandatory.");
        }

        Optional<User> senderOpt = userRepository.findById(senderId);
        if (senderOpt.isEmpty()) {
            throw new EntityNotFoundException("Transmission aborted: Sender missing from records.");
        }
        User sender = senderOpt.get();

        MessageType finalType = MessageType.TEXT;
        if (type != null) {
            finalType = type;
        }

        ChatMessage.ChatMessageBuilder msgBuilder = ChatMessage.builder()
                .content(content)
                .messageType(finalType)
                .sender(sender)
                .user(sender)
                .timestamp(LocalDateTime.now())
                .deletedByAdmin(false)
                .deletedByUser(false);

        // Strict validation check for Recipient using if-else
        if (recipientId != null) {
            Optional<User> recipientOpt = userRepository.findById(recipientId);
            if (recipientOpt.isEmpty()) {
                throw new EntityNotFoundException("Transmission aborted: Recipient profile targets are missing.");
            }
            msgBuilder.recipient(recipientOpt.get());
        }

        // CRUCIAL FIX: DTO se check karne ke liye ya specific methods me attachment parameter dynamic map karne ka option
        // Agar real chat content image ya file path detect kare, toh null handle karne ki strategy:
        ChatMessage dynamicMsg = chatMessageRepository.save(msgBuilder.build());
        return ChatMessageDto.fromEntity(dynamicMsg);
    }

    // Overloaded easy method support for real-time media transfers
    public ChatMessageDto saveAndBroadcastMediaMessage(Long senderId, Long recipientId, String content, MessageType type, Long attachmentId, Long parentMsgId) {
        if (senderId == null) {
            throw new IllegalArgumentException("Sender ID cannot be null.");
        }

        Optional<User> senderOpt = userRepository.findById(senderId);
        if (senderOpt.isEmpty()) {
            throw new EntityNotFoundException("Sender not found.");
        }
        User sender = senderOpt.get();

        ChatMessage.ChatMessageBuilder builder = ChatMessage.builder()
                .content(content)
                .messageType(type != null ? type : MessageType.TEXT)
                .sender(sender)
                .user(sender)
                .timestamp(LocalDateTime.now())
                .deletedByAdmin(false)
                .deletedByUser(false);

        // Recipient map check
        if (recipientId != null) {
            Optional<User> recipientOpt = userRepository.findById(recipientId);
            if (recipientOpt.isPresent()) {
                builder.recipient(recipientOpt.get());
            }
        }

        // Attachment mapping fix
        if (attachmentId != null) {
            Optional<FileUploads> fileOpt = fileUploadRepository.findById(attachmentId);
            if (fileOpt.isPresent()) {
                builder.attachment(fileOpt.get());
            }
        }

        // Parent Message mapping fix
        if (parentMsgId != null) {
            Optional<ChatMessage> parentOpt = chatMessageRepository.findById(parentMsgId);
            if (parentOpt.isPresent()) {
                builder.parentMessage(parentOpt.get());
            }
        }

        return ChatMessageDto.fromEntity(chatMessageRepository.save(builder.build()));
    }

    @Override
    public void executePageSoftDelete(Long messageId, String userRole) {
        if (messageId == null || userRole == null || userRole.isBlank()) {
            throw new IllegalArgumentException("Soft delete rejected: Mandatory parameter contexts are empty.");
        }

        Optional<ChatMessage> msgOpt = chatMessageRepository.findById(messageId);
        if (msgOpt.isEmpty()) {
            throw new EntityNotFoundException("Soft hide failed. Target message sequence missing: " + messageId);
        }

        ChatMessage message = msgOpt.get();

        // Evaluate flags cleanly using standard if-else logic
        if (Role.ADMIN.toString().equalsIgnoreCase(userRole)) {
            message.setDeletedByAdmin(true);
        } else if (Role.STUDENT.toString().equalsIgnoreCase(userRole)) {
            message.setDeletedByUser(true);
        } else {
            throw new IllegalArgumentException("Action denied: Unauthorized role assignment context.");
        }

        // Hard clear from disk only if both sides clicked hide
        if (message.getDeletedByAdmin() && message.getDeletedByUser()) {
            chatMessageRepository.delete(message);
        } else {
            chatMessageRepository.save(message);
        }
    }

    @Override
    public ChatMessageDto updateComplaintStatus(Long id, String status) {
        if (id == null || status == null || status.isBlank()) {
            throw new IllegalArgumentException("Parameters and Status criteria metrics cannot be empty.");
        }

        Optional<ChatMessage> msgOpt = chatMessageRepository.findById(id);
        if (msgOpt.isEmpty()) {
            throw new EntityNotFoundException("Message tracking link broken for ID: " + id);
        }

        ChatMessage message = msgOpt.get();
        message.setContent(message.getContent() + " [Status Updated To: " + status.toUpperCase() + "]");
        return ChatMessageDto.fromEntity(chatMessageRepository.save(message));
    }

    @Override
    public ChatMessageDto getComplainById(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Message tracking ID cannot be null.");
        }
        Optional<ChatMessage> msgOpt = chatMessageRepository.findById(id);
        if (msgOpt.isEmpty()) {
            throw new EntityNotFoundException("Message record does not exist for ID: " + id);
        }
        return ChatMessageDto.fromEntity(msgOpt.get());
    }

    @Override
    public void deleteComplaint(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Target identity mapping parameter cannot be null.");
        }
        if (!chatMessageRepository.existsById(id)) {
            throw new EntityNotFoundException("Delete aborted. Message record not found for ID: " + id);
        }
        chatMessageRepository.deleteById(id);
    }

    @Override
    public List<ChatMessageDto> getAllComplaints() {
        return chatMessageRepository.findAll().stream()
                .filter(msg -> msg.getDeletedByAdmin() != null && !msg.getDeletedByAdmin())
                .map(ChatMessageDto::fromEntity)
                .collect(Collectors.toList());
    }

    @Override
    public List<ChatMessageDto> getComplaintsByUserId(Long userId) {
        if (userId == null) {
            throw new IllegalArgumentException("User constraint mapping cannot be null.");
        }
        return chatMessageRepository.findByUserId(userId).stream()
                .map(ChatMessageDto::fromEntity)
                .collect(Collectors.toList());
    }

    @Override
    public List<ChatMessageDto> getChatHistoryBetween(Long userId, Long adminId) {
        return chatMessageRepository.findBySenderIdAndRecipientIdOrderByTimestampAsc(userId, adminId).stream()
                .map(ChatMessageDto::fromEntity)
                .collect(Collectors.toList());
    }

    @Override
    public List<ChatMessageDto> getConversationHistoryForStudent(Long studentId, Long adminId) {
        return chatMessageRepository.findConversationForStudent(studentId, adminId).stream()
                .map(ChatMessageDto::fromEntity)
                .collect(Collectors.toList());
    }

    @Override
    public List<ChatMessageDto> getConversationHistoryForAdmin(Long adminId, Long studentId) {
        return chatMessageRepository.findConversationForAdmin(adminId, studentId).stream()
                .map(ChatMessageDto::fromEntity)
                .collect(Collectors.toList());
    }

    @Override
    public List<ChatMessageDto> getAdminSandboxScratchpad(Long adminId) {
        return chatMessageRepository.findAdminSandboxMessages(adminId).stream()
                .map(ChatMessageDto::fromEntity)
                .collect(Collectors.toList());
    }

    @Override
    public List<ChatMessageDto> getAllMessagesForStudent(Long studentId) {
        return chatMessageRepository.findAllMessagesForStudent(studentId).stream()
                .map(ChatMessageDto::fromEntity)
                .collect(Collectors.toList());
    }
}
