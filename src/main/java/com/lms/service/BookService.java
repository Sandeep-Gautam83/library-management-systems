package com.lms.service;

import com.lms.entity.Book;
import java.util.List;

public interface BookService {

    Book addBook(Book book);

    Book updateBook(Long id, Book book);

    void saveBook(Book book);

    void deleteBook(Long id);

    Book getBookById(Long id);

    Book getBookByName(String bookName);

    List<Book> getAllBooks();

    List<Book> getBooksByCategory(String category);

    List<Book> getFreeBooks();

    List<Book> getPaidBooks();

    List<Book> getBooksByAuthor(String authorName);

    List<Book> searchBook(String keyword);

    List<Book> getAvailableBooks();

    List<Book> getLowStockBooks();

    List<Book> getTrendingBooks();

    List<Book> getLatestBooks();

    List<Book> getSimilarBooks(String category);

    long countBooks();

}
