package qa.udst.perfume_shop.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;


import qa.udst.perfume_shop.model.Perfume;

import java.util.List;

public interface PerfumeRepository extends MongoRepository<Perfume, String> {

    // Filter perfumes by brand
    List<Perfume> findByBrand(String brand);

    // Filter perfumes by note name
    @Query("{ 'notes.note.name' : ?0 }")
    List<Perfume> findByNoteName(String noteName);

     /**
     * Find perfumes by both brand AND note name.
     * Example: "Chanel" + "Vanilla" → returns only Chanel perfumes that contain Vanilla.
     */
    @Query("{ 'brand' : ?0, 'notes.note.name' : ?1 }")
    List<Perfume> findByBrandAndNoteName(String brand, String noteName);

      /**
     * Find perfumes within a price range.
     * Example: 100.0 → 250.0 returns all perfumes priced between 100 and 250.
     */
    List<Perfume> findByPriceBetween(Double minPrice, Double maxPrice);

    

}
