package qa.udst.perfume_shop.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@NoArgsConstructor
@Document(collection = "payment_methods")
public class PaymentMethod {

    @Id
    private String id;

    private String name;        // "Visa", "Mastercard", "Cash on Delivery"
    private String type;        // "CARD", "WALLET", "COD"
    private String imagePath;   // "/images/payments/visa.png"
    private boolean enabled;    // TRUE if available
}
