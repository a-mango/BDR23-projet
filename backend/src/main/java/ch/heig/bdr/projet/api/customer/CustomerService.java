package ch.heig.bdr.projet.api.customer;

import ch.heig.bdr.projet.api.PostgresConnection;
import ch.heig.bdr.projet.api.person.Person;
import ch.heig.bdr.projet.api.Utils;

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
     * Constructor.
     */
    public CustomerService() {
        conn = PostgresConnection.getInstance().getConnection();
    }

    Customer getCustomerById(String id){
        String query = "SELECT * FROM customer_info_view WHERE customer_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)){
            pstmt.setString(1, id);
            try(ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return newCustomerFromResultSet(rs);
                } else {
                    return null;
                }
            }
        } catch (SQLException e){
            Utils.logError(e);
            return null;
        }
    }

    ArrayList<Customer> getCustomers(){
        String query = "SELECT * FROM customer_info_view";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            try(ResultSet rs = pstmt.executeQuery(query)) {
                ArrayList<Customer> customers = new ArrayList<>();
                while (rs.next()) {
                    customers.add(newCustomerFromResultSet(rs));
                }
                return customers;
            }
        } catch (SQLException e){
            Utils.logError(e);
            return null;
        }
    }

    void updateCustomer(String id, Customer updatedCustomer){
        String query = "UPDATE customer SET phone_no =?, name =?, comment =?, tos_accepted =?, private_note =? WHERE customer_id =?  AND ? IN (TRUE, FALSE)";

        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, updatedCustomer.phoneNumber);
            pstmt.setString(2, updatedCustomer.name);
            pstmt.setString(3, updatedCustomer.comment);
            pstmt.setBoolean(4, updatedCustomer.tosAccepted);
            pstmt.setString(4, updatedCustomer.privateNote);
            pstmt.setString(6, id);
            pstmt.setBoolean(7, updatedCustomer.tosAccepted);

            pstmt.executeUpdate();
        } catch (SQLException e){
            Utils.logError(e);
        }
    }

    void deleteCustomer(String id){
        String query = "DELETE FROM person WHERE person_id =?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)){
            pstmt.setString(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e){
            Utils.logError(e);
        }
    }

    void createCustomer(Customer customer){
        String query = "CALL projet.InsertCustomer(?, ?, ?, ?, ?);";

        try (PreparedStatement pstmt = conn.prepareStatement(query)){
            pstmt.setString(1, customer.name);
            pstmt.setString(2, customer.phoneNumber);
            pstmt.setString(3, customer.comment);
            pstmt.setBoolean(4, customer.tosAccepted);
            pstmt.setString(5, customer.privateNote);

            pstmt.executeUpdate();
        } catch (SQLException e){
            Utils.logError(e);
        }
    }

    protected Customer newCustomerFromResultSet(ResultSet rs) throws SQLException {
        Person p = new Person(rs.getInt("customer_id"), rs.getString("phone_no"), rs.getString("name"), rs.getString("comment"));

        return new Customer(p.personId, p.phoneNumber, p.name, p.comment, rs.getString("private_note"), rs.getBoolean("tos_accepted"));
    }
}

