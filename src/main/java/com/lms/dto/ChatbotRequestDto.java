package com.lms.dto;
import jakarta.validation.constraints.NotBlank;

public class ChatbotRequestDto {

    @NotBlank(message = "Question is required")
    private String question;

    public ChatbotRequestDto() {
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }
}
