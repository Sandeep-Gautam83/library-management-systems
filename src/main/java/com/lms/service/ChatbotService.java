package com.lms.service;

import com.lms.dto.ChatHistoryDto;
import com.lms.dto.ChatbotRequestDto;
import com.lms.dto.ChatbotResponseDto;

import java.util.List;

public interface ChatbotService {

    ChatbotResponseDto askQuestion(Long userId, ChatbotRequestDto requestDto);

    List<ChatHistoryDto> getChatHistory(Long userId);

    ChatbotResponseDto getLatestChat(Long userId);

    void deleteChat(Long userId);

}
