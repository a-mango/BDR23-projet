package ch.heig.bdr.projet.api.collaborator;

import ch.heig.bdr.projet.api.PostgresConnection;
import ch.heig.bdr.projet.api.Utils;
import ch.heig.bdr.projet.api.customer.Customer;
import ch.heig.bdr.projet.api.person.Person;

import java.sql.*;
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
        String query = "SELECT * FROM collab_info_view WHERE collaborator_id = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(query)){
            pstmt.setString(1, id);
            try(ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return newCollaboratorFromResultSet(rs);
                } else {
                    return null;
                }
            }
        } catch (SQLException e){
            Utils.logError(e);
            return null;
        }
    }

    ArrayList<Collaborator> getCollaborators(){
        String query = "SELECT * FROM collab_info_view";
        try (PreparedStatement pstmt = conn.prepareStatement(query)){
            try(ResultSet rs = pstmt.executeQuery()) {
                ArrayList<Collaborator> collaborators = new ArrayList<>();
                while (rs.next()) {
                    collaborators.add(newCollaboratorFromResultSet(rs));
                }
                return collaborators;
            }
        } catch (SQLException e){
            Utils.logError(e);
            return null;
        }
    }

    void updateCollaborator(String id, Collaborator updatedCollaborator){
        String query = "UPDATE collaborator SET phone_no = ?, name = ?, comment = ?, email = ? WHERE customer_id =?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)){
            pstmt.setString(1, updatedCollaborator.phoneNumber);
            pstmt.setString(2, updatedCollaborator.name);
            pstmt.setString(3, updatedCollaborator.comment);
            pstmt.setString(4, updatedCollaborator.email);
            pstmt.setString(5, id);

            pstmt.executeUpdate(query);
        } catch (SQLException e){
            Utils.logError(e);
        }
    }

    void deleteCollaborator(String id){
        String query = "DELETE FROM person WHERE person_id =?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)){
            pstmt.setString(1, id);
            pstmt.executeUpdate(query);
        } catch (SQLException e){
            Utils.logError(e);
        }
    }

    void createCollaborator(Collaborator collaborator){
        String query = "CALL projet.InsertCollaborator(?, ?, ?, ?)";

        try (PreparedStatement pstmt = conn.prepareStatement(query)){
            pstmt.setString(1, collaborator.name);
            pstmt.setString(2, collaborator.phoneNumber);
            pstmt.setString(3, collaborator.comment);
            pstmt.setString(4, collaborator.email);

            pstmt.executeUpdate(query);
        } catch (SQLException e){
            Utils.logError(e);
        }
    }

    protected Collaborator newCollaboratorFromResultSet(ResultSet rs) throws SQLException {
        Person p = new Person(rs.getInt("customer_id"), rs.getString("phone_no"), rs.getString("name"), rs.getString("comment"));

        return new Collaborator(p.personId, p.phoneNumber, p.name, p.comment, rs.getString("email"));
    }
}
