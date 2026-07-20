package com.lms.repository;
import com.lms.entity.Fine;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FineRepository extends JpaRepository<Fine, Long> {

    List<Fine> findByFineStatus(String fineStatus);

    List<Fine> findByRollNumber(String rollNumber);

}

