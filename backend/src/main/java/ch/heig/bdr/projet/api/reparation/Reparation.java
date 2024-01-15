package ch.heig.bdr.projet.api.reparation;

import ch.heig.bdr.projet.api.Customer;
import ch.heig.bdr.projet.api.object.Object;
import ch.heig.bdr.projet.api.QuoteState;
import ch.heig.bdr.projet.api.receptionist.Receptionist;
import ch.heig.bdr.projet.api.ReparationState;
import ch.heig.bdr.projet.api.sms.Sms;
import ch.heig.bdr.projet.api.specialization.Specialization;
import ch.heig.bdr.projet.api.technician.Technician;

import java.sql.Time;
import java.util.ArrayList;
import java.util.Date;

/**
 * Class representing a reparation.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class Reparation {

    public int id;
    public Date dateCreated;
    public Date dateModified;
    public int quote;
    public String repairDescription;
    public Time estimatedDuration;
    public ArrayList<Sms> sms = new ArrayList<>();
    public ReparationState reparationState;
    public QuoteState quoteState;
    public ArrayList<Specialization> specializations = new ArrayList<>();
    public ArrayList<Technician> technicians = new ArrayList<>();
    public Receptionist receptionist;
    public Customer customer;
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
     * @param sms The sms conversation related to the reparation.
     * @param reparationState The reparation state.
     * @param quoteState The quote state.
     * @param specializations The specializations needed for the reparation.
     * @param technicians The technicians working on the reparation.
     * @param receptionist The receptionist in charge of the reparation.
     * @param customer The customer concerned by the reparation.
     * @param object The object concerned by the reparation.
     */
    public Reparation(int id, Date dateCreated, Date dateModified, int quote, String repairDescription, Time estimatedDuration, ArrayList<Sms> sms, ReparationState reparationState, QuoteState quoteState, ArrayList<Specialization> specializations, ArrayList<Technician> technicians, Receptionist receptionist, Customer customer, Object object) {
        this.id = id;
        this.dateCreated = dateCreated;
        this.dateModified = dateModified;
        this.quote = quote;
        this.repairDescription = repairDescription;
        this.estimatedDuration = estimatedDuration;
        this.sms = sms;
        this.reparationState = reparationState;
        this.quoteState = quoteState;
        this.specializations = specializations;
        this.technicians = technicians;
        this.receptionist = receptionist;
        this.customer = customer;
        this.object = object;
    }
}
