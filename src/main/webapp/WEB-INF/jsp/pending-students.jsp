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
<html lang="en" data-theme="light">
<head>
    <script>
        // Critical Render-Blocking Script to prevent flash of light/dark theme during initial page paint
        (function() {
            const activeTheme = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-theme', activeTheme);
        })();
    </script>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pending Student Registration Approval | LMS Premium Admin</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">

    <style>
        /* =====================================
           THEME VARIABLES (Light & Dark)
        ===================================== */
        :root {
            --sidebar-bg: #0f172a;
            --sidebar-hover: #1e293b;
            --primary-color: #4f46e5;
            --primary-hover: #4338ca;
            --bg-body: #f8fafc;
            --card-bg: #ffffff;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
            --table-thead-bg: #0f172a;
            --table-thead-text: #ffffff;
            --table-row-hover: #f8fafc;
            --text-dark-override: #0f172a;
            --bg-light-override: #f8fafc;
            --search-focus-ring: rgba(79, 70, 229, 0.15);
        }

        [data-theme="dark"] {
            --bg-body: #0f172a;
            --card-bg: #1e293b;
            --text-main: #f1f5f9;
            --text-muted: #cbd5e1;
            --border-color: #334155;
            --table-thead-bg: #0b0f19;
            --table-thead-text: #ffffff;
            --table-row-hover: #1e293b;
            --text-dark-override: #f1f5f9;
            --bg-light-override: #0f172a;
            --search-focus-ring: rgba(79, 70, 229, 0.3);
        }

        * {
            margin: 0; padding: 0; box-sizing: border-box;
            font-family: 'Inter', 'Poppins', sans-serif;
            transition: background-color 0.2s ease, border-color 0.2s ease, color 0.1s ease;
        }

        body {
            background-color: var(--bg-body) !important;
            color: var(--text-main) !important;
            overflow-x: hidden;
            min-height: 100vh;
        }

        /* =====================================
           SIDEBAR STYLE (Always Dark Modern)
        ===================================== */
        .sidebar {
            width: 280px; height: 100vh; background: var(--sidebar-bg); position: fixed;
            top: 0; left: 0; z-index: 1000; padding: 30px 20px;
            box-shadow: 4px 0 24px rgba(0,0,0,0.05);
        }

        .logo { padding: 0 10px; margin-bottom: 40px; }
        .logo h2 { color: #fff; font-size: 22px; font-weight: 700; letter-spacing: -0.5px; margin-bottom: 4px; }
        .logo p { color: #64748b; font-size: 13px; margin: 0; }

        .sidebar-nav { display: flex; flex-direction: column; gap: 8px; }
        .sidebar a {
            display: flex; align-items: center; gap: 14px; color: #94a3b8; text-decoration: none;
            padding: 12px 16px; border-radius: 10px; font-weight: 500; font-size: 14px;
        }
        .sidebar a:hover { background: var(--sidebar-hover); color: #fff; }
        .sidebar a.active { background: var(--primary-color); color: #fff; box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3); }

        /* =====================================
           MAIN CONTENT & TOPBAR
        ===================================== */
        .main-content { margin-left: 280px; padding: 40px; min-height: 100vh; }

        .topbar {
            background: var(--card-bg); padding: 24px 32px; border-radius: 16px; display: flex;
            justify-content: space-between; align-items: center; margin-bottom: 32px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02), 0 10px 20px -5px rgba(0,0,0,0.03);
        }
        .topbar h3 { font-size: 24px; font-weight: 700; color: var(--text-dark-override) !important; margin-bottom: 4px; }
        .topbar p { color: var(--text-muted) !important; margin: 0; font-size: 14px; }

        .theme-toggle-btn {
            background: var(--bg-light-override); color: var(--text-main); border: 1px solid var(--border-color);
            padding: 10px 18px; border-radius: 10px; cursor: pointer; font-size: 14px; font-weight: 500;
            display: flex; align-items: center; gap: 8px;
        }

        /* Metrics Display Grid */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 24px; margin-bottom: 32px; }
        .stat-card {
            background: var(--card-bg); border: 1px solid var(--border-color); border-radius: 16px;
            padding: 24px; display: flex; align-items: center; gap: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02), 0 10px 20px -5px rgba(0,0,0,0.03);
        }
        .stat-icon { font-size: 22px; width: 52px; height: 52px; border-radius: 12px; display: flex; align-items: center; justify-content: center; }

        /* =====================================
           PREMIUM MODERN SEARCH BOX STYLE
        ===================================== */
        .search-container-box {
            background: var(--card-bg); border-radius: 12px; padding: 4px;
            border: 1px solid var(--border-color); transition: all 0.3s ease; max-width: 450px; width: 100%;
        }
        .search-control { position: relative; display: flex; align-items: center; }
        .search-control i { position: absolute; left: 18px; color: var(--text-muted); font-size: 16px; }
        .search-control .form-control {
            height: 48px; padding-left: 48px; padding-right: 18px; border-radius: 10px; border: none !important;
            background-color: transparent !important; color: var(--text-main) !important; font-size: 14px; box-shadow: none !important;
        }
        .search-control .form-control::placeholder { color: var(--text-muted); opacity: 0.7; }
        .search-container-box:has(.form-control:focus) { border-color: var(--primary-color); box-shadow: 0 0 0 4px var(--search-focus-ring), 0 4px 12px rgba(0,0,0,0.03); }
        .search-container-box:has(.form-control:focus) i { color: var(--primary-color); }

        /* =====================================
           TABLE CONTEXT & BADGES
        ===================================== */
        .table-section {
            background: var(--card-bg); padding: 30px; border-radius: 16px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02), 0 10px 20px -5px rgba(0,0,0,0.03);
        }
        .table { margin-bottom: 0; color: var(--text-main) !important; border-color: var(--border-color) !important; }
        .table thead { background-color: var(--table-thead-bg) !important; }
        .table th {
            color: var(--table-thead-text) !important; font-weight: 600; font-size: 14px; letter-spacing: 0.3px;
            padding: 18px 16px; border-bottom: none !important; background: transparent !important;
        }
        .table td { padding: 16px; font-size: 14px; color: var(--text-main) !important; border-bottom: 1px solid var(--border-color) !important; white-space: nowrap; background: transparent !important; }
        .table-hover tbody tr:hover { background-color: var(--table-row-hover) !important; }

        .user-id-text { color: var(--text-muted) !important; }
        .text-muted { color: var(--text-muted) !important; }

        /* Custom soft badges context */
        .badge-soft { padding: 6px 12px; border-radius: 30px; font-size: 12px; font-weight: 600; display: inline-block; }
        .badge-course-custom { background-color: rgba(56, 189, 248, 0.12) !important; color: #0284c7 !important; }
        .role-student { background-color: rgba(16, 185, 129, 0.1) !important; color: #10b981 !important; }

        .status-pending {
            background: rgba(245, 158, 11, 0.12) !important; color: #d97706 !important;
            padding: 6px 14px; border-radius: 30px; font-size: 12px; font-weight: 600; display: inline-flex; align-items: center; gap: 6px;
        }

        /* Action Buttons Panel */
        .btn-action-panel { display: flex; gap: 8px; justify-content: flex-end; }
        .btn-approve { background: #10b981 !important; color: #fff !important; border: none; padding: 8px 14px; border-radius: 8px; font-size: 13px; font-weight: 500; text-decoration: none; transition: all 0.2s; }
        .btn-approve:hover { background: #059669 !important; box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2); }
        .btn-reject { background: rgba(239, 68, 68, 0.1) !important; color: #ef4444 !important; border: none; padding: 8px 14px; border-radius: 8px; font-size: 13px; font-weight: 500; text-decoration: none; transition: all 0.2s; }
        .btn-reject:hover { background: #dc2626 !important; color: #fff !important; }

        @media(max-width:991px){
            .sidebar { width: 100%; height: auto; position: relative; padding: 20px; }
            .main-content { margin-left: 0; padding: 20px; }
            .topbar { flex-direction: column; align-items: flex-start; gap: 15px; }
        }
    </style>
</head>

<body>

<div class="sidebar">
    <div class="logo">
        <h2>LMS Admin Panel</h2>
        <p>Premium Management Suite</p>
    </div>
    <div class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/admin/dashboard">
            <i class="bi bi-grid-1x2-fill"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/admin/add-book">
            <i class="bi bi-journal-plus"></i> Add Book
        </a>
        <a href="${pageContext.request.contextPath}/admin/books">
            <i class="bi bi-journal-text"></i> Manage Books
        </a>
        <a href="${pageContext.request.contextPath}/admin/pending-students" class="active">
            <i class="bi bi-person-lines-fill"></i> Pending Approvals
        </a>
        <a href="${pageContext.request.contextPath}/admin/students">
            <i class="bi bi-people-fill"></i> Manage Students
        </a>
        <a href="${pageContext.request.contextPath}/admin/logout" class="mt-4 border-top pt-3 text-danger">
            <i class="bi bi-box-arrow-left"></i> Logout
        </a>
    </div>
</div>

<div class="main-content">

    <div class="topbar">
        <div>
            <h3>Pending Student Approval Console</h3>
            <p>Verify or cancel new student enrollment pipelines safely.</p>
        </div>
        <div class="d-flex align-items-center gap-3">
            <button class="theme-toggle-btn" id="themeToggleBtn">
                <i class="bi bi-moon-fill" id="themeIcon"></i>
                <span id="themeText">Dark Mode</span>
            </button>
        </div>
    </div>

    <!-- Alert System Notifications -->
    <c:if test="${not empty success}">
        <div class="alert alert-success border-0 shadow-sm rounded-3 d-flex align-items-center role-alert fade show mb-4">
            <i class="bi bi-check-circle-fill me-3 fs-5 text-success"></i>
            <div>${success}</div>
            <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger border-0 shadow-sm rounded-3 d-flex align-items-center role-alert fade show mb-4">
            <i class="bi bi-exclamation-triangle-fill me-3 fs-5 text-danger"></i>
            <div>${error}</div>
            <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Metrics Cards Grid -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon bg-warning bg-opacity-10 text-warning"><i class="bi bi-clock-history"></i></div>
            <div>
                <div style="font-size: 13px;" class="text-muted">Total Pending</div>
                <h4 class="mb-0 fw-bold text-dark-override" id="totalPendingCount">0</h4>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon bg-success bg-opacity-10 text-success"><i class="bi bi-mortarboard-fill"></i></div>
            <div>
                <div style="font-size: 13px;" class="text-muted">Student Requests</div>
                <h4 class="mb-0 fw-bold text-dark-override" id="studentReqCount">0</h4>
            </div>
        </div>
    </div>

    <div class="table-section">
        <!-- Premium Designed Search Box Field -->
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
            <div class="search-container-box">
                <div class="search-control">
                    <i class="bi bi-search"></i>
                    <input type="text" id="approvalSearchInput" class="form-control" placeholder="Search entries by name, email, course...">
                </div>
            </div>
            <div class="text-end text-muted small" id="searchFeedback">
                Syncing records...
            </div>
        </div>

        <div class="table-responsive rounded-3">
            <table class="table table-hover align-middle shadow-sm" id="approvalTable">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Mobile</th>
                    <th>Roll Number</th>
                    <th>Course</th>
                    <th>Branch</th>
                    <th>Year</th>
                    <th>Role</th>
                    <th>Status</th>
                    <th class="text-end">Action</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty students}">
                        <c:forEach items="${students}" var="student">
                            <tr class="approval-row" data-user-role="${student.role}">
                                <td class="fw-bold user-id-text search-target">#${student.id}</td>
                                <td class="fw-semibold text-dark-override search-target">${student.fullName}</td>
                                <td class="search-target">${student.email}</td>
                                <td>${student.mobileNumber}</td>
                                <td>${student.rollNumber}</td>
                                <td class="search-target"><span class="badge-soft badge-course-custom">${student.course}</span></td>
                                <td>${student.branch}</td>
                                <td>${student.year} Year</td>
                                <td><span class="badge-soft role-student">${student.role}</span></td>
                                <td>
                                    <span class="status-pending">
                                        <i class="bi bi-hourglass-split"></i> PENDING
                                    </span>
                                </td>
                                <td class="text-end">
                                    <div class="btn-action-panel">
                                        <a href="${pageContext.request.contextPath}/admin/approve-student/${student.id}"
                                           class="btn btn-approve btn-sm"
                                           onclick="return confirm('Confirm and validate credentials to approve this account entry?')">
                                            <i class="bi bi-check-circle me-1"></i> Approve
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/cancel-student/${student.id}"
                                           class="btn btn-reject btn-sm"
                                           onclick="return confirm('Are you sure you want to completely reject this application?')">
                                            <i class="bi bi-x-circle me-1"></i> Reject
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr id="emptyRowPlaceholder">
                            <td colspan="11" class="text-center py-5 text-muted">
                                <i class="bi bi-exclamation-triangle text-warning display-6 d-block mb-2"></i>
                                <span class="fw-semibold">No Pending Registration Assets Found</span>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {

        // =====================================
        // LIGHT / DARK THEME CONTROLLER
        // =====================================
        const htmlElement = document.documentElement;
        const themeToggleBtn = document.getElementById("themeToggleBtn");
        const themeIcon = document.getElementById("themeIcon");
        const themeText = document.getElementById("themeText");

        // Uses unified global key matching 'students.jsp' preference architecture
        const activeSavedTheme = localStorage.getItem("theme") || "light";
        setTheme(activeSavedTheme);

        themeToggleBtn.addEventListener("click", () => {
            const currentSelectedTheme = htmlElement.getAttribute("data-theme");
            const structuralNewTheme = currentSelectedTheme === "dark" ? "light" : "dark";
            setTheme(structuralNewTheme);
        });

        function setTheme(theme) {
            htmlElement.setAttribute("data-theme", theme);
            localStorage.setItem("theme", theme);

            if (theme === "dark") {
                themeIcon.className = "bi bi-sun-fill";
                themeText.textContent = "Light Mode";
            } else {
                themeIcon.className = "bi bi-moon-fill";
                themeText.textContent = "Dark Mode";
            }
        }

        // =====================================
        // METRICS CALCULATOR
        // =====================================
        function computePipelineMetrics() {
            const lines = document.querySelectorAll(".approval-row");
            let totalPending = lines.length;
            let studentTotal = 0;

            lines.forEach(line => {
                const extractionRole = line.getAttribute("data-user-role");
                if (extractionRole === "STUDENT") studentTotal++;
            });

            document.getElementById("totalPendingCount").textContent = totalPending;
            document.getElementById("studentReqCount").textContent = studentTotal;

            const feedbackNode = document.getElementById("searchFeedback");
            if(feedbackNode) feedbackNode.textContent = `Showing all ${totalPending} records`;
        }
        computePipelineMetrics();

        // =====================================
        // CLIENT LIVE FILTER SEARCH
        // =====================================
        const lookupInput = document.getElementById("approvalSearchInput");
        if(lookupInput) {
            lookupInput.addEventListener("keyup", function() {
                const criteria = this.value.toLowerCase().trim();
                const listings = document.querySelectorAll(".approval-row");
                let matchedCounter = 0;

                listings.forEach(row => {
                    const targets = row.querySelectorAll('.search-target');
                    let textMatch = (criteria === '');

                    targets.forEach(target => {
                        if (target.textContent.toLowerCase().includes(criteria)) {
                            textMatch = true;
                        }
                    });

                    if(textMatch) {
                        row.style.display = "";
                        matchedCounter++;
                    } else {
                        row.style.display = "none";
                    }
                });

                const noticeNode = document.getElementById("searchFeedback");
                if(noticeNode) {
                    noticeNode.textContent = criteria === "" ?
                        `Showing all ${listings.length} records` :
                        `Found ${matchedCounter} matching request streams`;
                }
            });
        }
    });
</script>
</body>
</html>



