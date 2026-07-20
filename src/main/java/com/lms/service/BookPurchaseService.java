package com.lms.service;

import com.lms.entity.BookPurchase;
import java.util.List;

public interface BookPurchaseService {
    void processPurchaseWithPayment(Long studentId, Long bookId, Double amount, String paymentId);

    BookPurchase savePurchase(BookPurchase purchase);

    List<BookPurchase> getAllPurchases();

    List<BookPurchase> getPurchasesByStudent(Long studentId);

    List<BookPurchase> getPurchasesByBook(Long bookId);

    boolean hasPurchased(Long studentId, Long bookId);

    boolean hasPurchasedSuccess(Long studentId, Long bookId);

    void processPurchase(Long studentId, Long bookId);
}
