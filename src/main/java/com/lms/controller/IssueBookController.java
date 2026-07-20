package com.lms.controller;

import com.lms.dto.UserDto;
import com.lms.entity.Fine;
import com.lms.entity.IssueBook;
import com.lms.service.BookService;
import com.lms.service.FineService;
import com.lms.service.IssueBookService;
import com.lms.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@Controller
@RequestMapping("/admin/issue-book")
public class IssueBookController {

    private final IssueBookService issueBookService;
    private final UserService userService;
    private final BookService bookService;
    private final FineService fineService;

    public IssueBookController(IssueBookService issueBookService,
                               UserService userService,
                               BookService bookService,
                               FineService fineService) {
        this.issueBookService = issueBookService;
        this.userService = userService;
        this.bookService = bookService;
        this.fineService = fineService;
    }

    // 1. LOAD DASHBOARD VIEWS
    @GetMapping
    public String issueBookPage(Model model) {
        try {
            model.addAttribute("students", userService.getApprovedStudents());
            model.addAttribute("books", bookService.getAllBooks());
            model.addAttribute("issuedBooks", issueBookService.getAllIssuedBooks());
        } catch (Exception e) {
            model.addAttribute("error", "Failed to populate issuance dashboard context layers.");
        }
        return "issue-book";
    }

    @GetMapping("/return-book")
    public String returnBookPage(Model model) {
        try {
            model.addAttribute("issuedBooks", issueBookService.getAllIssuedBooks());
        } catch (Exception e) {
            model.addAttribute("error", "Failed to populate return logs matrix registry lists.");
        }
        return "return-book";
    }

    // 2. TRANSACTION OPERATIONS MANAGEMENT
    @PostMapping("/save")
    public String issueBook(@RequestParam("studentId") Long studentId,
                            @RequestParam("bookId") Long bookId,
                            RedirectAttributes redirectAttributes) {
        try {
            // Mapped to use compile-safe UserDto from updated UserService layer
            UserDto studentDto = userService.getUserById(studentId);

            issueBookService.issueBook(studentDto.getRollNumber(), bookId);
            redirectAttributes.addFlashAttribute("success", "Book Issued Successfully");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Issuance rejected: " + e.getMessage());
        }
        return "redirect:/admin/issue-book";
    }

    @GetMapping("/return/{id}")
    public String returnBook(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            IssueBook issueBook = issueBookService.getIssueBookById(id);

            if ("RETURNED".equals(issueBook.getStatus())) {
                redirectAttributes.addFlashAttribute("error", "Book already processed as RETURNED.");
                return "redirect:/admin/issue-book/return-book";
            }

            LocalDate returnDate = LocalDate.now();
            // Standard 7 days grace period logic calculation
            LocalDate dueDate = issueBook.getIssueDate().plusDays(7);

            issueBook.setReturnDate(returnDate);
            issueBook.setStatus("RETURNED");

            // Late Return Processing Automation Engine
            if (returnDate.isAfter(dueDate)) {
                long lateDays = ChronoUnit.DAYS.between(dueDate, returnDate);
                double fineAmount = lateDays * 10.0; // ₹10 per day fine metrics rate

                issueBook.setFine(fineAmount);
                issueBookService.updateIssueBook(issueBook);

                // Build Fine transaction log records inside structural database tables
                Fine fine = Fine.builder()
                        .rollNumber(issueBook.getRollNumber())
                        .studentName(issueBook.getStudentName())
                        .bookId(issueBook.getBookId())
                        .bookName(issueBook.getBookName())
                        .fineAmount(fineAmount)
                        .fineDate(LocalDate.now())
                        .fineStatus("UNPAID")
                        .build();

                fineService.createFine(fine);
                redirectAttributes.addFlashAttribute("success", "Book Returned With Fine ₹ " + fineAmount);
            } else {
                issueBook.setFine(0.0);
                issueBookService.updateIssueBook(issueBook);
                redirectAttributes.addFlashAttribute("success", "Book Returned Successfully");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Return flow aborted due to a system error: " + e.getMessage());
        }
        return "redirect:/admin/issue-book/return-book";
    }
}
