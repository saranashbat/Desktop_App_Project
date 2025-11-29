package qa.udst.perfume_shop.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import qa.udst.perfume_shop.model.PaymentMethod;
import qa.udst.perfume_shop.service.PaymentMethodService;

import java.util.List;

@RestController
@RequestMapping("/api/payment-methods")
@RequiredArgsConstructor
@CrossOrigin("*")
public class PaymentMethodController {

    private final PaymentMethodService paymentMethodService;

    @GetMapping
    public List<PaymentMethod> getAllPaymentMethods() {
        return paymentMethodService.getAll();
    }

    @PostMapping
    public PaymentMethod create(@RequestBody PaymentMethod pm) {
        return paymentMethodService.create(pm);
    }
}
