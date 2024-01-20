package ch.heig.bdr.projet.api.technician;

import ch.heig.bdr.projet.api.PostgresConnection;
import ch.heig.bdr.projet.api.Utils;
import ch.heig.bdr.projet.api.customer.Customer;
import ch.heig.bdr.projet.api.reparation.Reparation;
import ch.heig.bdr.projet.api.specialization.Specialization;

import java.sql.*;
import java.util.ArrayList;

public class TechnicianService {

    Connection conn;
    public TechnicianService() {
        conn = PostgresConnection.getInstance().getConnection();
    }

    Technician getTechnicianById(String id){
        String query = "SELECT * FROM technician_info_view WHERE technician_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            try(ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return newTechnicianFromResultSet(rs);
                } else {
                    return null;
                }
            }
        } catch (SQLException e){
            Utils.logError(e);
            return null;
        }
    }

    ArrayList<Technician> getTechnicians(){
        String query = "SELECT * FROM technician_info_view";
        try(Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
            ArrayList<Technician> technicians = new ArrayList<>();
            while (rs.next()) {
                technicians.add(newTechnicianFromResultSet(rs));
            }
            return technicians;
        } catch (SQLException e){
            Utils.logError(e);
            return null;
        }
    }

    void updateTechnician(String id, Technician updatedTechnician){
        String query = "UPDATE technician SET name =?, phone_no =?, email =?, comment =?, specializations =?, reparations =? WHERE technician_id =?";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, updatedTechnician.name);
            pstmt.setString(2, updatedTechnician.phoneNumber);
            pstmt.setString(3, updatedTechnician.email);
            pstmt.setString(4, updatedTechnician.comment);
            pstmt.setArray(5, conn.createArrayOf("specialization", updatedTechnician.specializations.toArray()));
            pstmt.setArray(6, conn.createArrayOf("reparation", updatedTechnician.reparations.toArray()));
            pstmt.setInt(7, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e){
            Utils.logError(e);
        }
    }

    void deleteTechnician(String id){
        String query = "DELETE FROM technician WHERE technician_id =? ";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e){
            Utils.logError(e);
        }
    }

    void createTechnician(Technician technician){
        String query = "INSERT INTO technician (name, phone_no, comment, email) VALUES (?,?,?,?)";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, technician.name);
            pstmt.setString(2, technician.phoneNumber);
            pstmt.setString(3, technician.comment);
            pstmt.setString(4, technician.email);

            pstmt.executeUpdate();
        } catch (SQLException e){
            Utils.logError(e);
        }
    }

    protected Technician newTechnicianFromResultSet(ResultSet rs) throws SQLException {

        return new Technician(rs.getInt("technician_id"), rs.getString("name"), rs.getString("phone_no"), rs.getString("email"), rs.getString("comment"), (ArrayList<Specialization>) (rs.getArray("specializations")), (ArrayList<Reparation>) (rs.getArray("reparations")));
    }
}
