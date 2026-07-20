package com.lms.service;

import com.lms.Enum.MessageType;
import com.lms.dto.ChatMessageDto;
import java.util.List;

public interface ChatMessageService {

    ChatMessageDto createComplain(ChatMessageDto chatMessageDto);

    ChatMessageDto getComplainById(Long id);

    List<ChatMessageDto> getAllComplaints();

    List<ChatMessageDto> getComplaintsByUserId(Long userId);

    ChatMessageDto updateComplaintStatus(Long id, String status);

    void deleteComplaint(Long id);

    List<ChatMessageDto> getChatHistoryBetween(Long userId, Long adminId);

    ChatMessageDto saveAndBroadcastMessage(Long senderId, Long recipientId, String content, MessageType type);

    List<ChatMessageDto> getConversationHistoryForStudent(Long studentId, Long adminId);

    List<ChatMessageDto> getConversationHistoryForAdmin(Long adminId, Long studentId);

    List<ChatMessageDto> getAdminSandboxScratchpad(Long adminId);

    void executePageSoftDelete(Long messageId, String userRole);

    List<ChatMessageDto> getAllMessagesForStudent(Long studentId);
}
