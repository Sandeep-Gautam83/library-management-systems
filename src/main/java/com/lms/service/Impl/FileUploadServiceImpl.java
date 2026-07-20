package com.lms.service.Impl;

import com.lms.Enum.FileStatus;
import com.lms.Enum.UploadFileType;
import com.lms.dto.FileUploadsDto;
import com.lms.entity.FileUploads;
import com.lms.entity.User;
import com.lms.repository.FileUploadRepository;
import com.lms.repository.UserRepository;
import com.lms.service.FileUploadService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import jakarta.transaction.Transactional;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@Transactional
public class FileUploadServiceImpl implements FileUploadService {

    private static final long MAX_FILE_SIZE = 50 * 1024 * 1024; // 50MB Max Size

    private final FileUploadRepository fileRepository;
    private final UserRepository userRepository;

    public FileUploadServiceImpl(FileUploadRepository fileRepository, UserRepository userRepository) {
        this.fileRepository = fileRepository;
        this.userRepository = userRepository;
    }

    @Value("${file.upload-dir:uploads}")
    private String uploadDir;

    public FileUploadsDto uploadUserProfileImage(Long userId, MultipartFile file) throws IOException {
        if (userId == null) {
            throw new IllegalArgumentException("User ID cannot be null.");
        }

        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            throw new EntityNotFoundException("User not found with ID: " + userId);
        }

        // Upload image using internal helper
        FileUploads savedImage = uploadImage(file);

        // Link with user explicitly
        User user = userOpt.get();
        user.setProfileImage(savedImage);
        userRepository.save(user);

        return FileUploadsDto.fromEntity(savedImage);
    }

    public FileUploadsDto uploadUserPdfFile(Long userId, MultipartFile file) throws IOException {
        if (userId == null) {
            throw new IllegalArgumentException("User ID cannot be null.");
        }

        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            throw new EntityNotFoundException("User not found with ID: " + userId);
        }

        // Upload PDF using internal helper
        FileUploads savedPdf = uploadPdf(file);

        // Link with user explicitly
        User user = userOpt.get();
        user.setPdfFile(savedPdf);
        userRepository.save(user);

        return FileUploadsDto.fromEntity(savedPdf);
    }

    @Override
    public FileUploads uploadFile(MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("Upload failed: File payload is empty.");
        }

        String extension = getExtension(file.getOriginalFilename());

        if ("pdf".equals(extension)) {
            return uploadPdf(file);
        } else if (List.of("jpg", "jpeg", "png", "heic", "webp").contains(extension)) {
            return uploadImage(file);
        } else {
            return storeFile(file, "other", List.of("txt", "doc", "docx", "xls", "xlsx", "zip"),
                    UploadFileType.OTHER, "Unsupported file format.");
        }
    }

    @Override
    public FileUploads uploadImage(MultipartFile file) throws IOException {
        return storeFile(
                file,
                "images",
                List.of("jpg", "jpeg", "png", "heic", "webp"),
                UploadFileType.IMAGE,
                "Only JPG, JPEG, PNG, HEIC and WEBP image files are allowed!"
        );
    }

    @Override
    public FileUploads uploadPdf(MultipartFile file) throws IOException {
        return storeFile(
                file,
                "pdfs",
                List.of("pdf"),
                UploadFileType.PDF,
                "Only PDF files are allowed!"
        );
    }

    @Override
    public List<FileUploads> uploadMultipleFiles(MultipartFile[] files) throws IOException {
        List<FileUploads> uploadedFiles = new ArrayList<>();
        if (files == null || files.length == 0) {
            return uploadedFiles;
        }

        for (MultipartFile file : files) {
            if (file != null && !file.isEmpty()) {
                uploadedFiles.add(uploadFile(file));
            }
        }
        return uploadedFiles;
    }

    @Override
    public FileUploadsDto uploadNewFile(MultipartFile file, UploadFileType fileType) throws IOException {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("Upload failed: File payload is empty.");
        }

        String originalFileName = StringUtils.cleanPath(file.getOriginalFilename());
        String extension = getExtension(originalFileName);

        UploadFileType actualType;
        String subDirectory;

        if ("pdf".equals(extension)) {
            actualType = UploadFileType.PDF;
            subDirectory = "pdfs";
        } else {
            actualType = UploadFileType.IMAGE;
            subDirectory = "images";
        }

        FileUploads entity = storeFile(
                file,
                subDirectory,
                List.of("jpg", "jpeg", "png", "heic", "webp", "pdf"),
                actualType,
                "Only Images and PDF files are allowed!"
        );
        return FileUploadsDto.fromEntity(entity);
    }

    @Override
    public List<FileUploads> getAllFiles() {
        return fileRepository.findAll();
    }

    @Override
    public FileUploads getFileById(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("File ID cannot be null.");
        }

        Optional<FileUploads> fileOpt = fileRepository.findById(id);
        if (fileOpt.isEmpty()) {
            throw new EntityNotFoundException("File resource missing for ID: " + id);
        }
        return fileOpt.get();
    }

    @Override
    public FileUploadsDto getFileDetailsById(Long id) {
        FileUploads file = getFileById(id);
        return FileUploadsDto.fromEntity(file);
    }

    @Override
    public FileUploadsDto getFileDetailsByStoredName(String storedFileName) {
        if (!StringUtils.hasText(storedFileName)) {
            throw new IllegalArgumentException("Stored filename target string cannot be empty.");
        }

        Optional<FileUploads> fileOpt = fileRepository.findByStoredFileName(storedFileName);
        if (fileOpt.isEmpty()) {
            throw new EntityNotFoundException("Asset missing matching storage key: " + storedFileName);
        }
        return FileUploadsDto.fromEntity(fileOpt.get());
    }

    @Override
    public List<FileUploadsDto> getFilesByCategory(UploadFileType fileType) {
        if (fileType == null) {
            throw new IllegalArgumentException("File category type cannot be null.");
        }
        return fileRepository.findByFileType(fileType).stream()
                .map(FileUploadsDto::fromEntity)
                .collect(Collectors.toList());
    }

    @Override
    public long calculateSystemActiveStorageBytes() {
        try {
            return fileRepository.totalStorageSizeByStatus(FileStatus.ACTIVE);
        } catch (Exception e) {
            return 0;
        }
    }

    @Override
    public void deleteStoredFile(FileUploads file) throws IOException {
        if (file == null || !StringUtils.hasText(file.getFilePath())) {
            return;
        }
        Path localDiskAddress = Paths.get(file.getFilePath());
        Files.deleteIfExists(localDiskAddress);
    }

    @Override
    public void deleteFile(Long id) throws IOException {
        if (id == null) {
            throw new IllegalArgumentException("File ID cannot be null.");
        }

        Optional<FileUploads> fileOpt = fileRepository.findById(id);
        if (fileOpt.isPresent()) {
            FileUploads file = fileOpt.get();
            deleteStoredFile(file);
            fileRepository.deleteById(id);
        } else {
            throw new EntityNotFoundException("Cannot delete file. Record not found for ID: " + id);
        }
    }

    @Override
    public void alterFileStatus(Long id, FileStatus status) {
        if (id == null || status == null) {
            throw new IllegalArgumentException("Parameters cannot be null.");
        }

        if (!fileRepository.existsById(id)) {
            throw new EntityNotFoundException("Status change aborted: Reference missing.");
        }
        fileRepository.updateStatusById(id, status);
    }

    @Override
    public void physicallyPurgeFileRecord(Long id) throws IOException {
        this.deleteFile(id);
    }

    // ==========================================
    // PRIVATE CORE FILE CORE ENGINE
    // ==========================================

    private FileUploads storeFile(
            MultipartFile file,
            String subDirectory,
            List<String> allowedExtensions,
            UploadFileType fileType,
            String validationMessage
    ) throws IOException {

        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("File stream is empty.");
        }

        if (file.getSize() > MAX_FILE_SIZE) {
            throw new IllegalArgumentException("File size exceeds the 50MB limit.");
        }

        String originalFileName = StringUtils.cleanPath(file.getOriginalFilename());

        if (!StringUtils.hasText(originalFileName) || originalFileName.contains("..")) {
            throw new IllegalArgumentException("Security alert: Path traversal block caught inside filename.");
        }

        String extension = getExtension(originalFileName);

        if (!allowedExtensions.contains(extension)) {
            throw new IllegalArgumentException(validationMessage);
        }

        // Generate Path Locations
        Path uploadRoot = Paths.get(uploadDir).toAbsolutePath().normalize();
        Path targetDirectory = uploadRoot.resolve(subDirectory).normalize();
        Files.createDirectories(targetDirectory);

        String storedFileName = UUID.randomUUID().toString() + "_" + originalFileName;
        Path filePath = targetDirectory.resolve(storedFileName).normalize();

        if (!filePath.startsWith(targetDirectory)) {
            throw new SecurityException("Security verification blocked: Invalid destination generated.");
        }

        // Save physical file to disk
        file.transferTo(filePath.toFile());

        // Create Entity and Map Meta Info
        FileUploads fileUpload = new FileUploads();
        fileUpload.setFileName(originalFileName);
        fileUpload.setStoredFileName(storedFileName);
        fileUpload.setFilePath(filePath.toString());
        fileUpload.setFileSize(file.getSize());
        fileUpload.setContentType(resolveContentType(file, fileType));
        fileUpload.setFileType(fileType);
        fileUpload.setStatus(FileStatus.ACTIVE);

        return fileRepository.save(fileUpload);
    }

    private String resolveContentType(MultipartFile file, UploadFileType fileType) {
        if (StringUtils.hasText(file.getContentType())) {
            return file.getContentType();
        }

        if (fileType == UploadFileType.PDF) {
            return "application/pdf";
        } else {
            return "application/octet-stream";
        }
    }

    private String getExtension(String fileName) {
        if (!StringUtils.hasText(fileName) || !fileName.contains(".")) {
            throw new IllegalArgumentException("Failed parsing extension: Filename format invalid.");
        }
        return fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
    }
}
