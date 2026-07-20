package com.lms.entity;

import com.lms.Enum.MessageType;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "chat_messages")
@Builder
public class ChatMessage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;

    @Enumerated(EnumType.STRING)
    @Column(name = "chat_messages", nullable = false)
    private MessageType messageType;

    @Builder.Default
    @Column(name = "timestamp", nullable = false)
    private LocalDateTime timestamp = LocalDateTime.now();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sender_id", nullable = false)
    private User sender;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "recipient_id")
    private User recipient;

    @OneToOne(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "attachment_id", referencedColumnName = "id")
    private FileUploads attachment;

    @Builder.Default
    @Column(name = "deleted_by_admin", nullable = false)
    private Boolean deletedByAdmin = false;

    @Builder.Default
    @Column(name = "deleted_by_user", nullable = false)
    private Boolean deletedByUser = false;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_message_id")
    private ChatMessage parentMessage;

    public ChatMessage(Long id, String content, MessageType messageType, LocalDateTime timestamp,
                       User user, User sender, User recipient, FileUploads attachment,
                       Boolean deletedByAdmin, Boolean deletedByUser, ChatMessage parentMessage) {
        this.id = id;
        this.content = content;
        this.messageType = messageType;
        this.timestamp = timestamp;
        this.user = user;
        this.sender = sender;
        this.recipient = recipient;
        this.attachment = attachment;
        this.deletedByAdmin = deletedByAdmin;
        this.deletedByUser = deletedByUser;
        this.parentMessage = parentMessage;
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

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public User getSender() {
        return sender;
    }

    public void setSender(User sender) {
        this.sender = sender;
    }

    public User getRecipient() {
        return recipient;
    }

    public void setRecipient(User recipient) {
        this.recipient = recipient;
    }

    public FileUploads getAttachment() {
        return attachment;
    }

    public void setAttachment(FileUploads attachment) {
        this.attachment = attachment;
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

    public ChatMessage getParentMessage() {
        return parentMessage;
    }

    public void setParentMessage(ChatMessage parentMessage) {
        this.parentMessage = parentMessage;
    }

    public ChatMessage() {
    }
}
