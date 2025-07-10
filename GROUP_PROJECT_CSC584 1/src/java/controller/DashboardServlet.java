package controller;

import model.Order;
import model.Booking;
import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class DashboardServlet extends HttpServlet {

    private Connection getConnection() throws Exception {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        return DriverManager.getConnection(
            "jdbc:derby://localhost:1527/GROUP_PROJECT", "app", "app");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String username = (session != null) ? (String) session.getAttribute("username") : null;
        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Order> orders = new ArrayList<>();
        List<Booking> bookings = new ArrayList<>();

        try (Connection conn = getConnection()) {

            // Get only user's orders (unless admin)
            PreparedStatement ps1;
            if ("admin".equalsIgnoreCase(username)) {
                ps1 = conn.prepareStatement("SELECT * FROM ORDERS");
            } else {
                ps1 = conn.prepareStatement("SELECT * FROM ORDERS WHERE USERNAME = ?");
                ps1.setString(1, username);
            }

            ResultSet rs1 = ps1.executeQuery();
            while (rs1.next()) {
                orders.add(new Order(
                    rs1.getInt("ID"),
                    rs1.getString("USERNAME"),
                    rs1.getString("ITEM_NAME"),
                    rs1.getInt("QUANTITY"),
                    rs1.getString("STATUS"),
                    rs1.getDate("ORDER_DATE").toString(),
                    rs1.getString("LOCATION")
                ));
            }

            // Get only user's bookings (unless admin)
            PreparedStatement ps2;
            if ("admin".equalsIgnoreCase(username)) {
                ps2 = conn.prepareStatement("SELECT * FROM BOOKINGS");
            } else {
                ps2 = conn.prepareStatement("SELECT * FROM BOOKINGS WHERE USERNAME = ?");
                ps2.setString(1, username);
            }

            ResultSet rs2 = ps2.executeQuery();
            while (rs2.next()) {
                bookings.add(new Booking(
                    rs2.getInt("ID"),
                    rs2.getString("USERNAME"),
                    rs2.getString("SUPPLY_TYPE"),
                    rs2.getInt("QUANTITY"),
                    rs2.getString("STATUS"),
                    rs2.getDate("BOOKING_DATE").toString()
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("orders", orders);
        request.setAttribute("bookings", bookings);

        RequestDispatcher rd = request.getRequestDispatcher("dashboard.jsp");
        rd.forward(request, response);
    }
}
