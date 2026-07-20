package com.lms.service.Impl;

import com.lms.entity.Book;
import com.lms.entity.IssueBook;
import com.lms.entity.User;
import com.lms.repository.BookRepository;
import com.lms.repository.IssueBookRepository;
import com.lms.repository.UserRepository;
import com.lms.service.IssueBookService;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class IssueBookServiceImpl implements IssueBookService {

    private final IssueBookRepository issueBookRepository;
    private final UserRepository userRepository;
    private final BookRepository bookRepository;

    public IssueBookServiceImpl(IssueBookRepository issueBookRepository, UserRepository userRepository, BookRepository bookRepository) {
        this.bookRepository = bookRepository;
        this.userRepository = userRepository;
        this.issueBookRepository = issueBookRepository;
    }

    @Override
    public IssueBook issueBook(String rollNumber, Long bookId) {
        User user = userRepository.findByRollNumber(rollNumber)
                .orElseThrow(() -> new RuntimeException("Student Not Found"));

        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new RuntimeException("Book Not Found"));

        long totalBooks = issueBookRepository.countByRollNumberAndStatus(rollNumber, "ISSUED");

        if (totalBooks >= 5) {
            throw new RuntimeException("Maximum 5 Books Allowed");
        }

        boolean alreadyIssued = issueBookRepository.existsByRollNumberAndBookIdAndStatus(rollNumber, bookId, "ISSUED");

        if (alreadyIssued) {
            throw new RuntimeException("Book Already Issued");
        }

        if (book.getAvailableQuantity() <= 0) {
            throw new RuntimeException("Book Not Available");
        }
        LocalDate issueDate = LocalDate.now();
        LocalDate dueDate = issueDate.plusDays(7);
        IssueBook issueBook = IssueBook.builder()
                .rollNumber(user.getRollNumber())
                .studentName(user.getFullName())
                .bookId(book.getId())
                .bookName(book.getBookName())
                .issueDate(issueDate)
                .dueDate(dueDate)
                .returnDate(null)
                .fine(0.0)
                .status("ISSUED")
                .build();
        book.setAvailableQuantity(book.getAvailableQuantity() - 1);
        bookRepository.save(book);
        return issueBookRepository.save(issueBook);
    }

@Override
public IssueBook returnBook(Long issueBookId) {
    return returnBook(issueBookId, LocalDate.now());
}

@Override
public IssueBook returnBook(Long issueBookId, LocalDate returnDate) {

    IssueBook issueBook = issueBookRepository.findById(issueBookId)
                    .orElseThrow(() -> new RuntimeException("Issue Record Not Found"));
    if ("RETURNED".equals(issueBook.getStatus())) {
        throw new RuntimeException("Book Already Returned");
    }
    issueBook.setReturnDate(returnDate);
    double fine = calculateFine(issueBook.getDueDate(), returnDate);
    issueBook.setFine(fine);
    if (fine > 0) {
        issueBook.setStatus("OVERDUE");
    } else {
        issueBook.setStatus("RETURNED");
    }
    Book book = bookRepository.findById(issueBook.getBookId()).orElseThrow(() -> new RuntimeException("Book Not Found"));
    book.setAvailableQuantity(book.getAvailableQuantity() + 1);
    bookRepository.save(book);
    return issueBookRepository.save(issueBook);
}

    @Override
    public List<IssueBook> getAllIssuedBooks() {
        return issueBookRepository.findAll();
    }

    @Override
    public List<IssueBook> getIssuedBooksByStudent(String rollNumber) {
        return issueBookRepository.findByRollNumber(rollNumber);
    }

    @Override
    public IssueBook getIssueBookById(Long issueBookId) {
        return issueBookRepository.findById(issueBookId).orElseThrow(() ->
                new RuntimeException("Issue Record Not Found"));
    }

    @Override
    public List<IssueBook> getIssuedBooksByStatus(String status) {
        return issueBookRepository.findByStatus(status);
    }

    @Override
    public List<IssueBook> getOverdueBooks() {
        return issueBookRepository
                .findByStatus("ISSUED")
                .stream()
                .filter(issueBook -> issueBook.getDueDate().isBefore(LocalDate.now()))
                .peek(issueBook -> {
                    issueBook.setStatus("OVERDUE");
                    double fine = calculateFine(issueBook.getDueDate(), LocalDate.now());
                    issueBook.setFine(fine);
                    issueBookRepository.save(issueBook);
                })
                .collect(Collectors.toList());
    }

    @Override
    public void updateIssueBook(IssueBook issueBook) {
        issueBookRepository.save(issueBook);
    }

    @Override
    public void deleteIssueBook(Long issueBookId) {
        IssueBook issueBook = issueBookRepository.findById(issueBookId).orElseThrow(() -> new RuntimeException("Issue Record Not Found"));
        issueBookRepository.delete(issueBook);
    }

    @Override
    public Long totalIssuedBooks() {
        return issueBookRepository.countByStatus("ISSUED");
    }

    @Override
    public Long totalReturnedBooks() {
        return issueBookRepository.countByStatus("RETURNED");
    }

    @Override
    public Long totalOverdueBooks() {
        return issueBookRepository.countByStatus("OVERDUE");
    }

    @Override
    public Long totalLostBooks() {
        return issueBookRepository.countByStatus("LOST");
    }

    @Override
    public Double totalFineAmount() {
        return issueBookRepository.totalFineCollection();
    }

    @Override
    public Double calculateFine(LocalDate dueDate, LocalDate returnDate) {
        long overdueDays = ChronoUnit.DAYS.between(dueDate, returnDate);
        if(overdueDays > 0){
            return overdueDays * 10.0;
        }
        return 0.0;
    }
}
