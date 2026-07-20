package com.lms.repository;

import com.lms.entity.Book;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BookRepository extends JpaRepository<Book, Long> {

    List<Book> findByAccessType(String accessType);

    Optional<Book> findByBookName(String bookName);

    boolean existsByBookName(String bookName);

    List<Book> findByCategory(String category);

    List<Book> findByAuthorName(String authorName);

    List<Book> findByAvailableQuantityGreaterThan(Integer quantity);

    List<Book> findByAvailableQuantityLessThan(Integer quantity);

    List<Book> findTop10ByOrderByRatingDesc();

    List<Book> findTop10ByOrderByIdDesc();

    List<Book>
    findByBookNameContainingIgnoreCaseOrAuthorNameContainingIgnoreCaseOrCategoryContainingIgnoreCase(String bookName, String authorName, String category);
}

