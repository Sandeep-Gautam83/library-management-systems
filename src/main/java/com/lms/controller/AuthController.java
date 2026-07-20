package com.lms.controller;

import com.lms.Enum.Role;
import com.lms.dto.UserDto;
import com.lms.entity.User;
import com.lms.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class AuthController {

    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    // Login Page Open
    @GetMapping("/login")
    public String loginPage(HttpSession session, Model model) {
        try {
            UserDto user = (UserDto) session.getAttribute("loggedInUser");
            if (user != null) {
                return redirectToDashboard(user);
            } else {
                model.addAttribute("userDto", new UserDto());
                return "login";
            }
        } catch (Exception e) {
            return "login";
        }
    }

    @GetMapping("/admin/login")
    public String adminLoginPage(HttpSession session, Model model) {
        return loginPage(session, model);
    }

    @GetMapping("/register")
    public String registerPage(Model model) {
        model.addAttribute("userDto", new UserDto());
        return "register";
    }

    // Student Registration
    @PostMapping("/auth/register")
    public String registerUser(@ModelAttribute("userDto") UserDto userDto, Model model) {
        try {
            // Check role
            if (userDto.getRole() == null) {
                userDto.setRole(Role.STUDENT);
            }
            userService.registerNewUser(userDto);
            model.addAttribute("success", "Registration Successful! Wait for Admin Approval.");
            model.addAttribute("userDto", new UserDto());
            return "login";
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("userDto", userDto);
            return "register";
        } catch (Exception e) {
            model.addAttribute("error", "Registration Failed.");
            model.addAttribute("userDto", userDto);
            return "register";
        }
    }

    @PostMapping("/auth/login")
    public String loginUser(@RequestParam String email, @RequestParam String password, HttpSession session, Model model) {
        try {
            UserDto userDto = userService.authenticateUser(email, password);

            if (userDto == null) {
                model.addAttribute("error", "Email or Password is incorrect.");
                return "login";
            }

            if (userDto.getRole() == Role.STUDENT) {
                if (userDto.getApproved() == null || !userDto.getApproved()) {
                    model.addAttribute("error", "Admin verification approval is pending.");
                    return "login";
                }
            }

            // Establish secure session variables tracking
            session.setAttribute("loggedInUser", userDto);
            session.setAttribute("userId", userDto.getId());
            session.setAttribute("userName", userDto.getFullName());
            session.setAttribute("userEmail", userDto.getEmail());
            session.setAttribute("userRole", userDto.getRole().toString());

            return redirectToDashboard(userDto);

        } catch (Exception e) {
            model.addAttribute("error", "Wrong Password! Please Enter Correct Password.");
            return "login";
        }
    }

    @GetMapping({"/auth/logout", "/admin/logout"})
    public String logout(HttpSession session) {
        try {
            if (session != null) {
                session.invalidate();
            }
        } catch (Exception ignored) {}
        return "redirect:/login";
    }

    // 3. ROLE SWITCHER INTERACTION LAYER (STUDENT <-> ADMIN) WITH SYNC
    @GetMapping("/auth/toggle-role/{id}")
    public String toggleUserRole(@PathVariable Long id, HttpSession session, Model model) {
        try {
            User updatedUserEntity = userService.toggleUserRole(id);
            UserDto updatedUserDto = UserDto.fromEntity(updatedUserEntity);

            UserDto loggedInUser = (UserDto) session.getAttribute("loggedInUser");

            // Session Refresh sync block
            if (loggedInUser != null && loggedInUser.getId().equals(id)) {
                session.setAttribute("loggedInUser", updatedUserDto);
                session.setAttribute("userRole", updatedUserDto.getRole().toString());
                session.setAttribute("userName", updatedUserDto.getFullName());

                return redirectToDashboard(updatedUserDto);
            }

            return "redirect:/admin/students?success=Role modified to " + updatedUserDto.getRole();

        } catch (Exception e) {
            return "redirect:/login?error=Role transformation operation rejected.";
        }
    }

    private String redirectToDashboard(UserDto user) {
        if (user.getRole() == Role.ADMIN) {
            return "redirect:/admin/dashboard";
        }
        return "redirect:/student/dashboard";
    }
}




