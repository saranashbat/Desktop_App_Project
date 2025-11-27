package qa.udst.perfume_shop.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import qa.udst.perfume_shop.model.Perfume;
import qa.udst.perfume_shop.repository.PerfumeRepository;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PerfumeService {

    private final PerfumeRepository perfumeRepository;

    // ----------------------------------------------------------
    // BASIC CRUD
    // ----------------------------------------------------------

    public Perfume createPerfume(Perfume perfume) {
        return perfumeRepository.save(perfume);
    }

    public List<Perfume> getAllPerfumes() {
        return perfumeRepository.findAll();
    }

    public Perfume getPerfumeById(String id) {
        return perfumeRepository.findById(id).orElse(null);
    }

    public Perfume updatePerfume(String id, Perfume updateData) {
        Perfume existing = perfumeRepository.findById(id).orElse(null);
        if (existing == null) return null;

        existing.setName(updateData.getName());
        existing.setBrand(updateData.getBrand());
        existing.setPrice(updateData.getPrice());
        existing.setImagePath(updateData.getImagePath());
        existing.setDescription(updateData.getDescription());
        existing.setNotes(updateData.getNotes());

        return perfumeRepository.save(existing);
    }

    public void deletePerfume(String id) {
        perfumeRepository.deleteById(id);
    }


    // ----------------------------------------------------------
    // FILTERING METHODS (the ones you asked for)
    // ----------------------------------------------------------

    /**
     * Get perfumes that match a brand.
     * Example call: GET /perfumes?brand=Dior
     */
    public List<Perfume> getPerfumesByBrand(String brand) {
        return perfumeRepository.findByBrand(brand);
    }

    /**
     * Get perfumes that contain a specific note name.
     * It looks inside perfume.notes.listOfPerfumeNote.note.name
     *
     * Example call: GET /perfumes?note=Vanilla
     */
    public List<Perfume> getPerfumesByNoteName(String noteName) {
        return perfumeRepository.findByNoteName(noteName);
    }

    /**
     * Brand + Note together.
     * Example:
     *   brand = "Chanel"
     *   note = "Vanilla"
     *
     * Only returns perfumes where BOTH are true.
     */
    public List<Perfume> getPerfumesByBrandAndNote(String brand, String noteName) {
        return perfumeRepository.findByBrandAndNoteName(brand, noteName);
    }

    /**
     * Filter perfumes within a price range.
     * Example: min = 100, max = 250
     */
    public List<Perfume> getPerfumesByPriceRange(Double min, Double max) {
        return perfumeRepository.findByPriceBetween(min, max);
    }
}
