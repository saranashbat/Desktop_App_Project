package qa.udst.perfume_shop.controller;

import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import qa.udst.perfume_shop.model.Cart;
import qa.udst.perfume_shop.model.CartItem;
import qa.udst.perfume_shop.service.CartService;

@RestController
@RequestMapping("/api/carts")
@RequiredArgsConstructor
public class CartController {

    private final CartService cartService;

    @Operation(summary = "Get cart by user ID")
    @GetMapping("/user/{userId}")
    public ResponseEntity<Cart> getCartByUser(@PathVariable String userId) {
        return ResponseEntity.ok(cartService.getCartByUser(userId));
    }

    @Operation(summary = "Add item to cart")
    @PostMapping("/user/{userId}/add")
    public ResponseEntity<Cart> addItem(
            @PathVariable String userId,
            @RequestBody CartItem item
    ) {
        return ResponseEntity.ok(cartService.addItem(userId, item));
    }

    @DeleteMapping("/user/{userId}/remove/{perfumeName}")
public ResponseEntity<Cart> removeItem(
        @PathVariable String userId,
        @PathVariable String perfumeName
) {
    return ResponseEntity.ok(cartService.removeItemByName(userId, perfumeName));
}

}
