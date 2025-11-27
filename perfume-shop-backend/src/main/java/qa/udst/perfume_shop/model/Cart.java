package qa.udst.perfume_shop.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Data
@NoArgsConstructor
@Document(collection = "carts")
public class Cart {

    @Id
    private String id;

    private String userId; // linking the cart to the user

    private List<CartItem> items;

    private Double subtotal;
    private Double deliveryFee;
    private Double total;
}
