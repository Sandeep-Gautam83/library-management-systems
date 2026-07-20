<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password | LMS Portal</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        /* Matrix Theme Architecture Custom Properties */
        :root[data-theme="dark"] {
            --bg-blend: radial-gradient(circle at 50% 50%, rgba(15, 23, 42, 0.45) 0%, rgba(2, 6, 23, 0.93) 100%);
            --card-bg: rgba(15, 23, 42, 0.65);
            --card-border: rgba(255, 255, 255, 0.05);
            --text-heading: #ffffff;
            --text-muted: #64748b;
            --input-bg: rgba(2, 6, 23, 0.7);
            --input-border: rgba(255, 255, 255, 0.1);
            --input-color: #ffffff;
            --accent-gradient: linear-gradient(135deg, #2563eb 0%, #0ea5e9 100%);
            --btn-shadow: rgba(37, 99, 235, 0.35);
            --mesh-glow: rgba(14, 165, 233, 0.12);
        }

        :root[data-theme="light"] {
            --bg-blend: linear-gradient(135deg, rgba(241, 245, 249, 0.82) 0%, rgba(219, 234, 254, 0.9) 100%);
            --card-bg: rgba(255, 255, 255, 0.88);
            --card-border: rgba(15, 24, 42, 0.08);
            --text-heading: #0f172a;
            --text-muted: #94a3b8;
            --input-bg: #ffffff;
            --input-border: rgba(15, 24, 42, 0.14);
            --input-color: #0f172a;
            --accent-gradient: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            --btn-shadow: rgba(37, 99, 235, 0.25);
            --mesh-glow: rgba(37, 99, 235, 0.05);
        }

        * {
            margin: 0; padding: 0; box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
            transition: background 0.4s cubic-bezier(0.4, 0, 0.2, 1),
                        color 0.4s cubic-bezier(0.4, 0, 0.2, 1),
                        border-color 0.4s cubic-bezier(0.4, 0, 0.2, 1),
                        box-shadow 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }

        body {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            position: relative;
            background: var(--bg-blend), url('https://images.unsplash.com/photo-1521587760476-6c12a4b040da?q=80&w=1920');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            overflow-x: hidden;
            z-index: 1;
        }

        .ambient-glow-layer {
            position: absolute; width: 500px; height: 500px;
            background: var(--mesh-glow); border-radius: 50%;
            filter: blur(120px); pointer-events: none; z-index: -1;
            animation: floatGlow 15s infinite alternate ease-in-out;
        }

        @keyframes floatGlow {
            0% { transform: translate(-10%, -10%) scale(1); }
            100% { transform: translate(10%, 10%) scale(1.1); }
        }

        .reset-container {
            width: 100%; max-width: 450px; position: relative; z-index: 5;
        }

        .reset-box {
            background: var(--card-bg);
            backdrop-filter: blur(25px); -webkit-backdrop-filter: blur(25px);
            border: 1px solid var(--card-border); border-radius: 32px;
            padding: 50px 40px;
            box-shadow: 0 30px 70px rgba(0,0,0,0.4);
            position: relative;
        }

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
            width: 76px; height: 76px; margin: 0 auto 24px auto; border-radius: 22px;
            display: flex; justify-content: center; align-items: center;
            background: var(--accent-gradient); box-shadow: 0 10px 30px var(--btn-shadow);
        }
        .logo-box i { font-size: 32px; color: white; }

        .main-title {
            text-align: center; color: var(--text-heading); font-size: 28px; font-weight: 800;
            margin-bottom: 8px; letter-spacing: -0.75px;
        }

        .sub-title {
            text-align: center; color: var(--text-muted); font-size: 13.5px; margin-bottom: 35px;
        }

        /* FIXED: Pure Inline-Flex Alignment Mesh to lock elements perfectly */
        .password-field-mesh {
            position: relative;
            display: flex;
            width: 100%;
            background: var(--input-bg);
            border: 1px solid var(--input-border);
            border-radius: 16px;
            margin-bottom: 4px;
            overflow: hidden; /* Ensures strict boundary constraints */
        }

        /* Form-floating expands natively inside the flex container */
        .password-field-mesh .form-floating {
            flex: 1 1 auto;
            margin-bottom: 0 !important;
        }

        /* Seamless border elimination inside the container mesh */
        .password-field-mesh .form-control {
            background: transparent !important;
            border: none !important;
            border-radius: 0 !important;
            height: 60px;
            color: var(--input-color);
            box-shadow: none !important;
        }

        .form-floating > label { color: var(--text-muted); left: 6px; }

        .password-field-mesh:focus-within {
            border-color: #2563eb !important;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.15) !important;
        }

        .form-floating > .form-control:focus ~ label,
        .form-floating > .form-control:not(:placeholder-shown) ~ label {
            color: #2563eb;
        }

        /* FIXED: Action Button Geometry matching perfectly with text line height */
        .toggle-visibility-btn {
            background: transparent;
            border: none;
            color: var(--text-muted);
            width: 55px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 18px;
            height: 60px;
            align-self: center;
            z-index: 5;
            padding: 0;
            margin: 0;
            transition: color 0.2s ease;
        }
        .toggle-visibility-btn:hover {
            color: var(--text-heading);
        }

        .ui-validation-error {
            color: #ef4444; font-size: 12.5px; font-weight: 500;
            padding-left: 4px; margin-bottom: 18px; display: block;
            min-height: 18px;
        }

        .btn-submit {
            width: 100%; height: 56px; border-radius: 16px;
            font-size: 15px; font-weight: 600;
            display: flex; align-items: center; justify-content: center; gap: 10px;
            background: var(--accent-gradient) !important;
            color: #ffffff !important;
            border: none !important;
            box-shadow: 0 10px 25px var(--btn-shadow);
            cursor: pointer;
            margin-top: 10px;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 14px 35px var(--btn-shadow);
        }

        /* Loading Spinner */
        .spinner-node {
            display: none; width: 20px; height: 20px;
            border: 3px solid rgba(255,255,255,0.3); border-radius: 50%;
            border-top-color: white; animation: spin 0.8s linear infinite;
        }
        @keyframes spin { to { transform: rotate(360deg); } }

        .alert { border-radius: 16px; font-size: 13.5px; border: none; padding: 14px 18px; }

        .bottom-links-mesh {
            display: flex; flex-direction: column; gap: 14px; margin-top: 30px;
            padding-top: 25px; border-top: 1px solid var(--card-border); text-align: center;
        }
        .bottom-links-mesh a {
            color: var(--text-muted); text-decoration: none; font-size: 14px;
            display: inline-flex; align-items: center; justify-content: center; gap: 6px;
        }
        .bottom-links-mesh a:hover { color: #2563eb; }

        @media(max-width:768px){
            body { padding: 15px; }
            .reset-box { padding: 45px 24px 35px 24px; border-radius: 24px; }
            .main-title { font-size: 24px; }
        }
    </style>
</head>
<body>

<div class="ambient-glow-layer"></div>

<div class="reset-container">
    <div class="reset-box">

        <button class="btn-theme-toggle" id="themeToggleBtn" title="Toggle Visual Interface">
            <i class="bi bi-moon-stars-fill" id="themeIcon"></i>
        </button>

        <div class="logo-box">
            <i class="bi bi-shield-lock-fill"></i>
        </div>

        <h1 class="main-title">Reset Password</h1>
        <p class="sub-title">Create your new secure cryptographic credential</p>

        <div id="alertContainer">
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
        </div>

        <form action="${pageContext.request.contextPath}/otp/reset-password" method="post" onsubmit="return validateFormFormulation(event)">

            <input type="hidden" name="email" value="${email}">

            <div class="password-field-mesh">
                <div class="form-floating">
                    <input type="password" name="password" id="password" class="form-control" placeholder="••••••••" oninput="realtimeCredentialCheck()" required>
                    <label for="password"><i class="bi bi-key-fill me-1"></i> New Password</label>
                </div>
                <button type="button" class="toggle-visibility-btn" onclick="togglePasswordSecurityStream('password', this)">
                    <i class="bi bi-eye-fill"></i>
                </button>
            </div>
            <span class="ui-validation-error" id="passError"></span>

            <div class="password-field-mesh">
                <div class="form-floating">
                    <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" placeholder="••••••••" oninput="realtimeCredentialCheck()" required>
                    <label for="confirmPassword"><i class="bi bi-shield-fill-check me-1"></i> Confirm Password</label>
                </div>
                <button type="button" class="toggle-visibility-btn" onclick="togglePasswordSecurityStream('confirmPassword', this)">
                    <i class="bi bi-eye-fill"></i>
                </button>
            </div>
            <span class="ui-validation-error" id="confirmError"></span>

            <button type="submit" class="btn btn-submit" id="submitBtn">
                <i class="bi bi-shield-check" id="btnIcon"></i>
                <span id="btnText">Update Session Credentials</span>
                <div class="spinner-node" id="btnSpinner"></div>
            </button>
        </form>

        <div class="bottom-links-mesh">
            <a href="${pageContext.request.contextPath}/login">
                <i class="bi bi-arrow-left-circle-fill"></i> Back To Secure Login
            </a>
        </div>

    </div>
</div>

<script>
    // System Theme LocalStorage Configuration Pipeline
    const themeToggleBtn = document.getElementById('themeToggleBtn');
    const themeIcon = document.getElementById('themeIcon');
    const rootHtml = document.documentElement;

    window.addEventListener('DOMContentLoaded', () => {
        const activeTheme = localStorage.getItem('theme') || 'dark';
        rootHtml.setAttribute('data-theme', activeTheme);
        refreshThemeUIElements(activeTheme);
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

    // Input Visibility Toggle Tunnelling Engine
    function togglePasswordSecurityStream(fieldId, elementRef) {
        const structuralInput = document.getElementById(fieldId);
        const iconRef = elementRef.querySelector('i');

        if (structuralInput.type === "password") {
            structuralInput.type = "text";
            iconRef.className = "bi bi-eye-slash-fill";
        } else {
            structuralInput.type = "password";
            iconRef.className = "bi bi-eye-fill";
        }
    }

    // Reactive Operational Validator Logic
    function realtimeCredentialCheck() {
        const pass = document.getElementById("password").value;
        const confirmPass = document.getElementById("confirmPassword").value;
        const passErr = document.getElementById("passError");
        const confirmErr = document.getElementById("confirmError");

        passErr.textContent = "";
        confirmErr.textContent = "";

        if (pass.length > 0 && pass.length < 6) {
            passErr.textContent = "Security policy requires at least 6 structural units.";
        }

        if (confirmPass.length > 0 && pass !== confirmPass) {
            confirmErr.textContent = "Credential synchronization mismatch.";
        }
    }

    // Explicit Form Submission Gateway Guard
    function validateFormFormulation(event) {
        const pass = document.getElementById("password").value;
        const confirmPass = document.getElementById("confirmPassword").value;

        if (pass.trim() === "" || pass.length < 6 || pass !== confirmPass) {
            event.preventDefault();
            realtimeCredentialCheck();
            return false;
        }

        // Trigger Production Spinner UI transition
        document.getElementById('btnIcon').style.display = 'none';
        document.getElementById('btnText').innerText = 'Re-encrypting Core Gateway Token...';
        document.getElementById('btnSpinner').style.display = 'inline-block';
        document.getElementById('submitBtn').style.pointerEvents = 'none';
        document.getElementById('submitBtn').style.opacity = '0.85';
        return true;
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>