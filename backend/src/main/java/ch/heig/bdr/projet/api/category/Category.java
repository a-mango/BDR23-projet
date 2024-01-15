package ch.heig.bdr.projet.api.category;

/**
 * Category model.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class Category {
    public String name;

    /**
    * Category default constructor.
    */
    public Category(){}

    /**
     * Category constructor.
     *
     * @param name The category's name.
     */
    public Category(String name){
        this.name = name;
    }
}
