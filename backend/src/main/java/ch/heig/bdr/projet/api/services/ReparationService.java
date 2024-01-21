package ch.heig.bdr.projet.api.services;


import ch.heig.bdr.projet.api.PostgresConnection;
import ch.heig.bdr.projet.api.models.QuoteState;
import ch.heig.bdr.projet.api.models.ReparationState;
import ch.heig.bdr.projet.api.models.Reparation;
import ch.heig.bdr.projet.api.models.Object;

import java.sql.*;
import java.time.Duration;
import java.time.LocalTime;
import java.time.OffsetDateTime;
import java.util.ArrayList;

/**
 * Reparation service.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class ReparationService {

    Connection conn;

    /**
     * Constructor.
     */
    public ReparationService() {
        conn = PostgresConnection.getInstance().getConnection();
    }

    /**
     * Get a reparation by id.
     *
     * @param id id of the reparation to get
     * @return Reparation with the given id
     */
    public Reparation getReparationById(String id) {
        String query = "SELECT * FROM reparation WHERE reparation_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new Reparation(rs.getInt("reparation_id"), rs.getObject("date_created", OffsetDateTime.class).toString(), rs.getObject("date_modified", OffsetDateTime.class).toString(), rs.getInt("quote"), rs.getString("description"), rs.getTime("estimated_duration"), ReparationState.valueOf(rs.getString("reparation_state")), QuoteState.valueOf(rs.getString("quote_state")), rs.getInt("receptionist_id"), rs.getInt("customer_id"), rs.getInt("object_id"), new ObjectService().getObjectById(Integer.toString(rs.getInt("object_id"))), new SmsService().getSmsForRepairId(Integer.toString(rs.getInt("reparation_id"))));
                } else {
                    return null;
                }
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    /**
     * Get all reparations.
     *
     * @return ArrayList<Reparation> list of reparations
     */
    public ArrayList<Reparation> getReparations() {
        String query = "SELECT * FROM reparation";
        try (Statement statement = conn.createStatement(); ResultSet rs = statement.executeQuery(query)) {
            ArrayList<Reparation> reparations = new ArrayList<>();
            while (rs.next()) {
                reparations.add(new Reparation(rs.getInt("reparation_id"), rs.getObject("date_created", OffsetDateTime.class).toString(), rs.getObject("date_modified", OffsetDateTime.class).toString(), rs.getInt("quote"), rs.getString("description"), rs.getTime("estimated_duration"), ReparationState.valueOf(rs.getString("reparation_state")), QuoteState.valueOf(rs.getString("quote_state")), rs.getInt("receptionist_id"), rs.getInt("customer_id"), rs.getInt("object_id"), new ObjectService().getObjectById(Integer.toString(rs.getInt("object_id"))), new SmsService().getSmsForRepairId(Integer.toString(rs.getInt("reparation_id")))));
            }
            return reparations;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    /**
     * Update a reparation.
     *
     * @param id                id of the reparation to update
     * @param updatedReparation new reparation
     */
    public void updateReparation(String id, Reparation updatedReparation) {
        final var objectService = new ObjectService();
        objectService.updateObject(Integer.toString(updatedReparation.object_id), updatedReparation.object);

        String query = "UPDATE reparation SET date_created =?, date_modified =?, quote =?, description =?, estimated_duration =CAST(? AS INTERVAL), reparation_state = CAST(? AS reparation_state), quote_state =CAST(? AS quote_state), receptionist_id =?, customer_id =?, object_id =? WHERE reparation_id =?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setObject(1, OffsetDateTime.parse(updatedReparation.dateCreated), Types.TIMESTAMP_WITH_TIMEZONE);
            pstmt.setObject(2, OffsetDateTime.parse(updatedReparation.dateModified), Types.TIMESTAMP_WITH_TIMEZONE);
            pstmt.setInt(3, updatedReparation.quote);
            pstmt.setString(4, updatedReparation.description);
            pstmt.setObject(5, Duration.between(LocalTime.MIDNIGHT, updatedReparation.estimatedDuration.toLocalTime()), Types.OTHER);
            pstmt.setString(6, updatedReparation.reparationState.toString());
            pstmt.setString(7, updatedReparation.quoteState.toString());
            pstmt.setInt(8, updatedReparation.receptionist_id);
            pstmt.setInt(9, updatedReparation.customer_id);
            pstmt.setInt(10, updatedReparation.object_id);
            pstmt.setInt(11, Integer.parseInt(id));

            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    /**
     * Delete a reparation.
     *
     * @param id id of the reparation to delete
     */
    public void deleteReparation(String id) {
        String query = "DELETE FROM reparation WHERE reparation_id =? ";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    /**
     * Create a reparation.
     *
     * @param reparation new reparation
     * @return id of the created reparation
     */
    public int createReparation(Reparation reparation) {
        String query = "CALL create_reparation(?, CAST(? AS TEXT), CAST(? AS INTERVAL), ?, ?, ?, CAST(? AS TEXT), CAST(? AS TEXT), ?, ? ,?, ?)";
        try (CallableStatement cstmt = conn.prepareCall(query)) {
            cstmt.setInt(1, reparation.quote);
            cstmt.setString(2, reparation.description);
            cstmt.setObject(3, Duration.between(LocalTime.MIDNIGHT, reparation.estimatedDuration.toLocalTime()), Types.OTHER);
            cstmt.setInt(4, reparation.receptionist_id);
            cstmt.setInt(5, reparation.customer_id);

            cstmt.setString(6, reparation.object.name);
            cstmt.setString(7, reparation.object.faultDesc);
            cstmt.setString(8, reparation.object.remark);
            cstmt.setString(9, reparation.object.serialNo);
            cstmt.setString(10, reparation.object.brand.name);
            cstmt.setString(11, reparation.object.category.name);
            cstmt.registerOutParameter(12, Types.INTEGER);

            cstmt.executeUpdate();
            return cstmt.getInt(12);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return -1;
        }
    }
}
