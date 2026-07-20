package com.lms.repository;

import com.lms.entity.IssueBook;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IssueBookRepository extends JpaRepository<IssueBook, Long> {
    List<IssueBook> findByRollNumber(String rollNumber);

    List<IssueBook> findByStatus(String status);

    long countByRollNumberAndStatus(String rollNumber, String status);

    boolean existsByRollNumberAndBookIdAndStatus(String rollNumber, Long bookId, String status);

    Long countByStatus(String status);

    @Query("""
            SELECT COALESCE(SUM(i.fine),0)
            FROM IssueBook i
            """)
    Double totalFineCollection();

}