package qa.udst.perfume_shop.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import qa.udst.perfume_shop.model.Order;

import java.util.List;

public interface OrderRepository extends MongoRepository<Order, String> {

    List<Order> findByUserId(String userId);
}
