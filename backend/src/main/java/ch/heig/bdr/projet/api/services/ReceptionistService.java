package ch.heig.bdr.projet.api.services;

import ch.heig.bdr.projet.api.PostgresConnection;
import ch.heig.bdr.projet.api.models.Language;
import ch.heig.bdr.projet.api.models.Receptionist;
import ch.heig.bdr.projet.api.util.Utils;

import java.sql.*;
import java.util.ArrayList;

/**
 * Receptionist CRUD service.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class ReceptionistService {

    Connection conn;

    /**
     * Default constructor.
     */
    public ReceptionistService() {
        conn = PostgresConnection.getInstance().getConnection();
    }

    /**
     * Get a receptionist by id.
     *
     * @param id id of the receptionist to get
     * @return Receptionist with the given id
     */
    public Receptionist getReceptionistById(String id){
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

    /**
     * Get all receptionists.
     *
     * @return ArrayList<Receptionist> list of receptionists
     */
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

    /**
     * Create a receptionist.
     *
     * @param receptionist new receptionist
     * @return id of the created receptionist
     */
    public int createReceptionist(Receptionist receptionist) {
            String query = "CALL createReceptionist(?, ?, ?, ?, ?::character varying[], ?)";

            try (CallableStatement cstmt = conn.prepareCall(query)) {
                cstmt.setString(1, receptionist.name);
                cstmt.setString(2, receptionist.phoneNumber);
                cstmt.setString(3, receptionist.comment);
                cstmt.setString(4, receptionist.email);

                String[] languageStrings = receptionist.languages.stream().map(Language::toString).toArray(String[]::new);
                Array sqlArray = conn.createArrayOf("VARCHAR", languageStrings);
                cstmt.setArray(5, sqlArray);
                cstmt.registerOutParameter(6, Types.INTEGER);

                cstmt.execute();
                return cstmt.getInt(6);
            } catch (SQLException e) {
                Utils.logError(e);
                return -1;
            }
    }


    /**
     * Update a receptionist.
     *
     * @param id                  id of the receptionist to update
     * @param updatedReceptionist new receptionist
     */
    public void updateReceptionist(String id, Receptionist updatedReceptionist) {
        String query = "CALL UpdateReceptionist(?, ?, ?, ?, ?, ?::character varying[],?::character varying[])";

        try (CallableStatement cstmt = conn.prepareCall(query)) {

            cstmt.setInt(1, Integer.parseInt(id));
            cstmt.setString(2, updatedReceptionist.name);
            cstmt.setString(3, updatedReceptionist.phoneNumber);
            cstmt.setString(4, updatedReceptionist.comment);
            cstmt.setString(5, updatedReceptionist.email);

            String[] newLanguages = updatedReceptionist.languages.stream().map(Language::toString).toArray(String[]::new);

            Array newLanguagesArray = conn.createArrayOf("VARCHAR", newLanguages);
            Receptionist r = getReceptionistById(id);
            String[] oldLanguages = r.languages.stream().map(Language::toString).toArray(String[]::new);
            Array oldLanguagesArray = conn.createArrayOf("VARCHAR", oldLanguages);

            cstmt.setArray(6, newLanguagesArray);
            cstmt.setArray(7, oldLanguagesArray);

            cstmt.execute();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    /**
     * Delete a receptionist.
     *
     * @param id id of the receptionist to delete
     */
    public void deleteReceptionist(String id){
        String query = "DELETE FROM receptionist_info_view WHERE receptionist_id =? ";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }


    /**
     * Get all languages of a receptionist.
     *
     * @param id id of the receptionist
     * @return ArrayList<Language> list of languages
     */
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
}
