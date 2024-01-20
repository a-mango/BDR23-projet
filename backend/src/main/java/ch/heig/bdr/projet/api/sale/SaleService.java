package ch.heig.bdr.projet.api.sale;

import ch.heig.bdr.projet.api.PostgresConnection;
import ch.heig.bdr.projet.api.object.Object;

import java.sql.*;
import java.time.OffsetDateTime;
import java.util.ArrayList;

public class SaleService {

    Connection conn;

    public SaleService() {
        conn = PostgresConnection.getInstance().getConnection();
    }

    Sale getSaleById(String id){
        String query = "SELECT * FROM sale WHERE id_sale = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            try(ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String dateSold = rs.getObject("date_sold", OffsetDateTime.class) == null ? "" : rs.getObject("date_sold", OffsetDateTime.class).toString();
                    return new Sale(rs.getInt("id_sale"),
                            rs.getInt("object_id") , rs.getInt("price"),
                            rs.getObject("date_created", OffsetDateTime.class).toString(),
                            dateSold);
                } else {
                    return null;
                }
            }
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    ArrayList<Sale> getSales(){
        String query = "SELECT * FROM sale";
        try(Statement statement = conn.createStatement();
            ResultSet rs = statement.executeQuery(query)) {
            ArrayList<Sale> sales = new ArrayList<>();
            while (rs.next()) {
                String dateSold = rs.getObject("date_sold", OffsetDateTime.class) == null ? "" : rs.getObject("date_sold", OffsetDateTime.class).toString();
                sales.add(new Sale(rs.getInt("id_sale"),
                        rs.getInt("object_id"), rs.getInt("price"),
                        rs.getObject("date_created", OffsetDateTime.class).toString(),
                        dateSold));
            }
            return sales;
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    void updateSale(String id, Sale updatedSale){
        String query = "UPDATE sale SET price =?, date_sold =? WHERE id_sale =?";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            OffsetDateTime dateSold = updatedSale.dateSold.isEmpty() ? null : OffsetDateTime.parse(updatedSale.dateSold);
            pstmt.setInt(1, updatedSale.price);
            pstmt.setObject(2, dateSold, Types.TIMESTAMP_WITH_TIMEZONE);
            pstmt.setInt(3, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }

    void deleteSale(String id){
        String query = "DELETE FROM sale WHERE id_sale =? ";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(id));
            pstmt.executeUpdate();
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }

    void createSale(Sale sale){
        String query = "INSERT INTO sale (object_id, price) VALUES (?,?)";
        try(PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, sale.objectId);
            pstmt.setInt(2, sale.price);
            pstmt.executeUpdate();
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }
}
