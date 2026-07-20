package com.lms.controller;

import com.lms.Enum.Role;
import com.lms.Enum.UploadFileType;
import com.lms.dto.ChatMessageDto;
import com.lms.dto.FileUploadsDto;
import com.lms.dto.UserDto;
import com.lms.service.ChatMessageService;
import com.lms.service.FileUploadService;
import com.lms.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/chat")
public class AdminChatController {

    private static final Logger log = LoggerFactory.getLogger(AdminChatController.class);

    private final ChatMessageService chatService;
    private final SimpMessagingTemplate messagingTemplate;
    private final FileUploadService fileUploadService;
    private final UserService userService;

    // Constructor Injection
    public AdminChatController(ChatMessageService chatService,
                               SimpMessagingTemplate messagingTemplate,
                               FileUploadService fileUploadService,
                               UserService userService) {
        this.chatService = chatService;
        this.messagingTemplate = messagingTemplate;
        this.fileUploadService = fileUploadService;
        this.userService = userService;
    }

    //  RENDER ADMIN VIEW DASHBOARD (admin-chat.jsp)
    @GetMapping("/dashboard")
    public String showAdminReplayDashboard(Model model, HttpSession session) {
        try {
            UserDto loggedInUser = (UserDto) session.getAttribute("loggedInUser");

            // Safe Operational Security Check
            if (loggedInUser == null || loggedInUser.getRole() != Role.ADMIN) {
                log.warn("User is not allowed to access Admin Dashboard.");
                return "redirect:/login?error=unauthorized_access";
            }
            log.info("Admin Login Successful: {}", loggedInUser.getEmail());

            List<ChatMessageDto> activeComplaints = chatService.getAllComplaints()
                    .stream()
                    .filter(msg -> msg.getDeletedByAdmin() == null || !msg.getDeletedByAdmin())
                    .collect(Collectors.toList());
            model.addAttribute("complaints", activeComplaints);

            List<UserDto> chatUsers = userService.getAllApprovedStudents();
            model.addAttribute("chatUsers", chatUsers);

            model.addAttribute("chatPartnerName", "Student Support Interactive Console");
            model.addAttribute("user", loggedInUser);

            return "admin-chat";

        } catch (Exception e) {
            log.error("Critical layer failure rendering administrative console workspace channel loops: ", e);
            model.addAttribute("errorMessage", "Error setting context workspace instances.");
            return "error";
        }
    }

    // image or pdf file uploads
    @PostMapping("/api/upload")
    @ResponseBody
    public ResponseEntity<String> uploadAdminChatImage(@RequestParam("file") MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return new ResponseEntity<>("File is empty.", HttpStatus.BAD_REQUEST);
        }

        try {
            String contentType = file.getContentType();
            String originalFilename = file.getOriginalFilename();

            FileUploadsDto uploadedAsset;
            String virtualWebUrl;

            // Check if file is a PDF
            if (contentType != null && contentType.equalsIgnoreCase("application/pdf")
                    || (originalFilename != null && originalFilename.toLowerCase().endsWith(".pdf"))) {

                uploadedAsset = fileUploadService.uploadNewFile(file, UploadFileType.PDF);
                virtualWebUrl = "/uploads/pdfs/" + uploadedAsset.getStoredFileName();

            } // Check if file is an image
            else if (contentType != null && contentType.startsWith("image/")
                    || (originalFilename != null && (originalFilename.toLowerCase().endsWith(".jpg")
                    || originalFilename.toLowerCase().endsWith(".jpeg")
                    || originalFilename.toLowerCase().endsWith(".png")
                    || originalFilename.toLowerCase().endsWith(".webp")))) {

                uploadedAsset = fileUploadService.uploadNewFile(file, UploadFileType.IMAGE);
                virtualWebUrl = "/uploads/images/" + uploadedAsset.getStoredFileName();

            } else {
                return new ResponseEntity<>("Unsupported file type. Only Images and PDFs are allowed.", HttpStatus.BAD_REQUEST);
            }

            log.info("Multimedia payload written successfully down to storage layout: {}", virtualWebUrl);
            return ResponseEntity.ok(virtualWebUrl);

        } catch (IOException e) {
            log.error("Storage disk fault processing administrative inline file attachment streams: ", e);
            return new ResponseEntity<>("Server storage layer failed to commit binary tracking logs: " + e.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }



    @GetMapping("/api/history/{userId}")
    @ResponseBody
    public ResponseEntity<List<ChatMessageDto>> getChatHistory(@PathVariable Long userId, @RequestParam Long adminId) {
        if (userId != null && adminId != null) {
            try {
                List<ChatMessageDto> history = chatService.getConversationHistoryForAdmin(adminId, userId);
                return ResponseEntity.ok(history);
            } catch (Exception e) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
            }
        } else {
            return ResponseEntity.badRequest().body(null);
        }
    }

    // 4. GLOBAL CONSOLE SCRATCHPAD PIPELINE (Filters out admin soft-deleted items)
    @GetMapping("/api/history/global")
    @ResponseBody
    public ResponseEntity<List<ChatMessageDto>> getGlobalHistory(@RequestParam Long adminId) {
        if (adminId != null) {
            try {
                List<ChatMessageDto> history = chatService.getAdminSandboxScratchpad(adminId);
                return ResponseEntity.ok(history);
            } catch (Exception e) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
            }
        } else {
            return ResponseEntity.badRequest()
                    .body(null);
        }
    }


    @DeleteMapping("/api/delete/{id}")
    @ResponseBody
    public ResponseEntity<String> deleteMessage(@PathVariable Long id) {
        if (id != null) {
            try {
                chatService.executePageSoftDelete(id, "ADMIN");
                messagingTemplate.convertAndSend("/topic/chat.delete", id);
                return ResponseEntity.ok("Message Deleted Successfully.");
            } catch (Exception e) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Message Delete Failed.");
            }
        } else {
            return ResponseEntity.badRequest()
                    .body("Invalid Message Id.");
        }
    }
}

