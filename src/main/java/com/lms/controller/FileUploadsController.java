package com.lms.controller;
import com.lms.entity.FileUploads;
import com.lms.repository.FileUploadRepository;
import org.jspecify.annotations.NonNull;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.InvalidMediaTypeException;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import java.net.MalformedURLException;
import java.nio.file.Path;
import java.nio.file.Paths;

@Controller
@RequestMapping("/files")
public class FileUploadsController {

    private final FileUploadRepository fileRepository;
    public FileUploadsController(FileUploadRepository fileRepository){
        this.fileRepository = fileRepository;
    }

    // VIEW IMAGE / PDF
    @GetMapping("/view/{id}")
    @ResponseBody
    public ResponseEntity<Resource> viewFile(@PathVariable Long id) throws MalformedURLException {

        FileUploads file = getFile(id);
        Resource resource = getFileResource(file);

        return ResponseEntity.ok().contentType(resolveMediaType(file))
                .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\""+ file.getFileName() + "\"")
                .body(resource);
    }

    // Download pdf
    @GetMapping("/download/{id}")
    @ResponseBody
    public ResponseEntity<Resource> downloadFile(@PathVariable Long id) throws MalformedURLException {
        FileUploads file = getFile(id);
        Resource resource = getFileResource(file);
        return ResponseEntity.ok().header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + file.getFileName() + "\"")
                .contentType(resolveMediaType(file))
                .body(resource);
    }

    private FileUploads getFile(Long id) {
        return fileRepository.findById(id).orElseThrow(()->new RuntimeException("File Not Found"));
    }

    private Resource getFileResource(FileUploads file) throws MalformedURLException {
        Path path = Paths.get(file.getFilePath());
        Resource resource = new UrlResource(path.toUri());
        if(!resource.exists() || !resource.isReadable()){
            throw new RuntimeException("File Not Readable");
        }
        return resource;
    }

    private MediaType resolveMediaType(@NonNull FileUploads file) {
        try {
            if (file.getContentType() != null && !file.getContentType().isBlank()) {
                return MediaType.parseMediaType(file.getContentType());
            }
        } catch (InvalidMediaTypeException ignored) {
        }
        return MediaType.APPLICATION_OCTET_STREAM;
    }
}
