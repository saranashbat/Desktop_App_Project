package qa.udst.perfume_shop.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import qa.udst.perfume_shop.model.PaymentMethod;
import qa.udst.perfume_shop.repository.PaymentMethodRepository;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PaymentMethodService {

    private final PaymentMethodRepository paymentMethodRepository;

    public List<PaymentMethod> getAll() {
        return paymentMethodRepository.findAll();
    }

    public PaymentMethod create(PaymentMethod pm) {
        return paymentMethodRepository.save(pm);
    }
}
