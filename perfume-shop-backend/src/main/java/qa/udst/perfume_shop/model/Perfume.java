package qa.udst.perfume_shop.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Data
@NoArgsConstructor
@Document(collection = "perfumes")
public class Perfume {

    @Id
    private String id;

    private String name;
    private String brand; 
    private Double price;
    private String imagePath;
    private String description;

    private List<PerfumeNote> notes;

}
