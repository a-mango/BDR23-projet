package ch.heig.bdr.projet.api;

import java.util.ArrayList;

/**
 * Class representing a receptionist.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class Receptionist extends Collaborator{

    private ArrayList<Language> languages = new ArrayList<>();

    /**
     * Collaborator constructor.
     *
     * @param id          The collaborator's id.
     * @param phoneNumber The collaborator's phone number.
     * @param name        The collaborator's name.
     * @param comment    Comments about the collaborator
     * @param email       The collaborator's email.
     */
    public Receptionist(int id, String phoneNumber, String name, String comment, String email, ArrayList<Language> languages) {
        super(id, phoneNumber, name, comment, email);
        this.languages = languages;
    }
}
