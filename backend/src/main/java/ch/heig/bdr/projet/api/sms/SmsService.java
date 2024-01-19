package ch.heig.bdr.projet.api.sms;

import ch.heig.bdr.projet.api.PostgresConnection;
import ch.heig.bdr.projet.api.ProcessingState;

import java.sql.*;
import java.util.ArrayList;

public class SmsService {

    Connection connection;

    public SmsService() {
        connection = PostgresConnection.getInstance().getConnection();
    }

    /**
     * Get all the sms for the reparation with the given id.
     * @param id
     * @return all the sms for the reparation with the given id.
     */
    Sms getSmsById(String id) {
        String query = "SELECT * FROM sms WHERE sms_id =? ";
        try(PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            try(ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new Sms(rs.getInt("sms_id"), rs.getInt("reparation_id"),
                            rs.getDate("date_created"), rs.getString("message"),
                            rs.getString("sender"), rs.getString("receiver"),
                            ProcessingState.valueOf(rs.getString("processing_state")));
                } else {
                    return null;
                }
            }
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    ArrayList<Sms> getSms() {
        String query = "SELECT * FROM sms";
        try(Statement statement = connection.createStatement();
            ResultSet rs = statement.executeQuery(query)) {
            ArrayList<Sms> sms = new ArrayList<>();
            while (rs.next()) {
                sms.add(new Sms(rs.getInt("sms_id"), rs.getInt("reparation_id"),
                        rs.getDate("date_created"), rs.getString("message"),
                        rs.getString("sender"), rs.getString("receiver"),
                        ProcessingState.valueOf(rs.getString("processing_state"))));
            }
            return sms;
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    void createSms(Sms sms) {
        String query = "INSERT INTO sms (reparation_id, message, sender, receiver, processing_state) VALUES (?, ?, ?, ?, CAST(? AS processing_state))";
        try(PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, sms.reparationId);
            pstmt.setString(2, sms.message);
            pstmt.setString(3, sms.sender);
            pstmt.setString(4, sms.receiver);
            pstmt.setString(5, sms.processingState.toString());
            pstmt.executeUpdate();
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }

    void updateSms(String id, Sms sms) {
          String query = "UPDATE sms SET reparation_id = ?, message = ?, sender = ?, receiver = ?, processing_state = CAST(? AS processing_state) WHERE sms_id = ?";
          try(PreparedStatement pstmt = connection.prepareStatement(query)) {
                pstmt.setInt(1, sms.reparationId);
                pstmt.setString(2, sms.message);
                pstmt.setString(3, sms.sender);
                pstmt.setString(4, sms.receiver);
                pstmt.setString(5, sms.processingState.toString());
                pstmt.setString(6, id);
                pstmt.executeUpdate();
          } catch (SQLException e){
                System.out.println(e.getMessage());
          }
    }

    void deleteSms(String id) {
        String query = "DELETE FROM sms WHERE sms_id = ?";
        try(PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setString(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }

    ArrayList<Sms> getSmsForRepairId(String id) {
        String query = "SELECT * FROM sms WHERE reparation_id =? ";
        ArrayList<Sms> sms = new ArrayList<>();
        try(PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            try(ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    sms.add(new Sms(rs.getInt("sms_id"), rs.getInt("reparation_id"),
                            rs.getDate("date_created"), rs.getString("message"),
                            rs.getString("sender"), rs.getString("receiver"),
                            ProcessingState.valueOf(rs.getString("processing_state"))));
                }
            }
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
        return sms;
    }
}
