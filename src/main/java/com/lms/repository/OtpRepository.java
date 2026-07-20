package com.lms.repository;

import com.lms.entity.OtpDetails;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface OtpRepository extends JpaRepository<OtpDetails, Long> {

    Optional<OtpDetails> findByEmail(String email);

    void deleteByEmail(String email);
}


