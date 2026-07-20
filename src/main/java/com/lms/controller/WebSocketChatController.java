package com.lms.controller;

import com.lms.dto.ChatMessageDto;
import com.lms.service.ChatMessageService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import java.time.LocalDateTime;

@Controller
public class WebSocketChatController {

    private static final Logger log = LoggerFactory.getLogger(WebSocketChatController.class);
    private final ChatMessageService chatService;

    public WebSocketChatController(ChatMessageService chatService) {
        this.chatService = chatService;
    }

    @MessageMapping("/chat.sendMessage")
    @SendTo("/topic/public")
    public ChatMessageDto sendMessage(@Payload ChatMessageDto message) {

        if (message == null) {
            log.warn("Null message object received.");
            return null;
        }

        if ("PRESENCE".equals(message.getMessageType())) {
            log.info("Presence notification received from senderId: {} [Status: {}]",
                    message.getSenderId(), message.getContent());
            if (message.getTimestamp() == null) {
                message.setTimestamp(LocalDateTime.now());
            }
            return message;
        }

        // Regular CHAT message content validations
        if (message.getContent() == null || message.getContent().trim().isEmpty()) {
            log.warn("Empty message content received from senderId: {}", message.getSenderId());
            return null;
        }
        else {
            // Timestamp initialization if it is missing
            if (message.getTimestamp() == null) {
                message.setTimestamp(LocalDateTime.now());
            }

            if ("USER".equals(message.getSenderRole()) &&
                    (message.getRecipientId() == null || message.getRecipientId() == 0)) {
                log.info("First message from student detected. Stripping invalid admin ID.");
            }

            try {
                log.info("Saving message from senderId: {} to recipientId: {}", message.getSenderId(), message.getRecipientId());
                return chatService.createComplain(message);
            } catch (Exception e) {
                log.error("Failed to persist message in DB, broadcasting fallback payload directly. Error: {}", e.getMessage(), e);
                return message;
            }
        }
    }

    @MessageMapping("/chat.typing")
    @SendTo("/topic/public")
    public ChatMessageDto broadcastTypingNotification(@Payload ChatMessageDto typingNotification) {

        if (typingNotification == null) {
            return null;
        }
        else {
            log.debug("Typing notification broadcasted from senderId: {} [Role: {}]",
                    typingNotification.getSenderId(), typingNotification.getSenderRole());
            return typingNotification;
        }
    }
}

