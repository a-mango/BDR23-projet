package ch.heig.bdr.projet.api.services;

import ch.heig.bdr.projet.api.PostgresConnection;
import ch.heig.bdr.projet.api.util.Utils;
import ch.heig.bdr.projet.api.models.Technician;

import java.sql.*;
import java.util.ArrayList;

/**
 * Technician CRUD service.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class TechnicianService {

    Connection conn;

    /**
     * Default constructor.
     */
    public TechnicianService() {
        conn = PostgresConnection.getInstance().getConnection();
    }


    /**
     * Get a technician by id.
     *
     * @param id id of the technician to get
     * @return Technician with the given id
     */
    public Technician getTechnicianById(String id) {
        String query = "SELECT * FROM technician_info_view WHERE technician_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return newTechnicianFromResultSet(rs);
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
     * Get all technicians.
     *
     * @return ArrayList<Technician> list of technicians
     */
    public ArrayList<Technician> getTechnicians() {
        String query = "SELECT * FROM technician_info_view";
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
            ArrayList<Technician> technicians = new ArrayList<>();
            while (rs.next()) {
                technicians.add(newTechnicianFromResultSet(rs));
            }
            return technicians;
        } catch (SQLException e) {
            Utils.logError(e);
            return null;
        }
    }

    /**
     * Update a technician.
     *
     * @param id                id of the technician to update
     * @param updatedTechnician updated technician
     */
    public void updateTechnician(String id, Technician updatedTechnician) {
        String query = "UPDATE technician_info_view SET name =?, phone_no =?, email =?, comment =? WHERE technician_id =?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, updatedTechnician.name);
            pstmt.setString(2, updatedTechnician.phoneNumber);
            pstmt.setString(3, updatedTechnician.email);
            pstmt.setString(4, updatedTechnician.comment);

            pstmt.setInt(5, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e) {
            Utils.logError(e);
        }
    }

    /**
     * Delete a technician.
     *
     * @param id id of the technician to delete
     */
    public void deleteTechnician(String id) {
        String query = "DELETE FROM technician_info_view WHERE technician_id =? ";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e) {
            Utils.logError(e);
        }
    }

    /**
     * Create a technician.
     *
     * @param technician technician to create
     * @return id of the created technician
     */
    public int createTechnician(Technician technician) {
        String query = "CALL projet.InsertTechnician(?, ?, ?, ?,?)";

        try (CallableStatement cstmt = conn.prepareCall(query)) {
            cstmt.setString(1, technician.name);
            cstmt.setString(2, technician.phoneNumber);
            cstmt.setString(3, technician.comment);
            cstmt.setString(4, technician.email);
            cstmt.registerOutParameter(5, Types.INTEGER);

            cstmt.executeUpdate();
            return cstmt.getInt(5);
        } catch (SQLException e) {
            Utils.logError(e);
            return -1;
        }
    }

    /**
     * Create a technician from a ResultSet.
     *
     * @param rs ResultSet to create the technician from
     * @return Technician created from the ResultSet
     * @throws SQLException if an error occurs while creating the technician
     */
    protected Technician newTechnicianFromResultSet(ResultSet rs) throws SQLException {
        return new Technician(rs.getInt("technician_id"), rs.getString("name"), rs.getString("phone_no"), rs.getString("email"), rs.getString("comment")/*, (ArrayList<Specialization>) (rs.getArray("specializations")), (ArrayList<Reparation>) (rs.getArray("reparations"))*/);
    }
}
