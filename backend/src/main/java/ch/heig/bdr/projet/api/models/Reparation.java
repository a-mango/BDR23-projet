package ch.heig.bdr.projet.api.models;

import java.sql.Time;
import java.util.ArrayList;


/**
 * Class representing a reparation.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class Reparation {

    public int id;
    public String dateCreated;
    public String dateModified;
    public int quote;
    public String description;
    public Time estimatedDuration;
    public ArrayList<Sms> sms = new ArrayList<>();
    public ReparationState reparationState;
    public QuoteState quoteState;
    public int receptionist_id;
    public int customer_id;
    public int object_id;
    public Object object;

    /**
     * Reparation default constructor.
     */
    public Reparation() {}

    /**
     * Reparation constructor.
     *
     * @param id The reparation id.
     * @param dateCreated The reparation creation date.
     * @param dateModified The reparation modification date.
     * @param quote The reparation quote.
     * @param repairDescription The reparation description.
     * @param estimatedDuration The reparation estimated duration.
     //* @param sms The sms conversation related to the reparation.
     * @param reparationState The reparation state.
     * @param quoteState The quote state.
     //* @param specializations The specializations needed for the reparation.
     //* @param technicians The technicians working on the reparation.
     * @param receptionist The receptionist in charge of the reparation.
     * @param customer The customer concerned by the reparation.
     * @param object The object concerned by the reparation.
     */
    public Reparation(int id, String dateCreated, String dateModified, int quote, String repairDescription, Time estimatedDuration, ReparationState reparationState, QuoteState quoteState, int receptionist, int customer, int object_id, Object object, ArrayList<Sms> sms) {
        this.id = id;
        this.dateCreated = dateCreated;
        this.dateModified = dateModified;
        this.quote = quote;
        this.description = repairDescription;
        this.estimatedDuration = estimatedDuration;
        this.reparationState = reparationState;
        this.quoteState = quoteState;
        this.receptionist_id = receptionist;
        this.customer_id = customer;
        this.object_id = object_id;
        this.object = object;
        this.sms = sms;
    }
}
