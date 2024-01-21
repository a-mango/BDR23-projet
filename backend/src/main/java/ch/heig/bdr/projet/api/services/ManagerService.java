package ch.heig.bdr.projet.api.services;

import ch.heig.bdr.projet.api.PostgresConnection;
import ch.heig.bdr.projet.api.models.Manager;

import java.sql.*;
import java.util.ArrayList;

/**
 * ManagerService class
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class ManagerService {

    Connection conn;

    public ManagerService() {
        conn = PostgresConnection.getInstance().getConnection();
    }

    public Manager getManagerById(String id){
        String query = "SELECT * FROM manager_info_view WHERE manager_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            try(ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new Manager(rs.getInt("manager_id"), rs.getString("phone_no"), rs.getString("name"), rs.getString("comment"), rs.getString("email"));
                } else {
                    return null;
                }
            }
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    public ArrayList<Manager> getManagers(){
        String query = "SELECT * FROM manager_info_view";
        try(Statement statement = conn.createStatement();
            ResultSet rs = statement.executeQuery(query)) {
            ArrayList<Manager> managers = new ArrayList<>();
            while (rs.next()) {
                managers.add(new Manager(rs.getInt("manager_id"), rs.getString("phone_no"), rs.getString("name"), rs.getString("comment"), rs.getString("email")));
            }
            return managers;
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    public void updateManager(String id, Manager updatedManager){
        String query = "UPDATE manager_info_view SET name =?, phone_no =?, comment =?, email =? WHERE manager_id =?";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, updatedManager.name);
            pstmt.setString(2, updatedManager.phoneNumber);
            pstmt.setString(3, updatedManager.comment);
            pstmt.setString(4, updatedManager.email);
            pstmt.setInt(5, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }

    public void deleteManager(String id){
        String query = "DELETE FROM manager_info_view WHERE manager_id = ?";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }

    public void createManager(Manager manager){
        String query = "INSERT INTO manager_info_view (name, phone_no, comment, email) VALUES (?, ?, ?, ?)";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, manager.name);
            pstmt.setString(2, manager.phoneNumber);
            pstmt.setString(3, manager.comment);
            pstmt.setString(4, manager.email);
            pstmt.executeUpdate();
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }
}

