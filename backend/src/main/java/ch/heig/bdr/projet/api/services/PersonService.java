package ch.heig.bdr.projet.api.services;

import ch.heig.bdr.projet.api.PostgresConnection;
import ch.heig.bdr.projet.api.models.Person;

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

    public Person getPersonById(String id){
        String query = "SELECT * FROM person WHERE person_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
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

    public ArrayList<Person> getPersons(){
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

    public void updatePerson(String id, Person updatedPerson){
        String query = "UPDATE person SET name =?, phone_no =?, comment =? WHERE person_id =?";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, updatedPerson.name);
            pstmt.setString(2, updatedPerson.phoneNumber);
            pstmt.setString(3, updatedPerson.comment);
            pstmt.setInt(4, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }

    public void deletePerson(String id){
        String query = "DELETE FROM person WHERE person_id =? ";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }

    public void createPerson(Person person){
        String query = "INSERT INTO person (name, phone_no, comment) VALUES (?,?,?)";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, person.name);
            pstmt.setString(2, person.phoneNumber);
            pstmt.setString(3, person.comment);
            pstmt.executeUpdate();
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }
}
