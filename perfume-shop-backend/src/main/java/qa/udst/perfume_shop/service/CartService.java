package qa.udst.perfume_shop.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import qa.udst.perfume_shop.model.Cart;
import qa.udst.perfume_shop.model.CartItem;
import qa.udst.perfume_shop.repository.CartRepository;

import java.util.List;
import java.util.Optional;
import java.util.ArrayList;

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

    public Cart addItem(String userId, CartItem item) {
    Cart cart = getCartByUser(userId);
    if (cart == null) {
        cart = new Cart();
        cart.setUserId(userId);
        cart.setItems(new ArrayList<>());
    }

    // Check if item already exists by perfume name
    Optional<CartItem> existing = cart.getItems().stream()
        .filter(i -> i.getPerfumeName().equalsIgnoreCase(item.getPerfumeName()))
        .findFirst();

    if (existing.isPresent()) {
        existing.get().setQuantity(existing.get().getQuantity() + item.getQuantity());
    } else {
        cart.getItems().add(item);
    }

    recalculateCart(cart);
    // save cart to DB (repository.save(cart))
    return cart;
}

public Cart removeItemByName(String userId, String perfumeName) {
    Cart cart = getCartByUser(userId);
    if (cart != null) {
        cart.setItems(cart.getItems().stream()
                .filter(i -> !i.getPerfumeName().equalsIgnoreCase(perfumeName))
                .toList());
        recalculateCart(cart);
        // save cart to DB
    }
    return cart;
}

// Optional: recalc subtotal/total
private void recalculateCart(Cart cart) {
    double subtotal = cart.getItems().stream()
            .mapToDouble(i -> i.getUnitPrice() * i.getQuantity())
            .sum();
    cart.setSubtotal(subtotal);
    cart.setDeliveryFee(subtotal > 0 ? 5.0 : 0.0); // example
    cart.setTotal(subtotal + cart.getDeliveryFee());
}
}