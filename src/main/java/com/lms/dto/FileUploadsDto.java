package com.lms.dto;

import com.lms.Enum.FileStatus;
import com.lms.Enum.UploadFileType;
import lombok.*;

import java.time.LocalDateTime;

@Builder
public class FileUploadsDto {

    private Long id;
    private String fileName;
    private String storedFileName;
    private String filePath;
    private Long fileSize;
    private String contentType;
    private UploadFileType fileType;
    private FileStatus status;
    private LocalDateTime uploadedAt;

    // Files sizes readable string me display karne ke liye, for example "345 KB"
    private String readableFileSize;

    public FileUploadsDto(Long id, String fileName, String storedFileName,
                          String filePath, Long fileSize, String contentType,
                          UploadFileType fileType, FileStatus status, LocalDateTime uploadedAt, String readableFileSize) {
        this.id = id;
        this.fileName = fileName;
        this.storedFileName = storedFileName;
        this.filePath = filePath;
        this.fileSize = fileSize;
        this.contentType = contentType;
        this.fileType = fileType;
        this.status = status;
        this.uploadedAt = uploadedAt;
        this.readableFileSize = readableFileSize;
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

    public String getReadableFileSize() {
        return readableFileSize;
    }

    public void setReadableFileSize(String readableFileSize) {
        this.readableFileSize = readableFileSize;
    }

    public FileUploadsDto() {

    }

    /** fromEntity :
     * Entity se DTO me data securely transform karne ke liye static converter utility method
     */
    public static FileUploadsDto fromEntity(com.lms.entity.FileUploads fileUploads) {
        if (fileUploads == null) return null;

        return FileUploadsDto.builder()
                .id(fileUploads.getId())
                .fileName(fileUploads.getFileName())
                .storedFileName(fileUploads.getStoredFileName())
                .filePath(fileUploads.getFilePath())
                .fileSize(fileUploads.getFileSize())
                .contentType(fileUploads.getContentType())
                .fileType(fileUploads.getFileType())
                .status(fileUploads.getStatus())
                .uploadedAt(fileUploads.getUploadedAt())
                .readableFileSize(calculateReadableSize(fileUploads.getFileSize()))
                .build();
    }

    private static String calculateReadableSize(Long bytes) {
        if (bytes == null || bytes <= 0) return "0 Bytes";
        final String[] units = new String[] { "Bytes", "KB", "MB", "GB" };
        int digitGroups = (int) (Math.log10(bytes) / Math.log10(1024));
        return new java.text.DecimalFormat("#,##0.#").format(bytes / Math.pow(1024, digitGroups)) + " " + units[digitGroups];
    }
}

