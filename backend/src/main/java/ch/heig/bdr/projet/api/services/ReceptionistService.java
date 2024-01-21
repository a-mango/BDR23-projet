package ch.heig.bdr.projet.api.services;

import ch.heig.bdr.projet.api.PostgresConnection;
import ch.heig.bdr.projet.api.models.Language;
import ch.heig.bdr.projet.api.models.Receptionist;

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

    public void createReceptionist(Receptionist receptionist) {
        String insertReceptionistQuery = "INSERT INTO receptionist_info_view (phone_no, name, comment, email) VALUES (?, ?, ?, ?)";
        //String insertLanguageQuery = "INSERT INTO receptionist_language (receptionist_id, language) VALUES (?, ?)";

        try (PreparedStatement pstmt = conn.prepareStatement(insertReceptionistQuery, Statement.RETURN_GENERATED_KEYS);
             /*PreparedStatement pstmt2 = conn.prepareStatement(insertLanguageQuery)*/) {

            pstmt.setString(1, receptionist.phoneNumber);
            pstmt.setString(2, receptionist.name);
            pstmt.setString(3, receptionist.comment);
            pstmt.setString(4, receptionist.email);

            // Execute the insert query for receptionist_info_view
            int rowsAffected = pstmt.executeUpdate();

            // Check if the insertion was successful
            if (rowsAffected > 0) {
                // Retrieve the generated keys (including the generated ID)
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int receptionistId = generatedKeys.getInt(1);

                        // Update the receptionist object with the generated ID
                        receptionist.id = receptionistId;

                        // Insert language rows with the generated receptionist ID
                        for (Language language : receptionist.languages) {
                            addReceptionistLanguage(receptionistId, language.name);
                        }
                    }
                }
            } else {
                System.out.println("Failed to insert receptionist.");
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }


    public void updateReceptionist(String id, Receptionist updatedReceptionist){
        String query = "UPDATE receptionist_info_view SET name =?, phone_no =?, comment =?, email =? WHERE receptionist_id =?";
        String query2 = "DELETE FROM receptionist_language WHERE receptionist_id =?";
        String query3 = "INSERT INTO receptionist_language (receptionist_id, language) VALUES (?, ?)";
        ArrayList<Language> currentLanguages = getReceptionistLanguages(id);
        ArrayList<Language> languagesToAdd = new ArrayList<>(updatedReceptionist.languages);
        languagesToAdd.removeAll(currentLanguages);
        ArrayList<Language> languagesToDelete = new ArrayList<>(currentLanguages);
        languagesToDelete.removeAll(updatedReceptionist.languages);
        try(PreparedStatement pstmt = conn.prepareStatement(query);
            PreparedStatement pstmt2 = conn.prepareStatement(query2);
            PreparedStatement pstmt3 = conn.prepareStatement(query3)) {
            pstmt.setString(1, updatedReceptionist.name);
            pstmt.setString(2, updatedReceptionist.phoneNumber);
            pstmt.setString(3, updatedReceptionist.comment);
            pstmt.setString(4, updatedReceptionist.email);
            pstmt.setInt(5, Integer.parseInt(id));
            pstmt.executeUpdate();
            for(Language language : languagesToAdd){
                pstmt3.setInt(1, updatedReceptionist.id);
                pstmt3.setString(2, language.name);
                pstmt3.executeUpdate();
            }
            for(Language language : languagesToDelete){
                deleteReceptionistLanguage(id, language.name);
            }
        } catch (SQLException e){
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
