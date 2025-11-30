package qa.udst.perfume_shop.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import qa.udst.perfume_shop.model.Cart;
import qa.udst.perfume_shop.model.CartItem;
import qa.udst.perfume_shop.repository.CartRepository;

import java.util.ArrayList;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CartService {

    private final CartRepository cartRepository;

    // Get cart by user ID (create if not exists)
    public Cart getCartByUser(String userId) {
        return cartRepository.findByUserId(userId)
                .orElseGet(() -> {
                    Cart newCart = new Cart();
                    newCart.setUserId(userId);
                    newCart.setItems(new ArrayList<>());
                    newCart.setSubtotal(0.0);
                    newCart.setDeliveryFee(0.0);
                    newCart.setTotal(0.0);
                    return cartRepository.save(newCart);
                });
    }

    // Add item to cart
    public Cart addItem(String userId, CartItem item) {
        Cart cart = getCartByUser(userId);

        // Check if item already exists by perfume name
        Optional<CartItem> existing = cart.getItems().stream()
            .filter(i -> i.getPerfumeName().equalsIgnoreCase(item.getPerfumeName()))
            .findFirst();

        if (existing.isPresent()) {
            // Update quantity
            existing.get().setQuantity(existing.get().getQuantity() + item.getQuantity());
        } else {
            // Add new item
            cart.getItems().add(item);
        }

        recalculateCart(cart);
        return cartRepository.save(cart); // ✅ SAVE!
    }

    // Remove item by name
    public Cart removeItemByName(String userId, String perfumeName) {
        Cart cart = getCartByUser(userId);
        
        cart.setItems(
            cart.getItems().stream()
                .filter(i -> !i.getPerfumeName().equalsIgnoreCase(perfumeName))
                .toList()
        );
        
        recalculateCart(cart);
        return cartRepository.save(cart); // ✅ SAVE!
    }

    // Update item quantity
    public Cart updateItemQuantity(String userId, String perfumeName, int newQuantity) {
        Cart cart = getCartByUser(userId);

        if (newQuantity <= 0) {
            return removeItemByName(userId, perfumeName);
        }

        cart.getItems().stream()
            .filter(i -> i.getPerfumeName().equalsIgnoreCase(perfumeName))
            .findFirst()
            .ifPresent(item -> item.setQuantity(newQuantity));

        recalculateCart(cart);
        return cartRepository.save(cart); // ✅ SAVE!
    }

    // Clear cart
    public Cart clearCart(String userId) {
        Cart cart = getCartByUser(userId);
        cart.setItems(new ArrayList<>());
        cart.setSubtotal(0.0);
        cart.setDeliveryFee(0.0);
        cart.setTotal(0.0);
        return cartRepository.save(cart);
    }

    // Recalculate totals
    private void recalculateCart(Cart cart) {
        double subtotal = cart.getItems().stream()
                .mapToDouble(i -> i.getUnitPrice() * i.getQuantity())
                .sum();
        
        cart.setSubtotal(subtotal);
        cart.setDeliveryFee(subtotal > 0 ? 5.0 : 0.0);
        cart.setTotal(subtotal + cart.getDeliveryFee());
    }
}