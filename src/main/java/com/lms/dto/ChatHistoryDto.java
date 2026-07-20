package com.lms.dto;

import java.time.LocalDateTime;

public class ChatHistoryDto {

    private Long id;

    private String question;

    private String answer;

    private LocalDateTime created;

    public ChatHistoryDto() {
    }

    public ChatHistoryDto(Long id,
                          String question,
                          String answer,
                          LocalDateTime created) {
        this.id = id;
        this.question = question;
        this.answer = answer;
        this.created = created;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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

    public LocalDateTime getCreated() {
        return created;
    }

    public void setCreated(LocalDateTime created) {
        this.created = created;
    }
}