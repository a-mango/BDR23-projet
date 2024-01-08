package ch.heig.bdr.projet.api;

import java.util.ArrayList;

/**
 * Class representing a Manager.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class Manager extends Collaborator {

    /**
     * Manager constructor.
     *
     * @param id          The Manager's id.
     * @param phoneNumber The Manager's phone number.
     * @param name        The Manager's name.
     * @param comment    Comments about the Manager
     * @param email       The Manager's email.
     */
    public Manager(int id, String phoneNumber, String name, String comment, String email) {
        super(id, phoneNumber, name, comment, email);
    }
}
