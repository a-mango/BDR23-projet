package ch.heig.bdr.projet.api.services;

import ch.heig.bdr.projet.api.models.Location;
import ch.heig.bdr.projet.api.PostgresConnection;
import ch.heig.bdr.projet.api.models.Brand;
import ch.heig.bdr.projet.api.models.Category;
import ch.heig.bdr.projet.api.models.Object;

import java.sql.*;
import java.util.ArrayList;

/**
 * Object CRUD service.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class ObjectService {

    Connection conn;

    public ObjectService() {
        conn = PostgresConnection.getInstance().getConnection();
    }

    public Object getObjectById(String id){
        String query = "SELECT * FROM object WHERE object_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            try(ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    ;
                    Object o =  new Object(rs.getInt("object_id"), rs.getString("name"),
                            rs.getString("fault_desc"), rs.getString("remark"),
                            rs.getString("serial_no"),
                            Location.valueOf(rs.getString("location")),
                            new Brand(rs.getString("brand")),
                            new Category(rs.getString("category")), rs.getInt("customer_id"));
                    return o;
                } else {
                    return null;
                }
            }
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    public ArrayList<Object> getObjects(){
        String query = "SELECT * FROM object";
        try(Statement statement = conn.createStatement();
            ResultSet rs = statement.executeQuery(query)) {
            ArrayList<Object> objects = new ArrayList<>();
            while (rs.next()) {
                objects.add(new Object(rs.getInt("object_id"), rs.getString("name"),
                        rs.getString("fault_desc"), rs.getString("remark"),
                        rs.getString("serial_no"),
                        Location.valueOf(rs.getString("location")),
                        new Brand(rs.getString("brand")),
                        new Category(rs.getString("category")), rs.getInt("customer_id")));
            }
            return objects;
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    public void updateObject(String id, Object updatedObject){
        String query = "UPDATE object SET name =?, fault_desc =?, remark =?, serial_no =?, location = CAST(? AS location), brand =?, category =?, customer_id =? WHERE object_id =?";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, updatedObject.name);
            pstmt.setString(2, updatedObject.faultDesc);
            pstmt.setString(3, updatedObject.remark);
            pstmt.setString(4, updatedObject.serialNo);
            pstmt.setString(5, updatedObject.location.toString());
            pstmt.setString(6, updatedObject.brand.name);
            pstmt.setString(7, updatedObject.category.name);
            pstmt.setInt(8, updatedObject.customerId);
            pstmt.setInt(9, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }

    public void deleteObject(String id){
        String query = "DELETE FROM object WHERE object_id =? ";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }

    public void createObject(Object object){
        String query = "INSERT INTO object (name, fault_desc, remark, serial_no, location, brand, category, customer_id) VALUES (?,?,?,?, CAST(? AS location),?,?,?)";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, object.name);
            pstmt.setString(2, object.faultDesc);
            pstmt.setString(3, object.remark);
            pstmt.setString(4, object.serialNo);
            pstmt.setString(5, object.location.toString());
            pstmt.setString(6, object.brand.name);
            pstmt.setString(7, object.category.name);
            pstmt.setInt(8, object.customerId);
            pstmt.executeUpdate();
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }
}
