package ch.heig.bdr.projet.api.technician;

import ch.heig.bdr.projet.api.Collaborator;
import ch.heig.bdr.projet.api.reparation.Reparation;
import ch.heig.bdr.projet.api.specialization.Specialization;

import ch.heig.bdr.projet.api.collaborator.Collaborator;

import java.util.ArrayList;

/**
 * Class representing a technician
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class Technician extends Collaborator {

    public ArrayList<Specialization> specializations = new ArrayList<>();
    public ArrayList<Reparation> reparations = new ArrayList<>();

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
     * @param specializations The technician's specializations
     * @param reparations The technician's reparations
     */
    public Technician(int id, String phoneNumber, String name, String email, String comment, ArrayList<Specialization> specializations, ArrayList<Reparation> reparations) {
        super(id, phoneNumber, name, comment, email);
        this.specializations = specializations;
        this.reparations = reparations;
    }

}
