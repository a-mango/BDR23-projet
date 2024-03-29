package ch.heig.bdr.projet.api.services;

import ch.heig.bdr.projet.api.PostgresConnection;
import ch.heig.bdr.projet.api.models.Sale;

import java.sql.*;
import java.time.OffsetDateTime;
import java.util.ArrayList;

/**
 * Sale CRUD service.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class SaleService {

    Connection conn;

    /**
     * Default constructor.
     */
    public SaleService() {
        conn = PostgresConnection.getInstance().getConnection();
    }

    /**
     * Get a sale by id.
     *
     * @param id id of the sale to get
     * @return Sale with the given id
     */
    public Sale getSaleById(String id) {
        String query = "SELECT * FROM sale WHERE id_sale = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String dateSold = rs.getObject("date_sold", OffsetDateTime.class) == null ? "" : rs.getObject("date_sold", OffsetDateTime.class).toString();
                    return new Sale(rs.getInt("id_sale"), rs.getInt("object_id"), rs.getInt("price"), rs.getObject("date_created", OffsetDateTime.class).toString(), dateSold);
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
     * Get all sales.
     *
     * @return ArrayList<Sale> list of sales
     */
    public ArrayList<Sale> getSales() {
        String query = "SELECT * FROM sale";
        try (Statement statement = conn.createStatement(); ResultSet rs = statement.executeQuery(query)) {
            ArrayList<Sale> sales = new ArrayList<>();
            while (rs.next()) {
                String dateSold = rs.getObject("date_sold", OffsetDateTime.class) == null ? "" : rs.getObject("date_sold", OffsetDateTime.class).toString();
                sales.add(new Sale(rs.getInt("id_sale"), rs.getInt("object_id"), rs.getInt("price"), rs.getObject("date_created", OffsetDateTime.class).toString(), dateSold));
            }
            return sales;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    /**
     * Update a sale.
     *
     * @param id          id of the sale to update
     * @param updatedSale new sale
     */
    public void updateSale(String id, Sale updatedSale) {
        String query = "UPDATE sale SET price =?, date_sold =? WHERE id_sale =?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            OffsetDateTime dateSold = updatedSale.dateSold.isEmpty() ? null : OffsetDateTime.parse(updatedSale.dateSold);
            pstmt.setInt(1, updatedSale.price);
            pstmt.setObject(2, dateSold, Types.TIMESTAMP_WITH_TIMEZONE);
            pstmt.setInt(3, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    /**
     * Delete a sale.
     *
     * @param id id of the sale to delete
     */
    public void deleteSale(String id) {
        String query = "DELETE FROM sale WHERE id_sale =? ";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    /**
     * Create a sale.
     *
     * @param sale new sale
     * @return id of the created sale
     */
    public void createSale(Sale sale) {
        String query = "INSERT INTO sale (object_id, price) VALUES (?,?)";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, sale.objectId);
            pstmt.setInt(2, sale.price);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
}
