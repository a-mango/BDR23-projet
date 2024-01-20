package ch.heig.bdr.projet.api.receptionist;

import ch.heig.bdr.projet.api.PostgresConnection;

import java.sql.*;
import java.util.ArrayList;

public class ReceptionistService {

    Connection conn;

    public ReceptionistService() {
        conn = PostgresConnection.getInstance().getConnection();
    }

    Receptionist getReceptionistByIs(String id){
        String query = "SELECT * FROM receptionist_info_view WHERE receptionist_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            try(ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new Receptionist(rs.getInt("receptionist_id"), rs.getString("phone_no"), rs.getString("name"), rs.getString("comment"), rs.getString("email"));
                } else {
                    return null;
                }
            }
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    ArrayList<Receptionist> getReceptionists(){
        String query = "SELECT * FROM receptionist_info_view";
        try(Statement statement = conn.createStatement();
            ResultSet rs = statement.executeQuery(query)) {
            ArrayList<Receptionist> receptionists = new ArrayList<>();
            while (rs.next()) {
                receptionists.add(new Receptionist(rs.getInt("receptionist_id"), rs.getString("phone_no"), rs.getString("name"), rs.getString("comment"), rs.getString("email")));
            }
            return receptionists;
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    void createReceptionist(Receptionist receptionist){
        String query = "INSERT INTO receptionist_info_view (phone_no, name, comment, email) VALUES (?, ?, ?, ?)";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, receptionist.phoneNumber);
            pstmt.setString(2, receptionist.name);
            pstmt.setString(3, receptionist.comment);
            pstmt.setString(4, receptionist.email);
            pstmt.executeUpdate();
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }

    }

    void updateReceptionist(String id, Receptionist updatedReceptionist){
        String query = "UPDATE receptionist_info_view SET name =?, phone_no =?, comment =?, email =? WHERE receptionist_id =?";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, updatedReceptionist.name);
            pstmt.setString(2, updatedReceptionist.phoneNumber);
            pstmt.setString(3, updatedReceptionist.comment);
            pstmt.setString(4, updatedReceptionist.email);
            pstmt.setInt(5, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }

    void deleteReceptionist(String id){
        String query = "DELETE FROM receptionist_info_view WHERE receptionist_id =? ";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }


}
