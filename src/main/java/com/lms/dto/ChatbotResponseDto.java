package com.lms.dto;
import com.lms.Enum.ChatbotStatus;

public class ChatbotResponseDto {

    private String answer;
    private ChatbotStatus status;

    public ChatbotResponseDto() {
    }

    public ChatbotResponseDto(String answer, ChatbotStatus status) {
        this.answer = answer;
        this.status = status;
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
}