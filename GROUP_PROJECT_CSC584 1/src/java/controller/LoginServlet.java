package controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String userType = request.getParameter("userType"); // "user" or "admin"

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:derby://localhost:1527/GROUP_PROJECT", "app", "app");

            PreparedStatement ps = conn.prepareStatement(
                    "SELECT * FROM users WHERE username=? AND password=?");

            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                boolean isAdminLogin = "admin".equalsIgnoreCase(userType);
                boolean isAdminUser = "admin".equalsIgnoreCase(username);

                if (isAdminLogin && !isAdminUser) {
                    // User trying to log in as admin
                    request.setAttribute("error", "Only admin can log in as admin.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }

                if (!isAdminLogin && isAdminUser) {
                    // Admin trying to log in as user
                    request.setAttribute("error", "Admin must log in as admin.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }

                //Valid role and credentials
                HttpSession session = request.getSession();
                session.setAttribute("username", username);

                if (isAdminUser) {
                    response.sendRedirect("AdminServlet");
                } else {
                    response.sendRedirect("DashboardServlet");
                }

            } else {
                // Invalid login
                request.setAttribute("error", "Invalid username or password.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error occurred.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
