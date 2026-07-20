package com.lms.entity;

import com.lms.Enum.Role;
import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "users")
@Builder
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Please enter your full name")
    @Column(name = "full_name", nullable = false)
    private String fullName;

    @Email
    @NotBlank(message = "Email is required")
    @Column(nullable = false, unique = true)
    private String email;

    @NotBlank(message = "Password is required")
    @Column(nullable = false)
    private String password;

    @Column(name = "roll_number", unique = true)
    private String rollNumber;

    @Column(name = "registration_number", unique = true)
    private String registrationNumber;

    @NotBlank(message = "Mobile number is required")
    @Column(name = "mobile_number", nullable = false, unique = true)
    private String mobileNumber;

    private String gender;

    private String course;

    private String branch;

    private String year;

    private String address;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private Role role = Role.STUDENT;

    @Builder.Default
    private Boolean approved = false;

    @Builder.Default
    private Boolean enabled = true;

    @Builder.Default
    private Boolean online = false;

    @Column(name = "last_seen")
    private LocalDateTime lastSeen;

    // Profile Image Association Mapping
    @OneToOne(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "profile_image_id", referencedColumnName = "id")
    private FileUploads profileImage;

    // PDF Documents File Link Mapping
    @OneToOne(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "pdf_file_id", referencedColumnName = "id")
    private FileUploads pdfFile;

    @OneToMany(
            mappedBy = "user",
            cascade = CascadeType.ALL,
            orphanRemoval = true,
            fetch = FetchType.LAZY
    )
    @Builder.Default
    private List<ChatMessage> chatMessages = new ArrayList<>();

    @Builder.Default
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Builder.Default
    @Column(name = "updated_at")
    private LocalDateTime updatedAt = LocalDateTime.now();

    public User(Long id, String fullName, String email, String password,
                String rollNumber, String registrationNumber, String mobileNumber,
                String gender, String course, String branch, String year, String address,
                Role role, Boolean approved, Boolean enabled, Boolean online, LocalDateTime lastSeen,
                FileUploads profileImage, FileUploads pdfFile, List<ChatMessage> chatMessages, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.rollNumber = rollNumber;
        this.registrationNumber = registrationNumber;
        this.mobileNumber = mobileNumber;
        this.gender = gender;
        this.course = course;
        this.branch = branch;
        this.year = year;
        this.address = address;
        this.role = role;
        this.approved = approved;
        this.enabled = enabled;
        this.online = online;
        this.lastSeen = lastSeen;
        this.profileImage = profileImage;
        this.pdfFile = pdfFile;
        this.chatMessages = chatMessages;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRollNumber() {
        return rollNumber;
    }

    public void setRollNumber(String rollNumber) {
        this.rollNumber = rollNumber;
    }

    public String getRegistrationNumber() {
        return registrationNumber;
    }

    public void setRegistrationNumber(String registrationNumber) {
        this.registrationNumber = registrationNumber;
    }

    public String getMobileNumber() {
        return mobileNumber;
    }

    public void setMobileNumber(String mobileNumber) {
        this.mobileNumber = mobileNumber;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getCourse() {
        return course;
    }

    public void setCourse(String course) {
        this.course = course;
    }

    public String getBranch() {
        return branch;
    }

    public void setBranch(String branch) {
        this.branch = branch;
    }

    public String getYear() {
        return year;
    }

    public void setYear(String year) {
        this.year = year;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public Boolean getApproved() {
        return approved;
    }

    public void setApproved(Boolean approved) {
        this.approved = approved;
    }

    public Boolean getEnabled() {
        return enabled;
    }

    public void setEnabled(Boolean enabled) {
        this.enabled = enabled;
    }

    public Boolean getOnline() {
        return online;
    }

    public void setOnline(Boolean online) {
        this.online = online;
    }

    public LocalDateTime getLastSeen() {
        return lastSeen;
    }

    public void setLastSeen(LocalDateTime lastSeen) {
        this.lastSeen = lastSeen;
    }

    public FileUploads getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(FileUploads profileImage) {
        this.profileImage = profileImage;
    }

    public FileUploads getPdfFile() {
        return pdfFile;
    }

    public void setPdfFile(FileUploads pdfFile) {
        this.pdfFile = pdfFile;
    }

    public List<ChatMessage> getChatMessages() {
        return chatMessages;
    }

    public void setChatMessages(List<ChatMessage> chatMessages) {
        this.chatMessages = chatMessages;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public User() {

    }

    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    public boolean isAdmin() {
        return this.role == Role.ADMIN;
    }

    public boolean isStudent() {
        return this.role == Role.STUDENT;
    }

    public String getDisplayName() {
        if (this.rollNumber == null || this.rollNumber.isBlank()) {
            return this.fullName + " (ADMIN)";
        }
        return this.fullName + " (" + this.rollNumber + ")";
    }

    public void addChatMessage(ChatMessage message) {
        if (message != null) {
            this.chatMessages.add(message);
            message.setUser(this);
        }
    }

    public void removeChatMessage(ChatMessage message) {
        if (message != null) {
            this.chatMessages.remove(message);
            message.setUser(null);
        }
    }
}


