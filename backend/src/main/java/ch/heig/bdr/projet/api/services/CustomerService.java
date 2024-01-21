package ch.heig.bdr.projet.api.services;

import ch.heig.bdr.projet.api.PostgresConnection;
import ch.heig.bdr.projet.api.models.Customer;
import ch.heig.bdr.projet.api.util.Utils;

import java.sql.*;
import java.util.ArrayList;

/**
 * CustomerService class
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class CustomerService {

    Connection conn;

    /**
     * Default constructor.
     */
    public CustomerService() {
        conn = PostgresConnection.getInstance().getConnection();
    }

    /**
     * Get a customer by id.
     *
     * @param id id of the customer to get
     * @return Customer with the given id
     */
    public Customer getCustomerById(String id) {
        String query = "SELECT * FROM customer_info_view WHERE customer_id =?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return newCustomerFromResultSet(rs);
                } else {
                    return null;
                }
            }
        } catch (SQLException e) {
            Utils.logError(e);
            return null;
        }
    }

    /**
     * Get all customers.
     *
     * @return ArrayList<Customer> list of customers
     */
    public ArrayList<Customer> getCustomers() {
        String query = "SELECT * FROM customer_info_view";
        try (Statement pstmt = conn.createStatement(); ResultSet rs = pstmt.executeQuery(query)) {
            ArrayList<Customer> customers = new ArrayList<>();
            while (rs.next()) {
                customers.add(newCustomerFromResultSet(rs));
            }
            return customers;

        } catch (SQLException e) {
            Utils.logError(e);
            return null;
        }
    }

    /**
     * Update a customer.
     *
     * @param id              id of the customer to update
     * @param updatedCustomer updated customer
     */
    public void updateCustomer(String id, Customer updatedCustomer) {
        String query = "UPDATE customer_info_view SET phone_no =?, name =?, comment =?, tos_accepted =?, private_note =? WHERE customer_id =?";

        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, updatedCustomer.phoneNumber);
            pstmt.setString(2, updatedCustomer.name);
            pstmt.setString(3, updatedCustomer.comment);
            pstmt.setBoolean(4, updatedCustomer.tosAccepted);
            pstmt.setString(5, updatedCustomer.privateNote);
            pstmt.setInt(6, Integer.parseInt(id));

            pstmt.executeUpdate();
        } catch (SQLException e) {
            Utils.logError(e);
        }
    }

    /**
     * Delete a customer.
     *
     * @param id id of the customer to delete
     */
    public void deleteCustomer(String id) {
        String query = "DELETE FROM person WHERE person_id =?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e) {
            Utils.logError(e);
        }
    }

    /**
     * Create a customer.
     *
     * @param customer customer to create
     * @return id of the created customer
     */
    public int createCustomer(Customer customer) {
        String query = "CALL projet.InsertCustomer(?, ?, ?, ?, ?, ?)";

        try (CallableStatement cstmt = conn.prepareCall(query)) {
            cstmt.setString(1, customer.name);
            cstmt.setString(2, customer.phoneNumber);
            cstmt.setString(3, customer.comment);
            cstmt.setBoolean(4, customer.tosAccepted);
            cstmt.setString(5, customer.privateNote);
            cstmt.registerOutParameter(6, Types.INTEGER);

            cstmt.execute();

            return cstmt.getInt(6);
        } catch (SQLException e) {
            Utils.logError(e);
            return -1;
        }
    }

    /**
     * Create a customer from a ResultSet.
     *
     * @param rs ResultSet to create the customer from
     * @return Customer created from the ResultSet
     * @throws SQLException if an error occurs while accessing the ResultSet
     */
    protected Customer newCustomerFromResultSet(ResultSet rs) throws SQLException {

        return new Customer(rs.getInt("customer_id"), rs.getString("phone_no"), rs.getString("name"), rs.getString("comment"), rs.getString("private_note"), rs.getBoolean("tos_accepted"));
    }
}

