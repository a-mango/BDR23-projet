package ch.heig.bdr.projet.api;

import java.util.ArrayList;

/**
 * Class representing a technician
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class Technician extends Collaborator {

    private ArrayList<Specialization> specializations = new ArrayList<>();
    private ArrayList<Reparation> reparations = new ArrayList<>();

    /**
     * Technician constructor
     * @param id The technician's id
     * @param phoneNumber The technician's phone number
     * @param name The technician's name
     * @param comment Comments about the technician
     * @param email The Technician's email
     * @param specializations The technician's specializations
     * @param reparations The technician's reparations
     */
    public Technician(int id, String phoneNumber, String name, String email, String comment, ArrayList<Specialization> specializations, ArrayList<Reparation> reparations) {
        super(id, phoneNumber, name, comment, email);
        this.specializations = specializations;
        this.reparations = reparations;
    }

}
