package com.lms.service.Impl;

import com.lms.entity.Fine;
import com.lms.repository.FineRepository;
import com.lms.service.FineService;

import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class FineServiceImpl implements FineService {

    private final FineRepository fineRepository;
    public FineServiceImpl(FineRepository fineRepository) {
        this.fineRepository = fineRepository;
    }

    // add fine
@Override
public Fine addFine(Fine fine) {
    // Fine ki date aaj ki date set karo
    fine.setFineDate(LocalDate.now());
    // Fine status default UNPAID set karo
    fine.setFineStatus("UNPAID");
    // Fine ko database me save karo
    return fineRepository.save(fine);
}

@Override
public void createFine(Fine fine) {
    fine.setFineDate(LocalDate.now());
    fine.setFineStatus("UNPAID");
    fineRepository.save(fine);
}

    @Override
    public List<Fine> getAllFines() {
        return fineRepository.findAll();
    }

    @Override
    public Fine getFineById(Long fineId) {
        return fineRepository.findById(fineId).orElseThrow(() -> new RuntimeException("Fine Not Found"));
    }

    @Override
    public List<Fine> getPaidFines() {
        return fineRepository.findByFineStatus("PAID");
    }

    @Override
    public List<Fine> getUnpaidFines() {
        return fineRepository.findByFineStatus("UNPAID");
    }

    @Override
    public List<Fine> getFinesByRollNumber(String rollNumber) {
        return fineRepository.findByRollNumber(rollNumber);
    }

@Override
public Fine payFine(Long fineId) {
    // Fine ID se fine ko find karo
    Fine fine = fineRepository.findById(fineId).orElseThrow(() -> new RuntimeException("Fine Not Found"));
    // Fine ka status PAID set karo
    fine.setFineStatus("PAID");
    // Updated fine ko save karke return karo
    return fineRepository.save(fine);
}

    @Override
    public void deleteFine(Long fineId) {
        Fine fine = fineRepository.findById(fineId)
                .orElseThrow(() -> new RuntimeException("Fine Not Found"));
        fineRepository.delete(fine);
    }

}
