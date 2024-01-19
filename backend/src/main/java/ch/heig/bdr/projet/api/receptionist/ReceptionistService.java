package ch.heig.bdr.projet.api.receptionist;

import ch.heig.bdr.projet.api.PostgresConnection;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class ReceptionistService {

    Connection conn;

    public ReceptionistService() {
        conn = PostgresConnection.getInstance().getConnection();
    }

    Receptionist getReceptionistByIs(String id){
        return null;
    }

    ArrayList<Receptionist> getReceptionists(){
        String query = "SELECT * FROM receptionist_info_view";
        try(Statement statement = conn.createStatement();
            ResultSet rs = statement.executeQuery(query)) {
            ArrayList<Receptionist> receptionists = new ArrayList<>();
            while (rs.next()) {
                //receptionists.add(new Receptionist(rs.getInt("receptionist_id"), rs.getString("phone_no"), rs.getString("name"), rs.getString("comment")));
            }
            return receptionists;
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    void createReceptionist(Receptionist receptionist){

    }

    void updateReceptionist(String id, Receptionist updatedReceptionist){

    }

    void deleteReceptionist(String id){

    }


}
