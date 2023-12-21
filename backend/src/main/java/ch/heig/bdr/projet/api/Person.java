package ch.heig.bdr.projet.api;

/**
 * Comment model.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Hugo Germano <hugo.germano@heig-vd.ch>
 */
public record Person(String blogId, String username, String content) {
    public Person(){
        this(null, null, null);
    }
}
