package com.lms.repository;

import com.lms.entity.ChatMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long> {

    List<ChatMessage> findByParentMessageIsNull();

    List<ChatMessage> findByUserId(Long userId);

    List<ChatMessage> findBySenderIdAndRecipientIdOrderByTimestampAsc(Long senderId, Long recipientId);

    /**
     * 6. Global Student Chat History (Kewal Student ID ke aadhar par)
     * Jab page refresh ho aur adminId exact na pata ho, tab bhi saare received aur sent messages load honge.
     */
    @Query("SELECT m FROM ChatMessage m WHERE " +
            "(m.sender.id = :studentId OR m.recipient.id = :studentId) " +
            "AND m.deletedByUser = false " +
            "ORDER BY m.timestamp ASC")
    List<ChatMessage> findAllMessagesForStudent(@Param("studentId") Long studentId);


    /**
     * 3. Student Chat View Filter
     * Student aur Admin ke beech ki conversation load karta hai (Jo student ne delete na ki ho).
     */
    @Query("SELECT m FROM ChatMessage m WHERE " +
            "((m.sender.id = :studentId AND m.recipient.id = :adminId) OR " +
            "(m.sender.id = :adminId AND m.recipient.id = :studentId)) " +
            "AND m.deletedByUser = false " +
            "ORDER BY m.timestamp ASC")
    List<ChatMessage> findConversationForStudent(@Param("studentId") Long studentId, @Param("adminId") Long adminId);

    /**
     * 4. Admin Chat View Filter
     * Admin aur select kiye gaye Student ke beech ki conversation load karta hai (Jo admin ne delete na ki ho).
     */
    @Query("SELECT m FROM ChatMessage m WHERE " +
            "((m.sender.id = :adminId AND m.recipient.id = :studentId) OR " +
            "(m.sender.id = :studentId AND m.recipient.id = :adminId)) " +
            "AND m.deletedByAdmin = false " +
            "ORDER BY m.timestamp ASC")
    List<ChatMessage> findConversationForAdmin(@Param("adminId") Long adminId, @Param("studentId") Long studentId);

    /**
     * 5. Admin HUD / Sandbox Scratchpad
     * Jab Admin ne kisi student ko select nahi kiya ho, tab loopback self-chat logs yahan se load honge.
     */
    @Query("SELECT m FROM ChatMessage m WHERE " +
            "m.sender.id = :adminId " +
            "AND m.recipient IS NULL " +
            "AND m.deletedByAdmin = false " +
            "ORDER BY m.timestamp ASC")
    List<ChatMessage> findAdminSandboxMessages(@Param("adminId") Long adminId);

    void deleteBySenderIdOrRecipientId(Long id, Long id1);

}


