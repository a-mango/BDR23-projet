package ch.heig.bdr.projet.api.customer;

import ch.heig.bdr.projet.api.PostgresConnection;
import ch.heig.bdr.projet.api.person.Person;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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
        try {
            Statement statement = conn.createStatement();
            String query = "SELECT * FROM Customer_info_view WHERE Customer_id = " + id;
            ResultSet rs = statement.executeQuery(query);
            if (rs.next()) {
                Person p = new Person(rs.getInt("Customer_id"), rs.getString("phone_no"), rs.getString("name"), rs.getString("comment"));
                return new Customer(p.person_id, p.phone_number, p.name, p.comment, rs.getString("private_note"), rs.getBoolean("tos_accepted"));
            } else {
                return null;
            }
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    ArrayList<Customer> getCustomers(){
        try {
            Statement statement = conn.createStatement();
            String query = "SELECT * FROM Customer_info_view";
            // System.out.println("query: " + query);
            ResultSet rs = statement.executeQuery(query);
            ArrayList<Customer> Customers = new ArrayList<>();
            while (rs.next()) {
                //System.out.println("inside while");
                Person p = new Person(rs.getInt("Customer_id"), rs.getString("phone_no"), rs.getString("name"), rs.getString("comment"));
                Customers.add(new Customer(p.person_id, p.phone_number, p.name, p.comment, rs.getString("private_note"), rs.getBoolean("tos_accepted")));
            }
            return Customers;

        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    void updateCustomer(String id, Customer updatedCustomer){
        try {
            Statement statement = conn.createStatement();
            String query = "UPDATE Customer SET phone_no = '" + updatedCustomer.phone_number + "', name = '" + updatedCustomer.name + "', comment = '" + updatedCustomer.comment + "', tos_accepted = '" + updatedCustomer.tosAccepted + "', private_note = '" + updatedCustomer.privateNote + "' WHERE customer_id = '" + id + "'  AND '" + updatedCustomer.tosAccepted + " 'IN (TRUE, FALSE)";
            statement.executeQuery(query);
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }

    void deleteCustomer(String id){
        try {
            Statement statement = conn.createStatement();
            String query = "DELETE FROM customer WHERE Customer_id = " + id + "; DELETE FROM person WHERE person_id = " + id;
            statement.executeQuery(query);

        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }

    void createCustomer(Customer customer){
        try {
            Statement statement = conn.createStatement();
            String query = "INSERT INTO person (phone_no, name, comment) VALUES ('" + customer.phone_number + "', '" + customer.name + "', '" + customer.comment + "'); INSERT INTO Customer (phone_no, name, comment) VALUES ('" + customer.phone_number + "', '" + customer.name + "', '" + customer.comment + "')";
            statement.executeQuery(query);

        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }
}

