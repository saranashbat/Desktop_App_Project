package qa.udst.perfume_shop.model;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class CartItem {
    // private String perfumeId; // remove this
    private String perfumeName;  // store name instead
    private double unitPrice;
    private int quantity;
}
