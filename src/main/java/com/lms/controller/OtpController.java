package com.lms.controller;

import com.lms.service.EmailService;
import com.lms.service.OtpStorageService;
import com.lms.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Random;

@Controller
@RequestMapping("/otp")
public class OtpController {

    private final EmailService emailService;
    private final OtpStorageService otpStorageService;
    private final UserService userService;

    public OtpController(EmailService emailService, OtpStorageService otpStorageService, UserService userService) {
        this.emailService = emailService;
        this.otpStorageService = otpStorageService;
        this.userService = userService;
    }

    // forget password
    @GetMapping("/forgot-password")
    public String forgotPasswordPage() {
        return "forgot-password";
    }

    // verify page
    @GetMapping("/verify")
    public String verifyPage() {
        return "forgot-password";
    }

    // SEND OTP
    @PostMapping("/send")
    @ResponseBody
    public String sendOtp(@RequestParam String email) {
        String otp = String.valueOf(100000 + new Random().nextInt(900000));
        otpStorageService.storeOtp(email, otp);
        emailService.sendOtp(email, otp);
        return "OTP sent successfully";
    }

    // VERIFY OTP
    @PostMapping("/verify")
    public String verifyOtp(
            @RequestParam String email,
            @RequestParam String otp,
            Model model
    ) {
        boolean isValid = otpStorageService.validateOtp(email, otp);
        if (!isValid) {
            model.addAttribute("error", "Invalid or Expired OTP");
            return "forgot-password";
        }
        return "redirect:/otp/reset-password?email=" + email;
    }

    // RESET PASSWORD PAGE
    @GetMapping("/reset-password")
    public String resetPasswordPage(
            @RequestParam String email,
            Model model
    ) {
        model.addAttribute("email", email);
        return "reset-password";
    }

    // UPDATE PASSWORD
    @PostMapping("/reset-password")
    public String updatePassword(
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String confirmPassword,
            Model model
    ) {
        // 1. Check if passwords match
        if (!password.equals(confirmPassword)) {
            model.addAttribute("error", "Passwords do not match");
            model.addAttribute("email", email);
            return "reset-password";
        }

        boolean isUpdated = userService.updatePassword(email, password);

        if (isUpdated) {
            model.addAttribute("success", "Password reset successful! Please login with your new password.");
            return "login";
        } else {
            model.addAttribute("error", "Failed to update password. User not found.");
            model.addAttribute("email", email);
            return "reset-password";
        }
    }
}