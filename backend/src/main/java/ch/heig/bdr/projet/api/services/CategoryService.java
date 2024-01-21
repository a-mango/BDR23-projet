package ch.heig.bdr.projet.api.services;

import ch.heig.bdr.projet.api.PostgresConnection;
import ch.heig.bdr.projet.api.models.Category;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

/**
 * CategoryService class
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class CategoryService {

    Connection conn;

    /**
     * Default constructor.
     */
    public CategoryService() {
        conn = PostgresConnection.getInstance().getConnection();
    }

    public ArrayList<Category> getCategories(){
        String query = "SELECT * FROM category";
        try(Statement statement = conn.createStatement();
            ResultSet rs = statement.executeQuery(query)) {
            ArrayList<Category> categories = new ArrayList<>();
            while (rs.next()) {
                categories.add(new Category(rs.getString("name")));
            }
            return categories;
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

}

