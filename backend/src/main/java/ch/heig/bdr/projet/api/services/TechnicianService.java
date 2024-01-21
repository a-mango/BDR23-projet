package ch.heig.bdr.projet.api.services;

import ch.heig.bdr.projet.api.PostgresConnection;
import ch.heig.bdr.projet.api.util.Utils;
import ch.heig.bdr.projet.api.models.Technician;

import java.sql.*;
import java.util.ArrayList;

public class TechnicianService {

    Connection conn;
    public TechnicianService() {
        conn = PostgresConnection.getInstance().getConnection();
    }

    public Technician getTechnicianById(String id){
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

    public ArrayList<Technician> getTechnicians(){
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

    public void updateTechnician(String id, Technician updatedTechnician){
        //        String query = "UPDATE technician_info_view SET name =?, phone_no =?, email =?, comment =?, specializations =?, reparations =? WHERE technician_id =?";
        String query = "UPDATE technician_info_view SET name =?, phone_no =?, email =?, comment =? WHERE technician_id =?";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, updatedTechnician.name);
            pstmt.setString(2, updatedTechnician.phoneNumber);
            pstmt.setString(3, updatedTechnician.email);
            pstmt.setString(4, updatedTechnician.comment);
            //pstmt.setArray(5, conn.createArrayOf("specialization", updatedTechnician.specializations.toArray()));
            //pstmt.setArray(6, conn.createArrayOf("reparation", updatedTechnician.reparations.toArray()));
            pstmt.setInt(7, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e){
            Utils.logError(e);
        }
    }

    public void deleteTechnician(String id){
        String query = "DELETE FROM technician_info_view WHERE technician_id =? ";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e){
            Utils.logError(e);
        }
    }

    public int createTechnician(Technician technician){
        String query = "{CALL projet.InsertTechnician(?, ?, ?, ?,?)}";

        try(CallableStatement cstmt = conn.prepareCall(query)) {
            cstmt.setString(1, technician.name);
            cstmt.setString(2, technician.phoneNumber);
            cstmt.setString(3, technician.comment);
            cstmt.setString(4, technician.email);
            cstmt.registerOutParameter(5, Types.INTEGER);

            cstmt.executeUpdate();
            return cstmt.getInt(5);
        } catch (SQLException e){
            Utils.logError(e);
            return -1;
        }
    }

    protected Technician newTechnicianFromResultSet(ResultSet rs) throws SQLException {
        //        return new Technician(rs.getInt("technician_id"), rs.getString("name"), rs.getString("phone_no"), rs.getString("email"), rs.getString("comment"), (ArrayList<Specialization>) (rs.getArray("specializations")), (ArrayList<Reparation>) (rs.getArray("reparations")));
        return new Technician(rs.getInt("technician_id"), rs.getString("name"), rs.getString("phone_no"), rs.getString("email"), rs.getString("comment")/*, (ArrayList<Specialization>) (rs.getArray("specializations")), (ArrayList<Reparation>) (rs.getArray("reparations"))*/);
    }
}
