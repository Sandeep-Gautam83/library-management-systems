package com.lms.controller;

import com.lms.Enum.PaymentStatus;
import com.lms.Enum.PaymentType;
import com.lms.Enum.Role;
import com.lms.dto.UserDto;
import com.lms.entity.Book;
import com.lms.entity.Payment;
import com.lms.service.BookService;
import com.lms.service.PaymentService;
import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;
import com.razorpay.Utils;
import jakarta.servlet.http.HttpSession;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Objects;

@Controller
@RequestMapping("/payment")
public class PaymentController {

    private static final Logger log = LoggerFactory.getLogger(PaymentController.class);

    private final PaymentService paymentService;
    private final BookService bookService;

    @Value("${razorpay.key.id:}")
    private String razorpayKeyId;

    @Value("${razorpay.key.secret:}")
    private String razorpayKeySecret;

    public PaymentController(PaymentService paymentService, BookService bookService) {
        this.paymentService = paymentService;
        this.bookService = bookService;
    }

    // 1. GATEWAY INITIALIZATION & CHECKOUT OUTBOUND HOOK
    @GetMapping("/checkout")
    public String handleBookPaymentCheckout(@RequestParam("bookId") Long bookId,
                                            Model model,
                                            HttpSession session) {
        UserDto studentDto = getLoggedInStudent(session);
        if (studentDto == null) {
            log.warn("Unauthorized gateway access attempt. Secure session context is missing.");
            return "redirect:/login";
        }

        try {
            if (bookId == null) {
                return redirectToBookDetails(null, "error=invalid_book");
            }

            Book book = bookService.getBookById(bookId);
            if (book == null) {
                return redirectToBookDetails(null, "error=invalid_book");
            }

            if (!isPaidBook(book)) {
                return redirectToBookDetails(bookId, "error=free_book");
            }

            if (paymentService.hasBookAccess(studentDto.getId(), bookId)) {
                session.setAttribute("purchased_book_" + bookId, Boolean.TRUE);
                return redirectToBookDetails(bookId, "payment=already_purchased");
            }

            validateRazorpayConfiguration();

            int amountInPaise = toPaise(book.getPrice());
            if (amountInPaise <= 0) {
                return redirectToBookDetails(bookId, "error=invalid_amount");
            }

            RazorpayClient razorpay = new RazorpayClient(razorpayKeyId, razorpayKeySecret);

            JSONObject orderRequest = new JSONObject();
            orderRequest.put("amount", amountInPaise);
            orderRequest.put("currency", "INR");
            orderRequest.put("receipt", "txn_bk_" + bookId + "_st_" + studentDto.getId() + "_" + System.currentTimeMillis());

            Order order = razorpay.orders.create(orderRequest);
            if (order == null || !order.has("id")) {
                throw new RazorpayException("Failed to construct a unique structural checkout order identification token.");
            }

            String orderId = order.get("id").toString();

            // Store transaction logs inside database mappings as safe PENDING state
            paymentService.createPayment(buildPendingPayment(studentDto, book, orderId));

            // Populate metadata elements onto presentation views layer templates smoothly
            model.addAttribute("razorpayKey", razorpayKeyId);
            model.addAttribute("amount", amountInPaise);
            model.addAttribute("orderId", orderId);
            model.addAttribute("book", book);
            model.addAttribute("user", studentDto);

            return "payment-gateway";

        } catch (IllegalStateException e) {
            log.error("Configuration framework validation abort: {}", e.getMessage());
            return redirectToBookDetails(bookId, "error=missing_config");
        } catch (RazorpayException e) {
            log.error("API transmission state failed for resource asset ID {}: ", bookId, e);
            return redirectToBookDetails(bookId, "error=payment_init_failed");
        } catch (Exception e) {
            log.error("Core engine pipeline handling exception mapping execution context: ", e);
            return redirectToBookDetails(bookId, "error=server_error");
        }
    }

    @PostMapping("/verify")
    public String verifyPayment(@RequestParam("razorpay_order_id") String orderId,
                                @RequestParam("razorpay_payment_id") String paymentId,
                                @RequestParam("razorpay_signature") String signature,
                                @RequestParam(value = "bookId", required = false) Long requestedBookId,
                                HttpSession session) {
        try {
            UserDto studentDto = getLoggedInStudent(session);
            if (studentDto == null) {
                return "redirect:/login";
            }

            if (isBlank(orderId) || isBlank(paymentId) || isBlank(signature)) {
                return redirectToBookDetails(requestedBookId, "error=invalid_payment_request");
            }

            Payment payment = paymentService.getPaymentByOrderId(orderId);
            if (payment == null) {
                return redirectToBookDetails(requestedBookId, "error=payment_not_found");
            }

            if (!Objects.equals(payment.getStudentId(), studentDto.getId())) {
                return redirectToBookDetails(resolveBookId(requestedBookId, payment), "error=unauthorized_payment");
            }

            Long bookId = resolveBookId(requestedBookId, payment);

            JSONObject options = new JSONObject();
            options.put("razorpay_order_id", orderId);
            options.put("razorpay_payment_id", paymentId);
            options.put("razorpay_signature", signature);

            boolean isValid = false;
            try {
                isValid = Utils.verifyPaymentSignature(options, razorpayKeySecret);
            } catch (Exception sigEx) {
                log.error("Signature engine hashing trace validation fault parameter gap: ", sigEx);
            }

            if (isValid) {
                payment.setPaymentId(paymentId);
                payment.setTransactionId(paymentId);
                payment.setAccessGranted(true);
                payment.setPaymentDate(LocalDateTime.now());
                payment.setPaymentGateway(PaymentType.RAZORPAY);
                payment.setPaymentStatus(PaymentStatus.SUCCESS);

                paymentService.savePayment(payment);
                session.setAttribute("purchased_book_" + bookId, Boolean.TRUE);

                return "redirect:/payment/success?bookId=" + bookId;
            } else {
                payment.setPaymentStatus(PaymentStatus.FAILED);
                payment.setAccessGranted(false);
                paymentService.savePayment(payment);
                return redirectToBookDetails(bookId, "error=signature_mismatch");
            }

        } catch (Exception e) {
            log.error("Critical error while verifying client runtime transaction state indices: ", e);
            return redirectToBookDetails(requestedBookId, "error=verification_failed");
        }
    }

    @GetMapping("/success")
    public String confirmTransaction(@RequestParam("bookId") Long bookId) {
        return "redirect:/student/book-details/" + bookId + "?payment=success";
    }

    // =========================================================================
    // 3. TRANSACTION CANCELLATION FLOW OVERRIDES
    // =========================================================================
    @GetMapping("/cancel")
    public String cancelTransaction(@RequestParam(value = "bookId", required = false) Long bookId,
                                    @RequestParam(value = "orderId", required = false) String orderId,
                                    HttpSession session) {
        UserDto studentDto = getLoggedInStudent(session);
        if (studentDto != null && orderId != null && !orderId.isBlank()) {
            try {
                Payment payment = paymentService.getPaymentByOrderId(orderId);
                if (payment != null && Objects.equals(payment.getStudentId(), studentDto.getId())
                        && payment.getPaymentStatus() == PaymentStatus.PENDING) {
                    payment.setPaymentStatus(PaymentStatus.FAILED);
                    paymentService.savePayment(payment);
                    bookId = payment.getBookId();
                }
            } catch (Exception e) {
                log.error("Error setting verification pipeline failure parameters on user cancellation event.", e);
            }
        }
        return redirectToBookDetails(bookId, "payment=cancelled");
    }

    // =========================================================================
    // 4. STRATEGIC UTILITY PROCESSING HELPER METHODS
    // =========================================================================
    private Payment buildPendingPayment(UserDto studentDto, Book book, String orderId) {
        Payment payment = new Payment();
        payment.setStudentId(studentDto.getId());
        payment.setStudentName(studentDto.getFullName());
        payment.setStudentEmail(studentDto.getEmail());
        payment.setBookId(book.getId());
        payment.setBookTitle(book.getBookName());
        payment.setAmount(book.getPrice());
        payment.setCurrency("INR");
        payment.setOrderId(orderId);
        payment.setAccessGranted(false);
        payment.setPaymentDate(LocalDateTime.now());
        payment.setPaymentGateway(PaymentType.RAZORPAY);
        payment.setPaymentStatus(PaymentStatus.PENDING);
        return payment;
    }

    private UserDto getLoggedInStudent(HttpSession session) {
        if (session == null) return null;
        Object userObject = session.getAttribute("loggedInUser");
        if (userObject instanceof UserDto userDto) {
            // Mapped to compile-safe integrated Role Enum validation properties
            if (userDto.getRole() == Role.STUDENT) {
                return userDto;
            }
        }
        return null;
    }

    private boolean isPaidBook(Book book) {
        return book != null && book.getPrice() != null && book.getPrice() > 0;
    }

    private int toPaise(Double amount) {
        if (amount == null) return 0;
        return (int) Math.round(amount * 100);
    }

    private Long resolveBookId(Long requestedBookId, Payment payment) {
        return (payment != null && payment.getBookId() != null) ? payment.getBookId() : requestedBookId;
    }

    private void validateRazorpayConfiguration() {
        if (isBlank(razorpayKeyId) || isBlank(razorpayKeySecret)) {
            throw new IllegalStateException("Gateway setup properties missing from system deployment architecture environments.");
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String redirectToBookDetails(Long bookId, String query) {
        if (bookId == null) {
            return query == null ? "redirect:/student/dashboard" : "redirect:/student/dashboard?" + query;
        }
        return query == null ? "redirect:/student/book-details/" + bookId : "redirect:/student/book-details/" + bookId + "?" + query;
    }
}
