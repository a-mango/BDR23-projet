package ch.heig.bdr.projet.api;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * Person CRUD service.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class PersonService {
    Connection conn;

    /**
     * Constructor.
     */
    public PersonService() {
        conn = PostgresConnection.getInstance().getConnection();
    }

    Person getPersonById(String id) throws Exception {
        Statement statement = conn.createStatement();
        String query = "SELECT * FROM person";
        ResultSet rs = statement.executeQuery(query);
    }

    // TODO Implement createPerson, getPersonById, getPersons, updatePerson,
    // deletePerson here
}
