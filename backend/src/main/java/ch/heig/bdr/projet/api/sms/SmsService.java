package ch.heig.bdr.projet.api.sms;

import ch.heig.bdr.projet.api.PostgresConnection;
import ch.heig.bdr.projet.api.ProcessingState;
import ch.heig.bdr.projet.api.person.Person;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class SmsService {

    Connection connection;

    public SmsService() {
        connection = PostgresConnection.getInstance().getConnection();
    }

    Sms getSmsById(String id) {
        try {
            Statement statement = connection.createStatement();
            String query = "SELECT * FROM sms WHERE sms_id = " + id;
            ResultSet rs = statement.executeQuery(query);
            if (rs.next()) {
                return new Sms(rs.getInt("sms_id"), rs.getDate("date_created"), rs.getString("message"), rs.getString("sender"), rs.getString("receiver"), (ProcessingState) rs.getObject("processing_state"));
            } else {
                return null;
            }
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    ArrayList<Sms> getSms() {
        return null;
    }

    void createSms(Sms sms) {

    }

    void updateSms(String id, Sms sms) {

    }

    void deleteSms(String id) {

    }
}
