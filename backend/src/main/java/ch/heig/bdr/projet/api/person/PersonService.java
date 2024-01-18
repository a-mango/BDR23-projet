package ch.heig.bdr.projet.api.person;

import ch.heig.bdr.projet.api.PostgresConnection;

import java.sql.*;
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
        String query = "SELECT * FROM person WHERE person_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, id);
            try(ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new Person(rs.getInt("person_id"), rs.getString("phone_no"), rs.getString("name"), rs.getString("comment"));
                } else {
                    return null;
                }
            }
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    ArrayList<Person> getPersons(){
        String query = "SELECT * FROM person";
        try(Statement statement = conn.createStatement();
            ResultSet rs = statement.executeQuery(query)) {
            ArrayList<Person> persons = new ArrayList<>();
            while (rs.next()) {
                persons.add(new Person(rs.getInt("person_id"), rs.getString("phone_no"), rs.getString("name"), rs.getString("comment")));
            }
            return persons;
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    void updatePerson(String id, Person updatedPerson){
        String query = "UPDATE person SET phone_no =?, name =? , comment =? WHERE person_id =?";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, updatedPerson.phoneNumber);
            pstmt.setString(2, updatedPerson.name);
            pstmt.setString(3, updatedPerson.comment);
            pstmt.setString(4, id);
            pstmt.executeUpdate();
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }

    void deletePerson(String id){
        String query = "DELETE FROM person WHERE person_id =? ";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }

    void createPerson(Person person){
        String query = "INSERT INTO person (phone_no, name, comment) VALUES (?,?,?)";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, person.phoneNumber);
            pstmt.setString(2, person.name);
            pstmt.setString(3, person.comment);
            pstmt.executeUpdate();
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }
}
