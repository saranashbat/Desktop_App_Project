package qa.udst.perfume_shop.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import qa.udst.perfume_shop.model.User;

import java.util.Optional;

public interface UserRepository extends MongoRepository<User, String> {

    Optional<User> findByUsername(String username);

    Optional<User> findByEmail(String email);
}
