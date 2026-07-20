package com.lms.controller;

import com.lms.entity.Book;
import com.lms.entity.FileUploads;
import com.lms.entity.User;
import com.lms.service.BookService;
import com.lms.service.FileUploadService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Controller
@RequestMapping("/books")
public class BookController {

    private final BookService bookService;
    private final FileUploadService fileUploadService;

    public BookController(BookService bookService, FileUploadService fileUploadService) {
        this.bookService = bookService;
        this.fileUploadService = fileUploadService;
    }

    @GetMapping("/add")
    public String addBookPage(Model model) {
        model.addAttribute("book", new Book());
        return "add-book";
    }

    @PostMapping("/save")
    public String saveBook(
            @ModelAttribute Book book,
            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
            @RequestParam(value = "pdfFile", required = false) MultipartFile pdfFile,
            Model model
    ) {
        FileUploads uploadedImage = null;
        FileUploads uploadedPdf = null;

        try {
            // Set initial available quantity equal to the total quantity
            if (book.getAvailableQuantity() == null) {
                book.setAvailableQuantity(book.getQuantity());
            }

            // Handle Cover Image Upload
            if (imageFile != null && !imageFile.isEmpty()) {
                uploadedImage = fileUploadService.uploadImage(imageFile);
                book.setBookImage(uploadedImage);
            }

            // Handle PDF Document Upload
            if (pdfFile != null && !pdfFile.isEmpty()) {
                uploadedPdf = fileUploadService.uploadPdf(pdfFile);
                book.setBookPdf(uploadedPdf);
            }

            bookService.addBook(book);
            return "redirect:/books/view-books";

        } catch (Exception e) {
            // Rollback files from storage if database transaction fails
            cleanupUploadedFile(uploadedImage);
            cleanupUploadedFile(uploadedPdf);

            model.addAttribute("error", getErrorMessage(e));
            model.addAttribute("book", book);
            return "add-book";
        }
    }

    @GetMapping("/view-books")
    public String viewBooks(Model model) {
        model.addAttribute("books", bookService.getAllBooks());
        return "view-books";
    }

    @GetMapping("/free")
    public String getFreeBooks(Model model, HttpSession session) {
        model.addAttribute("books", bookService.getFreeBooks());
        addLoggedInUser(model, session);
        return "free-books";
    }

    @GetMapping("/paid")
    public String getPaidBooks(Model model, HttpSession session) {
        model.addAttribute("books", bookService.getPaidBooks());
        addLoggedInUser(model, session);
        return "paid-books";
    }

    @GetMapping("/edit/{id}")
    public String editBookPage(@PathVariable Long id, Model model) {
        Book book = bookService.getBookById(id);
        model.addAttribute("book", book);
        return "edit-book";
    }

    @PostMapping("/update")
    public String updateBook(
            @ModelAttribute Book book,
            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
            @RequestParam(value = "pdfFile", required = false) MultipartFile pdfFile
    ) {
        // Fetch existing data to preserve original references (e.g., hidden properties or files)
        Book existingBook = bookService.getBookById(book.getId());

        if (existingBook != null) {
            // Retain files if new ones aren't provided in the form submission
            if (imageFile == null || imageFile.isEmpty()) {
                book.setBookImage(existingBook.getBookImage());
            } else {
                try {
                    cleanupStoredFile(existingBook.getBookImage()); // Clean old file
                    FileUploads newImage = fileUploadService.uploadImage(imageFile);
                    book.setBookImage(newImage);
                } catch (IOException ignored) {}
            }

            if (pdfFile == null || pdfFile.isEmpty()) {
                book.setBookPdf(existingBook.getBookPdf());
            } else {
                try {
                    cleanupStoredFile(existingBook.getBookPdf()); // Clean old file
                    FileUploads newPdf = fileUploadService.uploadPdf(pdfFile);
                    book.setBookPdf(newPdf);
                } catch (IOException ignored) {}
            }

            bookService.updateBook(book.getId(), book);
        }

        return "redirect:/books/view-books";
    }

    @GetMapping("/delete/{id}")
    public String deleteBook(@PathVariable Long id) {
        Book book = bookService.getBookById(id);

        if (book != null) {
            FileUploads imageFile = book.getBookImage();
            FileUploads pdfFile = book.getBookPdf();

            // Delete book record from DB first
            bookService.deleteBook(id);

            // Safe cleanup of actual assets from server filesystem/S3 bucket
            cleanupStoredFile(imageFile);
            cleanupStoredFile(pdfFile);
        }
        return "redirect:/books/view-books";
    }

    private void cleanupUploadedFile(FileUploads file) {
        if (file == null || file.getId() == null) {
            return;
        }
        try {
            fileUploadService.deleteFile(file.getId());
        } catch (IOException ignored) {
        }
    }

    private void cleanupStoredFile(FileUploads file) {
        // Added crucial null check to prevent NullPointerException
        if (file == null) {
            return;
        }
        try {
            fileUploadService.deleteStoredFile(file);
        } catch (IOException ignored) {
        }
    }

    private String getErrorMessage(Exception e) {
        if (e.getMessage() != null && !e.getMessage().isBlank()) {
            return e.getMessage();
        }
        return "File Upload Failed";
    }

    private void addLoggedInUser(Model model, HttpSession session) {
        Object userObject = session.getAttribute("loggedInUser");
        if (userObject instanceof User user) {
            model.addAttribute("user", user);
            model.addAttribute("studentId", user.getId());
        }
    }
}
