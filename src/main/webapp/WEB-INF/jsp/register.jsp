<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>

    <script>
        // Critical Render-Blocking Script to prevent flash of light/dark theme during initial page paint
        (function() {
            const activeTheme = localStorage.getItem('theme') || 'dark';
            document.documentElement.setAttribute('data-theme', activeTheme);
        })();
    </script>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LMS Registration | New Registration Library Portal</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        /* CSS Variables Supporting Synchronized Matrix Theme Architecture */
        :root[data-theme="dark"] {
            --bg-blend: radial-gradient(circle at 50% 50%, rgba(15, 23, 42, 0.45) 0%, rgba(2, 6, 23, 0.93) 100%);
            --card-bg: rgba(15, 23, 42, 0.65);
            --card-border: rgba(255, 255, 255, 0.05);
            --card-glow: rgba(14, 165, 233, 0.08);
            --text-heading: #ffffff;
            --text-body: #f1f5f9;
            --text-muted: #64748b;
            --input-bg: rgba(2, 6, 23, 0.7);
            --input-border: rgba(255, 255, 255, 0.1);
            --input-color: #ffffff;
            --accent-gradient: linear-gradient(135deg, #2563eb 0%, #0ea5e9 100%);
            --btn-shadow: rgba(37, 99, 235, 0.35);
            --mesh-glow: rgba(14, 165, 233, 0.12);
            --option-color: #0f172a;
        }

        :root[data-theme="light"] {
            --bg-blend: linear-gradient(135deg, rgba(241, 245, 249, 0.82) 0%, rgba(219, 234, 254, 0.9) 100%);
            --card-bg: rgba(255, 255, 255, 0.88);
            --card-border: rgba(15, 24, 42, 0.08);
            --card-glow: rgba(37, 99, 235, 0.04);
            --text-heading: #0f172a;
            --text-body: #334155;
            --text-muted: #94a3b8;
            --input-bg: #ffffff;
            --input-border: rgba(15, 24, 42, 0.14);
            --input-color: #0f172a;
            --accent-gradient: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            --btn-shadow: rgba(37, 99, 235, 0.25);
            --mesh-glow: rgba(37, 99, 235, 0.05);
            --option-color: #0f172a;
        }

        * {
            margin: 0; padding: 0; box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
            transition: background 0.3s ease, color 0.3s ease, border-color 0.3s ease, box-shadow 0.3s ease;
        }

        body {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
            position: relative;
            background: var(--bg-blend), url('https://images.unsplash.com/photo-1521587760476-6c12a4b040da?q=80&w=1920');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            overflow-x: hidden;
            z-index: 1;
        }

        /* Ambient Micro Glowing Fluid Layer */
        .ambient-glow-layer {
            position: absolute; width: 600px; height: 600px;
            background: var(--mesh-glow); border-radius: 50%;
            filter: blur(140px); pointer-events: none; z-index: -1;
            animation: floatGlow 18s infinite alternate ease-in-out;
        }

        @keyframes floatGlow {
            0% { transform: translate(-8%, -8%) scale(1); }
            100% { transform: translate(8%, 8%) scale(1.1); }
        }

        .register-container {
            width: 100%; max-width: 580px; position: relative; z-index: 5;
        }

        /* Glassmorphic Platform Surface */
        .register-box {
            background: var(--card-bg);
            backdrop-filter: blur(25px); -webkit-backdrop-filter: blur(25px);
            border: 1px solid var(--card-border); border-radius: 32px;
            padding: 45px 40px;
            box-shadow: 0 30px 70px rgba(0,0,0,0.4);
            position: relative;
        }
        .register-box::after {
            content: ''; position: absolute; inset: 0; border-radius: 32px;
            box-shadow: 0 0 40px var(--card-glow); pointer-events: none; z-index: -1;
        }

        /* Theme Toggle System Button */
        .btn-theme-toggle {
            position: absolute; top: 30px; right: 30px;
            background: rgba(255, 255, 255, 0.02); border: 1px solid var(--card-border);
            color: var(--text-heading); width: 44px; height: 44px; border-radius: 14px;
            display: flex; align-items: center; justify-content: center; cursor: pointer; z-index: 10;
        }
        .btn-theme-toggle:hover {
            background: rgba(255, 255, 255, 0.08); transform: scale(1.05);
        }

        .logo-box {
            width: 76px; height: 76px; margin: 0 auto 20px auto; border-radius: 22px;
            display: flex; justify-content: center; align-items: center;
            background: var(--accent-gradient); box-shadow: 0 10px 30px var(--btn-shadow);
        }
        .logo-box i { font-size: 32px; color: white; }

        .main-title {
            text-align: center; color: var(--text-heading); font-size: 28px; font-weight: 800;
            margin-bottom: 6px; letter-spacing: -0.75px;
        }

        .sub-title {
            text-align: center; color: var(--text-muted); font-size: 14px; margin-bottom: 35px;
        }

        /* Modernized Floating Label Input System */
        .form-floating {
            margin-bottom: 18px;
        }
        .form-floating > .form-control,
        .form-floating > .form-select {
            background: var(--input-bg); border: 1px solid var(--input-border);
            color: var(--input-color); border-radius: 16px; height: 58px;
        }
        .form-floating > .form-control:focus,
        .form-floating > .form-select:focus {
            background: var(--input-bg); color: var(--input-color); border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.15);
        }
        .form-floating > label { color: var(--text-muted); left: 4px; }
        .form-floating > .form-control:focus ~ label,
        .form-floating > .form-control:not(:placeholder-shown) ~ label,
        .form-floating > .form-select:focus ~ label,
        .form-floating > .form-select:not([value=""]):valid ~ label {
            color: #2563eb;
        }

        .form-select option {
            color: var(--option-color); background: #ffffff;
        }

        textarea.form-control {
            min-height: 110px !important; height: auto !important; padding-top: 28px !important;
        }

        /* Custom Floating Password Engine Split Fix */
        .password-container-mesh {
            position: relative; display: flex; align-items: stretch; width: 100%; margin-bottom: 18px;
        }
        .password-container-mesh .form-floating {
            flex-grow: 1; margin-bottom: 0;
        }
        .password-container-mesh .form-control {
            border-top-right-radius: 0 !important; border-bottom-right-radius: 0 !important;
        }
        .show-btn {
            border: 1px solid var(--input-border); border-left: none;
            background: var(--input-bg); color: var(--text-muted); width: 56px;
            border-radius: 0 16px 16px 0; display: flex; align-items: center;
            justify-content: center; cursor: pointer; transition: 0.2s;
        }
        .show-btn:hover { color: var(--text-heading); background: rgba(255, 255, 255, 0.05); }

        /* Premium Form Trigger Commit Element */
        .btn-register {
            width: 100%; height: 56px; border: none; border-radius: 16px;
            background: var(--accent-gradient); color: white; font-size: 16px; font-weight: 600;
            display: flex; align-items: center; justify-content: center; gap: 10px;
            box-shadow: 0 10px 25px var(--btn-shadow); cursor: pointer; margin-top: 10px;
        }
        .btn-register:hover {
            transform: translateY(-2px); box-shadow: 0 14px 35px var(--btn-shadow); color: white;
        }

        /* Internal Component Loading Animation */
        .spinner-node {
            display: none; width: 20px; height: 20px;
            border: 3px solid rgba(255,255,255,0.3); border-radius: 50%;
            border-top-color: white; animation: spin 0.8s linear infinite;
        }
        @keyframes spin { to { transform: rotate(360deg); } }

        .alert { border-radius: 16px; font-size: 13.5px; border: none; padding: 14px 18px; }

        /* Router Interface Grid Navigation Links Mesh */
        .bottom-links-mesh {
            display: flex; flex-direction: column; gap: 12px; margin-top: 25px;
            padding-top: 20px; border-top: 1px solid var(--card-border); text-align: center;
        }
        .bottom-links-mesh a {
            color: var(--text-muted); text-decoration: none; font-size: 14px;
            display: inline-flex; align-items: center; justify-content: center; gap: 6px;
            font-weight: 500;
        }
        .bottom-links-mesh a strong { color: var(--text-muted); font-weight: 500; }
        .bottom-links-mesh a:hover strong { color: #2563eb; font-weight: 600; }
        .bottom-links-mesh a:hover { color: #2563eb; }

        @media(max-width:768px){
            body { padding: 20px 15px; }
            .register-box { padding: 45px 24px 35px 24px; border-radius: 24px; }
            .main-title { font-size: 24px; }
        }
    </style>
</head>
<body>

<div class="ambient-glow-layer"></div>

<div class="register-container">
    <div class="register-box">

        <button class="btn-theme-toggle" id="themeToggleBtn" title="Invert Visual Space">
            <i class="bi bi-moon-stars-fill" id="themeIcon"></i>
        </button>

        <div class="logo-box">
            <i class="bi bi-book-half"></i>
        </div>

        <h1 class="main-title">Create New Account</h1>
        <p class="sub-title">Join Library Management System Portal</p>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible border-0 shadow-lg text-white bg-danger bg-opacity-75 rounded-4 p-3 mb-4 fade show" role="alert">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-exclamation-octagon-fill fs-5"></i>
                    <div>${error}</div>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible border-0 shadow-lg text-white bg-success bg-opacity-75 rounded-4 p-3 mb-4 fade show" role="alert">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-check-circle-fill fs-5"></i>
                    <div>${success}</div>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/auth/register" method="post" id="registerForm">

            <!-- SECURITY DATA FIX: Background injection point for registration number to satisfy full UserDto constraints safely -->
            <input type="hidden" name="registrationNumber" id="registrationNumber" value="">

            <div class="form-floating">
                <input type="text" name="fullName" id="fullName" class="form-control" placeholder="Full Name" required autocomplete="name">
                <label for="fullName"><i class="bi bi-person-fill me-1"></i> Full Name *</label>
            </div>

            <div class="form-floating">
                <input type="email" name="email" id="email" class="form-control" placeholder="Email" required autocomplete="email">
                <label for="email"><i class="bi bi-envelope-fill me-1"></i> Email Address *</label>
            </div>

            <div class="form-floating">
                <input type="text" name="rollNumber" id="rollNumber" class="form-control" placeholder="Roll Number" required>
                <label for="rollNumber"><i class="bi bi-card-text me-1"></i> Roll Number *</label>
            </div>

            <div class="form-floating">
                <input type="text" name="mobileNumber" id="mobileNumber" class="form-control" placeholder="Mobile" maxlength="10" pattern="[6789][0-9]{9}" title="Please enter a valid 10-digit Indian mobile number" required autocomplete="tel">
                <label for="mobileNumber"><i class="bi bi-telephone-fill me-1"></i> Mobile Number *</label>
            </div>

            <div class="form-floating">
                <select name="gender" id="gender" class="form-select" required>
                    <option value="" selected disabled></option>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                    <option value="Other">Other</option>
                </select>
                <label for="gender"><i class="bi bi-gender-ambiguous me-1"></i> Select Gender *</label>
            </div>

            <div class="form-floating">
                <input type="text" name="course" id="course" class="form-control" placeholder="Course" required>
                <label for="course"><i class="bi bi-mortarboard-fill me-1"></i> Course *</label>
            </div>

            <div class="form-floating">
                <input type="text" name="branch" id="branch" class="form-control" placeholder="Branch" required>
                <label for="branch"><i class="bi bi-diagram-3-fill me-1"></i> Branch *</label>
            </div>

            <div class="form-floating">
                <select name="year" id="year" class="form-select" required>
                    <option value="" selected disabled></option>
                    <option value="1st Year">1st Year</option>
                    <option value="2nd Year">2nd Year</option>
                    <option value="3rd Year">3rd Year</option>
                    <option value="4th Year">4th Year</option>
                    <option value="other">Other</option>
                </select>
                <label for="year"><i class="bi bi-calendar3 me-1"></i> Academic Year *</label>
            </div>

            <div class="form-floating">
                <textarea name="address" id="address" class="form-control" placeholder="Address" required autocomplete="street-address"></textarea>
                <label for="address"><i class="bi bi-geo-alt-fill me-1"></i> Permanent Address *</label>
            </div>

            <div class="password-container-mesh">
                <div class="form-floating">
                    <input type="password" name="password" id="password" class="form-control" placeholder="Password" required autocomplete="new-password">
                    <label for="password"><i class="bi bi-key-fill me-1"></i> Password *</label>
                </div>
                <button type="button" class="show-btn" onclick="togglePasswordVisibilityPipeline()">
                    <i class="bi bi-eye-fill" id="toggleIcon"></i>
                </button>
            </div>

            <!-- CORRECTED DYNAMIC ROUTING ENGINE: Both options map to 'STUDENT' data value attribute
                 to force redirect into student dashboard safely in all use cases -->
            <div class="form-floating">
                <select name="role" id="role" class="form-select" required>
                    <option value="" selected disabled></option>
                    <option value="STUDENT">Student</option>
                    <option value="STUDENT">Other</option>
                </select>
                <label for="role"><i class="bi bi-shield-lock-fill"></i> Select Authority Role *</label>
            </div>

            <button type="submit" class="btn btn-register" id="regSubmitBtn">
                <i class="bi bi-person-plus-fill" id="btnIcon"></i>
                <span id="btnText">Register Form</span>
                <div class="spinner-node" id="btnSpinner"></div>
            </button>
        </form>

        <div class="bottom-links-mesh">
            <a href="${pageContext.request.contextPath}/login">Already have an account? <strong>Login Here</strong></a>
            <a href="${pageContext.request.contextPath}/"><i class="bi bi-house-door-fill"></i> Return to Core Home</a>
        </div>

    </div>
</div>

<script>
    // System Theme Configuration Sync Modules
    const themeToggleBtn = document.getElementById('themeToggleBtn');
    const themeIcon = document.getElementById('themeIcon');
    const rootHtml = document.documentElement;

    window.addEventListener('DOMContentLoaded', () => {
        const activeTheme = rootHtml.getAttribute('data-theme') || 'dark';
        refreshThemeUIElements(activeTheme);
        setupCustomValidationMessages();
    });

    themeToggleBtn.addEventListener('click', () => {
        const activeThemeState = rootHtml.getAttribute('data-theme');
        const targetState = activeThemeState === 'light' ? 'dark' : 'light';
        rootHtml.setAttribute('data-theme', targetState);
        localStorage.setItem('theme', targetState);
        refreshThemeUIElements(targetState);
    });

    function refreshThemeUIElements(theme) {
        themeIcon.className = theme === 'light' ? 'bi bi-moon-stars-fill' : 'bi bi-sun-fill';
    }

    // Keyway Visibility Engine Pipeline
    function togglePasswordVisibilityPipeline(){
        const passwordField = document.getElementById("password");
        const iconElement = document.getElementById("toggleIcon");

        if(passwordField.type === "password"){
            passwordField.type = "text";
            iconElement.className = "bi bi-eye-slash-fill";
        } else {
            passwordField.type = "password";
            iconElement.className = "bi bi-eye-fill";
        }
    }

    // Custom Validation Engine Setup
    function setupCustomValidationMessages() {
        const fields = [
            { id: 'fullName', requiredMsg: 'Please enter your Full Name.' },
            { id: 'email', requiredMsg: 'Please enter your Email Address.', typeMsg: 'Please enter a valid email address (e.g., user@example.com).' },
            { id: 'rollNumber', requiredMsg: 'Please provide your Roll Number.' },
            { id: 'mobileNumber', requiredMsg: 'Please fill out your Mobile Number.', patternMsg: 'Please enter a valid 10-digit Indian mobile number starting with 6, 7, 8, or 9.' },
            { id: 'gender', requiredMsg: 'Please select your Gender from the list.' },
            { id: 'course', requiredMsg: 'Please enter your Course details.' },
            { id: 'branch', requiredMsg: 'Please enter your Branch specialization.' },
            { id: 'year', requiredMsg: 'Please choose your Academic Year.' },
            { id: 'address', requiredMsg: 'Please specify your Permanent Address.' },
            { id: 'password', requiredMsg: 'Please set a secure Password.' },
            { id: 'role', requiredMsg: 'Please select an Authority Role.' }
        ];

        fields.forEach(field => {
            const element = document.getElementById(field.id);
            if (!element) return;

            const validate = () => {
                if (element.validity.valueMissing) {
                    element.setCustomValidity(field.requiredMsg);
                } else if (element.validity.typeMismatch && field.typeMsg) {
                    element.setCustomValidity(field.typeMsg);
                } else if (element.validity.patternMismatch && field.patternMsg) {
                    element.setCustomValidity(field.patternMsg);
                } else {
                    element.setCustomValidity('');
                }
            };

            element.addEventListener('input', validate);
            element.addEventListener('change', validate);
            element.addEventListener('invalid', validate);
        });
    }

    // Dynamic State Form Submission Loading Dispatcher
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        if (this.checkValidity()) {
            // AUTOMATION HOOK: Synchronizes dynamic registration numbers instantly based on unique current milli timestamps
            // to fulfill background DTO validators cleanly on any random submission event.
            document.getElementById('registrationNumber').value = "REG_" + Date.now();

            document.getElementById('btnIcon').style.display = 'none';
            document.getElementById('btnText').innerText = 'Initializing System Manifest...';
            document.getElementById('btnSpinner').style.display = 'inline-block';
            document.getElementById('regSubmitBtn').style.pointerEvents = 'none';
            document.getElementById('regSubmitBtn').style.opacity = '0.85';
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>


  only two problem currect karo
<!-- 1. esme logout button add karo click karne par student-dashboard page pe redirect ho jaye aur session destroy ho jaye ,
<!-- 2. student-chat page  me data store nahi ho raha hai , page ko refersh karein par admin-chat ka receive message delete ho ja raha hai currect karo  >
