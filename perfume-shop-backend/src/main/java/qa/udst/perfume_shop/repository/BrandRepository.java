package qa.udst.perfume_shop.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import qa.udst.perfume_shop.model.Brand;
import java.util.Optional;

public interface BrandRepository extends MongoRepository<Brand, String> {
    Optional<Brand> findByName(String name);
}
