package com.lms.entity;

import java.time.LocalDateTime;
import com.lms.Enum.FileStatus;
import com.lms.Enum.UploadFileType;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "file_uploads")
@Builder
public class FileUploads {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "file_name", nullable = false)
    private String fileName;

    @Column(name = "stored_file_name", nullable = false, unique = true)
    private String storedFileName;

    // system path (e.g., uploads/images/a.png)
    @Column(name = "file_path", nullable = false, length = 512)
    private String filePath;

    @Column(name = "file_size", nullable = false)
    private Long fileSize;

    //  (e.g., image/png, application/pdf)
    @Column(name = "content_type", nullable = false)
    private String contentType;

    @Enumerated(EnumType.STRING)
    @Column(name = "file_type", nullable = false)
    private UploadFileType fileType;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private FileStatus status;

    @Column(name = "uploaded_at", nullable = false, updatable = false)
    private LocalDateTime uploadedAt;

    public FileUploads(Long id, String fileName, String storedFileName,
                       String filePath, Long fileSize, String contentType,
                       UploadFileType fileType, FileStatus status, LocalDateTime uploadedAt) {
        this.id = id;
        this.fileName = fileName;
        this.storedFileName = storedFileName;
        this.filePath = filePath;
        this.fileSize = fileSize;
        this.contentType = contentType;
        this.fileType = fileType;
        this.status = status;
        this.uploadedAt = uploadedAt;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getStoredFileName() {
        return storedFileName;
    }

    public void setStoredFileName(String storedFileName) {
        this.storedFileName = storedFileName;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public Long getFileSize() {
        return fileSize;
    }

    public void setFileSize(Long fileSize) {
        this.fileSize = fileSize;
    }

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public UploadFileType getFileType() {
        return fileType;
    }

    public void setFileType(UploadFileType fileType) {
        this.fileType = fileType;
    }

    public FileStatus getStatus() {
        return status;
    }

    public void setStatus(FileStatus status) {
        this.status = status;
    }

    public LocalDateTime getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(LocalDateTime uploadedAt) {
        this.uploadedAt = uploadedAt;
    }

    public FileUploads() {

    }
    @PrePersist
    public void prePersist() {
        this.uploadedAt = LocalDateTime.now();
        if (this.status == null) {
            this.status = FileStatus.ACTIVE;
        }
    }
}
