package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseConnection {

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/YourDatabaseName", "yourUsername", "yourPassword"
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }
}
