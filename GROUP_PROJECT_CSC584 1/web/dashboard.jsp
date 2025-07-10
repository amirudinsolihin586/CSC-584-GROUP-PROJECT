<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Order, model.Booking, java.util.*" %>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - ICSMS</title>

    <script src="https://cdn.jsdelivr.net/npm/particles.js@2.0.0/particles.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @font-face {
            font-family: 'Poppins';
            src: url('fonts/Poppins-Regular.ttf') format('truetype');
        }

        :root {
            --p: 0%;
            --t: 0s;
        }

        body {
            margin: 0;
            padding: 0;
            font-family: 'Poppins', sans-serif;
            overflow-x: hidden;
            background: #0d47a1;
        }

        #particles-js {
            position: fixed;
            width: 100%;
            height: 100%;
            z-index: -1;
            top: 0;
            left: 0;
        }

        .navbar {
            background-color: #007BFF;
            padding: 15px 30px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar .logo {
            display: flex;
            align-items: center;
        }

        .navbar .logo img {
            height: 40px;
            margin-right: 10px;
        }

        .navbar .nav-links a {
            font-family: 'Poppins', sans-serif;
            font-weight: 600;
            font-size: 14px;
            margin-left: 20px;
            text-decoration: none;
            padding: 10px 18px;
            border-radius: 8px;
            color: white;
            border: 2px solid #00f0ff;
            background: linear-gradient(#00f0ff 0 0) no-repeat calc(200% - var(--p)) 100% / 200% var(--p);
            transition: 0.3s var(--t), background-position 0.3s calc(0.3s - var(--t));
        }

        .navbar .nav-links a:hover {
            --p: 100%;
            --t: 0.3s;
            color: #fff;
        }

        .container {
            background: rgba(255, 255, 255, 0.15);
            border-radius: 16px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            padding: 40px;
            margin: 40px auto;
            width: 90%;
            max-width: 1100px;
            color: #000;
            animation: fadeIn 1s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        h2, h3 {
            color: #ffffff;
            text-shadow: 1px 1px 2px #000;
        }

        h2 {
            text-align: center;
            font-size: 28px;
        }

        .liquid-button {
            padding: 12px 24px;
            font-size: 14px;
            font-weight: 600;
            color: white;
            background: none;
            border: 2px solid #00f0ff;
            border-radius: 8px;
            cursor: pointer;
            background: linear-gradient(#00f0ff 0 0) no-repeat calc(200% - var(--p)) 100% / 200% var(--p);
            transition: 0.3s var(--t), background-position 0.3s calc(0.3s - var(--t));
            text-decoration: none;
            display: inline-block;
        }

        .liquid-button:hover {
            --p: 100%;
            --t: 0.3s;
            color: #fff;
        }

        .button-row {
            text-align: center;
            margin: 25px 0;
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 15px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            background-color: rgba(255, 255, 255, 0.8);
            border-radius: 10px;
            overflow: hidden;
        }

        th, td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #ccc;
        }

        th {
            background-color: #007BFF;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        tr:hover {
            background-color: #e6f0ff;
        }

        hr {
            margin: 40px 0 20px 0;
            border: none;
            border-top: 2px solid #ccc;
        }
    </style>
</head>
<body>

<div id="particles-js"></div>

<div class="navbar">
    <div class="logo">
        <img src="images/logo.png" alt="ICSMS Logo">
        <span><strong>ICSMS Dashboard</strong></span>
    </div>
    <div class="nav-links">
        <a href="DashboardServlet"><i class="fa fa-home"></i> Home</a>
        <a href="LogoutServlet"><i class="fa fa-sign-out-alt"></i> Logout</a>
    </div>
</div>

<div class="container">
    <h2>Welcome, <%= username %>!</h2>

    <div class="button-row">
        <% if ("admin".equalsIgnoreCase(username)) { %>
            <a href="AdminServlet" class="liquid-button"><i class="fa fa-cogs"></i> Admin Dashboard</a>
            <a href="StockServlet" class="liquid-button"><i class="fa fa-box-open"></i> Manage Stock</a>
        <% } %>

        <form action="OrderServlet" method="get" style="display:inline;">
            <button type="submit" class="liquid-button">Order Supplies</button>
        </form>
        <form action="BookingServlet" method="get" style="display:inline;">
            <button type="submit" class="liquid-button">Book Supplies</button>
        </form>
    </div>

    <hr>

    <h3>📦 Recent Orders</h3>
    <table>
        <tr>
            <th>No</th><th>Username</th><th>Item</th><th>Qty</th><th>Status</th><th>Location</th><th>Date</th>
        </tr>
        <%
            List<Order> orders = (List<Order>) request.getAttribute("orders");
            int orderRow = 1;
            if (orders != null && !orders.isEmpty()) {
                for (Order o : orders) {
        %>
        <tr>
            <td><%= orderRow++ %></td>
            <td><%= o.getUsername() %></td>
            <td><%= o.getItemName() %></td>
            <td><%= o.getQuantity() %></td>
            <td><%= o.getStatus() %></td>
            <td><%= o.getLocation() %></td>
            <td><%= o.getOrderDate() %></td>
        </tr>
        <%
                }
            } else {
        %>
        <tr><td colspan="7">No orders found.</td></tr>
        <%
            }
        %>
    </table>

    <hr>

    <h3>📝 Recent Bookings</h3>
    <table>
        <tr>
            <th>No</th><th>Username</th><th>Item</th><th>Quantity</th><th>Status</th><th>Date</th>
        </tr>
        <%
            List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
            int bookingRow = 1;
            if (bookings != null && !bookings.isEmpty()) {
                for (Booking b : bookings) {
        %>
        <tr>
            <td><%= bookingRow++ %></td>
            <td><%= b.getUsername() %></td>
            <td><%= b.getSupplyType() %></td>
            <td><%= b.getQuantity() %></td>
            <td><%= b.getStatus() %></td>
            <td><%= b.getBookingDate() %></td>
        </tr>
        <%
                }
            } else {
        %>
        <tr><td colspan="6">No bookings found.</td></tr>
        <%
            }
        %>
    </table>
</div>

<script>
    particlesJS("particles-js", {
        "particles": {
            "number": { "value": 60, "density": { "enable": true, "value_area": 800 } },
            "color": { "value": "#ffffff" },
            "shape": { "type": "circle" },
            "opacity": { "value": 0.5 },
            "size": { "value": 3 },
            "move": { "enable": true, "speed": 2 }
        },
        "interactivity": {
            "events": {
                "onhover": { "enable": true, "mode": "repulse" }
            }
        }
    });
</script>

</body>
</html>
