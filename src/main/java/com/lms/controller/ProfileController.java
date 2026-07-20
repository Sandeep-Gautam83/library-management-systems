package com.lms.controller;

import com.lms.entity.User;
import com.lms.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ModelAttribute;

@Controller
public class ProfileController {

    private final UserRepository userRepository;

    public ProfileController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping("/profile")
    public String profilePage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedInUser");
        if(user == null){
            return "redirect:/login";
        }
        model.addAttribute("loggedInUser", user);
        return "profile";
    }

    @GetMapping("/edit-profile")
    public String editProfilePage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedInUser");
        if(user == null) {
            return "redirect:/login";
        }
        model.addAttribute("user", user);
        return "edit-profile";
    }

    @PostMapping("/update-profile")
    public String updateProfile(@ModelAttribute User updatedUser, HttpSession session) {

        User existingUser = (User) session.getAttribute("loggedInUser");

        if(existingUser == null){
            return "redirect:/login";
        }


        // KEEP OLD DATA
        existingUser.setFullName(updatedUser.getFullName());

        existingUser.setEmail(updatedUser.getEmail());

        existingUser.setMobileNumber(updatedUser.getMobileNumber());

        existingUser.setRollNumber(updatedUser.getRollNumber());

        existingUser.setCourse(updatedUser.getCourse());

        existingUser.setBranch(updatedUser.getBranch());

        existingUser.setYear(updatedUser.getYear());

        existingUser.setGender(updatedUser.getGender());

        existingUser.setAddress(updatedUser.getAddress());

        // SAVE UPDATED USER
        userRepository.save(existingUser);
        // UPDATE SESSION
        session.setAttribute("loggedInUser", existingUser);

        return "redirect:/profile";
    }
}