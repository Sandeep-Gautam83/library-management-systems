package com.lms.service;

import com.lms.Enum.FileStatus;
import com.lms.Enum.UploadFileType;
import com.lms.dto.FileUploadsDto;
import com.lms.entity.FileUploads;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

public interface FileUploadService {

    FileUploads uploadFile(MultipartFile file) throws IOException;

    FileUploads uploadImage(MultipartFile file) throws IOException;

    FileUploads uploadPdf(MultipartFile file) throws IOException;

    List<FileUploads> uploadMultipleFiles(MultipartFile[] files) throws IOException;

    FileUploadsDto uploadNewFile(MultipartFile file, UploadFileType fileType) throws IOException;

    List<FileUploads> getAllFiles();

    FileUploads getFileById(Long id);

    FileUploadsDto getFileDetailsById(Long id);

    FileUploadsDto getFileDetailsByStoredName(String storedFileName);

    List<FileUploadsDto> getFilesByCategory(UploadFileType fileType);

    long calculateSystemActiveStorageBytes();

    void deleteStoredFile(FileUploads file) throws IOException;

    void deleteFile(Long id) throws IOException;

    void alterFileStatus(Long id, FileStatus status);

    void physicallyPurgeFileRecord(Long id) throws IOException;
}