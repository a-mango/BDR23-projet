package ch.heig.bdr.projet.api.models;

import java.util.Date;

/**
 * Sms model.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class Sms {

    public int id;
    public int reparationId;
    public Date dateCreated;
    public String message;
    public String sender;
    public String receiver;
    public ProcessingState processingState;

    /**
     * Sms default constructor.
     */
    public Sms() {}

    /**
     * Sms constructor.
     * @param id                The sms id.
     * @param dateCreated       The sms creation date.
     * @param message           The sms message.
     * @param sender            The phone number of the sms sender.
     * @param receiver          The phone number of the sms receiver.
     * @param processingState   The sms processing status.
     */
    public Sms(int id, int reparationId, Date dateCreated, String message, String sender, String receiver, ProcessingState processingState){
        this.id = id;
        this.reparationId = reparationId;
        this.dateCreated = dateCreated;
        this.message = message;
        this.sender = sender;
        this.receiver = receiver;
        this.processingState = processingState;
    }
}
