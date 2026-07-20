package com.lms.service;

import com.lms.Enum.Role;
import com.lms.dto.UserDto;
import com.lms.entity.User;
import java.util.List;

public interface UserService {

    UserDto registerNewUser(UserDto userDto);
    UserDto authenticateUser(String email, String password);
    User getLoggedInUser();
    void changePassword(Long id, String oldPassword, String newPassword);
    boolean updatePassword(String email, String password);

    UserDto getUserById(Long id);
    UserDto getUserByEmail(String email);
    User getUserByRollNumber(String rollNumber);
    List<User> getAllUsers();
    List<UserDto> getAllUsersByRole(Role role);

    List<UserDto> getAllApprovedStudents();
    List<User> getApprovedStudents();
    List<User> getPendingStudents();
    UserDto toggleUserApproval(Long userId, Boolean approvedState);
    void approveStudent(Long id);
    void cancelStudent(Long id);

    User updateUser(Long id, User user);
    User updateStudent(Long id, User user);
    void deleteUser(Long id);

    void changeUserOnlineStatus(Long userId, Boolean isOnline);
    void updateUserProfileImage(Long userId, Long fileUploadId);

    long totalStudents();
    long pendingStudentsCount();
    User toggleUserRole(Long id);


}

