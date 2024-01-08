package ch.heig.bdr.projet.api;

import java.util.ArrayList;

/**
 * Collaborator model.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class Collaborator extends Person{

    private String email;


    /**
     * Collaborator constructor.
     *
     * @param id          The collaborator id.
     * @param phoneNumber The collaborator phone number.
     * @param name        The collaborator name.
     * @param comment     Comment about the collaborator.
     * @param email       The collaborator email.
     */
    public Collaborator(int id, String phoneNumber, String name, String comment, String email) {
        super(id, phoneNumber, name, comment);
        this.email = email;
    }
}
