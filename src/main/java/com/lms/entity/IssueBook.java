package com.lms.entity;

import jakarta.persistence.*;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Entity
@Table(name = "issued_books")
@Builder
public class IssueBook {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String rollNumber;

    @Column(nullable = false)
    private String studentName;

    @Column(nullable = false)
    private Long bookId;

    @Column(nullable = false)
    private String bookName;

    @Column(nullable = false)
    private LocalDate issueDate;

    @Column(nullable = false)
    private LocalDate dueDate;

    private LocalDate returnDate;

    @Column(nullable = false)
    private Double fine = 0.0;

    @Column(nullable = false)
    private String status;

    public IssueBook(Long id, String rollNumber, String studentName, Long bookId, String bookName, LocalDate issueDate, LocalDate dueDate, LocalDate returnDate, Double fine, String status) {
        this.id = id;
        this.rollNumber = rollNumber;
        this.studentName = studentName;
        this.bookId = bookId;
        this.bookName = bookName;
        this.issueDate = issueDate;
        this.dueDate = dueDate;
        this.returnDate = returnDate;
        this.fine = fine;
        this.status = status;
    }

    public IssueBook() {

    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setRollNumber(String rollNumber) {
        this.rollNumber = rollNumber;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public void setBookId(Long bookId) {
        this.bookId = bookId;
    }

    public void setBookName(String bookName) {
        this.bookName = bookName;
    }

    public void setIssueDate(LocalDate issueDate) {
        this.issueDate = issueDate;
    }

    public void setDueDate(LocalDate dueDate) {
        this.dueDate = dueDate;
    }

    public void setReturnDate(LocalDate returnDate) {
        this.returnDate = returnDate;
    }

    public void setFine(Double fine) {
        this.fine = fine;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Long getId() {
        return id;
    }

    public String getRollNumber() {
        return rollNumber;
    }

    public String getStudentName() {
        return studentName;
    }

    public Long getBookId() {
        return bookId;
    }

    public String getBookName() {
        return bookName;
    }

    public LocalDate getIssueDate() {
        return issueDate;
    }

    public LocalDate getDueDate() {
        return dueDate;
    }

    public LocalDate getReturnDate() {
        return returnDate;
    }

    public Double getFine() {
        return fine;
    }

    public String getStatus() {
        return status;
    }
}