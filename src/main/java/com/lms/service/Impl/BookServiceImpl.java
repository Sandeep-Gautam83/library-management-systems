package com.lms.service.Impl;

import com.lms.entity.Book;
import com.lms.exception.ResourceNotFoundException;
import com.lms.exception.UserAlreadyExistsException;
import com.lms.repository.BookRepository;
import com.lms.service.BookService;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BookServiceImpl implements BookService {

    private final BookRepository bookRepository;

    public BookServiceImpl(BookRepository bookRepository){
        this.bookRepository = bookRepository;
    }


    // ADD BOOK
@Override
public Book addBook(Book book) {
    if (book.getAvailableQuantity() == null) {
        book.setAvailableQuantity(book.getQuantity());
    }
    if (bookRepository.existsByBookName(book.getBookName())) {
        throw new UserAlreadyExistsException("Book Already Exists");
    }
    if (book.getAvailableQuantity() > book.getQuantity()) {
        throw new IllegalArgumentException("Available Quantity Cannot Exceed Total Quantity");
    }
    return bookRepository.save(book);
}

@Override
public Book updateBook(Long id, Book updatedBook) {
    // ID se existing book nikalo
    Book existingBook = getBookById(id);
    // Book details update karo
    existingBook.setBookName(updatedBook.getBookName());
    existingBook.setAuthorName(updatedBook.getAuthorName());
    existingBook.setCategory(updatedBook.getCategory());
    existingBook.setPrice(updatedBook.getPrice());
    existingBook.setPublisher(updatedBook.getPublisher());
    existingBook.setPublishedYear(updatedBook.getPublishedYear());
    existingBook.setQuantity(updatedBook.getQuantity());
    existingBook.setAvailableQuantity(updatedBook.getAvailableQuantity());
    existingBook.setDescription(updatedBook.getDescription());

    // Extra book details update karo
    existingBook.setLanguage(updatedBook.getLanguage());
    existingBook.setRating(updatedBook.getRating());
    existingBook.setTotalPages(updatedBook.getTotalPages());
    existingBook.setReadLink(updatedBook.getReadLink());
    // Check karo ki new image aayi hai ya nahi.

    if (updatedBook.getBookImage() != null) {
//        Updated book ki image ko existing book me set (update) kar do.
        existingBook.setBookImage(updatedBook.getBookImage());
    }

    // Check karo ki new pdf aayi hai ya nahi.
    if (updatedBook.getBookPdf() != null) {
        existingBook.setBookPdf(updatedBook.getBookPdf());
    }

    // Available quantity total quantity se jyada nahi honi chahiye
    if (existingBook.getAvailableQuantity() > existingBook.getQuantity()) {
        throw new IllegalArgumentException("Available Quantity Cannot Exceed Total Quantity");
    }
    return bookRepository.save(existingBook);
}

    // SAVE BOOK
@Override
public void saveBook(Book book) {
    // Available quantity nahi di gayi hai to total quantity set karo
    if (book.getAvailableQuantity() == null) {
        book.setAvailableQuantity(book.getQuantity());
    }
    // Available quantity total quantity se jyada nahi honi chahiye
    if (book.getAvailableQuantity() > book.getQuantity()) {
        throw new IllegalArgumentException("Available Quantity Cannot Exceed Total Quantity");
    }
    // Book ko database me save karo
    bookRepository.save(book);
}


    // DELETE
@Override
public void deleteBook(Long id) {
    // ID se book ko find karo
    Book book = getBookById(id);
    // Book ko database se delete karo
    bookRepository.delete(book);
}

    // GET BY ID
    @Override
    public Book getBookById(Long id) {
        return bookRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Book Not Found With ID : " + id));
    }

    // GET ALL
    @Override
    public List<Book> getAllBooks() {
        return bookRepository.findAll();
    }

    // CATEGORY
    @Override
    public List<Book> getBooksByCategory(String category) {
        return bookRepository.findByCategory(category);
    }


    @Override
    public List<Book> getFreeBooks() {
        return bookRepository.findByAccessType("FREE");
    }

    @Override
    public List<Book> getPaidBooks() {
        return bookRepository.findByAccessType("PAID");
    }

    // AUTHOR
    @Override
    public List<Book> getBooksByAuthor(String authorName) {
        return bookRepository.findByAuthorName(authorName);
    }

    // GET BY NAME
    @Override
    public Book getBookByName(String bookName) {
        return bookRepository.findByBookName(bookName).orElseThrow(() -> new ResourceNotFoundException("Book Not Found"));
    }

    // SEARCH
    @Override
    public List<Book> searchBook(String keyword) {
        return bookRepository.findByBookNameContainingIgnoreCaseOrAuthorNameContainingIgnoreCaseOrCategoryContainingIgnoreCase(keyword, keyword, keyword);
    }

    // AVAILABLE BOOKS
    @Override
    public List<Book> getAvailableBooks() {
        return bookRepository.findByAvailableQuantityGreaterThan(0);
    }

    // LOW STOCK BOOKS
    @Override
    public List<Book> getLowStockBooks() {
        return bookRepository.findByAvailableQuantityLessThan(5);
    }

    // TRENDING BOOKS
    @Override
    public List<Book> getTrendingBooks() {
        return bookRepository.findTop10ByOrderByRatingDesc();
    }

    // LATEST BOOKS
    @Override
    public List<Book> getLatestBooks() {
        return bookRepository.findTop10ByOrderByIdDesc();
    }

    // SIMILAR BOOKS
    @Override
    public List<Book> getSimilarBooks(String category) {
        return bookRepository.findByCategory(category);
    }

    // COUNT
    @Override
    public long countBooks() {
        return bookRepository.count();
    }
}