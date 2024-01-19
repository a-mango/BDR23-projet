package ch.heig.bdr.projet.api.brand;

import ch.heig.bdr.projet.api.PostgresConnection;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

/**
 * BrandService class
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class BrandService {

    Connection conn;

    /**
     * Default constructor.
     */
    BrandService() {
        conn = PostgresConnection.getInstance().getConnection();
    }

    ArrayList<Brand> getBrands(){
        String query = "SELECT * FROM brand";
        try(Statement statement = conn.createStatement();
            ResultSet rs = statement.executeQuery(query)) {
            ArrayList<Brand> brands = new ArrayList<>();
            while (rs.next()) {
                brands.add(new Brand(rs.getString("name")));
            }
            return brands;
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }

    }
}

