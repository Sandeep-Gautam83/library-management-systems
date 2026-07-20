package com.lms.controller;

import com.lms.Enum.Role;
import com.lms.dto.UserDto;
import com.lms.service.BookService;
import com.lms.service.IssueBookService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/student")
public class StudentDashBoardController {

    private final BookService bookService;
    private final IssueBookService issueBookService;

    public StudentDashBoardController(BookService bookService, IssueBookService issueBookService) {
        this.bookService = bookService;
        this.issueBookService = issueBookService;
    }

    private Object validateStudentOrRedirect(HttpSession session) {
        try {
            UserDto userDto = (UserDto) session.getAttribute("loggedInUser");

            // Check 1: Session empty parameters check
            if (userDto == null) {
                return "redirect:/login";
            }

            // Check 2: Dynamic Compile-Safe Role Check
            if (userDto.getRole() == null) {
                return "redirect:/login";
            }

            // LIVE TOGGLE PROTECTION: If student is elevated to ADMIN, redirect smoothly
            if (userDto.getRole() == Role.ADMIN) {
                return "redirect:/admin/dashboard";
            }

            return userDto; // Returns validated context when role is matching Role.STUDENT
        } catch (Exception e) {
            return "redirect:/login";
        }
    }

    // 2. STUDENT MAIN DASHBOARD
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        try {
            Object validationResult = validateStudentOrRedirect(session);

            if (validationResult instanceof String) {
                return (String) validationResult;
            }

            UserDto userDto = (UserDto) validationResult;

            // Fetch list arrays for dashboard population mapping
            model.addAttribute("books", bookService.getAvailableBooks());
            model.addAttribute("issuedBooks", issueBookService.getIssuedBooksByStudent(userDto.getRollNumber()));
            model.addAttribute("totalBooks", bookService.countBooks());
            model.addAttribute("issuedBookCount", issueBookService.getIssuedBooksByStudent(userDto.getRollNumber()).size());

            // Available Stock Tracking Matrix Optimization
            long availableBooksCount = bookService.getAllBooks()
                    .stream()
                    .filter(book -> book.getAvailableQuantity() > 0)
                    .count();
            model.addAttribute("availableBooksCount", availableBooksCount);

            // Low Stock Notification Threshold Alerts Evaluation
            long lowStockBooks = bookService.getAllBooks()
                    .stream()
                    .filter(book -> book.getAvailableQuantity() <= 3)
                    .count();
            model.addAttribute("lowStockBooks", lowStockBooks);

            // Bind current user context back to template engine
            model.addAttribute("user", userDto);

            return "student-dashboard";
        } catch (Exception e) {
            model.addAttribute("error", "Failed to compile student dashboard indicators cleanly.");
            return "redirect:/login";
        }
    }

    // =========================================================================
    // 3. CATALOGUE VIEW CHANNELS
    // =========================================================================
    @GetMapping("/view-books")
    public String viewBooks(HttpSession session, Model model) {
        try {
            Object validationResult = validateStudentOrRedirect(session);

            if (validationResult instanceof String) {
                return (String) validationResult;
            }

            UserDto userDto = (UserDto) validationResult;
            model.addAttribute("books", bookService.getAllBooks());
            model.addAttribute("user", userDto);

            return "view-books";
        } catch (Exception e) {
            return "redirect:/student/dashboard";
        }
    }

    // =========================================================================
    // 4. POWERFUL ENGINE SEARCH FILTERS
    // =========================================================================
    @GetMapping("/search-book")
    public String searchBook(@RequestParam(required = false) String keyword,
                             HttpSession session,
                             Model model) {
        try {
            Object validationResult = validateStudentOrRedirect(session);

            if (validationResult instanceof String) {
                return (String) validationResult;
            }

            UserDto userDto = (UserDto) validationResult;

            if (keyword == null || keyword.trim().isEmpty()) {
                model.addAttribute("books", bookService.getAllBooks());
            } else {
                model.addAttribute("books", bookService.searchBook(keyword.trim()));
            }

            model.addAttribute("keyword", keyword);
            model.addAttribute("user", userDto);

            return "view-books";
        } catch (Exception e) {
            return "view-books";
        }
    }

    @GetMapping("/available-books")
    public String availableBooks(HttpSession session, Model model) {
        try {
            Object validationResult = validateStudentOrRedirect(session);

            if (validationResult instanceof String) {
                return (String) validationResult;
            }

            UserDto userDto = (UserDto) validationResult;
            model.addAttribute("books", bookService.getAllBooks());
            model.addAttribute("user", userDto);

            return "available_books";
        } catch (Exception e) {
            return "redirect:/student/dashboard";
        }
    }

    @GetMapping("/student-issued-books")
    public String studentIssuedBooks(HttpSession session, Model model) {
        try {
            Object validationResult = validateStudentOrRedirect(session);

            if (validationResult instanceof String) {
                return (String) validationResult;
            }

            UserDto userDto = (UserDto) validationResult;
            model.addAttribute("issuedBooks", issueBookService.getIssuedBooksByStudent(userDto.getRollNumber()));
            model.addAttribute("user", userDto);

            return "student-issued-books";
        } catch (Exception e) {
            return "redirect:/student/dashboard";
        }
    }

    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        try {
            Object validationResult = validateStudentOrRedirect(session);

            if (validationResult instanceof String) {
                return (String) validationResult;
            }

            UserDto userDto = (UserDto) validationResult;
            model.addAttribute("user", userDto);

            return "profile";
        } catch (Exception e) {
            return "redirect:/student/dashboard";
        }
    }
}
