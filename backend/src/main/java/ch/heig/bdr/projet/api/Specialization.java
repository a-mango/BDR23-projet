package ch.heig.bdr.projet.api;

/**
 * Class representing a specialization.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class Specialization {
    public String name;

    /**
     * Specialization default constructor.
     */
    public Specialization() {}

    /**
     * Specialization constructor.
     *
     * @param name The specialization name.
     */
    public Specialization(String name){
        this.name = name;
    }
}
