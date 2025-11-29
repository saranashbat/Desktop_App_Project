package qa.udst.perfume_shop.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import qa.udst.perfume_shop.model.Brand;
import qa.udst.perfume_shop.repository.BrandRepository;

import java.util.List;

@Service
@RequiredArgsConstructor
public class BrandService {

    private final BrandRepository brandRepository;

    public List<Brand> getAllBrands() {
        return brandRepository.findAll();
    }

    public Brand getBrandById(String id) {
        return brandRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Brand not found"));
    }

    public Brand createBrand(Brand brand) {
        return brandRepository.save(brand);
    }

    public Brand updateBrand(String id, Brand updatedBrand) {
        Brand brand = getBrandById(id);
        brand.setName(updatedBrand.getName());
        brand.setDescription(updatedBrand.getDescription());
        brand.setLogoPath(updatedBrand.getLogoPath());
        return brandRepository.save(brand);
    }

    public void deleteBrand(String id) {
        brandRepository.deleteById(id);
    }

    public Brand getBrandByName(String name) {
        return brandRepository.findByName(name)
            .orElseThrow(() -> new RuntimeException("Brand not found"));
    }

}
