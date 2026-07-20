<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    com.lms.dto.UserDto adminUserDto = (com.lms.dto.UserDto) session.getAttribute("loggedInUser");
    if(adminUserDto == null || adminUserDto.getRole() != com.lms.Enum.Role.ADMIN){
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enterprise Admin Dashboard | Admin Dashboard</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        /* Modern CSS Custom Property Architecture for Real-time Theme Inversion */
        :root[data-theme="dark"] {
            --bg-gradient: radial-gradient(circle at 50% 50%, #0f172a 0%, #020617 100%);
            --sidebar-bg: rgba(15, 23, 42, 0.95);
            --card-bg: rgba(30, 41, 59, 0.55);
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --border-color: rgba(255, 255, 255, 0.08);
            --glass-panel: rgba(255, 255, 255, 0.03);
            --navbar-bg: rgba(15, 23, 42, 0.85);
            --footer-bg: rgba(15, 23, 42, 0.95);
            --accent-glow: rgba(14, 165, 233, 0.15);
            --dropdown-bg: rgba(30, 41, 59, 0.98);
            --input-text: #ffffff;
            --placeholder-color: #64748b;

            /* Custom Learner Widgets Colors */
            --widget-border: rgba(255, 255, 255, 0.12);
            --widget-bg: rgba(30, 41, 59, 0.4);

            /* Chart Palette Parameters */
            --chart-line-stroke: #38bdf8;
            --chart-bar-fill: rgba(56, 189, 248, 0.35);
            --chart-bar-hover: #0ea5e9;
            --chart-grid-line: rgba(255, 255, 255, 0.05);
        }

        :root[data-theme="light"] {
            --bg-gradient: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            --sidebar-bg: rgba(255, 255, 255, 0.96);
            --card-bg: rgba(255, 255, 255, 0.85);
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border-color: rgba(15, 24, 42, 0.08);
            --glass-panel: rgba(15, 23, 42, 0.03);
            --navbar-bg: rgba(255, 255, 255, 0.85);
            --footer-bg: rgba(241, 245, 249, 0.98);
            --accent-glow: rgba(37, 99, 235, 0.05);
            --dropdown-bg: rgba(255, 255, 255, 0.98);
            --input-text: #0f172a;
            --placeholder-color: #94a3b8;

            /* Custom Learner Widgets Colors Light Mode */
            --widget-border: rgba(15, 24, 42, 0.1);
            --widget-bg: rgba(255, 255, 255, 0.8);

            /* Chart Palette Parameters */
            --chart-line-stroke: #2563eb;
            --chart-bar-fill: rgba(37, 99, 235, 0.25);
            --chart-bar-hover: #1d4ed8;
            --chart-grid-line: rgba(15, 24, 42, 0.05);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
            transition: background-color 0.3s ease, border-color 0.3s ease, color 0.3s ease, box-shadow 0.3s ease;
        }

        body {
            background: var(--bg-gradient);
            overflow-x: hidden;
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .console-trigger {
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 22px;
            font-weight: 700;
            color: var(--text-main);
            user-select: none;
        }

        .logo-icon-box {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 3px;
            width: 22px;
            height: 22px;
        }

        .logo-icon-box span {
            background: #38bdf8;
            border-radius: 2px;
        }

        .logo-icon-box span:nth-child(1),
        .logo-icon-box span:nth-child(4) { background: #0ea5e9; }

        .console-dropdown-menu {
            position: absolute;
            top: 75px;
            left: 30px;
            background: var(--dropdown-bg);
            backdrop-filter: blur(24px);
            -webkit-backdrop-filter: blur(24px);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            width: 280px;
            padding: 20px 15px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.4);
            display: none;
            z-index: 2000;
            animation: consoleEntrance 0.2s cubic-bezier(0.16, 1, 0.3, 1) forwards;
        }

        @keyframes consoleEntrance {
            from { opacity: 0; transform: translateY(-10px) scale(0.98); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }

        .menu-title {
            color: var(--text-muted);
            font-size: 11px;
            text-transform: uppercase;
            margin: 0 0 12px 10px;
            letter-spacing: 2px;
            font-weight: 600;
        }

        .menu-links {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .menu-links li { margin-bottom: 5px; }

        .menu-links a {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            color: var(--text-main);
            padding: 11px 15px;
            border-radius: 12px;
            font-weight: 500;
            font-size: 14px;
        }

        .menu-links a:hover, .menu-links li.active a {
            background: linear-gradient(135deg, #0ea5e9 0%, #2563eb 100%);
            color: white !important;
            box-shadow: 0 6px 20px rgba(14, 165, 233, 0.25);
        }

        .custom-navbar {
            position: fixed;
            top: 0;
            right: 0;
            left: 0;
            height: 80px;
            background: var(--navbar-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--border-color);
            z-index: 1000;
            padding: 0 30px;
            display: grid;
            grid-template-columns: auto 1fr auto;
            align-items: center;
        }

        /* Learners Widgets Metrics Center Section Layout */
        .center-metrics-container {
            justify-self: center;
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .metric-widget-box {
            border: 1px solid var(--widget-border);
            background: var(--widget-bg);
            border-radius: 14px;
            padding: 6px 24px;
            display: flex;
            align-items: center;
            gap: 14px;
            min-width: 170px;
        }

        .widget-pulse-node {
            width: 14px;
            height: 14px;
            background: #22c55e;
            border-radius: 50%;
            box-shadow: 0 0 10px #22c55e;
            display: inline-block;
            flex-shrink: 0;
        }

        .widget-icon-box {
            color: #38bdf8;
            font-size: 20px;
            display: flex;
            align-items: center;
        }

        .widget-data-flows {
            display: flex;
            flex-direction: column;
        }

        .widget-data-flows h4 {
            margin: 0;
            font-size: 20px;
            font-weight: 700;
            line-height: 1.2;
        }

        [data-theme="dark"] .widget-data-flows h4.live-text { color: #22c55e; }
        [data-theme="light"] .widget-data-flows h4.live-text { color: #16a34a; }
        [data-theme="dark"] .widget-data-flows h4.total-text { color: #38bdf8; }
        [data-theme="light"] .widget-data-flows h4.total-text { color: #2563eb; }

        .widget-data-flows span {
            font-size: 12px;
            color: var(--text-muted);
            white-space: nowrap;
        }

        .navbar-actions-group {
            justify-self: end;
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .action-icon-trigger {
            background: var(--glass-panel);
            border: 1px solid var(--border-color);
            color: var(--text-main);
            width: 42px;
            height: 42px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            position: relative;
        }

        .admin-profile-box {
            display: flex;
            align-items: center;
            gap: 12px;
            padding-left: 12px;
            border-left: 1px solid var(--border-color);
        }

        .admin-profile-box img {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            border: 2px solid #0ea5e9;
            object-fit: cover;
        }

        .main-content {
            width: 100%;
            flex: 1;
            padding: 105px 30px 25px 30px;
        }

        .dashboard-split-mesh {
            display: grid;
            grid-template-columns: 1fr 380px;
            gap: 25px;
        }

        .stats-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            padding: 22px;
            height: 100%;
            position: relative;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            word-wrap: break-word;
            overflow: hidden;
        }

        .stats-card:hover {
            transform: translateY(-4px);
            border-color: rgba(14, 165, 233, 0.4);
            box-shadow: 0 12px 30px rgba(14, 165, 233, 0.15);
        }

        .stats-link-card {
            text-decoration: none;
            color: inherit;
        }

        .stats-icon {
            width: 46px;
            height: 46px;
            border-radius: 12px;
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 14px;
            background: linear-gradient(135deg, #0ea5e9 0%, #2563eb 100%);
            color: white;
            font-size: 18px;
        }

        .icon-total-books {
            background: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%) !important;
        }

        .stats-card h3 {
            font-size: 30px;
            font-weight: 700;
            margin: 0;
            letter-spacing: -0.5px;
        }

        .stats-card p {
            color: var(--text-muted);
            margin: 2px 0 0 0;
            font-size: 13.5px;
        }

        .user-graph-analytics-workspace {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 24px;
            padding: 24px;
            margin-top: 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        .workspace-header-panel {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .workspace-title {
            font-size: 16px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .pulse-tracker-node {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 11px;
            background: rgba(34, 197, 94, 0.1);
            color: #22c55e;
            padding: 5px 12px;
            border-radius: 30px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .pulse-dot {
            width: 7px;
            height: 7px;
            background: #22c55e;
            border-radius: 50%;
            animation: pulse-glow 1.5s infinite ease-in-out;
        }

        @keyframes pulse-glow {
            0% { transform: scale(0.8); opacity: 0.5; }
            50% { transform: scale(1.3); opacity: 1; }
            100% { transform: scale(0.8); opacity: 0.5; }
        }

        .vector-graph-canvas-frame {
            position: relative;
            width: 100%;
            height: 250px;
            border-radius: 18px;
            padding: 10px;
        }

        .right-activity-feed-aside {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 24px;
            padding: 24px;
            height: fit-content;
            backdrop-filter: blur(10px);
        }

        .aside-panel-header {
            font-size: 15px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            color: var(--text-main);
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 12px;
        }

        .activity-logs-timeline {
            display: flex;
            flex-direction: column;
            gap: 14px;
            max-height: 480px;
            overflow-y: auto;
            padding-right: 4px;
        }

        .activity-logs-timeline::-webkit-scrollbar { width: 4px; }
        .activity-logs-timeline::-webkit-scrollbar-thumb { background: var(--border-color); border-radius: 10px; }

        .activity-stream-node {
            background: var(--glass-panel);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 14px;
            display: flex;
            gap: 14px;
            align-items: flex-start;
        }

        .activity-stream-node:hover {
            border-color: rgba(14,165,233,0.2);
            background: rgba(255,255,255,0.01);
        }

        .stream-avatar-icon {
            width: 42px;
            height: 42px;
            background: linear-gradient(135deg, #0ea5e9, #2563eb);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 18px;
            flex-shrink: 0;
        }

        .meta-log-details h6 {
            font-size: 13px;
            font-weight: 600;
            margin: 0 0 2px 0;
            line-height: 1.4;
        }

        .meta-log-details p {
            font-size: 11.5px;
            color: var(--text-muted);
            margin: 0 0 6px 0;
        }

        .custom-footer {
            margin-top: auto;
            background: var(--footer-bg);
            border-top: 1px solid var(--border-color);
            padding: 30px 0 15px 0;
            border-radius: 24px 24px 0 0;
        }

        .footer-details-heading {
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--text-main);
        }

        .lib-info-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .lib-info-list li {
            margin-bottom: 8px;
            font-size: 12.5px;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .digital-rack-system {
            background: rgba(0, 0, 0, 0.2);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 12px;
        }

        .rack-row { display: flex; gap: 4px; margin-bottom: 4px; }
        .rack-node { flex: 1; height: 6px; background: #22c55e; border-radius: 2px; }
        .rack-node.busy { background: #ef4444; }

        @media(max-width:1200px) {
            .dashboard-split-mesh { grid-template-columns: 1fr; }
            .center-metrics-container { display: none; }
            .custom-navbar { grid-template-columns: 1fr auto; }
        }
    </style>
</head>
<body>

<nav class="custom-navbar">
    <div class="console-trigger" onclick="toggleConsoleMenu(event)">
        <div class="logo-icon-box">
            <span></span><span></span><span></span><span></span>
        </div>
        <span>Admin Dashboard <i class="bi bi-chevron-down" style="font-size: 13px;"></i></span>
    </div>

    <div class="center-metrics-container">
        <div class="metric-widget-box">
            <span class="widget-pulse-node"></span>
            <div class="widget-data-flows">
                <h4 class="live-text"><c:out value="${liveLearners != null ? liveLearners : '734'}" /></h4>
                <span>Live Learners</span>
            </div>
        </div>
        <div class="metric-widget-box">
            <div class="widget-icon-box">
                <i class="bi bi-people-fill"></i>
            </div>
            <div class="widget-data-flows">
                <h4 class="total-text"><c:out value="${totalLearners != null ? totalLearners : '517,597'}" /></h4>
                <span>Total Learners</span>
            </div>
        </div>
    </div>

    <div class="navbar-actions-group">
        <div class="action-icon-trigger">
            <i class="bi bi-bell"></i>
            <div class="active-alert-indicator" style="position: absolute; top: 12px; right: 13px; width: 6px; height: 6px; background: #ef4444; border-radius: 50%;"></div>
        </div>
        <button class="action-icon-trigger" onclick="toggleTheme()"><i class="bi bi-moon-stars" id="themeIcon"></i></button>

        <div class="admin-profile-box">
            <c:catch var="elError">
                <c:choose>
                    <c:when test="${not empty sessionScope.loggedInUser and not empty sessionScope.loggedInUser.photoUrl}">
                        <img src="${sessionScope.loggedInUser.photoUrl}" alt="Profile Object">
                    </c:when>
                    <c:otherwise>
                        <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=100&q=80" alt="Fallback Profile">
                    </c:otherwise>
                </c:choose>
            </c:catch>

            <c:if test="${not empty elError}">
                <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=100&q=80" alt="Fallback Profile">
            </c:if>

            <div class="d-none d-md-block">
                <h6 class="m-0 font-weight-bold" style="font-size:13px;">
                    <c:catch var="nameError">
                        <c:out value="${not empty sessionScope.loggedInUser.name ? sessionScope.loggedInUser.name : 'System Admin'}"/>
                    </c:catch>
                    <c:if test="${not empty nameError}">System Admin</c:if>
                </h6>
                <small style="color: var(--text-muted); font-size: 10px;">
                    <c:catch var="roleError">
                        <c:out value="${not empty sessionScope.loggedInUser.role ? sessionScope.loggedInUser.role : 'Root Authorization'}"/>
                    </c:catch>
                    <c:if test="${not empty roleError}">Root Authorization</c:if>
                </small>
            </div>
        </div>
    </div>
</nav>

<div class="console-dropdown-menu" id="consoleDropdown">
    <div class="menu-title">Main Infrastructure Systems</div>
    <ul class="menu-links">
         <li class="${fn:contains(pageContext.request.requestURI, '/admin/dashboard') ? 'active' : ''}">
             <a href="${pageContext.request.contextPath}/admin/dashboard">
                 <i class="bi bi-house-door-fill"></i> Home
             </a>
         </li>
         <li class="${fn:contains(pageContext.request.requestURI, '/admin/add-book') ? 'active' : ''}">
             <a href="${pageContext.request.contextPath}/admin/add-book">
                 <i class="bi bi-plus-circle-fill"></i> Add New Book
             </a>
         </li>

         <li class="${fn:contains(pageContext.request.requestURI, '/admin/books') ? 'active' : ''}">
             <a href="${pageContext.request.contextPath}/admin/books">
                 <i class="bi bi-journal-bookmark-fill"></i> Edit & Delete Books
             </a>
         </li>
         <li class="${fn:contains(pageContext.request.requestURI, '/admin/pending-students') ? 'active' : ''}">
             <a href="${pageContext.request.contextPath}/admin/pending-students">
                 <i class="bi bi-person-check-fill"></i> Approve Students
             </a>
         </li>
         <li class="${fn:contains(pageContext.request.requestURI, '/admin/issue-book') ? 'active' : ''}">
             <a href="${pageContext.request.contextPath}/admin/issue-book">
                 <i class="bi bi-arrow-left-right"></i> Issue & Return Book
             </a>
         </li>
         <li class="${fn:contains(pageContext.request.requestURI, '/admin/fine') ? 'active' : ''}">
             <a href="${pageContext.request.contextPath}/admin/fine/all">
                 <i class="bi bi-patch-exclamation-fill"></i> Fine Management
             </a>
         </li>
         <li class="${fn:contains(pageContext.request.requestURI, '/admin/students') ? 'active' : ''}">
             <a href="${pageContext.request.contextPath}/admin/students">
                 <i class="bi bi-people-fill"></i> Access & User Control
             </a>
         </li>
         <li class="${fn:contains(pageContext.request.requestURI, '/admin/chat') ? 'active' : ''}">
             <a href="${pageContext.request.contextPath}/admin/chat/dashboard">
                 <i class="bi bi-chat-dots-fill"></i> Admin-chat
             </a>
         </li>
         <li style="border-top: 1px solid var(--border-color); margin-top: 10px; padding-top: 10px;">
             <a href="${pageContext.request.contextPath}/admin/logout" style="color: #f43f5e;">
                 <i class="bi bi-box-arrow-right"></i> Logout
             </a>
         </li>
     </ul>
</div>

<div class="main-content">
    <div class="dashboard-split-mesh">
        <div>
            <div class="row g-3">
                <div class="col-sm-6 col-lg-3">
                    <div class="stats-card">
                        <div class="stats-icon icon-total-books"><i class="bi bi-book-half"></i></div>
                        <h3><c:out value="${totalBooks != null ? totalBooks : '0'}" /></h3>
                        <p>Total Books</p>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <div class="stats-card">
                        <div class="stats-icon" style="background: linear-gradient(135deg, #0ea5e9, #2563eb);"><i class="bi bi-layers-half"></i></div>
                        <h3>
                            <c:choose>
                                <c:when test="${not empty issuedBooks}">
                                    <c:out value="${fn:length(issuedBooks)}" />
                                </c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </h3>
                        <p>Total Issued Books</p>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <div class="stats-card">
                        <div class="stats-icon" style="background: linear-gradient(135deg, #8b5cf6, #6d28d9);"><i class="bi bi-people-fill"></i></div>
                        <h3><c:out value="${totalStudents != null ? totalStudents : '0'}" /></h3>
                        <p>Verified Members</p>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <a href="${pageContext.request.contextPath}/admin/fine/all" class="stats-link-card">
                        <div class="stats-card">
                            <div class="stats-icon" style="background: linear-gradient(135deg, #ef4444, #b91c1c);"><i class="bi bi-currency-rupee"></i></div>
                            <h3>₹<c:out value="${totalFine != null ? totalFine : '0.00'}" /></h3>
                            <p>Total Paid Fines <i class="bi bi-arrow-right-circle ms-1"></i></p>
                        </div>
                    </a>
                </div>
            </div>

            <div class="user-graph-analytics-workspace">
                <div class="workspace-header-panel">
                    <div class="workspace-title">
                        <i class="bi bi-bar-chart-line text-info"></i> Books Circulation Distribution & Issuance Load Activity Matrix
                    </div>
                    <div class="pulse-tracker-node">
                        <span class="pulse-dot"></span> Live Track Synced
                    </div>
                </div>
                <div class="vector-graph-canvas-frame">
                    <canvas id="lmsActivityHybridChart"></canvas>
                </div>
            </div>
        </div>

        <div class="right-activity-feed-aside">
            <div class="aside-panel-header">
                <span><i class="bi bi-activity text-info"></i> User Activity Flow</span>
                <span class="badge bg-primary-subtle text-primary border border-primary-subtle font-monospace" style="font-size: 10px;">SYSTEM LIVE</span>
            </div>

            <div class="activity-logs-timeline">
                <c:choose>
                    <c:when test="${not empty recentReadBooks}">
                        <c:forEach var="book" items="${recentReadBooks}">
                            <div class="activity-stream-node">
                                <div class="stream-avatar-icon"><i class="bi bi-book-half"></i></div>
                                <div class="meta-log-details">
                                    <h6><c:out value="${book.title}"/></h6>
                                    <p>Catalog ID: <span class="text-white font-monospace">#LMS-<c:out value="${book.id != null ? book.id : '9021'}"/></span></p>
                                    <span class="badge bg-info-subtle text-info border border-info-subtle px-2 py-1" style="font-size: 10px;">
                                        <i class="bi bi-person-fill"></i> <c:out value="${book.lastReaderName}"/>
                                    </span>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="activity-stream-node">
                            <div class="stream-avatar-icon" style="background: linear-gradient(135deg, #0ea5e9, #2563eb);"><i class="bi bi-journal-arrow-up"></i></div>
                            <div class="meta-log-details">
                                <h6>System Core Engineering</h6>
                                <p>By E. Balagurusamy • <span class="text-white font-monospace">ID: #9931</span></p>
                                <div class="d-flex align-items-center gap-2">
                                    <span class="badge bg-success-subtle text-success border border-success-subtle" style="font-size:10px;">Checked Out</span>
                                    <small class="text-muted" style="font-size: 11px;"><i class="bi bi-person"></i> Aarav Sharma</small>
                                </div>
                            </div>
                        </div>
                        <div class="activity-stream-node">
                            <div class="stream-avatar-icon" style="background: linear-gradient(135deg, #10b981, #059669);"><i class="bi bi-journal-check"></i></div>
                            <div class="meta-log-details">
                                <h6>Cloud Native Architecture</h6>
                                <p>By Richard M. • <span class="text-white font-monospace">ID: #4051</span></p>
                                <div class="d-flex align-items-center gap-2">
                                    <span class="badge bg-info-subtle text-info border border-info-subtle" style="font-size:10px;">Returned</span>
                                    <small class="text-muted" style="font-size: 11px;"><i class="bi bi-person"></i> Ishita Kapoor</small>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<footer class="custom-footer">
    <div class="container-fluid px-4">
        <div class="row g-3">
            <div class="col-md-4">
                <h5 class="footer-details-heading">Library Infrastructure Network</h5>
                <ul class="lib-info-list">
                    <li><i class="bi bi-building text-info"></i> Operational Hub: Sector-7 Corporate Intelligence Block</li>
                    <li><i class="bi bi-hdd-network text-info"></i> Interconnected System Architecture: 250+ Main Nodes</li>
                </ul>
            </div>
            <div class="col-md-4">
                <h5 class="footer-details-heading">Coordinates</h5>
                <ul class="lib-info-list">
                    <li><i class="bi bi-geo-alt text-primary"></i> Knowledge Park, Phase-II, Chandigarh</li>
                    <li><i class="bi bi-cpu text-primary"></i> Core System Architecture Platform: Enterprise v4.1.2</li>
                </ul>
            </div>
            <div class="col-md-4">
                <h5 class="footer-details-heading">Digital Racks Layout & Network Map</h5>
                <div class="digital-rack-system">
                    <div class="rack-row"><div class="rack-node"></div><div class="rack-node busy"></div><div class="rack-node"></div><div class="rack-node"></div><div class="rack-node"></div></div>
                    <div class="rack-row"><div class="rack-node"></div><div class="rack-node"></div><div class="rack-node"></div><div class="rack-node"></div><div class="rack-node busy"></div></div>
                </div>
            </div>
        </div>
        <hr style="border-top: 1px solid var(--border-color); margin: 15px 0 10px 0;">
        <div class="d-flex flex-column align-items-center text-center" style="font-size: 12px; color: var(--text-muted); gap: 8px;">
            <span>© 2026 <strong>Admin Dashboard Systems Ltd.</strong> System matrices synced dynamically over secure channels.</span>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Navigation Dropdown Controller
    function toggleConsoleMenu(event) {
        event.stopPropagation();
        const dropdown = document.getElementById('consoleDropdown');
        dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
    }

    document.addEventListener('click', function() {
        document.getElementById('consoleDropdown').style.display = 'none';
    });

    // Client Theme Inversion Framework
    function applyTheme(theme) {
        document.documentElement.setAttribute('data-theme', theme);
        const icon = document.getElementById('themeIcon');
        if(theme === 'light') {
            icon.className = 'bi bi-sun-fill';
        } else {
            icon.className = 'bi bi-moon-stars';
        }
    }

    const currentTheme = localStorage.getItem('theme') || 'dark';
    applyTheme(currentTheme);

    function toggleTheme() {
        const activeTheme = document.documentElement.getAttribute('data-theme');
        const nextTheme = activeTheme === 'light' ? 'dark' : 'light';
        applyTheme(nextTheme);
        localStorage.setItem('theme', nextTheme);
        updateChartColors();
    }

    // Chart JS Matrix Initialization
    let activityChart;
    function initChart() {
        const ctx = document.getElementById('lmsActivityHybridChart').getContext('2d');
        const styles = getComputedStyle(document.documentElement);

        activityChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
                datasets: [{
                    label: 'Books Issued Load',
                    data: [65, 59, 80, 81, 56, 55, 40],
                    backgroundColor: styles.getPropertyValue('--chart-bar-fill').trim(),
                    borderColor: styles.getPropertyValue('--chart-line-stroke').trim(),
                    borderWidth: 2,
                    borderRadius: 8,
                    hoverBackgroundColor: styles.getPropertyValue('--chart-bar-hover').trim()
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { labels: { color: styles.getPropertyValue('--text-main').trim() } }
                },
                scales: {
                    x: { grid: { color: styles.getPropertyValue('--chart-grid-line').trim() }, ticks: { color: styles.getPropertyValue('--text-muted').trim() } },
                    y: { grid: { color: styles.getPropertyValue('--chart-grid-line').trim() }, ticks: { color: styles.getPropertyValue('--text-muted').trim() } }
                }
            }
        });
    }

    function updateChartColors() {
        if(activityChart) {
            const styles = getComputedStyle(document.documentElement);
            activityChart.data.datasets[0].backgroundColor = styles.getPropertyValue('--chart-bar-fill').trim();
            activityChart.data.datasets[0].borderColor = styles.getPropertyValue('--chart-line-stroke').trim();
            activityChart.data.datasets[0].hoverBackgroundColor = styles.getPropertyValue('--chart-bar-hover').trim();
            activityChart.options.plugins.legend.labels.color = styles.getPropertyValue('--text-main').trim();
            activityChart.options.scales.x.grid.color = styles.getPropertyValue('--chart-grid-line').trim();
            activityChart.options.scales.x.ticks.color = styles.getPropertyValue('--text-muted').trim();
            activityChart.options.scales.y.grid.color = styles.getPropertyValue('--chart-grid-line').trim();
            activityChart.options.scales.y.ticks.color = styles.getPropertyValue('--text-muted').trim();
            activityChart.update();
        }
    }

    document.addEventListener('DOMContentLoaded', initChart);
</script>
</body>
</html>
