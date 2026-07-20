package com.lms.exception;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.NoHandlerFoundException;
import org.springframework.web.servlet.resource.NoResourceFoundException;
import org.springframework.dao.DataIntegrityViolationException;
import jakarta.validation.ConstraintViolationException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.messaging.handler.annotation.MessageExceptionHandler;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.access.AccessDeniedException;
import java.io.IOException;

@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    // 1. BOOK NOT FOUND
    @ExceptionHandler(BookNotFoundException.class)
    public String handleBookNotFoundException(
            BookNotFoundException ex,
            Model model,
            HttpServletRequest request) {

        model.addAttribute("errorMessage", ex.getMessage());
        model.addAttribute("url", request.getRequestURI());
        return "error";
    }

    // 2. DUPLICATE BOOK
    @ExceptionHandler(DuplicateBookException.class)
    public String handleDuplicateBookException(
            DuplicateBookException ex,
            Model model,
            HttpServletRequest request) {

        model.addAttribute("errorMessage", ex.getMessage());
        model.addAttribute("url", request.getRequestURI());
        return "error";
    }

    // 3. INVALID DATA (Custom Exception)
    @ExceptionHandler(InvalidBookDataException.class)
    public String handleInvalidBookDataException(
            InvalidBookDataException ex,
            Model model,
            HttpServletRequest request) {

        model.addAttribute("errorMessage", ex.getMessage());
        model.addAttribute("url", request.getRequestURI());
        return "error";
    }

    // 4. DATABASE INTEGRITY VIOLATION
    @ExceptionHandler(DataIntegrityViolationException.class)
    public String handleDataIntegrityViolationException(
            DataIntegrityViolationException ex,
            Model model,
            HttpServletRequest request) {

        model.addAttribute("errorMessage", "Database Error: Required data is missing or missing constraint!");
        model.addAttribute("url", request.getRequestURI());
        return "error";
    }

    // 5. BEAN VALIDATION ERRORS (@Valid / Form Validation Failure)
    @ExceptionHandler({MethodArgumentNotValidException.class, ConstraintViolationException.class})
    public String handleValidationExceptions(
            Exception ex,
            Model model,
            HttpServletRequest request) {

        model.addAttribute("errorMessage", "Validation Failed: Please fill all fields correctly.");
        model.addAttribute("url", request.getRequestURI());
        return "error";
    }

    // 6. SECURITY ACCESS DENIED (Unauthorized Access)
    @ExceptionHandler(AccessDeniedException.class)
    public String handleAccessDeniedException(
            AccessDeniedException ex,
            Model model,
            HttpServletRequest request) {

        model.addAttribute("errorMessage", "You do not have permission to access this page.");
        model.addAttribute("url", request.getRequestURI());
        return "error";
    }

    // 7. NULL POINTER EXCEPTION
    @ExceptionHandler(NullPointerException.class)
    public String handleNullPointerException(
            NullPointerException ex,
            Model model,
            HttpServletRequest request) {

        model.addAttribute("errorMessage", "Something Went Wrong! A null value was encountered.");
        model.addAttribute("url", request.getRequestURI());
        return "error";
    }

    // 10. FILE UPLOAD / IO EXCEPTION error handle
    @ExceptionHandler(IOException.class)
    public String handleIOException(IOException ex, Model model, HttpServletRequest request) {

        model.addAttribute("errorMessage", "File Input/Output error occurred while processing your request.");
        model.addAttribute("url", request.getRequestURI());
        return "error";
    }


    @MessageExceptionHandler
    public void handleMessageException(Exception ex) {
        log.error("WebSocket Pipeline Intercepted Exception: {}", ex.getMessage());
    }


    @ExceptionHandler(Exception.class)
    public String handleException(Exception ex, Model model, HttpServletRequest request) {
        if (request == null) {
            log.error("Fallback async/socket exception occurred: ", ex);
            return null;
        }

        model.addAttribute("errorMessage", "An unexpected error occurred: " + ex.getMessage());
        model.addAttribute("url", request.getRequestURI());
        return "error";
    }
}

