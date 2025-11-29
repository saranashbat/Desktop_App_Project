package qa.udst.perfume_shop.controller;

import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import qa.udst.perfume_shop.model.User;
import qa.udst.perfume_shop.service.UserService;
import qa.udst.perfume_shop.model.LoginRequest;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    // LOGIN --------------------------------------------------
    @Operation(summary = "Log in using email and password")
    @PostMapping("/login")
    public ResponseEntity<User> login(@RequestBody LoginRequest req) {
        User user = userService.login(req.getEmail(), req.getPassword());
        return ResponseEntity.ok(user);
    }

    // GET USER BY ID ----------------------------------------
    @Operation(summary = "Get a user's information")
    @GetMapping("/{id}")
    public ResponseEntity<User> getUser(@PathVariable String id) {
        return ResponseEntity.ok(userService.getUser(id));
    }

    // UPDATE profile image -----------------------------------
    @Operation(summary = "Update user's profile image path")
    @PatchMapping("/{id}/image")
    public ResponseEntity<User> updateProfileImage(
            @PathVariable String id,
            @RequestParam String imagePath
    ) {
        return ResponseEntity.ok(userService.updateProfileImage(id, imagePath));
    }

    // CREATE user (for seeding or testing)
    @Operation(summary = "Create a new user (admin/testing only)")
    @PostMapping
    public ResponseEntity<User> create(@RequestBody User user) {
        return ResponseEntity.status(201).body(userService.create(user));
    }
}
