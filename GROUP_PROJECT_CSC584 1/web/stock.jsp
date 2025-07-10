<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Stock" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Stock Management - ICSMS</title>
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
            top: 0;
            left: 0;
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
            overflow: hidden;
        }

        h2, h3 {
            color: #ffffff;
            text-shadow: 1px 1px 2px #000;
            text-align: center;
        }

        .form-grid {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
        }

        .form-row {
            display: flex;
            justify-content: space-between;
            width: 100%;
            max-width: 500px;
        }

        .form-row label {
            flex: 1;
            margin-right: 15px;
            text-align: left;
        }

        .form-row input {
            flex: 2;
            padding: 8px;
            border-radius: 6px;
            border: none;
        }

        .button-row {
            text-align: center;
            margin-top: 20px;
        }

        .btn-solid {
            font-family: 'Poppins', sans-serif;
            font-weight: bold;
            width: 100px;
            height: 40px;
            color: white;
            background-color: #007BFF;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-align: center;
        }

        .btn-solid:hover {
            background-color: #0056b3;
        }

        .action-buttons {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .table-wrapper {
            overflow-x: auto;
            margin-top: 15px;
            border-radius: 10px;
        }

        table {
            min-width: 800px;
            width: 100%;
            border-collapse: collapse;
            background-color: rgba(255, 255, 255, 0.85);
            color: #000;
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

        .back-link {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 25px;
            font-family: 'Poppins', sans-serif;
            font-weight: bold;
            font-size: 16px;
            color: white;
            background-color: transparent;
            border: 2px solid white;
            border-radius: 8px;
            text-decoration: none;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .back-link:hover {
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
    <h2>📦 Stock Management</h2>

    <!-- Add New Stock -->
    <form action="StockServlet" method="post" class="form-grid">
        <input type="hidden" name="action" value="add">

        <div class="form-row">
            <label for="itemName">Item Name:</label>
            <input type="text" id="itemName" name="itemName" required>
        </div>
        <div class="form-row">
            <label for="category">Category:</label>
            <input type="text" id="category" name="category" required>
        </div>
        <div class="form-row">
            <label for="quantity">Quantity:</label>
            <input type="number" id="quantity" name="quantity" required>
        </div>
        

        <div class="button-row">
            <input type="submit" class="btn-solid" value="Add Stock">
        </div>
    </form>

    <hr>

    <!-- Display All Stocks -->
    <h3>📋 All Stock Items</h3>

    <div class="table-wrapper">
        <table>
            <tr>
                <th>No</th><th>Item Name</th><th>Category</th><th>Quantity</th><th>Actions</th>
            </tr>
            <%
                List<Stock> stocks = (List<Stock>) request.getAttribute("stocks");
                int row = 1;
                if (stocks != null) {
                    for (Stock s : stocks) {
            %>
            <tr>
                <form action="StockServlet" method="post">
                    <input type="hidden" name="id" value="<%= s.getId() %>">
                    <td><%= row++ %></td>
                    <td><input type="text" name="itemName" value="<%= s.getItemName() %>" required></td>
                    <td><input type="text" name="category" value="<%= s.getCategory() %>" required></td>
                    <td><input type="number" name="quantity" value="<%= s.getQuantity() %>" required></td>
                    
                    <td>
                        <div class="action-buttons">
                            <input type="hidden" name="action" value="update">
                            <input type="submit" class="btn-solid" value="Update">
                </form>
                <form action="StockServlet" method="post">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="<%= s.getId() %>">
                    <input type="submit" class="btn-solid" value="Delete">
                </form>
                        </div>
                    </td>
            </tr>
            <%
                    }
                }
            %>
        </table>
    </div>

    <a href="DashboardServlet" class="back-link">← Back to Dashboard</a>
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
