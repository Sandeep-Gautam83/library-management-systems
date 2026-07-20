package com.lms.repository;

import com.lms.Enum.FileStatus;
import com.lms.Enum.UploadFileType;
import com.lms.entity.FileUploads;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import jakarta.transaction.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public interface FileUploadRepository extends JpaRepository<FileUploads, Long> {

    Optional<FileUploads> findByStoredFileName(String storedFileName);

    List<FileUploads> findByFileType(UploadFileType fileType);

    @Query("SELECT COALESCE(SUM(f.fileSize), 0) FROM FileUploads f WHERE f.status = :status")
    long totalStorageSizeByStatus(@Param("status") FileStatus status);

    @Modifying
    @Transactional
    @Query("UPDATE FileUploads f SET f.status = :status WHERE f.id = :id")
    void updateStatusById(@Param("id") Long id, @Param("status") FileStatus status);
}
