package qa.udst.perfume_shop.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import qa.udst.perfume_shop.model.Cart;
import qa.udst.perfume_shop.model.CartItem;
import qa.udst.perfume_shop.repository.CartRepository;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CartService {

    private final CartRepository cartRepository;

    // Get cart by ID
    public Cart getCart(String cartId) {
        return cartRepository.findById(cartId)
                .orElseThrow(() -> new RuntimeException("Cart not found"));
    }

    // Get cart by user ID
    public Cart getCartByUser(String userId) {
        return cartRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Cart not found for user"));
    }

    // Create a new cart for a user
    public Cart createCart(Cart cart) {
        return cartRepository.save(cart);
    }

    // Add item to cart
    public Cart addItem(String userId, CartItem item) {
        Cart cart = getCartByUser(userId);
        cart.getItems().add(item);
        updateTotals(cart);
        return cartRepository.save(cart);
    }

    // Remove item from cart
    public Cart removeItem(String userId, String perfumeId) {
        Cart cart = getCartByUser(userId);
        cart.getItems().removeIf(i -> i.getPerfumeId().equals(perfumeId));
        updateTotals(cart);
        return cartRepository.save(cart);
    }

    // Helper to recalc totals
    private void updateTotals(Cart cart) {
        double subtotal = cart.getItems().stream()
                .mapToDouble(i -> i.getUnitPrice() * i.getQuantity())
                .sum();
        cart.setSubtotal(subtotal);

        // Example delivery fee logic
        double deliveryFee = subtotal > 200 ? 0 : 20;
        cart.setDeliveryFee(deliveryFee);
        cart.setTotal(subtotal + deliveryFee);
    }
}
