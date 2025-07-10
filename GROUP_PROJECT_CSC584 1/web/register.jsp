<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Register - ICSMS</title>
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

        .input-field i.fa-lock,
        .input-field i.fa-user {
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
        }

        .input-field input {
            width: 100%;
            padding: 10px 30px 10px 30px;
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

        .login-link {
            margin-top: 15px;
            display: block;
            font-size: 14px;
            color: #fff;
        }
    </style>
</head>
<body>
    <div id="particles-js"></div>

    <div class="container">
        <img src="images/logo.png" alt="ICSMS Logo" class="logo">
        <h2>Register</h2>
        
        <% String error = (String) request.getAttribute("error");
            if (error != null) { %>
            <div style="color: #ffdddd; background-color: #ff4444; padding: 10px; border-radius: 8px; margin-bottom: 15px;">
                <strong>Error:</strong> <%= error %>
            </div>
        <% } %>

        
        <div id="passwordError" style="display:none; background-color: #ffdddd; color: #a94442; padding: 10px; border-radius: 8px; margin-bottom: 15px;">
    
    </div>

        <form method="post" action="RegisterServlet" onsubmit="return validateRegisterForm()">
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
            <div class="input-field">
                <label for="confirm">Confirm Password</label>
                <i class="fa fa-lock"></i>
                <input type="password" name="confirm" id="confirm" required>
                <i class="fa fa-eye toggle-password" toggle="#confirm"></i>
            </div>
            <button type="submit">Register</button>
        </form>
        <a href="login.jsp" class="login-link">Already have an account? Login here</a>
    </div>

    <!-- Particles & Script -->
    <script>
        
        
        function validateRegisterForm() {
            const password = document.getElementById("password").value;
            const errorBox = document.getElementById("passwordError");

        // Strong password pattern
            const pattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/;

        if (!pattern.test(password)) {
            errorBox.innerText = "Password must be at least 8 characters and include uppercase, lowercase, number, and special character.";
            errorBox.style.display = "block";
            return false;
        }

        errorBox.innerText = "";
        errorBox.style.display = "none";
        return true;
    }


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
            const confirm = document.querySelector("#confirm");

            if (username.value.trim() === "" || password.value.trim() === "" || confirm.value.trim() === "") {
                alert("All fields are required.");
                e.preventDefault();
            } else if (password.value !== confirm.value) {
                alert("Passwords do not match.");
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
    </script>
</body>
</html>
