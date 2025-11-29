package qa.udst.perfume_shop.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import qa.udst.perfume_shop.model.PaymentMethod;

public interface PaymentMethodRepository extends MongoRepository<PaymentMethod, String> {
}
