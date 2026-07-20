package com.lms.service;
import com.lms.entity.OtpDetails;
import com.lms.repository.OtpRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.Optional;

@Service
public class OtpStorageService {

    private final OtpRepository otpRepository;

    public OtpStorageService(OtpRepository otpRepository) {
        this.otpRepository = otpRepository;
    }

    @Transactional
    public void storeOtp(String email, String otp) {
        LocalDateTime expiryTime = LocalDateTime.now().plusMinutes(3);       // otp expiry time 3 minute
        OtpDetails otpDetails = otpRepository.findByEmail(email)
                .orElse(new OtpDetails());
        otpDetails.setEmail(email);
        otpDetails.setOtp(otp);
        otpDetails.setExpirationTime(expiryTime);
        otpRepository.save(otpDetails);
    }

    public boolean validateOtp(String email, String otp) {
        Optional<OtpDetails> optionalOtp = otpRepository.findByEmail(email);
        if (optionalOtp.isEmpty()) {
            return false;
        }
        OtpDetails otpDetails = optionalOtp.get();
        if (otpDetails.getExpirationTime().isBefore(LocalDateTime.now())) {
            return false;
        }
        if (otpDetails.getOtp().equals(otp)) {
            return true;
        } else {
            return false;
        }
    }

    @Transactional
    public void clearOtp(String email) {
        otpRepository.deleteByEmail(email);
    }

}

