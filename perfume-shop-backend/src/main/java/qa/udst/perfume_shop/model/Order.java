package qa.udst.perfume_shop.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@Document(collection = "orders")
public class Order {

    @Id
    private String id;
    private String userId; // link order to user

    private List<CartItem> items;

    private Double subtotal;
    private Double deliveryFee;
    private Double total;

    private String deliveryMethod;   // "shipping" or "pickup"
    private String deliveryAddress;  // used only for shipping
    private String pickupLocation = "123 Corniche St., Elite Notes Store, Doha, Qatar"; // used only for pickup

    private String paymentStatus; 
    private PaymentMethod paymentMethod; // <--- HERE
 
    private OrderStatus orderStatus;    

    private LocalDateTime createdAt;
}
