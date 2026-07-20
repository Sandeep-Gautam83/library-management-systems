package com.lms.repository;

import com.lms.entity.BookPurchase;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BookPurchaseRepository extends JpaRepository<BookPurchase, Long> {
    List<BookPurchase> findByStudentId(Long studentId);

    List<BookPurchase> findByBookId(Long bookId);

    boolean existsByStudentIdAndBookId(Long studentId, Long bookId);

    boolean existsByStudentIdAndBookIdAndStatus(Long studentId, Long bookId, String status);
}

