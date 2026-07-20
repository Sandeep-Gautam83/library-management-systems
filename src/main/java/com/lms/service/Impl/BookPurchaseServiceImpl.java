package com.lms.service.Impl;

import com.lms.entity.Book;
import com.lms.entity.BookPurchase;
import com.lms.entity.User;
import com.lms.repository.BookPurchaseRepository;
import com.lms.repository.BookRepository;
import com.lms.repository.UserRepository;
import com.lms.service.BookPurchaseService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class BookPurchaseServiceImpl implements BookPurchaseService {

    private final BookPurchaseRepository purchaseRepository;
    private final BookRepository bookRepository;
    private final UserRepository userRepository;

    public BookPurchaseServiceImpl(BookPurchaseRepository purchaseRepository,
                                   BookRepository bookRepository,
                                   UserRepository userRepository) {
        this.purchaseRepository = purchaseRepository;
        this.bookRepository = bookRepository;
        this.userRepository = userRepository;
    }

    @Override
    public BookPurchase savePurchase(BookPurchase purchase) {
        if (purchase == null) {
            throw new IllegalArgumentException("Purchase processing failed: Object payload is null.");
        }
        if (purchase.getStudentId() == null || purchase.getBookId() == null) {
            throw new IllegalArgumentException("Purchase mapping failed: Student ID and Book ID are mandatory fields.");
        }

        boolean alreadyOwned = hasPurchasedSuccess(purchase.getStudentId(), purchase.getBookId());
        if (alreadyOwned) {
            throw new IllegalStateException("Duplicate transaction: Student has already successfully purchased this book.");
        }

        if (purchase.getFullName() == null || purchase.getBookName() == null) {
            User student = userRepository.findById(purchase.getStudentId())
                    .orElseThrow(() -> new IllegalArgumentException("Student not found ID: " + purchase.getStudentId()));
            Book book = bookRepository.findById(purchase.getBookId())
                    .orElseThrow(() -> new IllegalArgumentException("Book not found ID: " + purchase.getBookId()));

            purchase.setFullName(student.getFullName());
            purchase.setBookName(book.getBookName());
        }

        return purchaseRepository.save(purchase);
    }

    @Override
    public void processPurchaseWithPayment(Long studentId, Long bookId, Double amount, String paymentId) {
        if (studentId == null || bookId == null) {
            throw new IllegalArgumentException("Process aborted: Student ID and Book ID cannot be null.");
        }
        if (amount == null) {
            throw new IllegalArgumentException("Process aborted: Valid payment transaction amount is required.");
        }
        if (paymentId == null || paymentId.trim().isEmpty()) {
            throw new IllegalArgumentException("Process aborted: Gateway payment transaction ID tracking is missing.");
        }

        Optional<User> studentOpt = userRepository.findById(studentId);
        if (studentOpt.isEmpty()) {
            throw new IllegalArgumentException("Data mismatch error: No student record found for ID: " + studentId);
        }
        User student = studentOpt.get();

        Optional<Book> bookOpt = bookRepository.findById(bookId);
        if (bookOpt.isEmpty()) {
            throw new IllegalArgumentException("Data mismatch error: No book record found for ID: " + bookId);
        }
        Book book = bookOpt.get();

        if (book.getAvailableQuantity() == null || book.getAvailableQuantity() <= 0) {
            throw new IllegalStateException("Inventory out of stock: The book '" + book.getBookName() + "' has no copies left.");
        }

        if (hasPurchasedSuccess(studentId, bookId)) {
            throw new IllegalStateException("Operation rejected: A successful purchase for this book already exists for student ID: " + studentId);
        }

        // 5. Update book stock count safely
        book.setAvailableQuantity(book.getAvailableQuantity() - 1);
        bookRepository.save(book);

        BookPurchase purchase = new BookPurchase();
        purchase.setStudentId(student.getId());
        purchase.setBookId(book.getId());

        purchase.setFullName(student.getFullName());
        purchase.setBookName(book.getBookName());

        purchase.setAmount(amount);
        purchase.setPaymentId(paymentId);
        purchase.setPurchaseDate(LocalDateTime.now());
        purchase.setStatus("SUCCESS");

        purchaseRepository.save(purchase);
    }

    @Override
    public void processPurchase(Long studentId, Long bookId) {
        // Safe standard fallback wrapper method execution
        processPurchaseWithPayment(studentId, bookId, 0.0, "DIRECT_FREE_BYPASS_" + System.currentTimeMillis());
    }

    @Override
    @Transactional(readOnly = true)
    public List<BookPurchase> getAllPurchases() {
        return purchaseRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public List<BookPurchase> getPurchasesByStudent(Long studentId) {
        if (studentId == null) {
            throw new IllegalArgumentException("Search validation failed: Student ID parameter cannot be null.");
        }
        return purchaseRepository.findByStudentId(studentId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<BookPurchase> getPurchasesByBook(Long bookId) {
        if (bookId == null) {
            throw new IllegalArgumentException("Search validation failed: Book ID parameter cannot be null.");
        }
        return purchaseRepository.findByBookId(bookId);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean hasPurchased(Long studentId, Long bookId) {
        if (studentId == null || bookId == null) {
            return false;
        }
        return purchaseRepository.existsByStudentIdAndBookId(studentId, bookId);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean hasPurchasedSuccess(Long studentId, Long bookId) {
        if (studentId == null || bookId == null) {
            return false;
        }
        return purchaseRepository.existsByStudentIdAndBookIdAndStatus(studentId, bookId, "SUCCESS");
    }
}
