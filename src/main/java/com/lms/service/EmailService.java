package com.lms.service;

import jakarta.servlet.ServletContext;
import jakarta.mail.internet.MimeMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

@Service
public class EmailService {

    private static final Logger log = LoggerFactory.getLogger(EmailService.class);
    private final JavaMailSender mailSender;
    private final ServletContext servletContext;

    public EmailService(JavaMailSender mailSender, ServletContext servletContext) {
        this.mailSender = mailSender;
        this.servletContext = servletContext;
    }

    public void sendOtp(String email, String otp) {
        if (email != null && otp != null && !email.isEmpty() && !otp.isEmpty()) {
            try {
                MimeMessage message = mailSender.createMimeMessage();
                MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
                helper.setTo(email);
                helper.setSubject("Library Management System - OTP Verification");
                String htmlContent = getOtpTemplate(otp);
                helper.setText(htmlContent, true);
                mailSender.send(message);
                System.out.println("OTP Sent Successfully");
            } catch (Exception e) {
                System.out.println("Error While Sending OTP");
                throw new RuntimeException("Unable to send OTP.", e);
            }
        } else {
            System.out.println("Email or OTP is Empty");
            throw new RuntimeException("Email and OTP are required.");
        }
    }

    private String getOtpTemplate(String otp) {
        try (InputStream is = servletContext.getResourceAsStream("/WEB-INF/jsp/otp-template.jsp")) {
            if (is == null) {
                return "Your OTP is: " + otp;
            } else {
                String template = new String(is.readAllBytes(), StandardCharsets.UTF_8);
                return template.replace("${otp}", otp);
            }
        } catch (Exception e) {
            return "Your OTP is: " + otp;
        }
    }
}
















/*
Question: Logger kyu use karte hain?
Ans :  Logger application ke events, warnings aur errors ko record karne ke liye use hota hai. Ye System.out.println()
se better hai kyunki logging levels (info, warn, error, debug) provide karta hai aur debugging me help karta hai.

Qus : ServletContext Kya Hota Hai?
ServletContext ek object hai jo poori web application ki information provide karta hai.
 Example :  Iske through aap:                   //Upload Folder Path//    String uploadDir = servletContext.getRealPath("/uploads");
Project ka path nikal sakte ho
Context path le sakte ho
Application-level data store kar sakte ho
Resources/files access kar sakte ho

Qus : MimeMessage Kya Hota Hai?
MimeMessage Java Mail API ka ek class hai jo email message create karne ke liye use hota hai.
Simple words me:
MimeMessage email ka container hota hai jisme To, From, Subject, Message Body, Attachments sab store hote hain.


Qus : try Kyu Use Kiya Hai?
try block isliye use kiya gaya hai kyunki email send karte time error aa sakta hai.
Example:
Internet issue
Gmail SMTP configuration galat
Wrong email address
Mail server down
Authentication failed

Agar error aa jaye aur try-catch na ho to application crash ho sakti hai.
for Example
try {
    mailSender.send(message);
}
catch (Exception e) {
    System.out.println("Email send nahi hua");
}

Qus : "UTF-8"
➡ Character encoding hai.
Hindi, special symbols, emojis etc. ko properly display karne ke liye.
 */

