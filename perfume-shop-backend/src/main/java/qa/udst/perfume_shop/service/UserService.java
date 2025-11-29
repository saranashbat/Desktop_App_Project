package qa.udst.perfume_shop.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import qa.udst.perfume_shop.model.User;
import qa.udst.perfume_shop.repository.UserRepository;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepo;

    // LOGIN
    public User login(String email, String password) {
        User user = userRepo.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // For now: simple comparison
        // Later: use BCrypt
        if (!user.getPasswordHash().equals(password)) {
            throw new RuntimeException("Invalid credentials");
        }

        return user;
    }

    // GET user by ID
    public User getUser(String id) {
        return userRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    // UPDATE profile picture path
    public User updateProfileImage(String userId, String imagePath) {
        User user = getUser(userId);
        user.setImagePath(imagePath);
        return userRepo.save(user);
    }

    // CREATE user (for seeding or admin)
    public User create(User u) {
        return userRepo.save(u);
    }
}
