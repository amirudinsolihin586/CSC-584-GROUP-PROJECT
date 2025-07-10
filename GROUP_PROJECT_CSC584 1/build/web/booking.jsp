<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Booking" %>
<%@ page import="java.util.*" %>

<%
    String sessionUsername = (String) session.getAttribute("username");
    boolean isAdmin = "admin".equalsIgnoreCase(sessionUsername);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Booking Supplies - ICSMS</title>
    <script src="https://cdn.jsdelivr.net/npm/particles.js@2.0.0/particles.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @font-face {
            font-family: 'Poppins';
            src: url('fonts/Poppins-Regular.ttf') format('truetype');
        }

        body {
            margin: 0;
            padding: 0;
            font-family: 'Poppins', sans-serif;
            background-color: #0d47a1;
            overflow-x: hidden;
        }

        #particles-js {
            position: fixed;
            width: 100%;
            height: 100%;
            z-index: -1;
        }

        .container {
            background: rgba(255, 255, 255, 0.15);
            border-radius: 16px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            padding: 40px;
            width: 95%;
            max-width: 1200px;
            margin: 50px auto;
            color: #fff;
            animation: fadeIn 1s ease-in-out;
            display: flex;
            flex-direction: column;
            min-height: 90vh;
        }

        h2 {
            text-align: center;
            color: #fff;
            text-shadow: 1px 1px 2px #000;
        }

        .form-wrapper {
            width: 100%;
            max-width: 700px;
            margin: 0 auto 40px auto;
        }

        .input-field {
            margin-bottom: 20px;
            position: relative;
        }

        .input-field label {
            display: block;
            margin-bottom: 6px;
            font-weight: bold;
        }

        .input-field i {
            position: absolute;
            left: 10px;
            top: 38px;
            color: #555;
        }

        .input-field input {
            width: 100%;
            padding: 10px 10px 10px 30px;
            border-radius: 8px;
            border: none;
            background: rgba(255,255,255,0.7);
            font-size: 14px;
            box-sizing: border-box;
        }

        button, input[type="submit"] {
            background-color: #007BFF;
            color: white;
            padding: 10px 18px;
            border: none;
            border-radius: 10px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        button:hover, input[type="submit"]:hover {
            background-color: #0056b3;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: rgba(255, 255, 255, 0.8);
            color: #000;
            border-radius: 10px;
            overflow: hidden;
        }

        th, td {
            padding: 10px;
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

        .table-input {
            width: 100%;
            max-width: 140px;
            padding: 10px;
            padding-left: 12px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 14px;
            box-sizing: border-box;
        }

        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 10px;
        }

        .back-link {
            text-align: left;
            margin-top: auto;
            padding-top: 20px;
        }

        .back-button {
            display: inline-block;
            padding: 10px 20px;
            border: 2px solid white;
            color: white;
            background: transparent;
            text-decoration: none;
            border-radius: 10px;
            font-weight: bold;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .back-button:hover {
            background-color: white;
            color: #007BFF;
        }

        @keyframes fadeIn {
            from {opacity: 0; transform: translateY(20px);}
            to {opacity: 1; transform: translateY(0);}
        }
    </style>
</head>
<body>
<div id="particles-js"></div>

<div class="container">
    <h2>🚚 Book Supplies</h2>

    <% if (!isAdmin) { %>
    <div class="form-wrapper">
        <form action="BookingServlet" method="post">
            <input type="hidden" name="action" value="add">
            <div class="input-field">
                <label for="username">Username</label>
                <i class="fa fa-user"></i>
                <input type="text" name="username" value="<%= sessionUsername %>" readonly>
            </div>

            <div class="input-field">
                <label for="supplyType">Item</label>
                <i class="fa fa-box"></i>
                <input type="text" name="supplyType" required>
            </div>

            <div class="input-field">
                <label for="quantity">Quantity</label>
                <i class="fa fa-sort-numeric-up"></i>
                <input type="number" name="quantity" required>
            </div>

            <div class="input-field">
                <label for="status">Status</label>
                <i class="fa fa-check-circle"></i>
                <input type="text" name="status" value="Pending" readonly>
            </div>

            <div class="input-field">
                <label for="bookingDate">Booking Date</label>
                <i class="fa fa-calendar"></i>
                <input type="date" name="bookingDate" required>
            </div>

            <button type="submit">Add Booking</button>
        </form>
    </div>
    <% } %>

    <h3>📋 All Bookings</h3>
    <table>
        <tr>
            <th>No</th><th>Username</th><th>Item</th><th>Quantity</th><th>Status</th><th>Date</th><th>Actions</th>
        </tr>
        <%
        List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
        int row = 1;
        if (bookings != null) {
            for (Booking b : bookings) {
                boolean isEditable = "Pending".equalsIgnoreCase(b.getStatus()) || isAdmin;
        %>
        <form action="BookingServlet" method="post">
        <input type="hidden" name="status" value="<%= b.getStatus() %>">
        <input type="hidden" name="id" value="<%= b.getId() %>">
        <tr>
            <td><%= row++ %></td>
            <td><%= b.getUsername() %></td>
            <td>
                <% if (isEditable) { %>
                    <input class="table-input" type="text" name="supplyType" value="<%= b.getSupplyType() %>" required>
                <% } else { %>
                    <input class="table-input" type="text" value="<%= b.getSupplyType() %>" readonly>
                <% } %>
            </td>
            <td>
                <% if (isEditable) { %>
                    <input class="table-input" type="number" name="quantity" value="<%= b.getQuantity() %>" required>
                <% } else { %>
                    <input class="table-input" type="number" value="<%= b.getQuantity() %>" readonly>
                <% } %>
            </td>
            <td>
                <% if (isAdmin) { %>
                    <select name="status" class="table-input">
                        <option value="Pending" <%= "Pending".equalsIgnoreCase(b.getStatus()) ? "selected" : "" %>>Pending</option>
                        <option value="Approved" <%= "Approved".equalsIgnoreCase(b.getStatus()) ? "selected" : "" %>>Approved</option>
                        <option value="Rejected" <%= "Rejected".equalsIgnoreCase(b.getStatus()) ? "selected" : "" %>>Rejected</option>
                    </select>
                <% } else { %>
                    <input class="table-input" type="text" value="<%= b.getStatus() %>" readonly>
                <% } %>
            </td>
            <td>
                <% if (isEditable) { %>
                    <input class="table-input" type="date" name="bookingDate" value="<%= b.getBookingDate() %>" required>
                <% } else { %>
                    <input class="table-input" type="date" value="<%= b.getBookingDate() %>" readonly>
                <% } %>
            </td>
            <td class="action-buttons">
                <% if (isEditable) { %>
                    <input type="hidden" name="action" value="update">
                    <input type="submit" value="Update">
                <% } %>
        </form>
        <form action="BookingServlet" method="post">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="id" value="<%= b.getId() %>">
            <% if (isEditable) { %>
                <input type="submit" value="Delete">
            <% } %>
        </form>
            </td>
        </tr>
        <% }} %>
    </table>

    <!-- ✅ Bottom-left back button inside the container -->
    <div class="back-link">
        <a href="DashboardServlet" class="back-button"><i class="fa fa-arrow-left"></i> Back to Dashboard</a>
    </div>
</div>

<script>
    particlesJS("particles-js", {
        "particles": {
            "number": { "value": 60 },
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
