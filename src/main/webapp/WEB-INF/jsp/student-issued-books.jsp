<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
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
    <title>My Issued Books Repository | LMS Premium Admin</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

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
            --input-placeholder: #64748b;
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
            --input-placeholder: #cbd5e1;
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

        /* TRANSACTION SHEET CARD */
        .glass-table-card {
            background: var(--card-bg); border: 1px solid var(--border-color); border-radius: 16px;
            padding: 30px; box-shadow: 0 1px 3px rgba(0,0,0,0.02), 0 10px 20px -5px rgba(0,0,0,0.03);
        }

        /* DATA MATRIX PIPELINE */
        .table-responsive { overflow-x: auto; }
        .premium-data-table { width: 100%; border-collapse: separate; border-spacing: 0; min-width: 950px; }
        .premium-data-table thead tr { background-color: var(--table-thead-bg) !important; }

        .premium-data-table th {
            color: var(--table-thead-text) !important; font-weight: 600; font-size: 14px; letter-spacing: 0.3px;
            padding: 18px 16px; border-bottom: none !important; background: transparent !important;
        }

        .premium-data-table td {
            padding: 16px; font-size: 14px; color: var(--text-main) !important;
            border-bottom: 1px solid var(--border-color) !important; white-space: nowrap; background: transparent !important;
        }
        .premium-data-table tbody tr:hover { background-color: var(--table-row-hover) !important; }

        /* CUSTOM THEMATIC OVERRIDES FOR VISIBILITY */
        .custom-id-text { color: var(--text-muted) !important; font-size: 0.875rem; }
        .custom-reg-text { color: var(--text-main) !important; font-family: monospace; }
        .custom-date-icon { color: var(--text-muted) !important; margin-right: 4px; }

        .book-bold-meta { font-weight: 600; color: var(--text-dark-override) !important; }
        .student-profile-anchor { display: flex; align-items: center; gap: 10px; }
        .student-avatar-mock { width: 32px; height: 32px; border-radius: 50%; background: #4f46e5; color: white; display: flex; align-items: center; justify-content: center; font-size: 12px; font-weight: 600; }

        /* STATUS BADGE PIPELINE */
        .status-pipeline-badge {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 6px 14px; border-radius: 100px; font-size: 12px; font-weight: 600;
            text-transform: uppercase; letter-spacing: 0.5px;
        }
        .badge-active-issued { background: rgba(79, 70, 229, 0.1); color: #4f46e5; }
        .badge-safe-returned { background: rgba(34, 197, 94, 0.1); color: #22c55e; }
        .badge-critical-lost { background: rgba(239, 68, 68, 0.1); color: #ef4444; }

        /* TOOLBAR PIPELINE CONTROLS */
        .table-toolbar-panel {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 22px; flex-wrap: wrap; gap: 15px;
        }

        /* PREMIUM MODERN SEARCH BOX STYLE LINKED TO MAIN PANELS */
        .search-container-box {
            background: var(--card-bg); border-radius: 12px; padding: 4px;
            border: 1px solid var(--border-color); transition: all 0.3s ease; max-width: 350px; width: 100%;
        }
        .search-control { position: relative; display: flex; align-items: center; }
        .search-control i { position: absolute; left: 18px; color: var(--text-muted); font-size: 16px; }
        .search-control .form-control {
            height: 42px; padding-left: 48px; padding-right: 18px; border-radius: 10px; border: none !important;
            background-color: transparent !important; color: var(--text-main) !important; font-size: 14px; box-shadow: none !important;
        }
        .search-control .form-control::placeholder { color: var(--text-muted); opacity: 0.7; }
        .search-container-box:has(.form-control:focus) { border-color: var(--primary-color); box-shadow: 0 0 0 4px var(--search-focus-ring), 0 4px 12px rgba(0,0,0,0.03); }
        .search-container-box:has(.form-control:focus) i { color: var(--primary-color); }

        .utility-action-btn {
            padding: 10px 18px; border-radius: 12px; font-size: 13px; font-weight: 600;
            display: inline-flex; align-items: center; gap: 8px; border: 1px solid var(--border-color);
            background: var(--bg-light-override); color: var(--text-main); transition: 0.2s;
            cursor: pointer;
        }
        .utility-action-btn:hover { opacity: 0.85; }

        /* UNSET STATE DESIGN BOUNDARY */
        .empty-dataset-box { text-align: center; padding: 70px 20px; }
        .empty-dataset-box i { font-size: 65px; color: #ef4444; display: block; margin-bottom: 15px; }
        .empty-dataset-box h4 { font-size: 22px; font-weight: 700; color: var(--text-main); }

        @media(max-width: 992px) {
            .sidebar { transform: translateX(-100%); }
            .sidebar.active { transform: translateX(0); }
            .main-content { margin-left: 0; padding: 20px; }
            .mobile-hamburger { display: flex; padding: 10px; }
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
            <a href="${pageContext.request.contextPath}/student/student-issued-books" class="active"><i class="bi bi-journal-bookmark"></i> Issued History</a>
            <a href="${pageContext.request.contextPath}/student/profile"><i class="bi bi-person-circle"></i> My Profile</a>
            <a href="${pageContext.request.contextPath}/auth/logout" class="mt-4 border-top pt-3 text-danger"><i class="bi bi-box-arrow-left"></i> Logout</a>
        </div>
    </div>

    <div class="main-content">

        <div class="modern-topbar">
            <div class="d-flex align-items-center gap-3">
                <button class="control-trigger-btn mobile-hamburger" id="hamburgerMenuTrigger">
                    <i class="bi bi-list"></i>
                </button>
                <h1>Account Issued Registration</h1>
            </div>
            <div class="topbar-right-controls">
                <button class="control-trigger-btn" id="themeToggleBtn">
                    <i class="bi bi-moon-fill" id="themeIcon"></i>
                    <span id="themeText">Dark Mode</span>
                </button>
            </div>
        </div>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible border-0 fade show rounded-4 shadow-sm py-3 px-4 mb-4" role="alert">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-check-circle-fill fs-5 text-success"></i>
                    <div><strong>Success Notification:</strong> ${successMessage}</div>
                </div>
                <button type="button" class="btn-close shadow-none" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible border-0 fade show rounded-4 shadow-sm py-3 px-4 mb-4" role="alert">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-exclamation-octagon-fill fs-5 text-danger"></i>
                    <div><strong>Operation Alert:</strong> ${errorMessage}</div>
                </div>
                <button type="button" class="btn-close shadow-none" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="glass-table-card">

            <div class="table-toolbar-panel">
                <div class="search-container-box">
                    <div class="search-control">
                        <i class="bi bi-search"></i>
                        <input type="text" id="ledgerSearchInput" class="form-control" placeholder="Filter ledger records...">
                    </div>
                </div>
                <div class="d-flex gap-2 align-items-center">
                    <div class="text-end text-muted small me-2" id="searchFeedback">Syncing records...</div>
                    <button class="utility-action-btn" onclick="window.print()"><i class="bi bi-printer"></i> Print Statement</button>
                    <button class="utility-action-btn" id="exportToCsvTrigger"><i class="bi bi-filetype-csv"></i> Export CSV</button>
                </div>
            </div>

            <div class="table-responsive">
                <table class="premium-data-table align-middle" id="issuedLedgerTable">
                    <thead>
                        <tr>
                            <th>Student ID</th>
                            <th>Name</th>
                            <th>Registration Number</th>
                            <th>Book Title</th>
                            <th>Issue Date</th>
                            <th>Return Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty issuedBooks}">
                                <c:forEach items="${issuedBooks}" var="issue">
                                    <tr class="ledger-data-row">
                                        <td class="custom-id-text search-target">#TXN-${issue.id}</td>
                                        <td>
                                            <div class="student-profile-anchor">
                                                <div class="student-avatar-mock">
                                                    <c:choose>
                                                        <c:when test="${not empty issue.studentName}">
                                                            <c:out value="${fn:substring(issue.studentName, 0, 1)}"/>
                                                        </c:when>
                                                        <c:otherwise>S</c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <span class="fw-medium target-full-name search-target">${issue.studentName}</span>
                                            </div>
                                        </td>
                                        <td class="custom-reg-text search-target">${issue.rollNumber}</td>
                                        <td class="book-bold-meta search-target">${issue.bookName}</td>
                                        <td><i class="bi bi-calendar2-event custom-date-icon"></i> ${issue.issueDate}</td>
                                        <td><i class="bi bi-calendar-x custom-date-icon"></i> ${issue.returnDate}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${issue.status eq 'ISSUED'}">
                                                    <span class="status-pipeline-badge badge-active-issued"><i class="bi bi-clock-history"></i> Issued</span>
                                                </c:when>
                                                <c:when test="${issue.status eq 'RETURNED'}">
                                                    <span class="status-pipeline-badge badge-safe-returned"><i class="bi bi-shield-check"></i> Returned</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-pipeline-badge badge-critical-lost"><i class="bi bi-patch-question"></i> ${issue.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7">
                                        <div class="empty-dataset-box">
                                            <i class="bi bi-folder-symlink"></i>
                                            <h4>No active allocations allocated.</h4>
                                            <p class="text-muted small">Your current operational ledger parameters have detected zero issued accounts.</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
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

        const savedTheme = localStorage.getItem('theme') || 'light';
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

        // =====================================
        // CLIENT LIVE FILTER SEARCH
        // =====================================
        const ledgerSearchInput = document.getElementById('ledgerSearchInput');
        const feedbackNode = document.getElementById('searchFeedback');

        function updateFeedback(total, visible) {
            if(feedbackNode) {
                feedbackNode.textContent = searchInput.value === "" ?
                    `Showing all ${total} records` : `Found ${visible} matching entries`;
            }
        }

        if(ledgerSearchInput) {
            ledgerSearchInput.addEventListener('keyup', function() {
                const criteriaQuery = this.value.toLowerCase().trim();
                const ledgerRows = document.querySelectorAll('.ledger-data-row');
                let visibleCount = 0;

                ledgerRows.forEach(row => {
                    const targets = row.querySelectorAll('.search-target');
                    let textMatch = (criteriaQuery === '');

                    targets.forEach(target => {
                        if (target.textContent.toLowerCase().includes(criteriaQuery)) {
                            textMatch = true;
                        }
                    });

                    if(textMatch) {
                        row.style.display = '';
                        visibleCount++;
                    } else {
                        row.style.display = 'none';
                    }
                });

                if(feedbackNode) {
                    feedbackNode.textContent = criteriaQuery === "" ?
                        `Showing all ${ledgerRows.length} records` : `Found ${visibleCount} matching entries`;
                }
            });
        }

        // CSV EXPORT PROCESSING ENGINE
        const exportToCsvTrigger = document.getElementById('exportToCsvTrigger');
        if(exportToCsvTrigger) {
            exportToCsvTrigger.addEventListener('click', () => {
                let sequentialCsvBuffer = [];
                const targetedTableRows = document.querySelectorAll("#issuedLedgerTable tr");

                for (let idx = 0; idx < targetedTableRows.length; idx++) {
                    if(targetedTableRows[idx].offsetParent === null) continue; // Skip filtered elements
                    let rowDataAccumulator = [];
                    const columnCells = targetedTableRows[idx].querySelectorAll("td, th");

                    for (let cIdx = 0; cIdx < columnCells.length; cIdx++) {
                        let standardSanitizedText = "";
                        const fullNameNode = columnCells[cIdx].querySelector('.target-full-name');
                        if (fullNameNode) {
                            standardSanitizedText = fullNameNode.innerText.replace(/"/g, '""').trim();
                        } else {
                            standardSanitizedText = columnCells[cIdx].innerText.replace(/"/g, '""').trim();
                        }
                        rowDataAccumulator.push('"' + standardSanitizedText + '"');
                    }
                    sequentialCsvBuffer.push(rowDataAccumulator.join(","));
                }

                const compiledCsvStream = new Blob([sequentialCsvBuffer.join("\n")], { type: 'text/csv;charset=utf-8;' });
                const temporaryDownloadNode = document.createElement("a");
                temporaryDownloadNode.href = URL.createObjectURL(compiledCsvStream);
                temporaryDownloadNode.setAttribute("download", "LMS_Issued_Books_Statement.csv");
                document.body.appendChild(temporaryDownloadNode);
                temporaryDownloadNode.click();
                document.body.removeChild(temporaryDownloadNode);
            });
        }
    });
</script>
</body>
</html>

