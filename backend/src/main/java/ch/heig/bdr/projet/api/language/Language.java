package ch.heig.bdr.projet.api.language;

/**
 * Class representing a Language.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class Language {

    public String name;

    /**
     * Language default constructor.
     */
    public Language(){}

    /**
     * Language constructor.
     *
     * @param name
     */
    public Language(String name){
        this.name = name;
    }
}
