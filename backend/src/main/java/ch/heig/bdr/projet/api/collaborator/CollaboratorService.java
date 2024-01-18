package ch.heig.bdr.projet.api.collaborator;

import ch.heig.bdr.projet.api.PostgresConnection;
import ch.heig.bdr.projet.api.customer.Customer;
import ch.heig.bdr.projet.api.person.Person;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

/**
 * CollaboratorService class
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class CollaboratorService {
    Connection conn;

    /**
     * Constructor.
     */
    public CollaboratorService() {
        conn = PostgresConnection.getInstance().getConnection();
    }

    Collaborator getCollaboratorById(String id){
        try {
            Statement statement = conn.createStatement();
            String query = "SELECT * FROM collab_info_view WHERE collaborator_id = " + id;
            ResultSet rs = statement.executeQuery(query);
            if (rs.next()) {
                Person p = new Person(rs.getInt("collaborator_id"), rs.getString("phone_no"), rs.getString("name"), rs.getString("comment"));
                return new Collaborator(p.person_id, p.phone_number, p.name, p.comment, rs.getString("email"));
            } else {
                return null;
            }
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    ArrayList<Collaborator> getCollaborator(){
        try {
            Statement statement = conn.createStatement();
            String query = "SELECT * FROM collab_info_view";
            ResultSet rs = statement.executeQuery(query);
            ArrayList<Collaborator> Collaborators = new ArrayList<>();
            while (rs.next()) {
                //System.out.println("inside while");
                Person p = new Person(rs.getInt("collaborator_id"), rs.getString("phone_no"), rs.getString("name"), rs.getString("comment"));
                Collaborators.add(new Collaborator(p.person_id, p.phone_number, p.name, p.comment, rs.getString("email")));
            }
            return Collaborators;

        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    void updateCollaborator(String id, Collaborator updatedCollaborator){
        try {
            Statement statement = conn.createStatement();
            String query = "UPDATE collaborator SET phone_no = '" + updatedCollaborator.phone_number + "', name = '" + updatedCollaborator.name + "', comment = '" + updatedCollaborator.comment + "', email = '" + updatedCollaborator.email + "' WHERE customer_id = " + id;
            statement.executeQuery(query);
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }

    void deleteCollaborator(String id){
        try {
            Statement statement = conn.createStatement();
            String query = "DELETE FROM collaborator WHERE collaborator_id = " + id + "; DELETE FROM person WHERE person_id = " + id;
            statement.executeQuery(query);

        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }

    void createCollaborator(Collaborator collaborator){
        try {
            Statement statement = conn.createStatement();
            String query = "INSERT INTO person (phone_no, name, comment) VALUES ('" + collaborator.phone_number + "', '" + collaborator.name + "', '" + collaborator.comment + "'); INSERT INTO Customer (phone_no, name, comment) VALUES ('" + collaborator.phone_number + "', '" + collaborator.name + "', '" + collaborator.comment + "')";
            statement.executeQuery(query);

        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }
}

