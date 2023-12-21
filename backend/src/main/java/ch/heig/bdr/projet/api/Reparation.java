package ch.heig.bdr.projet.api;

import java.time.LocalDateTime;

/**
 * Blog model.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Hugo Germano <hugo.germano@heig-vd.ch>
 */
public record Reparation(String title, String content, LocalDateTime createdAt, LocalDateTime updatedAt) {
    public Reparation() {
        this(null, null, null, null);
    }
}
