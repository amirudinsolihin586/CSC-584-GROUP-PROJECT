package controller;

import model.Order;
import model.Stock;
import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class OrderServlet extends HttpServlet {

    private Connection getConnection() throws Exception {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        return DriverManager.getConnection(
            "jdbc:derby://localhost:1527/GROUP_PROJECT", "app", "app");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            try (Connection conn = getConnection()) {
                String itemName = request.getParameter("itemName");
                int quantity = Integer.parseInt(request.getParameter("quantity"));

                PreparedStatement checkStock = conn.prepareStatement(
                    "SELECT QUANTITY FROM STOCKS WHERE ITEM_NAME=?");
                checkStock.setString(1, itemName);
                ResultSet rs = checkStock.executeQuery();

                if (rs.next()) {
                    int available = rs.getInt("QUANTITY");

                    if (available >= quantity) {
                        PreparedStatement ps = conn.prepareStatement(
                            "INSERT INTO orders (username, item_name, quantity, status, order_date, location) VALUES (?, ?, ?, ?, ?, ?)");
                        ps.setString(1, request.getParameter("username"));
                        ps.setString(2, itemName);
                        ps.setInt(3, quantity);
                        ps.setString(4, request.getParameter("status"));
                        ps.setDate(5, java.sql.Date.valueOf(request.getParameter("orderDate")));
                        ps.setString(6, request.getParameter("location"));
                        ps.executeUpdate();

                        PreparedStatement reduceStock = conn.prepareStatement(
                            "UPDATE STOCKS SET QUANTITY = QUANTITY - ? WHERE ITEM_NAME = ?");
                        reduceStock.setInt(1, quantity);
                        reduceStock.setString(2, itemName);
                        reduceStock.executeUpdate();
                    } else {
                        request.setAttribute("error", "Not enough stock for " + itemName + ". Available: " + available);
                        doGet(request, response);
                        return;
                    }
                }

            } catch (Exception e) {
                e.printStackTrace();
            }

        } else if ("update".equals(action)) {
            try (Connection conn = getConnection()) {
                int orderId = Integer.parseInt(request.getParameter("id"));
                String newItemName = request.getParameter("itemName");
                int newQty = Integer.parseInt(request.getParameter("quantity"));
                String location = request.getParameter("location");

                // Get old item and quantity
                PreparedStatement getOrder = conn.prepareStatement("SELECT item_name, quantity FROM orders WHERE id=?");
                getOrder.setInt(1, orderId);
                ResultSet rsOrder = getOrder.executeQuery();

                if (rsOrder.next()) {
                    String oldItem = rsOrder.getString("item_name");
                    int oldQty = rsOrder.getInt("quantity");

                    boolean itemChanged = !oldItem.equals(newItemName);
                    int qtyDifference = newQty - oldQty;

                    if (itemChanged) {
                        // New item selected → check new stock availability
                        PreparedStatement checkNewStock = conn.prepareStatement("SELECT quantity FROM stocks WHERE item_name=?");
                        checkNewStock.setString(1, newItemName);
                        ResultSet rsNewStock = checkNewStock.executeQuery();

                        if (rsNewStock.next()) {
                            int newItemStock = rsNewStock.getInt("quantity");

                            if (newQty <= newItemStock) {
                                // Update order with new item & reduce new stock
                                PreparedStatement updateOrder = conn.prepareStatement(
                                    "UPDATE orders SET item_name=?, quantity=?, status=?, order_date=?, location=? WHERE id=?");
                                updateOrder.setString(1, newItemName);
                                updateOrder.setInt(2, newQty);
                                updateOrder.setString(3, request.getParameter("status"));
                                updateOrder.setDate(4, java.sql.Date.valueOf(request.getParameter("orderDate")));
                                updateOrder.setString(5, location);
                                updateOrder.setInt(6, orderId);
                                updateOrder.executeUpdate();

                                // Return stock to old item
                                PreparedStatement returnOldStock = conn.prepareStatement(
                                    "UPDATE stocks SET quantity = quantity + ? WHERE item_name = ?");
                                returnOldStock.setInt(1, oldQty);
                                returnOldStock.setString(2, oldItem);
                                returnOldStock.executeUpdate();

                                // Reduce stock from new item
                                PreparedStatement reduceNewStock = conn.prepareStatement(
                                    "UPDATE stocks SET quantity = quantity - ? WHERE item_name = ?");
                                reduceNewStock.setInt(1, newQty);
                                reduceNewStock.setString(2, newItemName);
                                reduceNewStock.executeUpdate();
                            } else {
                                // Not enough new stock
                                request.setAttribute("error", "Not enough stock for " + newItemName + ". Only " + newItemStock + " left.");
                                doGet(request, response);
                                return;
                            }
                        }

                    } else {
                        // Same item, only quantity changed
                        if (qtyDifference > 0) {
                            // Check stock for increase
                            PreparedStatement checkStock = conn.prepareStatement("SELECT quantity FROM stocks WHERE item_name=?");
                            checkStock.setString(1, newItemName);
                            ResultSet rsStock = checkStock.executeQuery();

                            if (rsStock.next()) {
                                int stockQty = rsStock.getInt("quantity");

                                if (stockQty >= qtyDifference) {
                                    // Update order and reduce stock
                                    PreparedStatement updateOrder = conn.prepareStatement(
                                        "UPDATE orders SET item_name=?, quantity=?, status=?, order_date=?, location=? WHERE id=?");
                                    updateOrder.setString(1, newItemName);
                                    updateOrder.setInt(2, newQty);
                                    updateOrder.setString(3, request.getParameter("status"));
                                    updateOrder.setDate(4, java.sql.Date.valueOf(request.getParameter("orderDate")));
                                    updateOrder.setString(5, location);
                                    updateOrder.setInt(6, orderId);
                                    updateOrder.executeUpdate();

                                    PreparedStatement reduceStock = conn.prepareStatement(
                                        "UPDATE stocks SET quantity = quantity - ? WHERE item_name=?");
                                    reduceStock.setInt(1, qtyDifference);
                                    reduceStock.setString(2, newItemName);
                                    reduceStock.executeUpdate();
                                } else {
                                    request.setAttribute("error", "Not enough stock. Available: " + stockQty);
                                    doGet(request, response);
                                    return;
                                }
                            }

                        } else if (qtyDifference < 0) {
                            // Returning stock
                            PreparedStatement updateOrder = conn.prepareStatement(
                                "UPDATE orders SET item_name=?, quantity=?, status=?, order_date=?, location=? WHERE id=?");
                            updateOrder.setString(1, newItemName);
                            updateOrder.setInt(2, newQty);
                            updateOrder.setString(3, request.getParameter("status"));
                            updateOrder.setDate(4, java.sql.Date.valueOf(request.getParameter("orderDate")));
                            updateOrder.setString(5, location);
                            updateOrder.setInt(6, orderId);
                            updateOrder.executeUpdate();

                            PreparedStatement returnStock = conn.prepareStatement(
                                "UPDATE stocks SET quantity = quantity + ? WHERE item_name=?");
                            returnStock.setInt(1, -qtyDifference);
                            returnStock.setString(2, newItemName);
                            returnStock.executeUpdate();

                        } else {
                            // Only other fields updated
                            PreparedStatement updateOrder = conn.prepareStatement(
                                "UPDATE orders SET item_name=?, quantity=?, status=?, order_date=?, location=? WHERE id=?");
                            updateOrder.setString(1, newItemName);
                            updateOrder.setInt(2, newQty);
                            updateOrder.setString(3, request.getParameter("status"));
                            updateOrder.setDate(4, java.sql.Date.valueOf(request.getParameter("orderDate")));
                            updateOrder.setString(5, location);
                            updateOrder.setInt(6, orderId);
                            updateOrder.executeUpdate();
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

        } else if ("delete".equals(action)) {
            try (Connection conn = getConnection()) {
                int orderId = Integer.parseInt(request.getParameter("id"));

                // Restore stock before deleting order
                PreparedStatement getOrder = conn.prepareStatement("SELECT item_name, quantity FROM orders WHERE id=?");
                getOrder.setInt(1, orderId);
                ResultSet rs = getOrder.executeQuery();

                if (rs.next()) {
                    String itemName = rs.getString("item_name");
                    int quantity = rs.getInt("quantity");

                    PreparedStatement restoreStock = conn.prepareStatement(
                        "UPDATE stocks SET quantity = quantity + ? WHERE item_name=?");
                    restoreStock.setInt(1, quantity);
                    restoreStock.setString(2, itemName);
                    restoreStock.executeUpdate();
                }

                // Delete the order
                PreparedStatement ps = conn.prepareStatement("DELETE FROM orders WHERE id=?");
                ps.setInt(1, orderId);
                ps.executeUpdate();

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect("OrderServlet");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Order> orders = new ArrayList<>();
        List<Stock> availableStock = new ArrayList<>();

        try (Connection conn = getConnection()) {
            Statement stmt = conn.createStatement();
            String username = (String) request.getSession().getAttribute("username");
            PreparedStatement ps;
            if ("admin".equalsIgnoreCase(username)) {
                ps = conn.prepareStatement("SELECT * FROM ORDERS"); // or BOOKINGS
            } else {
                ps = conn.prepareStatement("SELECT * FROM ORDERS WHERE USERNAME = ?");
                ps.setString(1, username);
            }
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order o = new Order(
                    rs.getInt("ID"),
                    rs.getString("USERNAME"),
                    rs.getString("ITEM_NAME"),
                    rs.getInt("QUANTITY"),
                    rs.getString("STATUS"),
                    rs.getDate("ORDER_DATE").toString(),
                    rs.getString("LOCATION")
                );
                orders.add(o);
            }

            PreparedStatement ps2 = conn.prepareStatement("SELECT * FROM STOCKS WHERE QUANTITY > 0");
            ResultSet stockRs = ps2.executeQuery();
            while (stockRs.next()) {
                Stock s = new Stock();
                s.setId(stockRs.getInt("ID"));
                s.setItemName(stockRs.getString("ITEM_NAME"));
                s.setCategory(stockRs.getString("CATEGORY"));
                s.setQuantity(stockRs.getInt("QUANTITY"));
                s.setLocation(stockRs.getString("LOCATION"));
                availableStock.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("orders", orders);
        request.setAttribute("availableStock", availableStock);
        RequestDispatcher rd = request.getRequestDispatcher("order.jsp");
        rd.forward(request, response);
    }
}