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

    /**
     * Default constructor.
     */
    public ManagerService() {
        conn = PostgresConnection.getInstance().getConnection();
    }

    /**
     * Get a manager by id.
     *
     * @param id id of the manager to get
     * @return Manager with the given id
     */
    public Manager getManagerById(String id) {
        String query = "SELECT * FROM manager_info_view WHERE manager_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new Manager(rs.getInt("manager_id"), rs.getString("phone_no"), rs.getString("name"), rs.getString("comment"), rs.getString("email"));
                } else {
                    return null;
                }
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    /**
     * Get all managers.
     *
     * @return ArrayList<Manager> list of managers
     */
    public ArrayList<Manager> getManagers() {
        String query = "SELECT * FROM manager_info_view";
        try (Statement statement = conn.createStatement(); ResultSet rs = statement.executeQuery(query)) {
            ArrayList<Manager> managers = new ArrayList<>();
            while (rs.next()) {
                managers.add(new Manager(rs.getInt("manager_id"), rs.getString("phone_no"), rs.getString("name"), rs.getString("comment"), rs.getString("email")));
            }
            return managers;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    /**
     * Update a manager.
     *
     * @param id             id of the manager to update
     * @param updatedManager new manager
     */
    public void updateManager(String id, Manager updatedManager) {
        String query = "UPDATE manager_info_view SET name =?, phone_no =?, comment =?, email =? WHERE manager_id =?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, updatedManager.name);
            pstmt.setString(2, updatedManager.phoneNumber);
            pstmt.setString(3, updatedManager.comment);
            pstmt.setString(4, updatedManager.email);
            pstmt.setInt(5, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    /**
     * Delete a manager.
     *
     * @param id id of the manager to delete
     */
    public void deleteManager(String id) {
        String query = "DELETE FROM manager_info_view WHERE manager_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    /**
     * Create a manager.
     *
     * @param manager manager to create
     * @return id of the created manager
     */
    public int createManager(Manager manager) {
        String query = "CALL projet.InsertManager(?, ?, ?, ?, ?)";
        try (CallableStatement cstmt = conn.prepareCall(query)) {
            cstmt.setString(1, manager.name);
            cstmt.setString(2, manager.phoneNumber);
            cstmt.setString(3, manager.comment);
            cstmt.setString(4, manager.email);
            cstmt.registerOutParameter(5, Types.INTEGER);

            cstmt.execute();
            return cstmt.getInt(5);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return -1;
        }
    }
}

