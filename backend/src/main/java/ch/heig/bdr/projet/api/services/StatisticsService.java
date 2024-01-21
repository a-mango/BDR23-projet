package ch.heig.bdr.projet.api.services;

import ch.heig.bdr.projet.api.PostgresConnection;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

public class StatisticsService {
    enum GraphType { Bar, Pie, Line, None }

    private final Connection conn;

    public StatisticsService() {
        conn = PostgresConnection.getInstance().getConnection();
    }

public HashMap<String, Object> getStatistics() {
    var statistics = new HashMap<String, Object>();
    statistics.put("employeesPerType", Map.of("name", "Employees per role", "type", GraphType.Bar, "data", employeesPerType()));
    statistics.put("ongoingRepairCount", Map.of("name", "Ongoing Repair Count", "type", GraphType.Bar, "data", ongoingRepairCount()));
    statistics.put("ongoingRepairsPerCategory", Map.of("name", "Ongoing Repairs Per Category", "type", GraphType.Bar, "data", ongoingRepairsPerCategory()));
    statistics.put("finishedRepairs", Map.of("name", "Finished Repairs", "type", GraphType.Bar, "data", finishedRepairs()));
    statistics.put("finishedRepairsPerCategory", Map.of("name", "Finished Repairs Per Category", "type", GraphType.Bar, "data", finishedRepairsPerCategory()));
    statistics.put("objectsForSale", Map.of("name", "Objects For Sale", "type", GraphType.Bar, "data", objectsForSale()));
    statistics.put("soldObjects", Map.of("name", "Sold Objects", "type", GraphType.Bar, "data", soldObjects()));
    statistics.put("objectsPerCategory", Map.of("name", "Objects Per Category", "type", GraphType.Bar, "data", objectsPerCategory()));
    statistics.put("objectsPerBrand", Map.of("name", "Objects Per Brand", "type", GraphType.Bar, "data", objectsPerBrand()));
    statistics.put("hoursWorkedPerSpecialisation", Map.of("name", "Hours Worked Per Specialisation", "type", GraphType.Bar, "data", hoursWorkedPerSpecialisation()));
    statistics.put("repairsPerMonth", Map.of("name", "Repairs Per Month", "type", GraphType.Bar, "data", repairsPerMonth()));
    statistics.put("repairsCreatedPerReceptionist", Map.of("name", "Repairs Created Per Receptionist", "type", GraphType.Bar, "data", repairsCreatedPerReceptionist()));
    statistics.put("receptionistsPerLanguage", Map.of("name", "Receptionists Per Language", "type", GraphType.Bar, "data", receptionistsPerLanguage()));
//    statistics.put("smsReceivedPerDay", Map.of("name", "SMS Received Per Day", "type", GraphType.Bar, "data", smsReceivedPerDay()));
//    statistics.put("smsSentPerDay", Map.of("name", "SMS Sent Per Day", "type", GraphType.Bar, "data", smsSentPerDay()));
    return statistics;
}

    private HashMap<String, Integer> employeesPerType() {
        final String query = """
                SELECT 'Manager' AS role,
                       COUNT(*)  AS nb_employees
                FROM manager
                UNION ALL
                SELECT 'Technician' AS role,
                       COUNT(*)     AS nb_employees
                FROM technician
                UNION ALL
                SELECT 'Receptionist' AS role,
                       COUNT(*)       AS nb_employees
                FROM receptionist;
                """;
        try (Statement statement = conn.createStatement(); ResultSet rs = statement.executeQuery(query)) {
            HashMap<String, Integer> employeesPerType = new HashMap<>();
            while (rs.next()) {
                employeesPerType.put(rs.getString("role"), rs.getInt("nb_employees"));
            }
            return employeesPerType;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    private Integer ongoingRepairCount() {
        final String query = """
                SELECT COUNT(*) AS nb_ongoing_rep
                FROM reparation
                WHERE reparation_state = 'ongoing'::reparation_state;
                """;
        try (Statement statement = conn.createStatement(); ResultSet rs = statement.executeQuery(query)) {
            int ongoingRepairCount = 0;
            while (rs.next()) {
                ongoingRepairCount = rs.getInt("nb_ongoing_rep");
            }
            return ongoingRepairCount;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    private HashMap<String, Integer> ongoingRepairsPerCategory() {
        final String query = """
                SELECT o.category, COUNT(*) nb_ongoing_rep_per_cat
                FROM reparation r
                         INNER JOIN object o
                                    ON r.object_id = o.object_id
                WHERE r.reparation_state = 'ongoing'::reparation_state
                GROUP BY o.category
                ORDER BY nb_ongoing_rep_per_cat DESC;
                """;
        try (Statement statement = conn.createStatement(); ResultSet rs = statement.executeQuery(query)) {
            HashMap<String, Integer> ongoingRepairsPerCategory = new HashMap<>();
            while (rs.next()) {
                ongoingRepairsPerCategory.put(rs.getString("category"), rs.getInt("nb_ongoing_rep_per_cat"));
            }
            return ongoingRepairsPerCategory;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    private Integer finishedRepairs() {
        final String query = """
                SELECT COUNT(*) AS nb_done_rep
                FROM reparation
                WHERE reparation_state = 'done'::reparation_state;
                """;
        try (Statement statement = conn.createStatement(); ResultSet rs = statement.executeQuery(query)) {
            int finishedRepairs = 0;
            while (rs.next()) {
                finishedRepairs = rs.getInt("nb_done_rep");
            }
            return finishedRepairs;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    private HashMap<String, Integer> finishedRepairsPerCategory() {
        final String query = """
                SELECT o.category, COUNT(*) AS nb_done_rep_per_cat
                FROM reparation r
                         INNER JOIN object o
                                    ON r.object_id = o.object_id
                WHERE reparation_state = 'done'::reparation_state
                GROUP BY o.category
                ORDER BY nb_done_rep_per_cat DESC;
                """;
        try (Statement statement = conn.createStatement(); ResultSet rs = statement.executeQuery(query)) {
            HashMap<String, Integer> finishedRepairsPerCategory = new HashMap<>();
            while (rs.next()) {
                finishedRepairsPerCategory.put(rs.getString("category"), rs.getInt("nb_done_rep_per_cat"));
            }
            return finishedRepairsPerCategory;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    private Integer objectsForSale() {
        final String query = """
                SELECT COUNT(*) AS nb_forsale_obj
                FROM object
                WHERE location = 'for_sale'::location;
                """;
        try (Statement statement = conn.createStatement(); ResultSet rs = statement.executeQuery(query)) {
            int objectsForSale = 0;
            while (rs.next()) {
                objectsForSale = rs.getInt("nb_forsale_obj");
            }
            return objectsForSale;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    private Integer soldObjects() {
        final String query = """
                SELECT COUNT(*) AS nb_sold_obj
                FROM object
                WHERE location = 'sold'::location;
                """;
        try (Statement statement = conn.createStatement(); ResultSet rs = statement.executeQuery(query)) {
            int soldObjects = 0;
            while (rs.next()) {
                soldObjects = rs.getInt("nb_sold_obj");
            }
            return soldObjects;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    private HashMap<String, Integer> objectsPerCategory() {
        final String query = """
                SELECT category, COUNT(*) AS nb_obj_per_cat
                FROM object
                GROUP BY category
                ORDER BY nb_obj_per_cat DESC;
                """;
        try (Statement statement = conn.createStatement(); ResultSet rs = statement.executeQuery(query)) {
            HashMap<String, Integer> objectsPerCategory = new HashMap<>();
            while (rs.next()) {
                objectsPerCategory.put(rs.getString("category"), rs.getInt("nb_obj_per_cat"));
            }
            return objectsPerCategory;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    private HashMap<String, Integer> objectsPerBrand() {
        final String query = """
                SELECT brand, COUNT(*) AS nb_obj_per_brand
                FROM object
                GROUP BY brand
                ORDER BY nb_obj_per_brand DESC;
                """;
        try (Statement statement = conn.createStatement(); ResultSet rs = statement.executeQuery(query)) {
            HashMap<String, Integer> objectsPerBrand = new HashMap<>();
            while (rs.next()) {
                objectsPerBrand.put(rs.getString("brand"), rs.getInt("nb_obj_per_brand"));
            }
            return objectsPerBrand;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    private HashMap<String, Integer> hoursWorkedPerSpecialisation() {
        final String query = """
                SELECT sr.spec_name, ((CAST(SUM(EXTRACT(EPOCH FROM tr.time_worked)) AS DECIMAL)) / 360) AS total_worked_time_hours
                FROM technician_reparation tr
                         INNER JOIN specialization_reparation sr
                                    ON sr.reparation_id = tr.reparation_id
                GROUP BY sr.spec_name;
                """;
        try (Statement statement = conn.createStatement(); ResultSet rs = statement.executeQuery(query)) {
            HashMap<String, Integer> hoursWorkedPerSpecialisation = new HashMap<>();
            while (rs.next()) {
                hoursWorkedPerSpecialisation.put(rs.getString("spec_name"), rs.getInt("total_worked_time_hours"));
            }
            return hoursWorkedPerSpecialisation;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    private HashMap<String, Integer> repairsPerMonth() {
        final String query = """
                SELECT date_trunc('month', date_created) AS DATE, COUNT(*) AS nb_rep_per_month
                FROM reparation
                GROUP BY DATE
                ORDER BY DATE DESC;
                """;
        try (Statement statement = conn.createStatement(); ResultSet rs = statement.executeQuery(query)) {
            HashMap<String, Integer> repairsPerMonth = new HashMap<>();
            while (rs.next()) {
                repairsPerMonth.put(rs.getString("date"), rs.getInt("nb_rep_per_month"));
            }
            return repairsPerMonth;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    private HashMap<String, Integer> repairsCreatedPerReceptionist() {
        final String query = """
                SELECT p.name, COUNT(*) AS nb_rep_per_recept
                FROM reparation r
                        INNER JOIN receptionist re
                                ON r.receptionist_id = re.receptionist_id
                        INNER JOIN person p
                                ON re.receptionist_id = p.person_id
                GROUP BY p.name;
                """;
        try (Statement statement = conn.createStatement(); ResultSet rs = statement.executeQuery(query)) {
            HashMap<String, Integer> repairsCreatedPerReceptionist = new HashMap<>();
            while (rs.next()) {
                repairsCreatedPerReceptionist.put(rs.getString("name"), rs.getInt("nb_rep_per_recept"));
            }
            return repairsCreatedPerReceptionist;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    private HashMap<String, Integer> receptionistsPerLanguage() {
        final String query = """
                SELECT LANGUAGE, COUNT(*) AS nb_recept_per_lang
                FROM receptionist_language
                GROUP BY LANGUAGE
                ORDER BY nb_recept_per_lang DESC;
                """;
        try (Statement statement = conn.createStatement(); ResultSet rs = statement.executeQuery(query)) {
            HashMap<String, Integer> receptionistsPerLanguage = new HashMap<>();
            while (rs.next()) {
                receptionistsPerLanguage.put(rs.getString("language"), rs.getInt("nb_recept_per_lang"));
            }
            return receptionistsPerLanguage;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    private HashMap<String, Integer> smsReceivedPerDay() {
        final String query = """
                SELECT date_trunc('day', date_created) AS date, COUNT(*) AS nb_rec_sms_per_day
                FROM sms
                WHERE processing_state = 'received'::processing_state
                GROUP BY date
                ORDER BY date DESC;
                """;
        try (Statement statement = conn.createStatement(); ResultSet rs = statement.executeQuery(query)) {
            HashMap<String, Integer> smsReceivedPerDay = new HashMap<>();
            while (rs.next()) {
                smsReceivedPerDay.put(rs.getString("date"), rs.getInt("nb_rec_sms_per_day"));
            }
            return smsReceivedPerDay;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    private HashMap<String, Integer> smsSentPerDay() {
        final String query = """
                SELECT date_trunc('day', date_created) AS date, COUNT(*) AS nb_sent_sms_per_day
                FROM sms
                WHERE processing_state = 'processed'::processing_state
                GROUP BY date
                ORDER BY date DESC;
                """;
        try (Statement statement = conn.createStatement(); ResultSet rs = statement.executeQuery(query)) {
            HashMap<String, Integer> smsSentPerDay = new HashMap<>();
            while (rs.next()) {
                smsSentPerDay.put(rs.getString("category"), rs.getInt("nb_sent_sms_per_day"));
            }
            return smsSentPerDay;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return null;
        }
    }
}
