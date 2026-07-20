package com.lms.controller;

import com.lms.entity.Fine;
import com.lms.service.FineService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class FineController {
    private final FineService fineService;

    // Constructor Injection
    public FineController(FineService fineService) {
        this.fineService = fineService;
    }

    // This now matches: http://localhost:8083/admin/fine/all
    @GetMapping("/fine/all")
    public String finePage(Model model) {
        List<Fine> fines = fineService.getAllFines();

        // Stream api logic: Sirf 'PAID' fines ka amount calculate karne ke liye
        double totalAmount = fines.stream()
                .filter(fine -> "PAID".equalsIgnoreCase(fine.getFineStatus()))
                .mapToDouble(fine -> fine.getFineAmount() == null ? 0 : fine.getFineAmount())
                .sum();

        model.addAttribute("fineList", fines);
        model.addAttribute("totalAmount", totalAmount);

        return "fine"; // Make sure fine.jsp or fine.html exists in your templates/views folder!
    }

    // This now matches: http://localhost:8083/admin/fine/pay
    @PostMapping("/fine/pay")
    public String processFinePayment(
            @RequestParam("fineId") Long fineId,
            RedirectAttributes redirectAttributes) {
        try {
            fineService.payFine(fineId);
            redirectAttributes.addFlashAttribute("successMessage", "Fine ID #" + fineId + " successfully PAID");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error updating status: " + e.getMessage());
        }

        // Redirect back to the absolute path of the list page
        return "redirect:/admin/fine/all";
    }
}

