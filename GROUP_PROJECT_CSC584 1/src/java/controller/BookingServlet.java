package controller;

import model.Booking;
import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class BookingServlet extends HttpServlet {

    private Connection getConnection() throws Exception {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        return DriverManager.getConnection(
            "jdbc:derby://localhost:1527/GROUP_PROJECT", "app", "app");
    }

    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String action = request.getParameter("action");

        try (Connection conn = getConnection()) {
            if ("add".equals(action)) {
                PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO BOOKINGS (USERNAME, SUPPLY_TYPE, QUANTITY, STATUS, BOOKING_DATE) VALUES (?, ?, ?, ?, ?)");
                ps.setString(1, request.getParameter("username"));
                ps.setString(2, request.getParameter("supplyType"));
                ps.setInt(3, Integer.parseInt(request.getParameter("quantity"))); 
                ps.setString(4, request.getParameter("status"));
                ps.setDate(5, java.sql.Date.valueOf(request.getParameter("bookingDate")));
                ps.executeUpdate();

            } else if ("update".equals(action)) {
                PreparedStatement ps = conn.prepareStatement(
                    "UPDATE BOOKINGS SET SUPPLY_TYPE=?, QUANTITY=?, STATUS=?, BOOKING_DATE=? WHERE ID=?");
                ps.setString(1, request.getParameter("supplyType"));
                ps.setInt(2, Integer.parseInt(request.getParameter("quantity")));
                ps.setString(3, request.getParameter("status"));
                ps.setDate(4, java.sql.Date.valueOf(request.getParameter("bookingDate")));
                ps.setInt(5, Integer.parseInt(request.getParameter("id")));
                ps.executeUpdate();

            } else if ("delete".equals(action)) {
                PreparedStatement ps = conn.prepareStatement("DELETE FROM BOOKINGS WHERE ID=?");
                ps.setInt(1, Integer.parseInt(request.getParameter("id")));
                ps.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("BookingServlet");
    }

    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        List<Booking> bookings = new ArrayList<>();
        HttpSession session = request.getSession(false);
        String username = (session != null) ? (String) session.getAttribute("username") : null;

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection conn = getConnection()) {
            PreparedStatement ps;

            if ("admin".equalsIgnoreCase(username)) {
                ps = conn.prepareStatement("SELECT * FROM BOOKINGS");
            } else {
                ps = conn.prepareStatement("SELECT * FROM BOOKINGS WHERE USERNAME = ?");
                ps.setString(1, username);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Booking b = new Booking(
                    rs.getInt("ID"),
                    rs.getString("USERNAME"),
                    rs.getString("SUPPLY_TYPE"),
                    rs.getInt("QUANTITY"),
                    rs.getString("STATUS"),
                    rs.getDate("BOOKING_DATE").toString()
                );
                bookings.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("bookings", bookings);
        RequestDispatcher rd = request.getRequestDispatcher("booking.jsp");
        rd.forward(request, response);
    }
}
