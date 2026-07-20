package com.lms.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity
@Table(name = "fines")
@Builder
public class Fine {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String rollNumber;
    private String studentName;
    private Long bookId;
    private String bookName;
    @Column(nullable = false)
    private Double fineAmount;
    private LocalDate fineDate;
    // PAID / UNPAID
    private String fineStatus;
    public Fine(Long id, String rollNumber, String studentName, Long bookId, String bookName, Double fineAmount, LocalDate fineDate, String fineStatus) {
        this.id = id;
        this.rollNumber = rollNumber;
        this.studentName = studentName;
        this.bookId = bookId;
        this.bookName = bookName;
        this.fineAmount = fineAmount;
        this.fineDate = fineDate;
        this.fineStatus = fineStatus;
    }

    public Fine() {
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

    public Double getFineAmount() {
        return fineAmount;
    }

    public void setFineAmount(Double fineAmount) {
        this.fineAmount = fineAmount;
    }

    public LocalDate getFineDate() {
        return fineDate;
    }

    public void setFineDate(LocalDate fineDate) {
        this.fineDate = fineDate;
    }

    public String getFineStatus() {
        return fineStatus;
    }

    public void setFineStatus(String fineStatus) {
        this.fineStatus = fineStatus;
    }
}
