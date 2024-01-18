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
                return new Sms(rs.getInt("sms_id"), rs.getInt("reparation_id"), rs.getDate("date_created"), rs.getString("message"), rs.getString("sender"), rs.getString("receiver"), (ProcessingState) rs.getObject("processing_state"));
            } else {
                return null;
            }
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    ArrayList<Sms> getSms() {
        try {
            Statement statement = connection.createStatement();
            String query = "SELECT * FROM sms";
            ResultSet rs = statement.executeQuery(query);
            ArrayList<Sms> sms = new ArrayList<>();
            while (rs.next()) {
                sms.add(new Sms(rs.getInt("sms_id"), rs.getInt("reparation_id"), rs.getDate("date_created"), rs.getString("message"), rs.getString("sender"), rs.getString("receiver"), (ProcessingState) rs.getObject("processing_state")));
            }
            return sms;
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    void createSms(Sms sms) {

        try {
            Statement statement = connection.createStatement();
            // String query = "INSERT INTO sms (phone_no, name, comment) VALUES ('" + person.phone_number + "', '" + person.name + "', '" + person.comment + "')";
            // statement.executeQuery(query);

        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }

    void updateSms(String id, Sms sms) {
        try {
            Statement statement = connection.createStatement();
            //String query = "UPDATE person SET phone_no = '" + updatedPerson.phone_number + "', name = '" + updatedPerson.name + "', comment = '" + updatedPerson.comment + "' WHERE person_id = " + id;
            //statement.executeQuery(query);
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }

    void deleteSms(String id) {
        try {
            Statement statement = connection.createStatement();
            String query = "DELETE FROM sms WHERE sms_id = " + id;
            statement.executeQuery(query);
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }

    }
}
