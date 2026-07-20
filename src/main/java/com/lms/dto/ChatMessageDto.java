package com.lms.dto;

import com.lms.Enum.MessageType;
import lombok.*;
import java.time.LocalDateTime;

@Builder
public class ChatMessageDto {

    private Long id;
    private String content;
    private MessageType messageType;
    private LocalDateTime timestamp;

    private Long senderId;
    private String fullName;
    private String rollNumber;

    private String senderName;
    private String senderRole; // "USER" or "ADMIN"

    private Long recipientId;
    private String recipientName;
    private String recipientRole;

    private Long attachmentId;
    private String attachmentName;
    private String attachmentType;
    private String attachmentUrl;

    private Boolean deletedByAdmin;
    private Boolean deletedByUser;

    public ChatMessageDto(Long id, String content, MessageType messageType, LocalDateTime timestamp,
                          Long senderId, String fullName, String rollNumber, String senderName,
                          String senderRole, Long recipientId, String recipientName,
                          String recipientRole, Long attachmentId, String attachmentName, String attachmentType,
                          String attachmentUrl, Boolean deletedByAdmin, Boolean deletedByUser) {
        this.id = id;
        this.content = content;
        this.messageType = messageType;
        this.timestamp = timestamp;
        this.senderId = senderId;
        this.fullName = fullName;
        this.rollNumber = rollNumber;
        this.senderName = senderName;
        this.senderRole = senderRole;
        this.recipientId = recipientId;
        this.recipientName = recipientName;
        this.recipientRole = recipientRole;
        this.attachmentId = attachmentId;
        this.attachmentName = attachmentName;
        this.attachmentType = attachmentType;
        this.attachmentUrl = attachmentUrl;
        this.deletedByAdmin = deletedByAdmin;
        this.deletedByUser = deletedByUser;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public MessageType getMessageType() {
        return messageType;
    }

    public void setMessageType(MessageType messageType) {
        this.messageType = messageType;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

    public Long getSenderId() {
        return senderId;
    }

    public void setSenderId(Long senderId) {
        this.senderId = senderId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getRollNumber() {
        return rollNumber;
    }

    public void setRollNumber(String rollNumber) {
        this.rollNumber = rollNumber;
    }

    public String getSenderName() {
        return senderName;
    }

    public void setSenderName(String senderName) {
        this.senderName = senderName;
    }

    public String getSenderRole() {
        return senderRole;
    }

    public void setSenderRole(String senderRole) {
        this.senderRole = senderRole;
    }

    public Long getRecipientId() {
        return recipientId;
    }

    public void setRecipientId(Long recipientId) {
        this.recipientId = recipientId;
    }

    public String getRecipientName() {
        return recipientName;
    }

    public void setRecipientName(String recipientName) {
        this.recipientName = recipientName;
    }

    public String getRecipientRole() {
        return recipientRole;
    }

    public void setRecipientRole(String recipientRole) {
        this.recipientRole = recipientRole;
    }

    public Long getAttachmentId() {
        return attachmentId;
    }

    public void setAttachmentId(Long attachmentId) {
        this.attachmentId = attachmentId;
    }

    public String getAttachmentName() {
        return attachmentName;
    }

    public void setAttachmentName(String attachmentName) {
        this.attachmentName = attachmentName;
    }

    public String getAttachmentType() {
        return attachmentType;
    }

    public void setAttachmentType(String attachmentType) {
        this.attachmentType = attachmentType;
    }

    public String getAttachmentUrl() {
        return attachmentUrl;
    }

    public void setAttachmentUrl(String attachmentUrl) {
        this.attachmentUrl = attachmentUrl;
    }

    public Boolean getDeletedByAdmin() {
        return deletedByAdmin;
    }

    public void setDeletedByAdmin(Boolean deletedByAdmin) {
        this.deletedByAdmin = deletedByAdmin;
    }

    public Boolean getDeletedByUser() {
        return deletedByUser;
    }

    public void setDeletedByUser(Boolean deletedByUser) {
        this.deletedByUser = deletedByUser;
    }

    public ChatMessageDto() {

    }

    public static ChatMessageDto fromEntity(com.lms.entity.ChatMessage message) {
        if (message == null) return null;
        ChatMessageDtoBuilder builder = ChatMessageDto.builder()
                .id(message.getId())
                .content(message.getContent())
                .messageType(message.getMessageType())
                .timestamp(message.getTimestamp())
                .deletedByAdmin(message.getDeletedByAdmin())
                .deletedByUser(message.getDeletedByUser());

        if (message.getSender() != null) {
            builder.senderId(message.getSender().getId())
                    .fullName(message.getSender().getFullName())
                    .rollNumber(message.getSender().getRollNumber())
                    .senderRole(String.valueOf(message.getSender().getRole()));
        }
        if (message.getRecipient() != null) {
            builder.recipientId(message.getRecipient().getId())
                    .recipientName(message.getRecipient().getFullName())
                    .recipientRole(String.valueOf(message.getRecipient().getRole()));
        }
        if (message.getAttachment() != null) {
            builder.attachmentId(message.getAttachment().getId())
                    .attachmentName(message.getAttachment().getFileName())
                    .attachmentType(String.valueOf(message.getAttachment().getFileType()))
                    .attachmentUrl(message.getAttachment().getFilePath());
        }
        return builder.build();
    }
}
