package controller;

import model.Stock;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/StockServlet")
public class StockServlet extends HttpServlet {

    private Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        return DriverManager.getConnection(
            "jdbc:derby://localhost:1527/GROUP_PROJECT", "app", "app");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        List<Stock> stockList = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM STOCKS ORDER BY ID");
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Stock s = new Stock();
                s.setId(rs.getInt("ID"));
                s.setItemName(rs.getString("ITEM_NAME"));
                s.setCategory(rs.getString("CATEGORY"));
                s.setQuantity(rs.getInt("QUANTITY"));
                s.setLocation(rs.getString("LOCATION"));
                stockList.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("stocks", stockList);
        RequestDispatcher rd = request.getRequestDispatcher("stock.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        String action = request.getParameter("action");

        try (Connection conn = getConnection()) {
            if ("add".equals(action)) {
                String itemName = request.getParameter("itemName");
                String category = request.getParameter("category");
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                String location = request.getParameter("location");

                String sql = "INSERT INTO STOCKS (ITEM_NAME, CATEGORY, QUANTITY, LOCATION) VALUES (?, ?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, itemName);
                ps.setString(2, category);
                ps.setInt(3, quantity);
                ps.setString(4, location);
                ps.executeUpdate();

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String itemName = request.getParameter("itemName");
                String category = request.getParameter("category");
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                String location = request.getParameter("location");

                String sql = "UPDATE STOCKS SET ITEM_NAME=?, CATEGORY=?, QUANTITY=?, LOCATION=? WHERE ID=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, itemName);
                ps.setString(2, category);
                ps.setInt(3, quantity);
                ps.setString(4, location);
                ps.setInt(5, id);
                ps.executeUpdate();

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String sql = "DELETE FROM STOCKS WHERE ID=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, id);
                ps.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("StockServlet"); // Refresh the stock list
    }
}
