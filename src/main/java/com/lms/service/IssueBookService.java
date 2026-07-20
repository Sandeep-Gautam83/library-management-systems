package com.lms.service;

import com.lms.entity.IssueBook;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public interface IssueBookService {

    IssueBook issueBook(String rollNumber, Long bookId);

    IssueBook returnBook(Long issueBookId);

    IssueBook returnBook(Long issueBookId, LocalDate returnDate);

    List<IssueBook> getAllIssuedBooks();

    List<IssueBook> getIssuedBooksByStudent(String rollNumber);

    IssueBook getIssueBookById(Long issueBookId);

    List<IssueBook> getIssuedBooksByStatus(String status);

    List<IssueBook> getOverdueBooks();

    void updateIssueBook(IssueBook issueBook);

    void deleteIssueBook(Long issueBookId);

    Long totalIssuedBooks();

    Long totalReturnedBooks();

    Long totalOverdueBooks();

    Long totalLostBooks();

    Double totalFineAmount();

    Double calculateFine(LocalDate dueDate, LocalDate returnDate);
}