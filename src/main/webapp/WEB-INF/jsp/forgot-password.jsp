<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password | LMS Portal</title>

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
            --btn-disabled-bg: rgba(255, 255, 255, 0.05);
            --btn-disabled-text: rgba(255, 255, 255, 0.35);
            --btn-disabled-border: rgba(255, 255, 255, 0.08);
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
            --btn-disabled-bg: rgba(15, 23, 42, 0.06);
            --btn-disabled-text: rgba(15, 23, 42, 0.4);
            --btn-disabled-border: rgba(15, 23, 42, 0.1);
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

        .forgot-container {
            width: 100%; max-width: 450px; position: relative; z-index: 5;
        }

        .forgot-box {
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

        .email-group-mesh {
            position: relative;
            display: flex;
            align-items: stretch;
            width: 100%;
            margin-bottom: 20px;
            border-radius: 16px;
        }

        .email-group-mesh .form-floating {
            flex-grow: 1;
            margin-bottom: 0;
        }

        .email-group-mesh .form-control {
            border-top-right-radius: 0 !important;
            border-bottom-right-radius: 0 !important;
        }

        .form-floating {
            margin-bottom: 20px;
        }

        .form-floating > .form-control {
            background: var(--input-bg); border: 1px solid var(--input-border);
            color: var(--input-color); border-radius: 16px; height: 60px;
        }

        .form-floating > .form-control:focus {
            background: var(--input-bg); color: var(--input-color); border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.15);
        }

        .form-floating > label { color: var(--text-muted); left: 6px; }
        .form-floating > .form-control:focus ~ label,
        .form-floating > .form-control:not(:placeholder-shown) ~ label {
            color: #2563eb;
        }

        .go-btn {
            border: 1px solid var(--input-border);
            border-left: none;
            background: var(--accent-gradient);
            color: white;
            min-width: 70px;
            padding: 0 15px;
            border-radius: 0 16px 16px 0;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-weight: 700;
            font-size: 14px;
            letter-spacing: 0.5px;
            box-shadow: 0 5px 15px var(--btn-shadow);
            height: 60px;
            align-self: center;
        }

        .go-btn:hover {
            opacity: 0.95;
            filter: brightness(1.1);
        }

        .go-btn:disabled {
            background: var(--btn-disabled-bg);
            border-color: var(--btn-disabled-border);
            color: var(--btn-disabled-text);
            box-shadow: none;
            cursor: not-allowed;
        }

        .email-group-mesh:focus-within .go-btn:not(:disabled) {
            border-color: #2563eb;
        }

        .btn-submit {
            width: 100%; height: 56px; border-radius: 16px;
            font-size: 15px; font-weight: 600;
            display: flex; align-items: center; justify-content: center; gap: 10px;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);

            background: var(--btn-disabled-bg) !important;
            color: var(--btn-disabled-text) !important;
            border: 1px solid var(--btn-disabled-border) !important;
            cursor: not-allowed;
            opacity: 1;
        }

        .btn-submit.active {
            background: var(--accent-gradient) !important;
            color: #ffffff !important;
            border: none !important;
            box-shadow: 0 10px 25px var(--btn-shadow);
            cursor: pointer;
        }

        .btn-submit.active:hover {
            transform: translateY(-2px);
            box-shadow: 0 14px 35px var(--btn-shadow);
        }

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
            .forgot-box { padding: 45px 24px 35px 24px; border-radius: 24px; }
            .main-title { font-size: 24px; }
        }
    </style>
</head>
<body>

<div class="ambient-glow-layer"></div>

<div class="forgot-container">
    <div class="forgot-box">

        <button class="btn-theme-toggle" id="themeToggleBtn" title="Toggle Visual Interface">
            <i class="bi bi-moon-stars-fill" id="themeIcon"></i>
        </button>

        <div class="logo-box">
            <i class="bi bi-shield-lock-fill"></i>
        </div>

        <h1 class="main-title">Reset Gateway</h1>
        <p class="sub-title">OTP verification for secure session recovery</p>

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

        <form action="${pageContext.request.contextPath}/otp/verify" method="post" onsubmit="dispatchSubmitLoader()">

            <div class="email-group-mesh">
                <div class="form-floating">
                    <input type="email" name="email" id="email" class="form-control" placeholder="user@matrix.com" value="${email}" required>
                    <label for="email"><i class="bi bi-envelope-fill me-1"></i> Email Address</label>
                </div>
                <button type="button" class="go-btn" id="sendOtpBtn" onclick="sendOtpPipeline()">
                    <span id="goBtnText">GO</span>
                    <div class="spinner-node" id="goBtnSpinner" style="width:16px; height:16px;"></div>
                </button>
            </div>

            <div class="form-floating">
                <input type="text" name="otp" id="otp" maxlength="6" pattern="\d{6}" class="form-control" placeholder="000000" oninput="validateOtpLength()" required>
                <label for="otp"><i class="bi bi-patch-check-fill me-1"></i> 6-Digit OTP</label>
            </div>

            <button type="submit" class="btn btn-submit" id="submitBtn" disabled>
                <i class="bi bi-shield-check" id="btnIcon"></i>
                <span id="btnText">Verify Identity Token</span>
                <div class="spinner-node" id="btnSpinner"></div>
            </button>
        </form>

        <div class="bottom-links-mesh">
            <a href="${pageContext.request.contextPath}/login">
                <i class="bi bi-arrow-left-circle-fill"></i> Return to Secure Login
            </a>
        </div>

    </div>
</div>

<script>
    // System Theme LocalStorage Engine Synchronization Core
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

    // Dynamic Client Alert Injection Wrapper
    function displayClientNotification(message, type) {
        const container = document.getElementById('alertContainer');
        const icon = type === 'success' ? 'bi-check-circle-fill' : 'bi-exclamation-octagon-fill';
        const bgClass = type === 'success' ? 'bg-success' : 'bg-danger';

        container.innerHTML = `
            <div class="alert ${bgClass} alert-dismissible border-0 shadow-lg text-white bg-opacity-75 rounded-4 p-3 mb-4 fade show" role="alert">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi ${icon} fs-5"></i>
                    <div>\${message}</div>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
            </div>
        `;

        // Auto dismiss after 7 seconds for cleaner production UX
        setTimeout(() => {
            const activeAlert = container.querySelector('.alert');
            if (activeAlert) {
                const bsAlert = new bootstrap.Alert(activeAlert);
                bsAlert.close();
            }
        }, 7000);
    }

    // PRODUCTION FEATURE: Anti-Spam Countdown Engine
    function startOtpCooldown(durationInSeconds) {
        const sendBtn = document.getElementById("sendOtpBtn");
        const btnText = document.getElementById("goBtnText");
        let timeLeft = durationInSeconds;

        sendBtn.disabled = true;

        const countdownTimer = setInterval(() => {
            if (timeLeft <= 0) {
                clearInterval(countdownTimer);
                btnText.textContent = "GO";
                sendBtn.disabled = false;
            } else {
                btnText.textContent = `\${timeLeft}s`;
                timeLeft--;
            }
        }, 1000);
    }

    // Modern Fetch Request Tunnel - Async Send OTP API Call
    function sendOtpPipeline(){
        const emailInput = document.getElementById("email");
        const sendBtn = document.getElementById("sendOtpBtn");
        const btnText = document.getElementById("goBtnText");
        const btnSpinner = document.getElementById("goBtnSpinner");

        if(!emailInput.checkValidity() || emailInput.value.trim() === ""){
            displayClientNotification("Please provide a valid structural email mapping.", "error");
            return;
        }

        // Trigger Loading States for request duration
        btnText.style.display = 'none';
        btnSpinner.style.display = 'inline-block';
        sendBtn.disabled = true;

        fetch("${pageContext.request.contextPath}/otp/send?email=" + encodeURIComponent(emailInput.value.trim()), {
            method: "POST"
        })
        .then(response => {
            if (!response.ok) throw new Error('Network latency node failure');
            return response.text();
        })
        .then(data => {
            // Check if backend returned success
            if(data.toLowerCase().includes("success") || data.toLowerCase().includes("sent")){
                displayClientNotification(data, "success");
                startOtpCooldown(60); // 60 Seconds cooldown on success
            } else {
                displayClientNotification(data, "error");
                btnText.style.display = 'inline-block';
                sendBtn.disabled = false;
            }
        })
        .catch(() => {
            displayClientNotification("Security Node Architecture failed to dispatch token routing.", "error");
            btnText.style.display = 'inline-block';
            sendBtn.disabled = false;
        })
        .finally(() => {
            btnSpinner.style.display = 'none';
        });
    }

    // Reactive State Verification Validator Form Logic
    function validateOtpLength(){
        const otpInput = document.getElementById("otp");
        const submitBtn = document.getElementById("submitBtn");

        // Clean non-digit characters in real-time
        otpInput.value = otpInput.value.replace(/\D/g, '');

        if(otpInput.value.length === 6){
            submitBtn.disabled = false;
            submitBtn.classList.add("active");
        } else {
            submitBtn.disabled = true;
            submitBtn.classList.remove("active");
        }
    }

    // Submit Sequence Action Loader Inversion Dispatched
    function dispatchSubmitLoader() {
        document.getElementById('btnIcon').style.display = 'none';
        document.getElementById('btnText').innerText = 'Validating Token Node Mapping...';
        document.getElementById('btnSpinner').style.display = 'inline-block';
        document.getElementById('submitBtn').style.pointerEvents = 'none';
        document.getElementById('submitBtn').style.opacity = '0.85';
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>