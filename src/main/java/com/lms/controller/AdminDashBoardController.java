package com.lms.controller;

import com.lms.Enum.Role;
import com.lms.dto.UserDto;
import com.lms.entity.Book;
import com.lms.entity.FileUploads;
import com.lms.entity.User;
import com.lms.service.BookService;
import com.lms.service.FileUploadService;
import com.lms.service.FineService;
import com.lms.service.IssueBookService;
import com.lms.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;

@Controller
@RequestMapping("/admin")
public class AdminDashBoardController {

    private final UserService userService;
    private final BookService bookService;
    private final IssueBookService issueBookService;
    private final FineService fineService;
    private final FileUploadService fileUploadService;

    public AdminDashBoardController(UserService userService,
                                    BookService bookService,
                                    IssueBookService issueBookService,
                                    FineService fineService,
                                    FileUploadService fileUploadService) {
        this.userService = userService;
        this.bookService = bookService;
        this.issueBookService = issueBookService;
        this.fineService = fineService;
        this.fileUploadService = fileUploadService;
    }

    private boolean isNotAdmin(HttpSession session) {
        try {
            UserDto loggedInUser = (UserDto) session.getAttribute("loggedInUser");
            return loggedInUser == null || loggedInUser.getRole() != Role.ADMIN;
        } catch (Exception e) {
            return true;
        }
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        if (isNotAdmin(session)) {
            return "redirect:/login";
        }
        try {
            model.addAttribute("students", userService.getApprovedStudents());
            model.addAttribute("books", bookService.getAllBooks());
            model.addAttribute("issuedBooks", issueBookService.getAllIssuedBooks());
            model.addAttribute("fines", fineService.getAllFines());
            model.addAttribute("totalBooks", bookService.countBooks());
            model.addAttribute("totalStudents", userService.totalStudents());
            model.addAttribute("pendingStudents", userService.pendingStudentsCount());
            model.addAttribute("issuedBooksCount", issueBookService.totalIssuedBooks());
        } catch (Exception e) {
            model.addAttribute("error", "Failed to compile background administrative operational metrics safely.");
        }
        return "admin-dashboard";
    }

    @GetMapping("/add-book")
    public String addBookPage(HttpSession session, Model model) {
        if (isNotAdmin(session)) {
            return "redirect:/login";
        }
        model.addAttribute("book", new Book());
        return "add-book";
    }

    @PostMapping("/save-book")
    public String saveBook(@ModelAttribute Book book,
                           @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                           @RequestParam(value = "pdfFile", required = false) MultipartFile pdfFile,
                           HttpSession session,
                           Model model,
                           RedirectAttributes redirectAttributes) {
        if (isNotAdmin(session)) {
            return "redirect:/login";
        }

        FileUploads uploadedImage = null;
        FileUploads uploadedPdf = null;

        try {
            if (book.getAvailableQuantity() == null) {
                book.setAvailableQuantity(book.getQuantity());
            }

            if (imageFile != null && !imageFile.isEmpty()) {
                uploadedImage = fileUploadService.uploadImage(imageFile);
                book.setBookImage(uploadedImage);
            }

            if (pdfFile != null && !pdfFile.isEmpty()) {
                uploadedPdf = fileUploadService.uploadPdf(pdfFile);
                book.setBookPdf(uploadedPdf);
            }

            bookService.addBook(book);
            redirectAttributes.addFlashAttribute("success", "Book added successfully");
            return "redirect:/admin/books";
        } catch (Exception e) {
            cleanupUploadedFile(uploadedImage);
            cleanupUploadedFile(uploadedPdf);

            model.addAttribute("book", book);
            model.addAttribute("error", getErrorMessage(e));
            return "add-book";
        }
    }

    @GetMapping("/books")
    public String books(HttpSession session, Model model) {
        if (isNotAdmin(session)) {
            return "redirect:/login";
        }
        model.addAttribute("books", bookService.getAllBooks());
        return "view-books";
    }

    @GetMapping("/edit-book/{id}")
    public String editBookPage(@PathVariable("id") Long id, HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        if (isNotAdmin(session)) {
            return "redirect:/login";
        }
        try {
            Book book = bookService.getBookById(id);
            if (book == null) {
                redirectAttributes.addFlashAttribute("error", "Book target reference asset absent.");
                return "redirect:/admin/books";
            }
            model.addAttribute("book", book);
            return "edit-book";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", getErrorMessage(e));
            return "redirect:/admin/books";
        }
    }

    @PostMapping("/update-book")
    public String updateBook(@ModelAttribute Book book,
                             @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                             @RequestParam(value = "pdfFile", required = false) MultipartFile pdfFile,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        if (isNotAdmin(session)) {
            return "redirect:/login";
        }

        FileUploads uploadedImage = null;
        FileUploads uploadedPdf = null;
        FileUploads oldImage = null;
        FileUploads oldPdf = null;

        try {
            Book existingBook = bookService.getBookById(book.getId());
            if (existingBook == null) {
                redirectAttributes.addFlashAttribute("error", "Cannot update. Book context missing.");
                return "redirect:/admin/books";
            }

            oldImage = existingBook.getBookImage();
            oldPdf = existingBook.getBookPdf();

            book.setBookImage(oldImage);
            book.setBookPdf(oldPdf);

            if (imageFile != null && !imageFile.isEmpty()) {
                uploadedImage = fileUploadService.uploadImage(imageFile);
                book.setBookImage(uploadedImage);
            }

            if (pdfFile != null && !pdfFile.isEmpty()) {
                uploadedPdf = fileUploadService.uploadPdf(pdfFile);
                book.setBookPdf(uploadedPdf);
            }

            bookService.updateBook(book.getId(), book);

            if (uploadedImage != null) {
                cleanupReplacedFile(oldImage);
            }
            if (uploadedPdf != null) {
                cleanupReplacedFile(oldPdf);
            }

            redirectAttributes.addFlashAttribute("success", "Book Updated successfully");
        } catch (Exception e) {
            cleanupUploadedFile(uploadedImage);
            cleanupUploadedFile(uploadedPdf);
            redirectAttributes.addFlashAttribute("error", getErrorMessage(e));
            return "redirect:/admin/edit-book/" + book.getId();
        }
        return "redirect:/admin/books";
    }

    @RequestMapping(value = "/delete-book/{id}", method = {RequestMethod.GET, RequestMethod.POST})
    public String deleteBook(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (isNotAdmin(session)) {
            return "redirect:/login";
        }
        try {
            Book book = bookService.getBookById(id);
            if (book != null) {
                FileUploads imageFile = book.getBookImage();
                FileUploads pdfFile = book.getBookPdf();

                bookService.deleteBook(id);
                cleanupStoredFile(imageFile);
                cleanupStoredFile(pdfFile);
                redirectAttributes.addFlashAttribute("success", "Book Deleted Successfully");
            } else {
                redirectAttributes.addFlashAttribute("error", "Book records already vacant.");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", getErrorMessage(e));
        }
        return "redirect:/admin/books";
    }

    @GetMapping("/pending-students")
    public String pendingStudents(HttpSession session, Model model) {
        if (isNotAdmin(session)) {
            return "redirect:/login";
        }
        model.addAttribute("students", userService.getPendingStudents());
        return "pending-students";
    }

    @GetMapping("/approve-student/{id}")
    public String approveStudent(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (isNotAdmin(session)) {
            return "redirect:/login";
        }
        try {
            userService.approveStudent(id);
            redirectAttributes.addFlashAttribute("success", "Student Approved Successfully");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/admin/pending-students";
    }

    @GetMapping("/cancel-student/{id}")
    public String cancelStudent(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (isNotAdmin(session)) {
            return "redirect:/login";
        }
        try {
            userService.cancelStudent(id);
            redirectAttributes.addFlashAttribute("success", "Student Rejected Successfully");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/admin/pending-students";
    }

    @GetMapping("/students")
    public String students(HttpSession session, Model model) {
        if (isNotAdmin(session)) {
            return "redirect:/login";
        }
        model.addAttribute("students", userService.getApprovedStudents());
        return "students";
    }

    @GetMapping("/delete-user/{id}")
    public String deleteUser(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (isNotAdmin(session)) {
            return "redirect:/login";
        }
        try {
            userService.deleteUser(id);
            redirectAttributes.addFlashAttribute("success", "User Deleted Successfully");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/admin/students";
    }

    @GetMapping("/toggle-role/{id}")
    public String toggleUserRole(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (isNotAdmin(session)) {
            return "redirect:/login";
        }
        try {
            User updatedUserEntity = userService.toggleUserRole(id);
            UserDto updatedUserDto = UserDto.fromEntity(updatedUserEntity);

            redirectAttributes.addFlashAttribute("success", "Role for " + updatedUserDto.getFullName() + " successfully updated to: " + updatedUserDto.getRole());

            UserDto currentLoggedUserDto = (UserDto) session.getAttribute("loggedInUser");

            // Sync current live environment conditions instantly if user swapped themselves
            if (currentLoggedUserDto != null && currentLoggedUserDto.getId().equals(id)) {
                session.setAttribute("loggedInUser", updatedUserDto);
                session.setAttribute("userRole", updatedUserDto.getRole().toString());

                if (updatedUserDto.getRole() != Role.ADMIN) {
                    return "redirect:/student/dashboard";
                }
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to transform user role variables: " + e.getMessage());
        }
        return "redirect:/admin/students";
    }

    private void cleanupUploadedFile(FileUploads file) {
        if (file == null || file.getId() == null) return;
        try {
            fileUploadService.deleteFile(file.getId());
        } catch (IOException ignored) {}
    }

    private void cleanupReplacedFile(FileUploads file) {
        cleanupUploadedFile(file);
    }

    private void cleanupStoredFile(FileUploads file) {
        if (file == null) return;
        try {
            fileUploadService.deleteStoredFile(file);
        } catch (IOException ignored) {}
    }

    private String getErrorMessage(Exception e) {
        if (e.getMessage() != null && !e.getMessage().isBlank()) {
            return e.getMessage();
        }
        return "Administrative inventory execution flow failure caught.";
    }
}
