package ch.heig.bdr.projet.api.person;

/**
 * Class representing a person.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class Person {
    public int person_id;
    public String phone_number;
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
        this.person_id = id;
        this.phone_number = phoneNumber;
        this.name = name;
        this.comment = comment;
    }

}
