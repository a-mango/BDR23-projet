package ch.heig.bdr.projet.api.person;

/**
 * Class representing a person.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class Person {
    public int personId;
    public String phoneNumber;
    public String name;
    public String comment;
    public Person() {}

    /**
     * Person constructor.
     *
     * @param id         The person id.
     * @param phoneNumber The person phone number.
     * @param name      The person name.
     * @param comment Comments about the person.
     */
    public Person(int id, String phoneNumber, String name, String comment) {
        this.personId = id;
        this.phoneNumber = phoneNumber;
        this.name = name;
        this.comment = comment;
    }

}
