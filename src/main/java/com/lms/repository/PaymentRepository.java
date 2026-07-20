package com.lms.repository;

import com.lms.Enum.PaymentStatus;
import com.lms.entity.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {

    Optional<Payment> findByPaymentId(String paymentId);

    Optional<Payment> findByOrderId(String orderId);

    List<Payment> findByStudentId(Long studentId);

    List<Payment> findByBookId(Long bookId);

    List<Payment> findByPaymentStatus(PaymentStatus paymentStatus);

    boolean existsByStudentIdAndBookIdAndPaymentStatus(Long studentId, Long bookId, PaymentStatus paymentStatus);

}


