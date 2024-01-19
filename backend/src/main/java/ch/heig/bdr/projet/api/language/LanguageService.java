package ch.heig.bdr.projet.api.language;

import ch.heig.bdr.projet.api.PostgresConnection;

import java.sql.Connection;
import java.util.ArrayList;

/**
 * LanguageService class
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class LanguageService {

    Connection conn;

    public LanguageService() {
        conn = PostgresConnection.getInstance().getConnection();
    }

    // only get all
    ArrayList<Language> getLanguages(){
        String query = "SELECT * FROM language";
        try(java.sql.Statement statement = conn.createStatement();
            java.sql.ResultSet rs = statement.executeQuery(query)) {
            ArrayList<Language> languages = new ArrayList<>();
            while (rs.next()) {
                languages.add(new Language(rs.getString("name")));
            }
            return languages;
        } catch (java.sql.SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }
}

