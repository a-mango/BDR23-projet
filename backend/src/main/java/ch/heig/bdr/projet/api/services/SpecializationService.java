package ch.heig.bdr.projet.api.services;

import ch.heig.bdr.projet.api.PostgresConnection;
import ch.heig.bdr.projet.api.models.Specialization;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

/**
 * Specialization CRUD service.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class SpecializationService {

    Connection conn;

    /**
     * Constructor.
     */
    public SpecializationService() {
        conn = PostgresConnection.getInstance().getConnection();
    }

    /**
     * Get all specializations.
     *
     * @return ArrayList<Specialization> list of specializations
     */
    public ArrayList<Specialization> getSpecializations(){
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
