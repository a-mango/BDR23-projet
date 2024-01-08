package ch.heig.bdr.projet.api;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

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

    Person getPersonById(String id){
        try {
            Statement statement = conn.createStatement();
            String query = "SELECT * FROM person WHERE person.id = " + id;
            ResultSet rs = statement.executeQuery(query);
            return new Person(rs.getInt("id"), rs.getString("phoneNumber"), rs.getString("name"), rs.getString("comment"));

        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    ArrayList<Person> getPersons(){
        try {
            Statement statement = conn.createStatement();
            String query = "SELECT * FROM person";
            ResultSet rs = statement.executeQuery(query);
            ArrayList<Person> persons = new ArrayList<>();
            while (rs.next()) {
                persons.add(new Person(rs.getInt("id"), rs.getString("phoneNumber"), rs.getString("name"), rs.getString("comment")));
            }
            return persons;

        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    void updatePerson(String id, Person updatedPerson){
        try {
            Statement statement = conn.createStatement();
            String query = "UPDATE person SET phoneNumber = '" + updatedPerson.phoneNumber + "', name = '" + updatedPerson.name + "', comment = '" + updatedPerson.comment + "' WHERE id = " + id;
            statement.executeQuery(query);

        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }

    void deletePerson(String id){
        try {
            Statement statement = conn.createStatement();
            String query = "DELETE FROM person WHERE id = " + id;
            statement.executeQuery(query);

        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }

    void createPerson(Person person){
        try {
            Statement statement = conn.createStatement();
            String query = "INSERT INTO person (phoneNumber, name, comment) VALUES ('" + person.phoneNumber + "', '" + person.name + "', '" + person.comment + "')";
            statement.executeQuery(query);

        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }

    // TODO Implement createPerson, getPersonById, getPersons, updatePerson,
    // deletePerson here
}
