package com.lms.controller;

import com.lms.entity.BookPurchase;
import com.lms.service.BookPurchaseService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/book-purchases")
public class BookPurchaseController {

    private final BookPurchaseService bookPurchaseService;

    public BookPurchaseController(BookPurchaseService bookPurchaseService) {
        this.bookPurchaseService = bookPurchaseService;
    }

    @GetMapping
    public String getAllPurchases(Model model) {
        List<BookPurchase> purchases = bookPurchaseService.getAllPurchases();
        model.addAttribute("purchases", purchases);
        return "purchase/list";
    }

    @GetMapping("/student/{studentId}")
    public String getStudentPurchases(@PathVariable Long studentId, Model model) {
        List<BookPurchase> purchases = bookPurchaseService.getPurchasesByStudent(studentId);

        model.addAttribute("purchases", purchases);
        model.addAttribute("studentId", studentId);
        return "purchase/student-purchases";
    }

    @GetMapping("/book/{bookId}")
    public String getBookPurchases(@PathVariable Long bookId, Model model) {
        List<BookPurchase> purchases = bookPurchaseService.getPurchasesByBook(bookId);

        model.addAttribute("purchases", purchases);
        model.addAttribute("bookId", bookId);
        return "purchase/book-purchases";
    }

    @PostMapping("/checkout")
    public String processPurchase(@RequestParam("studentId") Long studentId, @RequestParam("bookId") Long bookId, RedirectAttributes redirectAttributes) {
        try {
            bookPurchaseService.processPurchase(studentId, bookId);
            redirectAttributes.addFlashAttribute("success", "Book purchased successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", getErrorMessage(e));
        }
        return "redirect:/book-purchases/student/" + studentId;
    }

    private String getErrorMessage(Exception e) {
        if (e.getMessage() != null && !e.getMessage().isBlank()) {
            return e.getMessage();
        }
        return "An error occurred while processing your purchase transaction.";
    }
}


