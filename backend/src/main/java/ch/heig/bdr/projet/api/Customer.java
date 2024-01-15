package ch.heig.bdr.projet.api;

import java.util.ArrayList;

/**
 * Customer model.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class Customer extends Person {
    public String privateNote;
    public boolean tosAccepted;

    /**
     * Customer default constructor.
     */
    public Customer(){
        super();
    }

    /**
     * Customer constructor.
     *
     * @param id            The customer id.
     * @param phoneNumber   The customer phone number.
     * @param name          The customer name.
     * @param comment       Comment about the customer.
     * @param privateNote   A private note about the customer.
     * @param tosAccepted   Terms of service acceptance status.
     */
    public Customer(int id, String phoneNumber, String name, String comment, String privateNote, boolean tosAccepted){
        super(id, phoneNumber, name, comment);
        this.privateNote = privateNote;
        this.tosAccepted = tosAccepted;
    }
}
