package com.lms.controller;

import com.lms.Enum.Role;
import com.lms.dto.UserDto;
import com.lms.service.BookService;
import com.lms.service.IssueBookService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {

    private final BookService bookService;
    private final IssueBookService issueBookService;

    public PageController(BookService bookService, IssueBookService issueBookService) {
        this.bookService = bookService;
        this.issueBookService = issueBookService;
    }

    // 1. DEFAULT HOME PAGE
    @GetMapping("/")
    public String homePage() {
        return "defaultHomePage";
    }

    // =========================================================================
    // 2. ADD BOOK ROUTER LINK (Bypasses directly to matching dashboards)
    // =========================================================================
    @GetMapping("/add-book")
    public String addBookPage(HttpSession session, Model model) {
        try {
            UserDto userDto = (UserDto) session.getAttribute("loggedInUser");

            // Guard Check: Session security evaluation
            if (userDto == null) {
                return "redirect:/login";
            }

            // Dynamic Compile-Safe Role Routing (Librarian Removed)
            if (userDto.getRole() == Role.ADMIN) {
                return "redirect:/admin/add-book"; // Admin specialized view
            }

            // Fallback: Agar Student bina authorization ke access kare to uske dashboard par drop karo
            return "redirect:/student/dashboard";

        } catch (Exception e) {
            return "redirect:/login";
        }
    }

    // =========================================================================
    // 3. CATALOGUE VIEWING PAGE FILTER
    // =========================================================================
    @GetMapping("/view-books")
    public String viewBooks(HttpSession session, Model model) {
        try {
            UserDto userDto = (UserDto) session.getAttribute("loggedInUser");

            if (userDto == null) {
                return "redirect:/login";
            }

            // Interception Check: Agar database role dynamic runtime par change hoke ADMIN ho gaya ho
            if (userDto.getRole() == Role.ADMIN) {
                return "redirect:/admin/books";
            }

            model.addAttribute("user", userDto);
            model.addAttribute("books", bookService.getAllBooks());
            return "view-books";

        } catch (Exception e) {
            return "redirect:/login";
        }
    }

    // =========================================================================
    // 4. STUDENT ISSUED TRANSACTIONS ROUTER
    // =========================================================================
    @GetMapping("/student-issued-books")
    public String studentIssuedBooks(HttpSession session, Model model) {
        try {
            UserDto userDto = (UserDto) session.getAttribute("loggedInUser");

            if (userDto == null) {
                return "redirect:/login";
            }

            // Live Dynamic Check: Agar user ADMIN ban chuka hai to uski dashboard template path update karo
            if (userDto.getRole() != Role.STUDENT) {
                return "redirect:/admin/dashboard";
            }

            model.addAttribute("user", userDto);
            model.addAttribute("issuedBooks", issueBookService.getAllIssuedBooks());
            return "student-issued-books";

        } catch (Exception e) {
            return "redirect:/login";
        }
    }

    // =========================================================================
    // 5. GLOBAL LOGOUT CLEANER FLUSH
    // =========================================================================
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        try {
            if (session != null) {
                session.invalidate();
            }
        } catch (Exception ignored) {}
        return "redirect:/login";
    }
}
