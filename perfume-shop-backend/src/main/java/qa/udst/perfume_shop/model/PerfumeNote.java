package qa.udst.perfume_shop.model;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class PerfumeNote {
    private Note note;
    private NoteType type; // TOP, MIDDLE, BASE
}

