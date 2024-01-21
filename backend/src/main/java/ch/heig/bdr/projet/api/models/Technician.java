package ch.heig.bdr.projet.api.models;

/**
 * Class representing a technician
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class Technician extends Collaborator {

    /**
     * Technician default constructor
     */
    public Technician() {
        super();
    }

    /**
     * Technician constructor
     * @param id The technician's id
     * @param phoneNumber The technician's phone number
     * @param name The technician's name
     * @param comment Comments about the technician
     * @param email The Technician's email
     */
    public Technician(int id, String phoneNumber, String name, String email, String comment) {
        super(id, phoneNumber, name, comment, email);
    }

}
