package com.lms.dto;
import java.time.LocalDate;

public class IssueBookDto {

    private Long id;

    private String rollNumber;

    private String studentName;

    private Long bookId;

    private String bookName;

    private LocalDate issueDate;

    private LocalDate returnDate;

    private Double fine;

    // ISSUED / RETURNED / LOST
    private String status;

    public IssueBookDto(Long id, String rollNumber, String studentName,
                        Long bookId, String bookName, LocalDate issueDate,
                        LocalDate returnDate, Double fine, String status) {
        this.id = id;
        this.rollNumber = rollNumber;
        this.studentName = studentName;
        this.bookId = bookId;
        this.bookName = bookName;
        this.issueDate = issueDate;
        this.returnDate = returnDate;
        this.fine = fine;
        this.status = status;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getRollNumber() {
        return rollNumber;
    }

    public void setRollNumber(String rollNumber) {
        this.rollNumber = rollNumber;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public Long getBookId() {
        return bookId;
    }

    public void setBookId(Long bookId) {
        this.bookId = bookId;
    }

    public String getBookName() {
        return bookName;
    }

    public void setBookName(String bookName) {
        this.bookName = bookName;
    }

    public LocalDate getIssueDate() {
        return issueDate;
    }

    public void setIssueDate(LocalDate issueDate) {
        this.issueDate = issueDate;
    }

    public LocalDate getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(LocalDate returnDate) {
        this.returnDate = returnDate;
    }

    public Double getFine() {
        return fine;
    }

    public void setFine(Double fine) {
        this.fine = fine;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}



