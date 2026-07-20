package com.lms.entity;
import com.lms.Enum.ChatbotMessageType;
import com.lms.Enum.ChatbotStatus;
import jakarta.persistence.*;
import java.time.LocalDateTime;


@Entity
@Table(name="chatbot_messages")
public class Chatbot {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Long userId;

    @Enumerated(EnumType.STRING)
    private ChatbotMessageType messageType;                       // user , chatbot

    @Column(columnDefinition="TEXT")
    private String question;

    @Column(columnDefinition="LONGTEXT")
    private String answer;

    @Enumerated(EnumType.STRING)
    private ChatbotStatus status;                              // Pending, Answered, Failed

    private LocalDateTime created;

    public Chatbot(Long id, Long userId, ChatbotMessageType messageType, String question, String answer, ChatbotStatus status, LocalDateTime created) {
        this.id = id;
        this.userId = userId;
        this.messageType = messageType;
        this.question = question;
        this.answer = answer;
        this.status = status;
        this.created = created;
    }

    public Chatbot() {

    }
    
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public ChatbotMessageType getMessageType() {
        return messageType;
    }

    public void setMessageType(ChatbotMessageType messageType) {
        this.messageType = messageType;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public ChatbotStatus getStatus() {
        return status;
    }

    public void setStatus(ChatbotStatus status) {
        this.status = status;
    }

    public LocalDateTime getCreated() {
        return created;
    }

    public void setCreated(LocalDateTime created) {
        this.created = created;
    }
}


