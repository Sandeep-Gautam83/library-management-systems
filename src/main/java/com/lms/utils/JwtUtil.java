//package com.lms.utils;
//
//import io.jsonwebtoken.*;
//import io.jsonwebtoken.security.Keys;
//import jakarta.annotation.PostConstruct;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.stereotype.Component;
//
//import java.security.Key;
//import java.util.Date;
//
//@Component
//@Slf4j
//public class JwtUtil {
//
//    @Value("${jwt.secret}")
//    private String secret;
//
//    @Value("${jwt.expiration}")
//    private long expiration;
//
//    private Key key;
//
//    @PostConstruct
//    public void init() {
//        this.key = Keys.hmacShaKeyFor(secret.getBytes());
//    }
//
//    public String generateToken(String email) {
//
//        return Jwts.builder()
//                .setSubject(email)
//                .setIssuedAt(new Date())
//                .setExpiration(new Date(System.currentTimeMillis() + expiration))
//                .signWith(key, SignatureAlgorithm.HS256)
//                .compact();
//    }
//
//    public String extractEmail(String token) {
//        return extractClaims(token).getSubject();
//    }
//
//    public Date extractExpiration(String token) {
//        return extractClaims(token).getExpiration();
//    }
//
//    private Claims extractClaims(String token) {
//        return Jwts.parserBuilder()
//                .setSigningKey(key)
//                .build()
//                .parseClaimsJws(token)
//                .getBody();
//    }
//
//    public boolean validateToken(String token, String email) {
//        try {
//            String extractedEmail = extractEmail(token);
//            return (extractedEmail.equals(email) && !isTokenExpired(token));
//        } catch (JwtException | IllegalArgumentException e) {
//            log.error("Invalid JWT Token: {}", e.getMessage());
//            return false;
//        }
//    }
//
//    private boolean isTokenExpired(String token) {
//        return extractExpiration(token).before(new Date());
//    }
//}