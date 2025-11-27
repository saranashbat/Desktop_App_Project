package qa.udst.perfume_shop.model;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class CartItem {

    private String perfumeId;  
    private String perfumeName;
    private Double unitPrice;
    private Integer quantity;
}
