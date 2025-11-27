package qa.udst.perfume_shop.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;

import lombok.RequiredArgsConstructor;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import qa.udst.perfume_shop.model.Perfume;
import qa.udst.perfume_shop.service.PerfumeService;

import java.util.List;

@RestController
@RequestMapping("/api/perfumes")
@RequiredArgsConstructor
@Tag(name = "Perfumes", description = "Endpoints for managing perfumes")
public class PerfumeController {

    private final PerfumeService perfumeService;

    // ------------------------------------------------------------
    // CREATE
    // ------------------------------------------------------------
    @Operation(summary = "Create a new perfume")
    @PostMapping
    public ResponseEntity<Perfume> createPerfume(
            @Parameter(description = "Perfume object to create")
            @RequestBody Perfume perfume
    ) {
        Perfume saved = perfumeService.createPerfume(perfume);
        return ResponseEntity.status(201).body(saved);
    }

    // ------------------------------------------------------------
    // GET ALL
    // ------------------------------------------------------------
    @Operation(summary = "Get all perfumes")
    @GetMapping
    public ResponseEntity<List<Perfume>> getAllPerfumes() {
        return ResponseEntity.ok(perfumeService.getAllPerfumes());
    }

    // ------------------------------------------------------------
    // GET BY ID
    // ------------------------------------------------------------
    @Operation(summary = "Get a perfume by ID")
    @GetMapping("/{id}")
    public ResponseEntity<Perfume> getPerfume(
            @Parameter(description = "Perfume ID") 
            @PathVariable String id
    ) {
        Perfume p = perfumeService.getPerfumeById(id);
        return ResponseEntity.ok(p);
    }

    // ------------------------------------------------------------
    // DELETE
    // ------------------------------------------------------------
    @Operation(summary = "Delete a perfume by ID")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePerfume(
            @Parameter(description = "Perfume ID") 
            @PathVariable String id
    ) {
        perfumeService.deletePerfume(id);
        return ResponseEntity.noContent().build();
    }

    // ------------------------------------------------------------
    // FILTERING: BRAND
    // ------------------------------------------------------------
    @Operation(summary = "Filter perfumes by brand")
    @GetMapping("/filter/brand/{brand}")
    public ResponseEntity<List<Perfume>> filterByBrand(
            @Parameter(description = "Brand name")
            @PathVariable String brand
    ) {
        return ResponseEntity.ok(perfumeService.getPerfumesByBrand(brand));
    }

    // ------------------------------------------------------------
    // FILTERING: NOTE NAME
    // ------------------------------------------------------------
    @Operation(summary = "Filter perfumes by note name")
    @GetMapping("/filter/note/{noteName}")
    public ResponseEntity<List<Perfume>> filterByNote(
            @Parameter(description = "Fragrance note name")
            @PathVariable String noteName
    ) {
        return ResponseEntity.ok(perfumeService.getPerfumesByNoteName(noteName));
    }

    // ------------------------------------------------------------
    // FILTERING: BRAND + NOTE
    // ------------------------------------------------------------
    @Operation(summary = "Filter perfumes by brand and/or note")
    @GetMapping("/filter")
    public ResponseEntity<List<Perfume>> filterByBrandAndNote(
            @Parameter(description = "Brand name")
            @RequestParam(required = false) String brand,

            @Parameter(description = "Fragrance note name")
            @RequestParam(required = false) String note
    ) {

        // Case 1: only brand
        if (brand != null && note == null) {
            return ResponseEntity.ok(perfumeService.getPerfumesByBrand(brand));
        }

        // Case 2: only note
        if (note != null && brand == null) {
            return ResponseEntity.ok(perfumeService.getPerfumesByNoteName(note));
        }

        // Case 3: both
        if (brand != null && note != null) {
            return ResponseEntity.ok(perfumeService.getPerfumesByBrandAndNote(brand, note));
        }

        // Case 4: nothing — return all perfumes
        return ResponseEntity.ok(perfumeService.getAllPerfumes());
    }

    // ------------------------------------------------------------
    // FILTERING: PRICE RANGE
    // ------------------------------------------------------------
    @Operation(summary = "Filter perfumes by price range")
    @GetMapping("/price")
    public ResponseEntity<List<Perfume>> filterByPrice(
            @Parameter(description = "Minimum price")
            @RequestParam Double min,

            @Parameter(description = "Maximum price")
            @RequestParam Double max
    ) {
        return ResponseEntity.ok(perfumeService.getPerfumesByPriceRange(min, max));
    }

}
