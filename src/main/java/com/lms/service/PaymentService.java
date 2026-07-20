package com.lms.service;

import com.lms.entity.Payment;

import java.util.List;

public interface PaymentService {
    Payment savePayment(Payment payment);

    Payment getPaymentById(Long id);

    Payment getPaymentByPaymentId(String paymentId);

    Payment getPaymentByOrderId(String orderId);

    List<Payment> getAllPayments();

    List<Payment> getPaymentsByStudent(Long studentId);

    List<Payment> getPaymentsByBook(Long bookId);

    List<Payment> getPaymentsByStatus(String status);

    boolean hasBookAccess(Long studentId, Long bookId);

    void updatePaymentStatus(Long paymentId, String status);

    void deletePayment(Long id);

    Payment createPayment(Payment payment);

}

