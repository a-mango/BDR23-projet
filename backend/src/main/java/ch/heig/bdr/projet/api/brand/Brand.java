package ch.heig.bdr.projet.api.brand;

/**
 * Class representing a Brand.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class Brand{
    public String name;

    /**
    * Brand default constructor.
    */
    public Brand(){}
    /**
     * Brand constructor.
     *
     * @param name The brand's name.
     */
    public Brand(String name){
        this.name = name;
    }
}
