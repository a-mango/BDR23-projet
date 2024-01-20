package ch.heig.bdr.projet.api.object;
import ch.heig.bdr.projet.api.brand.*;
import ch.heig.bdr.projet.api.category.*;
import ch.heig.bdr.projet.api.Location;

/**
 * Class representing an object.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class Object {

    public int id;
    public int customerId;

    public String name;
    public String faultDesc;
    public String remark;
    public String serialNo;
    public Location location;
    public Brand brand;
    public Category category;

    /**
     * Object default constructor.
     */
    public Object(){}

    /**
     * Object constructor.
     *
     * @param id               The object id.
     * @param name             The object name.
     * @param faultDescription The object fault description.
     * @param remark           A remark about the object.
     * @param serialNo         The object serial number.
     * @param location         The object location.
     * @param brand            The object brand.
     * @param category         The object category.
     */
    public Object(int id, String name, String faultDescription, String remark, String serialNo, Location location, Brand brand, Category category, int customerId) {
        this.id = id;
        this.name = name;
        this.faultDesc = faultDescription;
        this.remark = remark;
        this.serialNo = serialNo;
        this.location = location;
        this.brand = brand;
        this.category = category;
        this.customerId = customerId;
    }
}
