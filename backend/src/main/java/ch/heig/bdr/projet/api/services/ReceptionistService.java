package ch.heig.bdr.projet.api.services;

import ch.heig.bdr.projet.api.PostgresConnection;
import ch.heig.bdr.projet.api.models.Language;
import ch.heig.bdr.projet.api.models.Receptionist;
import ch.heig.bdr.projet.api.util.Utils;

import java.sql.*;
import java.util.ArrayList;

public class ReceptionistService {

    Connection conn;

    public ReceptionistService() {
        conn = PostgresConnection.getInstance().getConnection();
    }

    public Receptionist getReceptionistByIs(String id){
        String query = "SELECT * FROM receptionist_info_view WHERE receptionist_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            try(ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new Receptionist(rs.getInt("receptionist_id"), rs.getString("phone_no"),
                            rs.getString("name"), rs.getString("comment"),
                            rs.getString("email"), getReceptionistLanguages(id));
                } else {
                    return null;
                }
            }
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    public ArrayList<Receptionist> getReceptionists(){
        String query = "SELECT * FROM receptionist_info_view";
        try(Statement statement = conn.createStatement();
            ResultSet rs = statement.executeQuery(query)) {
            ArrayList<Receptionist> receptionists = new ArrayList<>();
            while (rs.next()) {
                receptionists.add(new Receptionist(rs.getInt("receptionist_id"), rs.getString("phone_no"), rs.getString("name"), rs.getString("comment"), rs.getString("email"), getReceptionistLanguages(rs.getString("receptionist_id"))));
            }
            return receptionists;
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    public int createReceptionist(Receptionist receptionist) {
            String query = "CALL createReceptionist(?, ?, ?, ?, ?::character varying[], ?)";

            try (CallableStatement cstmt = conn.prepareCall(query)) {
                cstmt.setString(1, receptionist.name);
                cstmt.setString(2, receptionist.phoneNumber);
                cstmt.setString(3, receptionist.comment);
                cstmt.setString(4, receptionist.email);

                // Convert the ArrayList to an array of string representations
                String[] languageStrings = receptionist.languages.stream()
                        .map(Language::toString)
                        .toArray(String[]::new);

                // Convert the array of string representations to SQL array using Array class
                Array sqlArray = conn.createArrayOf("VARCHAR", languageStrings);


                // Set the SQL array as a parameter
                cstmt.setArray(5, sqlArray);
                cstmt.registerOutParameter(6, Types.INTEGER);

                cstmt.execute();
                return cstmt.getInt(6);
            } catch (SQLException e) {
                Utils.logError(e);
                return -1;
            }
    }


    public void updateReceptionist(String id, Receptionist updatedReceptionist) {
        String query = "{CALL UpdateReceptionist(?, ?, ?, ?, ?, ?::character varying[],?::character varying[])}";

        try (CallableStatement cstmt = conn.prepareCall(query)) {

            cstmt.setInt(1, Integer.parseInt(id));
            cstmt.setString(2, updatedReceptionist.name);
            cstmt.setString(3, updatedReceptionist.phoneNumber);
            cstmt.setString(4, updatedReceptionist.comment);
            cstmt.setString(5, updatedReceptionist.email);

            // Convert the ArrayList to an array of string representations
            String[] newLanguages = updatedReceptionist.languages.stream()
                    .map(Language::toString)
                    .toArray(String[]::new);

            // Convert the array of string representations to SQL array using Array class
            Array newLanguagesArray = conn.createArrayOf("VARCHAR", newLanguages);

            Receptionist r = getReceptionistByIs(id);
            String[] oldLanguages = r.languages.stream()
                    .map(Language::toString)
                    .toArray(String[]::new);

            // Convert the array of string representations to SQL array using Array class
            Array oldLanguagesArray = conn.createArrayOf("VARCHAR", oldLanguages);

            // Set the SQL array as a parameter
            cstmt.setArray(6, newLanguagesArray);
            cstmt.setArray(7, oldLanguagesArray);

            cstmt.execute();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    public void deleteReceptionist(String id){
        String query = "DELETE FROM receptionist_info_view WHERE receptionist_id =? ";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }


    public ArrayList<Language> getReceptionistLanguages(String id){
        String query = "SELECT * FROM receptionist_language WHERE receptionist_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            try(ResultSet rs = pstmt.executeQuery()) {
                ArrayList<Language> languages = new ArrayList<>();
                while (rs.next()) {
                    languages.add(new Language(rs.getString("language")));
                }
                return languages;
            }
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    public void addReceptionistLanguage(int id, String language){
        String query = "INSERT INTO receptionist_language (receptionist_id, language) VALUES (?, ?)";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, id);
            pstmt.setString(2, language);
            pstmt.executeUpdate();
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }

    public void deleteReceptionistLanguage(String id, String language){
        String query = "DELETE FROM receptionist_language WHERE receptionist_id =? AND language = ?";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            pstmt.setString(2, language);
            pstmt.executeUpdate();
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }
}
