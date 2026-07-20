<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    // Production Session Guard Validation Interceptor
    if (session == null || session.getAttribute("loggedInUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
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
    <title>Profile Hub | LMS Matrix</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

    <style>
        /* =====================================
           THEME VARIABLES (Light & Dark)
        ===================================== */
        :root[data-theme="dark"] {
            --sidebar-bg: #0f172a;
            --sidebar-hover: #1e293b;
            --primary-color: #4f46e5;
            --primary-hover: #4338ca;
            --bg-body: #0f172a;
            --card-bg: #1e293b;
            --text-main: #f1f5f9;
            --text-muted: #cbd5e1;
            --border-color: #334155;
            --text-dark-override: #f1f5f9;
            --bg-light-override: #0f172a;
            --inner-panel: #0f172a;
            --avatar-glow: rgba(56, 189, 248, 0.3);
        }

        :root[data-theme="light"] {
            --sidebar-bg: #0f172a;
            --sidebar-hover: #1e293b;
            --primary-color: #4f46e5;
            --primary-hover: #4338ca;
            --bg-body: #f8fafc;
            --card-bg: #ffffff;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
            --text-dark-override: #0f172a;
            --bg-light-override: #f8fafc;
            --inner-panel: #f8fafc;
            --avatar-glow: rgba(79, 70, 229, 0.15);
        }

        * {
            margin: 0; padding: 0; box-sizing: border-box;
            font-family: 'Inter', 'Poppins', sans-serif;
            transition: background-color 0.3s ease, color 0.3s ease, border-color 0.3s ease;
        }

        body {
            background-color: var(--bg-body) !important;
            color: var(--text-main) !important;
            overflow-x: hidden;
            min-height: 100vh;
        }

        .layout-wrapper { display: flex; min-height: 100vh; }

        /* PERSISTENT SIDEBAR COMPONENT */
        .sidebar {
            width: 280px; height: 100vh; position: fixed;
            top: 0; left: 0; background: var(--sidebar-bg);
            padding: 30px 20px; z-index: 1040; transition: transform 0.3s ease-in-out;
            box-shadow: 4px 0 24px rgba(0,0,0,0.05);
        }
        .sidebar .logo { padding: 0 10px; margin-bottom: 40px; }
        .sidebar .logo h2 { color: #fff; font-size: 22px; font-weight: 700; letter-spacing: -0.5px; margin-bottom: 4px; }
        .sidebar .logo p { color: #64748b; font-size: 13px; margin: 0; }

        .sidebar-menu { display: flex; flex-direction: column; gap: 8px; }
        .sidebar-menu a {
            display: flex; align-items: center; gap: 14px; color: #94a3b8; text-decoration: none;
            padding: 12px 16px; border-radius: 10px; font-weight: 500; font-size: 14px;
        }
        .sidebar-menu a:hover { background: var(--sidebar-hover); color: #fff; }
        .sidebar-menu a.active { background: var(--primary-color); color: #fff; box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3); }

        /* VIEWPORT CANVAS */
        .main-content { margin-left: 280px; width: 100%; padding: 40px; min-height: 100vh; }

        /* GLASSMORPHIC INTERACTIVE TOPBAR */
        .modern-topbar {
            background: var(--card-bg); padding: 24px 32px; border-radius: 16px; display: flex;
            justify-content: space-between; align-items: center; margin-bottom: 32px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02), 0 10px 20px -5px rgba(0,0,0,0.03);
        }
        .modern-topbar h1 { font-size: 24px; font-weight: 700; color: var(--text-dark-override) !important; margin: 0; }

        .topbar-right-controls { display: flex; align-items: center; gap: 12px; }
        .control-trigger-btn {
            background: var(--bg-light-override); color: var(--text-main); border: 1px solid var(--border-color);
            padding: 10px 18px; border-radius: 10px; cursor: pointer; font-size: 14px; font-weight: 500;
            display: flex; align-items: center; gap: 8px;
        }
        .mobile-hamburger { display: none; }

        /* PROFILE CARD PROFILE PACK */
        .glass-profile-card {
            background: var(--card-bg); border: 1px solid var(--border-color); border-radius: 16px;
            padding: 45px; box-shadow: 0 1px 3px rgba(0,0,0,0.02), 0 10px 20px -5px rgba(0,0,0,0.03);
        }

        /* MASTER IDENTITY COVER HEADER */
        .profile-canvas-header { text-align: center; margin-bottom: 45px; }
        .profile-canvas-avatar {
            width: 120px; height: 120px; border-radius: 50%;
            background: linear-gradient(135deg, #4f46e5, #0ea5e9);
            color: white; display: flex; justify-content: center; align-items: center;
            font-size: 48px; font-weight: 700; margin: 0 auto 20px auto;
            box-shadow: 0 10px 25px var(--avatar-glow);
            text-transform: uppercase;
        }
        .profile-canvas-header h2 { font-size: 26px; font-weight: 700; color: var(--text-dark-override) !important; margin-bottom: 6px; }
        .profile-canvas-header p { font-size: 13px; color: var(--text-muted); font-weight: 600; text-transform: uppercase; letter-spacing: 1px; }

        /* GRID FIELD ARCHITECTURE */
        .data-node-box {
            background: var(--inner-panel); border: 1px solid var(--border-color);
            border-radius: 12px; padding: 18px 22px; margin-bottom: 24px;
        }
        .data-node-box label { display: block; margin-bottom: 6px; color: var(--text-muted); font-size: 12px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }
        .data-node-box p { margin: 0; color: var(--text-main); font-size: 15px; font-weight: 600; word-break: break-word; }

        /* STATUS METRIC BADGES */
        .profile-matrix-badge {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 6px 14px; border-radius: 30px; font-size: 12px; font-weight: 600;
        }
        .badge-state-verified { background: rgba(34, 197, 94, 0.1); color: #22c55e; border: 1px solid rgba(34, 197, 94, 0.15); }
        .badge-state-pending { background: rgba(251, 191, 36, 0.1); color: #fbbf24; border: 1px solid rgba(251, 191, 36, 0.15); }
        .badge-role-tag { background: rgba(79, 70, 229, 0.1); color: var(--primary-color); border: 1px solid rgba(79, 70, 229, 0.15); }

        @media(max-width: 992px) {
            .sidebar { transform: translateX(-100%); }
            .sidebar.active { transform: translateX(0); }
            .main-content { margin-left: 0; padding: 20px; }
            .mobile-hamburger { display: flex; padding: 10px; }
            .glass-profile-card { padding: 30px 20px; }
        }
    </style>
</head>
<body>

<div class="layout-wrapper">

    <div class="sidebar" id="navigationDrawer">
        <div class="logo">
            <h2>LMS Admin Panel</h2>
            <p>Premium Management Suite</p>
        </div>
        <div class="sidebar-menu">
            <a href="${pageContext.request.contextPath}/student/dashboard"><i class="bi bi-grid-1x2-fill"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/student/available-books"><i class="bi bi-book"></i> Available Books</a>
            <a href="${pageContext.request.contextPath}/student/student-issued-books"><i class="bi bi-journal-bookmark"></i> Issued History</a>
            <a href="${pageContext.request.contextPath}/student/profile" class="active"><i class="bi bi-person-circle"></i> My Profile</a>
            <a href="${pageContext.request.contextPath}/auth/logout" class="mt-4 border-top pt-3 text-danger"><i class="bi bi-box-arrow-left"></i> Logout </a>
        </div>
    </div>

    <div class="main-content">

        <div class="modern-topbar">
            <div class="d-flex align-items-center gap-3">
                <button class="control-trigger-btn mobile-hamburger" id="hamburgerMenuTrigger">
                    <i class="bi bi-list"></i>
                </button>
                <h1>User Identity Profile</h1>
            </div>
            <div class="topbar-right-controls">
                <button class="control-trigger-btn" id="themeToggleBtn">
                    <i class="bi bi-moon-fill" id="themeIcon"></i>
                    <span id="themeText">Dark Mode</span>
                </button>
            </div>
        </div>

        <div class="glass-profile-card">

            <div class="profile-canvas-header">
                <div class="profile-canvas-avatar">
                    <c:choose>
                        <c:when test="${not empty user.fullName}">
                            <c:out value="${fn:substring(user.fullName, 0, 1)}" />
                        </c:when>
                        <c:otherwise>U</c:otherwise>
                    </c:choose>
                </div>
                <h2><c:out value="${user.fullName}" /></h2>
                <p><c:out value="${user.role}" /></p>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="data-node-box">
                        <label>Full Name</label>
                        <p><c:out value="${user.fullName}" /></p>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="data-node-box">
                        <label>Email Address</label>
                        <p><c:out value="${user.email}" /></p>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="data-node-box">
                        <label>Mobile Number</label>
                        <p><c:out value="${user.mobileNumber}" /></p>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="data-node-box">
                        <label>Institute Roll Number</label>
                        <p class="font-monospace text-info"><c:out value="${user.rollNumber}" /></p>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="data-node-box">
                        <label>Enrolled Course </label>
                        <p><c:out value="${user.course}" /></p>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="data-node-box">
                        <label>Academic Branch</label>
                        <p><c:out value="${user.branch}" /></p>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="data-node-box">
                        <label>Current Study Year</label>
                        <p><c:out value="${user.year}" /> Year</p>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="data-node-box">
                        <label>Gender</label>
                        <p><c:out value="${user.gender}" /></p>
                    </div>
                </div>

                <div class="col-md-12">
                    <div class="data-node-box">
                        <label>Address Information</label>
                        <p><c:out value="${user.address}" /></p>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="data-node-box">
                        <label>Account Lifecycle Status</label>
                        <div class="mt-1">
                            <c:choose>
                                <c:when test="${user.approved}">
                                    <span class="profile-matrix-badge badge-state-verified"><i class="bi bi-patch-check-fill"></i> System Verified</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="profile-matrix-badge badge-state-pending"><i class="bi bi-shield-exclamation"></i> Pending Approval</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="data-node-box">
                        <label>Role Type</label>
                        <div class="mt-1">
                            <span class="profile-matrix-badge badge-role-tag"><i class="bi bi-shield-lock-fill"></i> <c:out value="${user.role}" /></span>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        // =====================================
        // LIGHT / DARK MODE TOGGLE LOGIC
        // =====================================
        const htmlElement = document.documentElement;
        const themeToggleBtn = document.getElementById('themeToggleBtn');
        const themeIcon = document.getElementById('themeIcon');
        const themeText = document.getElementById('themeText');

        const savedTheme = localStorage.getItem('theme') || 'dark';
        setTheme(savedTheme);

        themeToggleBtn.addEventListener('click', function () {
            const currentTheme = htmlElement.getAttribute('data-theme');
            const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
            setTheme(newTheme);
        });

        function setTheme(theme) {
            htmlElement.setAttribute('data-theme', theme);
            localStorage.setItem('theme', theme);

            if (theme === 'dark') {
                themeIcon.className = 'bi bi-sun-fill';
                themeText.textContent = 'Light Mode';
            } else {
                themeIcon.className = 'bi bi-moon-fill';
                themeText.textContent = 'Dark Mode';
            }
        }

        // =====================================
        // SIDEBAR DRAWER INTERFACE CONTROL
        // =====================================
        const hamburgerMenuTrigger = document.getElementById('hamburgerMenuTrigger');
        const navigationDrawer = document.getElementById('navigationDrawer');

        if(hamburgerMenuTrigger) {
            hamburgerMenuTrigger.addEventListener('click', (e) => {
                navigationDrawer.classList.toggle('active');
                e.stopPropagation();
            });
            document.addEventListener('click', (e) => {
                if(!navigationDrawer.contains(e.target) && navigationDrawer.classList.contains('active')) {
                    navigationDrawer.classList.remove('active');
                }
            });
        }
    });
</script>
</body>
</html>



