package qa.udst.perfume_shop.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@NoArgsConstructor
@Document(collection = "notes")
public class Note {

    @Id
    private String id;

    private String name; // e.g., "Bergamot", "Vanilla", "Sandalwood"
}
