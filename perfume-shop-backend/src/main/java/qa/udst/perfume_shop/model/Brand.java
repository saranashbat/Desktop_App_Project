package qa.udst.perfume_shop.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@NoArgsConstructor
@Document(collection = "brands")
public class Brand {

    @Id
    private String id;

    private String name;          // e.g. "Tom Ford"
    private String description;   // optional: brand history
    private String logoPath;      // e.g. "/images/brands/tomford.png"
}
