package com.lms.repository;

import com.lms.entity.Chatbot;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChatbotRepository extends JpaRepository<Chatbot, Long> {

    // Login student ki complete chat history
    List<Chatbot> findByUserIdOrderByCreatedAsc(Long userId);

    // Latest chat 
    Chatbot findTopByUserIdOrderByCreatedDesc(Long userId);

}

