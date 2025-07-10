<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - ICSMS</title>
    <!-- Particles.js & Font Awesome -->
    <script src="https://cdn.jsdelivr.net/npm/particles.js@2.0.0/particles.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        @font-face {
            font-family: 'Poppins';
            src: url('fonts/Poppins-Regular.ttf') format('truetype');
        }

        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        #particles-js {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            background-color: #0d47a1;
        }

        .container {
            background: rgba(255, 255, 255, 0.15);
            border-radius: 16px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            padding: 30px 40px;
            width: 350px;
            color: #000;
            text-align: center;
            animation: fadeIn 1s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .container h2 {
    margin-bottom: 20px;
    color: #ffffff;
    text-shadow: 1px 1px 2px #000;
}


        .input-field {
            width: 100%;
            margin-bottom: 15px;
            text-align: left;
            position: relative;
        }

        .input-field label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
        }

        .input-field i.fa-user,
        .input-field i.fa-lock {
            position: absolute;
            left: 10px;
            top: 35px;
            color: #555;
        }

        .input-field .toggle-password {
            position: absolute;
            right: 10px;
            top: 35px;
            cursor: pointer;
            color: #777;
            z-index: 2;
        }

        .input-field input {
            width: 100%;
            padding: 10px 35px 10px 30px;
            border: none;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.7);
            box-shadow: inset 1px 1px 2px rgba(0, 0, 0, 0.05);
            font-size: 14px;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }

        .input-field input:focus {
            outline: none;
            border: 2px solid #007BFF;
            background: #fff;
        }

        button {
            width: 100%;
            padding: 10px;
            border: none;
            background-color: #007BFF;
            color: white;
            font-weight: bold;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        button:hover {
            background-color: #0056b3;
        }

        .logo {
            width: 60px;
            height: 60px;
            margin-bottom: 10px;
        }

        .register-link {
            margin-top: 15px;
            display: block;
            font-size: 14px;
            color: #fff;
        }
        
        .role-toggle {
            flex: 1;
            margin: 0 5px;
            padding: 8px 0;
            border: none;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
            background-color: #ffffff90;
            transition: background-color 0.3s;
        }

        .role-toggle.active {
            background-color: #007BFF;
            color: white;
        }

    </style>
</head>
<body>
    <div id="particles-js"></div>

    <div class="container">
        <img src="images/logo.png" alt="ICSMS Logo" class="logo">
        <h2>Login</h2>
        
        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
            <div style="background: #ffdddd; color: #a94442; padding: 10px; border-radius: 8px; margin-bottom: 15px; border: 1px solid #f5c6cb;">
                <i class="fa fa-exclamation-circle"></i> <%= error %>
           </div>
        <% } %>

        <form method="post" action="LoginServlet">
    
            <div class="input-field" style="display: flex; justify-content: space-between; margin-bottom: 20px;">
                <button type="button" class="role-toggle active" onclick="setUserType('user')" id="userBtn">User</button>
                <button type="button" class="role-toggle" onclick="setUserType('admin')" id="adminBtn">Admin</button>
                <input type="hidden" name="userType" id="userType" value="user">
            </div>

            <div class="input-field">
                <label for="username">Username</label>
                <i class="fa fa-user"></i>
                <input type="text" name="username" id="username" required>
            </div>
            <div class="input-field">
                <label for="password">Password</label>
                <i class="fa fa-lock"></i>
                <input type="password" name="password" id="password" required>
                <i class="fa fa-eye toggle-password" toggle="#password"></i>
            </div>
    
            
    
    
            <button type="submit">Login</button>
        </form>
        <a href="register.jsp" class="register-link">Don't have an account? Register here</a>
    </div>

    
    <script>
        // Particle Background
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

        // Form Validation
        document.querySelector("form").addEventListener("submit", function(e) {
            const username = document.querySelector("#username");
            const password = document.querySelector("#password");

            if (username.value.trim() === "" || password.value.trim() === "") {
                alert("Both username and password are required.");
                e.preventDefault();
            }
        });

        // Toggle Password Visibility
        document.querySelectorAll(".toggle-password").forEach(icon => {
            icon.addEventListener("click", function () {
                const input = document.querySelector(this.getAttribute("toggle"));
                const type = input.getAttribute("type") === "password" ? "text" : "password";
                input.setAttribute("type", type);
                this.classList.toggle("fa-eye-slash");
            });
        });
        
        function setUserType(type) {
            document.getElementById("userType").value = type;
            document.getElementById("userBtn").classList.remove("active");
            document.getElementById("adminBtn").classList.remove("active");
            document.getElementById(type + "Btn").classList.add("active");
}

    </script>
</body>
</html>
