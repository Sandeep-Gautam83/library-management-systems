package com.lms.service.Impl;

import com.lms.Enum.PaymentStatus;
import com.lms.entity.Payment;
import com.lms.repository.PaymentRepository;
import com.lms.service.PaymentService;
import com.lms.service.BookPurchaseService; // Injecting Purchase Service
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@Transactional
public class PaymentServiceImpl implements PaymentService {

    private static final Logger log = LoggerFactory.getLogger(PaymentServiceImpl.class);

    private final PaymentRepository paymentRepository;
    private final BookPurchaseService bookPurchaseService; // Added reference

    // Constructor Injection updated
    public PaymentServiceImpl(PaymentRepository paymentRepository, BookPurchaseService bookPurchaseService) {
        this.paymentRepository = paymentRepository;
        this.bookPurchaseService = bookPurchaseService;
    }

    @Override
    public Payment savePayment(Payment payment) {
        if (payment == null) {
            throw new IllegalArgumentException("Payment cannot be null");
        }

        if (payment.getPaymentStatus() == PaymentStatus.SUCCESS
                && payment.getStudentId() != null
                && payment.getBookId() != null
                && hasBookAccess(payment.getStudentId(), payment.getBookId())) {

            throw new IllegalStateException("Student already has access to this book.");
        }

        if (payment.getPaymentStatus() == PaymentStatus.SUCCESS) {
            payment.setAccessGranted(true);
        }

        Payment savedPayment = paymentRepository.save(payment);

        // CRUCIAL FIX: If payment is successfully saved as SUCCESS, create the Book Purchase entry
        if (savedPayment.getPaymentStatus() == PaymentStatus.SUCCESS) {
            bookPurchaseService.processPurchaseWithPayment(
                    savedPayment.getStudentId(),
                    savedPayment.getBookId(),
                    savedPayment.getAmount(),
                    savedPayment.getPaymentId() != null ? savedPayment.getPaymentId() : "PAY_GW_" + savedPayment.getId()
            );
            log.info("Auto-sync: Book Purchase record triggered successfully for Student: {}", savedPayment.getStudentId());
        }

        return savedPayment;
    }

    @Override
    public void updatePaymentStatus(Long paymentId, String status) {
        Payment payment = getPaymentById(paymentId);
        PaymentStatus paymentStatus = PaymentStatus.valueOf(status.toUpperCase());
        payment.setPaymentStatus(paymentStatus);

        if (paymentStatus == PaymentStatus.SUCCESS) {
            payment.setAccessGranted(true);
            payment.setPaymentDate(LocalDateTime.now());

            paymentRepository.save(payment); // Save status first

            // CRUCIAL FIX: When status transitions to SUCCESS via Webhook/API
            bookPurchaseService.processPurchaseWithPayment(
                    payment.getStudentId(),
                    payment.getBookId(),
                    payment.getAmount(),
                    payment.getPaymentId() != null ? payment.getPaymentId() : "PAY_UPD_" + payment.getId()
            );
            log.info("Auto-sync: Status changed to SUCCESS. Book Purchase generated.");

        } else {
            if (paymentStatus == PaymentStatus.FAILED || paymentStatus == PaymentStatus.REFUNDED) {
                payment.setAccessGranted(false);
            }
            paymentRepository.save(payment);
        }

        log.info("Payment status updated. Payment ID: {}, Status: {}", paymentId, paymentStatus);
    }

    @Override
    public Payment createPayment(Payment payment) {
        if (payment == null) {
            throw new IllegalArgumentException("Payment details cannot be null");
        }
        if (payment.getAmount() == null || payment.getAmount() <= 0) {
            throw new IllegalArgumentException("Amount must be greater than zero");
        }

        log.info("Creating payment for student ID: {}", payment.getStudentId());

        if (payment.getPaymentStatus() == null) {
            payment.setPaymentStatus(PaymentStatus.PENDING);
        }
        if (payment.getAccessGranted() == null) {
            payment.setAccessGranted(false);
        }
        if (payment.getPaymentDate() == null) {
            payment.setPaymentDate(LocalDateTime.now());
        }

        Payment savedPayment = paymentRepository.save(payment);
        log.info("Payment created successfully with ID: {}", savedPayment.getId());

        // CRUCIAL FIX: If initial creation itself is directly SUCCESS (e.g., Free books / Direct payments)
        if (savedPayment.getPaymentStatus() == PaymentStatus.SUCCESS) {
            bookPurchaseService.processPurchaseWithPayment(
                    savedPayment.getStudentId(),
                    savedPayment.getBookId(),
                    savedPayment.getAmount(),
                    savedPayment.getPaymentId() != null ? savedPayment.getPaymentId() : "PAY_CR_" + savedPayment.getId()
            );
        }

        return savedPayment;
    }

    // ==========================================
    // READ-ONLY STANDARD QUERIES (NO CHANGES)
    // ==========================================

    @Override
    @Transactional(readOnly = true)
    public Payment getPaymentById(Long id) {
        return paymentRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Payment not found with ID: " + id));
    }

    @Override
    @Transactional(readOnly = true)
    public Payment getPaymentByPaymentId(String paymentId) {
        return paymentRepository.findByPaymentId(paymentId)
                .orElseThrow(() -> new IllegalArgumentException("Payment not found with Payment ID: " + paymentId));
    }

    @Override
    @Transactional(readOnly = true)
    public Payment getPaymentByOrderId(String orderId) {
        return paymentRepository.findByOrderId(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Payment not found with Order ID: " + orderId));
    }

    @Override
    @Transactional(readOnly = true)
    public List<Payment> getAllPayments() {
        return paymentRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Payment> getPaymentsByStudent(Long studentId) {
        return paymentRepository.findByStudentId(studentId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Payment> getPaymentsByBook(Long bookId) {
        return paymentRepository.findByBookId(bookId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Payment> getPaymentsByStatus(String status) {
        try {
            PaymentStatus paymentStatus = PaymentStatus.valueOf(status.toUpperCase());
            return paymentRepository.findByPaymentStatus(paymentStatus);
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Invalid payment status: " + status);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public boolean hasBookAccess(Long studentId, Long bookId) {
        if (studentId == null || bookId == null) {
            return false;
        }
        return paymentRepository.existsByStudentIdAndBookIdAndPaymentStatus(studentId, bookId, PaymentStatus.SUCCESS);
    }

    @Override
    public void deletePayment(Long id) {
        if (!paymentRepository.existsById(id)) {
            throw new IllegalArgumentException("Payment not found with ID: " + id);
        }
        paymentRepository.deleteById(id);
        log.info("Payment deleted successfully: {}", id);
    }
}
