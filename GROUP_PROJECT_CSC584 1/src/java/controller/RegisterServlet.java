package controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/GROUP_PROJECT", "app", "app");

            // Check if the username already exists
            PreparedStatement checkStmt = conn.prepareStatement(
                "SELECT * FROM users WHERE username = ?");
            checkStmt.setString(1, username);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                // Username already exists
                request.setAttribute("error", "Registration failed. Username already exists.");
                rs.close();
                checkStmt.close();
                conn.close();
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Insert the new user
            PreparedStatement insertStmt = conn.prepareStatement(
                "INSERT INTO users (username, password) VALUES (?, ?)");
            insertStmt.setString(1, username);
            insertStmt.setString(2, password);
            insertStmt.executeUpdate();

            // Clean up
            insertStmt.close();
            conn.close();

            // Redirect to login
            response.sendRedirect("login.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error. Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
