package qa.udst.perfume_shop.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import qa.udst.perfume_shop.model.Order;
import qa.udst.perfume_shop.model.OrderStatus;
import qa.udst.perfume_shop.service.OrderService;

import java.util.List;

@RestController
@RequestMapping("/api/orders")
@RequiredArgsConstructor
@Tag(name = "Orders", description = "Manage order creation and retrieval")
public class OrderController {

    private final OrderService orderService;

    // CREATE ORDER -------------------------------------------
    @Operation(summary = "Create a new order")
    @PostMapping
    public ResponseEntity<Order> createOrder(@RequestBody Order order) {
        Order saved = orderService.createOrder(order);
        return ResponseEntity.status(201).body(saved);
    }

    // GET ALL ORDERS -----------------------------------------
    @Operation(summary = "Get all orders (admin)")
    @GetMapping
    public ResponseEntity<List<Order>> getAllOrders() {
        return ResponseEntity.ok(orderService.getAllOrders());
    }

    // GET ORDERS BY USER --------------------------------------
    @Operation(summary = "Get all orders for a specific user")
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Order>> getUserOrders(@PathVariable String userId) {
        return ResponseEntity.ok(orderService.getOrdersByUserId(userId));
    }

    // UPDATE ORDER STATUS -------------------------------------
    @Operation(summary = "Update status of an order")
    @PatchMapping("/{orderId}/status")
    public ResponseEntity<Order> updateStatus(
            @PathVariable String orderId,
            @RequestParam OrderStatus status
    ) {
        Order updated = orderService.updateOrderStatus(orderId, status);
        return ResponseEntity.ok(updated);
    }
}
