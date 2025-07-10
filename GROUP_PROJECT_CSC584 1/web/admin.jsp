<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, model.User, model.Order, model.Booking, model.Stock" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null || !"admin".equals(username)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - ICSMS</title>
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
            overflow-x: hidden;
            background: #0d47a1;
            color: white;
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
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            padding: 40px;
            margin: 40px auto;
            width: 90%;
            max-width: 1000px;
            animation: fadeIn 1s ease-in-out;
        }

        h2, h3 {
            color: #ffffff;
            text-shadow: 1px 1px 2px #000;
            text-align: center;
        }

        p {
            font-size: 16px;
            text-align: center;
        }

        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
            flex-wrap: wrap;
            margin: 30px 0;
        }

        .action-buttons a {
            color: white;
            text-decoration: none;
            font-weight: bold;
            padding: 12px 24px;
            border: 2px solid #00f0ff;
            border-radius: 8px;
            background: transparent;
            transition: 0.3s;
        }

        .action-buttons a:hover {
            background-color: #00f0ff;
            color: #0d47a1;
        }

        .back-button-container {
            text-align: left;
            margin-top: 40px;
        }

        .back-button-container a {
            color: white;
            text-decoration: none;
            font-weight: bold;
            padding: 10px 20px;
            border: 2px solid #fff;
            border-radius: 8px;
            display: inline-block;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .back-button-container a:hover {
            background-color: white;
            color: #0d47a1;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
        </head>
            <body>

                <div id="particles-js"></div>

                <div class="container">
                <h2>Welcome, Admin</h2>

                <h2>📊 Admin Summary</h2>
                    <%
                        Integer totalUsers = (Integer) request.getAttribute("totalUsers");
                        Integer totalOrders = (Integer) request.getAttribute("totalOrders");
                        Integer totalBookings = (Integer) request.getAttribute("totalBookings");
                    %>

                        <p>Total Users: <%= totalUsers != null ? totalUsers : 0 %></p>
                        <p>Total Orders: <%= totalOrders != null ? totalOrders : 0 %></p>
                        <p>Total Bookings: <%= totalBookings != null ? totalBookings : 0 %></p>

                    <h3>🔍 Actions</h3>

                    <div class="action-buttons">
                        <a href="OrderServlet"><i class="fa fa-box"></i> Manage Orders</a>
                        <a href="BookingServlet"><i class="fa fa-clipboard-list"></i> Manage Bookings</a>
                        <a href="StockServlet"><i class="fa fa-warehouse"></i> Manage Stocks</a>
                    </div>

                    <div class="back-button-container">
                        <a href="DashboardServlet"><i class="fa fa-arrow-left"></i> Back to Main Dashboard</a>
                    </div>
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
