package com.lms.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.boot.webmvc.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class CustomErrorController implements ErrorController {
    @RequestMapping("/error")
    public String handleError(HttpServletRequest request, Model model) {
        Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
        String errorCode = "Error";
        String errorMessage = "Something went wrong.";

        if (status != null) {
            int statusCode = Integer.parseInt(status.toString());
            errorCode = String.valueOf(statusCode);
            if (statusCode == 404) {
                errorMessage = "Page Not Found.";
            } else if (statusCode == 403) {
                errorMessage = "Access Denied.";
            } else if (statusCode == 405) {
                errorMessage = "Method Not Allowed.";
            } else if (statusCode == 500) {
                errorMessage = "Internal Server Error.";
            }
        }
        model.addAttribute("errorCode", errorCode);
        model.addAttribute("errorMessage", errorMessage);
        return "404-page";
    }
}
