package ch.heig.bdr.projet.api.util;

// TODO reorganize this class according to content of the file

import java.sql.SQLException;

/**
 * Utils class
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class Utils {

    /**
     * Log an error message.
     * @param e The exception from which to log the error message.
     */
    static public void logError(SQLException e){
        System.out.println(e.getMessage());
    }
}

