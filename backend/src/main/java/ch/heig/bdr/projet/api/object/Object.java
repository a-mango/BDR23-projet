package ch.heig.bdr.projet.api.object;
import ch.heig.bdr.projet.api.Brand;
import ch.heig.bdr.projet.api.Category;
import ch.heig.bdr.projet.api.Customer;
import ch.heig.bdr.projet.api.Location;

import java.util.Date;

/**
 * Class representing an object.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class Object {

    public int id;
    public String name;
    public String faultDescription;
    public String remark;
    public int serialNo;
    public Location location;
    public Brand brand;
    public Category category;
    public Customer customer;

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
    public Object(int id, String name, String faultDescription, String remark, int serialNo, Location location, Brand brand, Category category, Customer customer) {
        this.id = id;
        this.name = name;
        this.faultDescription = faultDescription;
        this.remark = remark;
        this.serialNo = serialNo;
        this.location = location;
        this.brand = brand;
        this.category = category;
        this.customer = customer;
    }

    /**
     * Intern class representing a sale
     */
    public static class Sale{

        int idSale;
        int price;
        Date dateCreated;
        Date dateSold;

        /**
         * Sale constructor.
         *
         * @param idSale      The sale id.
         * @param price       The sale price.
         * @param dateCreated The sale creation date.
         * @param dateSold    The sale sold date.
         */
        public Sale(int idSale, int price, Date dateCreated, Date dateSold) {
            this.idSale = idSale;
            this.price = price;
            this.dateCreated = dateCreated;
            this.dateSold = dateSold;
        }
    }
}
