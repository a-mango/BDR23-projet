package ch.heig.bdr.projet.api;

import java.util.Date;

/**
 * Sms model.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class Sms {
    private int id;
    private Date dateCreated;
    private String message;
    private String sender;
    private String receiver;
    private ProcessingState processingState;

    /**
     * Sms constructor.
     * @param id                The sms id.
     * @param dateCreated       The sms creation date.
     * @param message           The sms message.
     * @param sender            The phone number of the sms sender.
     * @param receiver          The phone number of the sms receiver.
     * @param processingState   The sms processing status.
     */
    Sms(int id, Date dateCreated, String message, String sender, String receiver, ProcessingState processingState){
        this.id = id;
        this.dateCreated = dateCreated;
        this.message = message;
        this.sender = sender;
        this.receiver = receiver;
        this.processingState = processingState;
    }
}
