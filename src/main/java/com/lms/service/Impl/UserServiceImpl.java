package com.lms.service.Impl;

import com.lms.Enum.Role;
import com.lms.dto.UserDto;
import com.lms.entity.FileUploads;
import com.lms.entity.User;
import com.lms.repository.ChatMessageRepository;
import com.lms.repository.FileUploadRepository;
import com.lms.repository.UserRepository;
import com.lms.service.UserService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import jakarta.transaction.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final FileUploadRepository fileUploadRepository;
    private final ChatMessageRepository chatMessageRepository;

    public UserServiceImpl(UserRepository userRepository,
                           FileUploadRepository fileUploadRepository,
                           ChatMessageRepository chatMessageRepository) {
        this.userRepository = userRepository;
        this.fileUploadRepository = fileUploadRepository;
        this.chatMessageRepository = chatMessageRepository;
    }

    @Override
    public UserDto registerNewUser(UserDto dto) {
        if (dto == null) {
            throw new IllegalArgumentException("Registration failed: User details cannot be empty.");
        }

        // 1. Validation Checks using if-else
        if (userRepository.existsByEmail(dto.getEmail())) {
            throw new IllegalArgumentException("Registration failed: Email is already registered.");
        }
        if (dto.getRollNumber() != null && !dto.getRollNumber().isBlank()) {
            if (userRepository.existsByRollNumber(dto.getRollNumber())) {
                throw new IllegalArgumentException("Registration failed: Roll number is already assigned.");
            }
        }

        // 2. Setting Default Values properly using if-else
        Role finalRole = Role.STUDENT;
        if (dto.getRole() != null) {
            finalRole = dto.getRole();
        }

        try {
            // 3. Object Creation with safe mappings (Fixing NULL lastSeen)
            User user = User.builder()
                    .fullName(dto.getFullName())
                    .email(dto.getEmail())
                    .password(dto.getPassword())
                    .rollNumber(dto.getRollNumber())
                    .registrationNumber(dto.getRegistrationNumber())
                    .mobileNumber(dto.getMobileNumber())
                    .gender(dto.getGender())
                    .course(dto.getCourse())
                    .branch(dto.getBranch())
                    .year(dto.getYear())
                    .address(dto.getAddress())
                    .role(finalRole)
                    .approved(false)
                    .enabled(true)
                    .online(false)
                    .lastSeen(LocalDateTime.now()) // Crucial Fix: Sets default last seen
                    .createdAt(LocalDateTime.now())
                    .updatedAt(LocalDateTime.now())
                    .build();

            User savedUser = userRepository.save(user);
            return UserDto.fromEntity(savedUser);

        } catch (Exception e) {
            throw new RuntimeException("Unexpected internal error occurred during user registration: " + e.getMessage(), e);
        }
    }

    @Override
    public UserDto authenticateUser(String email, String password) {
        if (email == null || password == null) {
            throw new IllegalArgumentException("Email and Password cannot be empty.");
        }

        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isEmpty()) {
            throw new EntityNotFoundException("Authentication failed: Email does not exist.");
        }

        User user = userOpt.get();
        if (!user.getPassword().equals(password)) {
            throw new IllegalArgumentException("Authentication failed: Incorrect password.");
        }

        return UserDto.fromEntity(user);
    }

    @Override
    public void changePassword(Long id, String oldPassword, String newPassword) {
        if (id == null || oldPassword == null || newPassword == null) {
            throw new IllegalArgumentException("All parameters (ID, old password, new password) are required.");
        }

        Optional<User> userOpt = userRepository.findById(id);
        if (userOpt.isEmpty()) {
            throw new EntityNotFoundException("User not found with ID: " + id);
        }

        User user = userOpt.get();
        if (!user.getPassword().equals(oldPassword)) {
            throw new IllegalArgumentException("Old password is incorrect.");
        }

        user.setPassword(newPassword);
        userRepository.save(user);
    }

    @Override
    public boolean updatePassword(String email, String password) {
        if (email == null || password == null) {
            return false;
        }

        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setPassword(password);
            userRepository.save(user);
            return true;
        } else {
            return false;
        }
    }

    @Override
    public UserDto getUserById(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("ID cannot be null.");
        }

        Optional<User> userOpt = userRepository.findById(id);
        if (userOpt.isEmpty()) {
            throw new EntityNotFoundException("No user profile found matching ID: " + id);
        }

        return UserDto.fromEntity(userOpt.get());
    }

    @Override
    public UserDto getUserByEmail(String email) {
        if (email == null) {
            throw new IllegalArgumentException("Email cannot be null.");
        }

        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isEmpty()) {
            throw new EntityNotFoundException("No account linked with email: " + email);
        }

        return UserDto.fromEntity(userOpt.get());
    }

    @Override
    public User getUserByRollNumber(String rollNumber) {
        if (rollNumber == null) {
            throw new IllegalArgumentException("Roll number cannot be null.");
        }

        Optional<User> userOpt = userRepository.findByRollNumber(rollNumber);
        if (userOpt.isEmpty()) {
            throw new EntityNotFoundException("Roll number index trace empty: " + rollNumber);
        }

        return userOpt.get();
    }

    @Override
    public List<User> getAllUsers() {
        try {
            return userRepository.findAll();
        } catch (Exception e) {
            throw new RuntimeException("Database error loading user directories: " + e.getMessage(), e);
        }
    }

    @Override
    public List<UserDto> getAllUsersByRole(Role role) {
        if (role == null) {
            throw new IllegalArgumentException("Role cannot be null.");
        }
        return userRepository.findByRole(role).stream()
                .map(UserDto::fromEntity)
                .collect(Collectors.toList());
    }

    @Override
    public List<UserDto> getAllApprovedStudents() {
        return userRepository.findByRoleAndApprovedTrue(Role.STUDENT).stream()
                .map(UserDto::fromEntity)
                .collect(Collectors.toList());
    }

    @Override
    public List<User> getApprovedStudents() {
        return userRepository.findByRoleAndApprovedTrue(Role.STUDENT);
    }

    @Override
    public List<User> getPendingStudents() {
        return userRepository.findByRole(Role.STUDENT).stream()
                .filter(user -> user.getApproved() != null && !user.getApproved())
                .collect(Collectors.toList());
    }

    @Override
    public UserDto toggleUserApproval(Long userId, Boolean approvedState) {
        if (userId == null || approvedState == null) {
            throw new IllegalArgumentException("User ID and Approved state cannot be null.");
        }

        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            throw new EntityNotFoundException("Approval state change failed. User missing.");
        }

        User user = userOpt.get();
        user.setApproved(approvedState);
        return UserDto.fromEntity(userRepository.save(user));
    }

    @Override
    public void approveStudent(Long id) {
        this.toggleUserApproval(id, true);
    }

    @Override
    public void cancelStudent(Long id) {
        this.toggleUserApproval(id, false);
    }

    @Override
    public User updateUser(Long id, User source) {
        if (id == null || source == null) {
            throw new IllegalArgumentException("User ID and source details cannot be null.");
        }

        Optional<User> userOpt = userRepository.findById(id);
        if (userOpt.isEmpty()) {
            throw new EntityNotFoundException("Update rejected. Target database record missing.");
        }

        User target = userOpt.get();
        target.setFullName(source.getFullName());
        target.setMobileNumber(source.getMobileNumber());
        target.setAddress(source.getAddress());
        target.setGender(source.getGender());
        return userRepository.save(target);
    }

    @Override
    public User updateStudent(Long id, User source) {
        if (id == null || source == null) {
            throw new IllegalArgumentException("User ID and student data details cannot be null.");
        }

        Optional<User> userOpt = userRepository.findById(id);
        if (userOpt.isEmpty()) {
            throw new EntityNotFoundException("Student parameters sync failed. Record empty.");
        }

        User student = userOpt.get();
        student.setCourse(source.getCourse());
        student.setBranch(source.getBranch());
        student.setYear(source.getYear());
        return userRepository.save(student);
    }

    @Override
    @Transactional
    public void deleteUser(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("User ID cannot be null.");
        }

        if (!userRepository.existsById(id)) {
            throw new EntityNotFoundException("User not found with ID: " + id);
        } else {
            chatMessageRepository.deleteBySenderIdOrRecipientId(id, id);
            userRepository.deleteById(id);
        }
    }

    @Override
    public void changeUserOnlineStatus(Long userId, Boolean isOnline) {
        if (userId == null || isOnline == null) {
            throw new IllegalArgumentException("Invalid state synchronization parameters.");
        }
        try {
            userRepository.updateStatusById(userId, isOnline, LocalDateTime.now());
        } catch (Exception e) {
            throw new RuntimeException("Network visibility state synchronization failed: " + e.getMessage(), e);
        }
    }

    @Override
    public void updateUserProfileImage(Long userId, Long fileUploadId) {
        if (userId == null || fileUploadId == null) {
            throw new IllegalArgumentException("User ID and File Asset ID cannot be null.");
        }

        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            throw new EntityNotFoundException("Asset mapping failed. User profile missing.");
        }

        Optional<FileUploads> assetOpt = fileUploadRepository.findById(fileUploadId);
        if (assetOpt.isEmpty()) {
            throw new EntityNotFoundException("Binary file asset not found inside standard uploads storage track.");
        }

        // Crucial Fix: Mapping relation correctly before saving
        User user = userOpt.get();
        FileUploads asset = assetOpt.get();
        user.setProfileImage(asset);

        userRepository.save(user);
    }

    @Override
    public long totalStudents() {
        try {
            return userRepository.countByRole(Role.STUDENT);
        } catch (Exception e) {
            return 0;
        }
    }

    @Override
    public long pendingStudentsCount() {
        try {
            return userRepository.countByApproved(false);
        } catch (Exception e) {
            return 0;
        }
    }

    @Override
    public User toggleUserRole(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("User ID cannot be null.");
        }

        Optional<User> userOpt = userRepository.findById(id);
        if (userOpt.isEmpty()) {
            throw new EntityNotFoundException("Role processing converter aborted. Profile missing.");
        }

        User user = userOpt.get();
        if (user.getRole() == Role.STUDENT) {
            user.setRole(Role.ADMIN);
        } else {
            user.setRole(Role.STUDENT);
        }

        return userRepository.save(user);
    }

    @Override
    public User getLoggedInUser() {
        try {
            Object principal = org.springframework.security.core.context.SecurityContextHolder
                    .getContext().getAuthentication().getPrincipal();

            if (principal instanceof org.springframework.security.core.userdetails.UserDetails) {
                String email = ((org.springframework.security.core.userdetails.UserDetails) principal).getUsername();
                return userRepository.findByEmail(email).orElse(null);
            }
        } catch (Exception e) {
            // Spring Security implementation not available, return safe null
            return null;
        }
        return null;
    }
}
