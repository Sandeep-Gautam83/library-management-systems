//package com.lms.utils;
//
//import jakarta.servlet.FilterChain;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.stereotype.Component;
//import org.springframework.web.filter.OncePerRequestFilter;
//import java.io.IOException;
//
//@Component
//@Slf4j
//public class JwtFilter extends OncePerRequestFilter {
//    @Override
//    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
//        filterChain.doFilter(request, response);
//    }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
///*
//
//@Slf4j Lombok annotation hai jo automatically SLF4J logger create karta hai.
//Isse manually Logger aur LoggerFactory likhne ki zaroorat nahi padti.
//Iska use application logs, debugging aur error tracking ke liye kiya jata hai.
//
//Qus : HttpServletRequest Kya Hota Hai?
//HttpServletRequest ek Servlet API interface hai jo client (browser) se aane wali request ki information ko access karne ke liye use hota hai.
//
//Qus : HttpServletResponse Kya Hota Hai?
//HttpServletResponse ek Servlet API interface hai jo server se client (browser) ko response bhejne ke liye use hota hai.
//
//FilterChain Kya Hota Hai?
//FilterChain Servlet API ka interface hai jo ek filter se request ko agle filter ya target resource (Servlet/Controller) tak bhejne ke liye use hota hai.
//
// */
//
