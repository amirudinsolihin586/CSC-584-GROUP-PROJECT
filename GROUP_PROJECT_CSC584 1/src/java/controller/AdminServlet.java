package controller;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {

    private Connection getConnection() throws Exception {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        return DriverManager.getConnection(
            "jdbc:derby://localhost:1527/GROUP_PROJECT", "app", "app");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null || !"admin".equalsIgnoreCase(username)) {
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection conn = getConnection()) {
            int totalUsers = getCount(conn, "USERS");
            int totalOrders = getCount(conn, "ORDERS");
            int totalBookings = getCount(conn, "BOOKINGS");
            int totalStocks = getCount(conn, "STOCKS");

            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("totalStocks", totalStocks);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error retrieving admin data.");
        }

        RequestDispatcher rd = request.getRequestDispatcher("admin.jsp");
        rd.forward(request, response);
    }

    private int getCount(Connection conn, String tableName) throws SQLException {
        String sql = "SELECT COUNT(*) FROM " + tableName;
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
}
