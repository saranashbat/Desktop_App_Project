package qa.udst.perfume_shop.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import qa.udst.perfume_shop.model.Order;
import qa.udst.perfume_shop.model.OrderStatus;
import qa.udst.perfume_shop.repository.OrderRepository;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderRepository orderRepository;

    // CREATE order
    public Order createOrder(Order order) {
        order.setCreatedAt(LocalDateTime.now());
        if (order.getOrderStatus() == null) {
            order.setOrderStatus(OrderStatus.PROCESSING); // default status
        }
        return orderRepository.save(order);
    }

    // GET all orders
    public List<Order> getAllOrders() {
        return orderRepository.findAll();
    }

    // GET orders by user ID
    public List<Order> getOrdersByUserId(String userId) {
        return orderRepository.findByUserId(userId);
    }

    // UPDATE order status
    public Order updateOrderStatus(String orderId, OrderStatus status) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));
        order.setOrderStatus(status);
        return orderRepository.save(order);
    }
}
