package com.lms.controller;

import com.lms.Enum.Role;
import com.lms.Enum.UploadFileType;
import com.lms.dto.ChatMessageDto;
import com.lms.dto.FileUploadsDto;
import com.lms.dto.UserDto;
import com.lms.service.ChatMessageService;
import com.lms.service.FileUploadService;
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
@RequestMapping("/student/chat")
public class StudentChatController {

    private static final Logger log = LoggerFactory.getLogger(StudentChatController.class);

    private final ChatMessageService complainService;
    private final SimpMessagingTemplate messagingTemplate;
    private final FileUploadService fileUploadService;
    public StudentChatController(ChatMessageService complainService, SimpMessagingTemplate messagingTemplate, FileUploadService fileUploadService) {
        this.complainService = complainService;
        this.messagingTemplate = messagingTemplate;
        this.fileUploadService = fileUploadService;
    }

    @GetMapping
    public String showComplaintDashboard(Model model, HttpSession session) {
        try {
            UserDto loggedInUser = (UserDto) session.getAttribute("loggedInUser");

            if (loggedInUser == null || loggedInUser.getRole() != Role.STUDENT) {
                log.warn("Unauthorized chat access attempt blocked or session expired.");
                return "redirect:/login?error=unauthorized_access";
            }
            List<ChatMessageDto> complaintsList = complainService.getAllMessagesForStudent(loggedInUser.getId())
                    .stream()
                    .filter(msg -> msg.getDeletedByUser() == null || !msg.getDeletedByUser())
                    .collect(Collectors.toList());

            model.addAttribute("complaints", complaintsList);
            model.addAttribute("chatPartnerName", "Admin Support Desk");
            model.addAttribute("user", loggedInUser);

            return "student-chat";
        } catch (Exception e) {
            log.error("Fatal exception parsing structural student complaint metrics: ", e);
            model.addAttribute("errorMessage", "Could not load dashboard records: " + e.getMessage());
            return "error";
        }
    }

    @PostMapping("/api/upload")
    @ResponseBody
    public ResponseEntity<String> uploadChatImage(@RequestParam("file") MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return ResponseEntity.badRequest().body("Selected file is empty.");
        }

        try {
            FileUploadsDto uploadedAsset = fileUploadService.uploadNewFile(file, UploadFileType.IMAGE);
            String folder = uploadedAsset.getFileType() == UploadFileType.PDF ? "pdfs" : "images";

            String virtualWebUrl = "/uploads/" + folder + "/" + uploadedAsset.getStoredFileName();
            log.info("Student uploaded file : {}", virtualWebUrl);
            return ResponseEntity.ok(virtualWebUrl);
        } catch (IOException e) {
            log.error("Upload failed", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }
    }

    // 3. SECURE PERSISTENT CHAT HISTORY FOR REFRESH
    @GetMapping("/api/history")
    @ResponseBody
    public ResponseEntity<List<ChatMessageDto>> getLiveChatHistory(@RequestParam("userId") Long userId,
                                                                   @RequestParam("adminId") Long adminId) {
        try {
            // Pull conversation data and filter out items where deletedByUser is true
            List<ChatMessageDto> history = complainService.getConversationHistoryForStudent(userId, adminId)
                    .stream()
                    .filter(msg -> msg.getDeletedByUser() == null || !msg.getDeletedByUser())
                    .collect(Collectors.toList());

            return ResponseEntity.ok(history);
        } catch (Exception e) {
            log.error("Error context search matching tracking chat timelines: ", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // 4. STUDENT SOFT PURGE ACTION (student-chat side only)
    @DeleteMapping("/api/delete/{id}")
    @ResponseBody
    public ResponseEntity<String> purgeMessageContext(@PathVariable("id") Long id) {
        try {
            complainService.executePageSoftDelete(id, Role.STUDENT.toString());

            // Notify via WebSocket so that the targeted element is instantly dropped from view
            messagingTemplate.convertAndSend("/topic/chat.delete", id);
            log.info("Soft hide operation successfully applied for Student interface on message ID: {}", id);

            return ResponseEntity.ok("Message visual trace successfully removed from your dashboard panel.");
        } catch (Exception e) {
            log.error("Student side visual clear macro execution crashed tracking transaction indices: ", e);
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Error processing message hide request: " + e.getMessage());
        }
    }
}


