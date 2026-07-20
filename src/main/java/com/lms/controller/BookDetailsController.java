package com.lms.controller;

import com.lms.Enum.Role;
import com.lms.dto.UserDto;
import com.lms.entity.Book;
import com.lms.service.BookService;
import com.lms.service.PaymentService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/student")
public class BookDetailsController {

    private final BookService bookService;
    private final PaymentService paymentService;

    public BookDetailsController(BookService bookService, PaymentService paymentService) {
        this.bookService = bookService;
        this.paymentService = paymentService;
    }

    @GetMapping("/book-details/{id}")
    public String bookDetails(@PathVariable Long id, Model model, HttpSession session) {
        try {
            if (id == null) {
                return "redirect:/student/dashboard?error=invalid_id";
            }

            Book book = bookService.getBookById(id);
            if (book == null) {
                return "redirect:/student/dashboard?error=book_not_found";
            }

            // Extract similar category recommendations gracefully
            List<Book> similarBooks = new ArrayList<>();
            if (book.getCategory() != null) {
                similarBooks.addAll(bookService.getSimilarBooks(book.getCategory()));
                similarBooks.removeIf(b -> b.getId().equals(book.getId()));
                if (similarBooks.size() > 6) {
                    similarBooks = similarBooks.subList(0, 6);
                }
            }

            UserDto userDto = null;
            boolean isBookPurchased = false;

            // Session identification extraction via modern compile-safe UserDto
            Object userObject = session.getAttribute("loggedInUser");
            if (userObject instanceof UserDto sessionUserDto) {
                userDto = sessionUserDto;

                // Compile-Safe Integrated Enum Role Boundary matching checkpoint
                if (userDto.getRole() == Role.STUDENT) {
                    isBookPurchased = paymentService.hasBookAccess(userDto.getId(), id);
                    if (isBookPurchased) {
                        session.setAttribute("purchased_book_" + id, Boolean.TRUE);
                    }
                }
            }

            // Bind transaction metadata variables back to view presentation layout
            model.addAttribute("book", book);
            model.addAttribute("similarBooks", similarBooks);
            model.addAttribute("user", userDto);
            model.addAttribute("isBookPurchased", isBookPurchased);

            return "book-details";

        } catch (Exception e) {
            model.addAttribute("error", "An internal error occurred while parsing book details attributes.");
            return "redirect:/student/dashboard";
        }
    }
}

