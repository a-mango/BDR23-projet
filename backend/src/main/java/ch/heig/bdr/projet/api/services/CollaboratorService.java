package ch.heig.bdr.projet.api.services;

import ch.heig.bdr.projet.api.PostgresConnection;
import ch.heig.bdr.projet.api.util.Utils;
import ch.heig.bdr.projet.api.models.Collaborator;
import ch.heig.bdr.projet.api.models.Person;

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
     * Default constructor.
     */
    public CollaboratorService() {
        conn = PostgresConnection.getInstance().getConnection();
    }

    /**
     * Get a collaborator by id.
     *
     * @param id id of the collaborator to get
     * @return Collaborator with the given id
     */
    public Collaborator getCollaboratorById(String id) {
        String query = "SELECT * FROM collab_info_view WHERE collaborator_id =?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return newCollaboratorFromResultSet(rs);
                } else {
                    return null;
                }
            }
        } catch (SQLException e) {
            Utils.logError(e);
            return null;
        }
    }

    /**
     * Get all collaborators.
     *
     * @return ArrayList<Collaborator> list of collaborators
     */
    public ArrayList<Collaborator> getCollaborators() {
        String query = "SELECT * FROM collab_info_view";
        try (Statement statement = conn.createStatement(); ResultSet rs = statement.executeQuery(query)) {
            ArrayList<Collaborator> collaborators = new ArrayList<>();
            while (rs.next()) {
                collaborators.add(newCollaboratorFromResultSet(rs));
            }
            return collaborators;
        } catch (SQLException e) {
            Utils.logError(e);
            return null;
        }
    }

    /**
     * Update a collaborator.
     *
     * @param id                  id of the collaborator to update
     * @param updatedCollaborator new collaborator
     */
    public void updateCollaborator(String id, Collaborator updatedCollaborator) {
        String query = "UPDATE collab_info_view SET phone_no = ?, name = ?, comment = ?, email = ? WHERE collaborator_id =?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, updatedCollaborator.phoneNumber);
            pstmt.setString(2, updatedCollaborator.name);
            pstmt.setString(3, updatedCollaborator.comment);
            pstmt.setString(4, updatedCollaborator.email);
            pstmt.setInt(5, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e) {
            Utils.logError(e);
        }
    }

    /**
     * Delete a collaborator.
     *
     * @param id id of the collaborator to delete
     */
    public void deleteCollaborator(String id) {
        String query = "DELETE FROM collab_info_view WHERE collaborator_id =?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e) {
            Utils.logError(e);
        }
    }

    /**
     * Create a collaborator.
     *
     * @param collaborator collaborator to create
     * @return id of the created collaborator
     */
    public int createCollaborator(Collaborator collaborator) {
        String query = "CALL projet.InsertCollaborator(?, ?, ?, ?, ?)";
        try (CallableStatement cstmt = conn.prepareCall(query)) {
            cstmt.setString(1, collaborator.name);
            cstmt.setString(2, collaborator.phoneNumber);
            cstmt.setString(3, collaborator.comment);
            cstmt.setString(4, collaborator.email);
            cstmt.registerOutParameter(5, Types.INTEGER);

            cstmt.execute();
            return cstmt.getInt(5);
        } catch (SQLException e) {
            Utils.logError(e);
            return -1;
        }
    }

    /**
     * Create a collaborator from a ResultSet.
     *
     * @param rs ResultSet to create the collaborator from
     * @return Collaborator created from the ResultSet
     * @throws SQLException if an error occurs while creating the collaborator
     */
    protected Collaborator newCollaboratorFromResultSet(ResultSet rs) throws SQLException {
        Person p = new Person(rs.getInt("collaborator_id"), rs.getString("phone_no"), rs.getString("name"), rs.getString("comment"));

        return new Collaborator(p.id, p.phoneNumber, p.name, p.comment, rs.getString("email"));
    }
}
