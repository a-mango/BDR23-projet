package ch.heig.bdr.projet.api.specialization;

import ch.heig.bdr.projet.api.PostgresConnection;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class SpecializationService {

    Connection conn;

    public SpecializationService() {
        conn = PostgresConnection.getInstance().getConnection();
    }

    ArrayList<Specialization> getSpecializations(){
        String query = "SELECT * FROM specialization";
        try(Statement statement = conn.createStatement();
            ResultSet rs = statement.executeQuery(query)) {
            ArrayList<Specialization> specializations = new ArrayList<>();
            while (rs.next()) {
                specializations.add(new Specialization(rs.getString("name")));
            }
            return specializations;
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }
}
