package com.lms.service;

import com.lms.entity.Fine;
import java.util.List;

public interface FineService {

    Fine addFine(Fine fine);

    List<Fine> getAllFines();

    Fine getFineById(Long fineId);

    List<Fine> getPaidFines();

    List<Fine> getUnpaidFines();

    List<Fine> getFinesByRollNumber(String rollNumber);

    Fine payFine(Long fineId);

    void deleteFine(Long fineId);

    void createFine(Fine fine);

}
