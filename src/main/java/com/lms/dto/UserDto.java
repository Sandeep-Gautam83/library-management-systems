package com.lms.dto;

import com.lms.Enum.Role;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.*;

import java.time.LocalDateTime;

@Builder
public class UserDto {

    private Long id;

    @NotBlank(message = "Full name cannot be blank")
    private String fullName;

    @Email(message = "Please provide a valid email address")
    @NotBlank(message = "Email is required")
    private String email;

    private String password;

    @NotBlank(message = "Roll number is required")
    private String rollNumber;

    private String registrationNumber;

    @NotBlank(message = "Mobile number is required")
    @Pattern(regexp = "^\\d{10}$", message = "Mobile number must be exactly 10 digits")
    private String mobileNumber;

    private String gender;
    private String course;
    private String branch;
    private String year;
    private String address;

    private Role role;
    private Boolean approved;
    private Boolean enabled;
    private Boolean online;
    private LocalDateTime lastSeen;

    private String profileImageUrl;
    private String pdfFileUrl;

    public UserDto(Long id, String fullName, String email, String password, String rollNumber,
                   String registrationNumber, String mobileNumber, String gender, String course, String branch,
                   String year, String address, Role role, Boolean approved, Boolean enabled, Boolean online,
                   LocalDateTime lastSeen, String profileImageUrl, String pdfFileUrl) {
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
        this.profileImageUrl = profileImageUrl;
        this.pdfFileUrl = pdfFileUrl;
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

    public String getProfileImageUrl() {
        return profileImageUrl;
    }

    public void setProfileImageUrl(String profileImageUrl) {
        this.profileImageUrl = profileImageUrl;
    }

    public String getPdfFileUrl() {
        return pdfFileUrl;
    }

    public void setPdfFileUrl(String pdfFileUrl) {
        this.pdfFileUrl = pdfFileUrl;
    }

    public UserDto() {

    }

    /**
     * Custom utility method to easily convert Entity to DTO securely
     */
    public static UserDto fromEntity(com.lms.entity.User user) {
        if (user == null) return null;

        return UserDto.builder()
                .id(user.getId())
                .fullName(user.getFullName())
                .email(user.getEmail())
                .rollNumber(user.getRollNumber())
                .registrationNumber(user.getRegistrationNumber())
                .mobileNumber(user.getMobileNumber())
                .gender(user.getGender())
                .course(user.getCourse())
                .branch(user.getBranch())
                .year(user.getYear())
                .address(user.getAddress())
                .role(user.getRole())
                .approved(user.getApproved())
                .enabled(user.getEnabled())
                .online(user.getOnline())
                .password(null)
                .build();
    }

}
