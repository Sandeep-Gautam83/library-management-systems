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
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Approve Student Information List | LMS Premium Admin</title>

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
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', 'Poppins', sans-serif;
        }

        body {
            background-color: var(--bg-body) !important;
            color: var(--text-main) !important;
            overflow-x: hidden;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        /* =====================================
           SIDEBAR STYLE (Always Dark Modern)
        ===================================== */
        .sidebar {
            width: 280px;
            height: 100vh;
            background: var(--sidebar-bg);
            position: fixed;
            top: 0;
            left: 0;
            z-index: 1000;
            padding: 30px 20px;
            transition: all 0.3s ease;
            box-shadow: 4px 0 24px rgba(0,0,0,0.05);
        }

        .logo {
            padding: 0 10px;
            margin-bottom: 40px;
        }

        .logo h2 {
            color: #fff;
            font-size: 22px;
            font-weight: 700;
            letter-spacing: -0.5px;
            margin-bottom: 4px;
        }

        .logo p {
            color: #64748b;
            font-size: 13px;
            margin: 0;
        }

        .sidebar-nav {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .sidebar a {
            display: flex;
            align-items: center;
            gap: 14px;
            color: #94a3b8;
            text-decoration: none;
            padding: 12px 16px;
            border-radius: 10px;
            font-weight: 500;
            font-size: 14px;
            transition: all 0.2s ease-in-out;
        }

        .sidebar a:hover {
            background: var(--sidebar-hover);
            color: #fff;
        }

        .sidebar a.active {
            background: var(--primary-color);
            color: #fff;
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
        }

        /* =====================================
           MAIN CONTENT & TOPBAR
        ===================================== */
        .main-content {
            margin-left: 280px;
            padding: 40px;
            min-height: 100vh;
            transition: all 0.3s ease;
        }

        .topbar {
            background: var(--card-bg);
            padding: 24px 32px;
            border-radius: 16px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02), 0 10px 20px -5px rgba(0,0,0,0.03);
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }

        .topbar h3 {
            font-size: 24px;
            font-weight: 700;
            color: var(--text-dark-override) !important;
            margin-bottom: 4px;
        }

        .topbar p {
            color: var(--text-muted) !important;
            margin: 0;
            font-size: 14px;
        }

        .theme-toggle-btn {
            background: var(--bg-light-override);
            color: var(--text-main);
            border: 1px solid var(--border-color);
            padding: 10px 18px;
            border-radius: 10px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s ease;
        }

        /* =====================================
           PREMIUM MODERN SEARCH BOX STYLE
        ===================================== */
        .search-container-box {
            background: var(--card-bg);
            border-radius: 12px;
            padding: 4px;
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
            max-width: 450px;
            width: 100%;
        }

        .search-control {
            position: relative;
            display: flex;
            align-items: center;
        }

        .search-control i {
            position: absolute;
            left: 18px;
            color: var(--text-muted);
            font-size: 16px;
            transition: color 0.3s ease;
        }

        .search-control .form-control {
            height: 48px;
            padding-left: 48px;
            padding-right: 18px;
            border-radius: 10px;
            border: none !important;
            background-color: transparent !important;
            color: var(--text-main) !important;
            font-size: 14px;
            font-weight: 400;
            box-shadow: none !important;
        }

        .search-control .form-control::placeholder {
            color: var(--text-muted);
            opacity: 0.7;
        }

        .search-container-box:has(.form-control:focus) {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px var(--search-focus-ring), 0 4px 12px rgba(0,0,0,0.03);
        }

        .search-container-box:has(.form-control:focus) i {
            color: var(--primary-color);
        }

        /* =====================================
           TABLE DESIGN ALIGNED WITH IMAGE
        ===================================== */
        .table-section {
            background: var(--card-bg);
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02), 0 10px 20px -5px rgba(0,0,0,0.03);
            transition: background-color 0.3s ease;
        }

        .table {
            margin-bottom: 0;
            color: var(--text-main) !important;
            border-color: var(--border-color) !important;
        }

        .table thead {
            background-color: var(--table-thead-bg) !important;
        }

        .table th {
            color: var(--table-thead-text) !important;
            font-weight: 600;
            font-size: 14px;
            letter-spacing: 0.3px;
            padding: 18px 16px;
            border-bottom: none !important;
            background: transparent !important;
        }

        .table td {
            padding: 16px;
            font-size: 14px;
            color: var(--text-main) !important;
            border-bottom: 1px solid var(--border-color) !important;
            white-space: nowrap;
            background: transparent !important;
        }

        .table-hover tbody tr:hover {
            background-color: var(--table-row-hover) !important;
        }

        .user-id-text {
            color: var(--text-muted) !important;
        }

        .text-muted {
            color: var(--text-muted) !important;
        }

        /* Soft Badge System */
        .badge-soft {
            padding: 6px 12px;
            border-radius: 30px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }

        .badge-student {
            background-color: rgba(16, 185, 129, 0.1);
            color: #10b981;
        }

        .badge-verified {
            background-color: rgba(79, 70, 229, 0.1);
            color: var(--primary-color);
        }

        .btn-modern-delete {
            background: rgba(239, 68, 68, 0.1);
            color: #ef4444;
            border: none;
            padding: 6px 14px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 500;
            transition: all 0.2s;
        }

        .btn-modern-delete:hover {
            background: #dc2626;
            color: #fff;
        }

        /* =====================================
           DARK MODE STABLE CONFIRMATION MODAL
        ===================================== */
        .modal-content {
            background-color: var(--card-bg) !important;
            color: var(--text-main) !important;
            border: 1px solid var(--border-color) !important;
        }

        .modal-header, .modal-body, .modal-footer {
            color: var(--text-main) !important;
            background-color: var(--card-bg) !important;
        }

        #modalTargetUser {
            color: var(--text-dark-override) !important;
        }

        [data-theme="dark"] .btn-close {
            filter: invert(1) grayscale(1) brightness(2);
        }

        @media(max-width: 991px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
                padding: 20px;
            }
            .main-content {
                margin-left: 0;
                padding: 20px;
            }
            .topbar {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
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
        <a href="${pageContext.request.contextPath}/admin/pending-students">
            <i class="bi bi-person-lines-fill"></i> Pending Approvals
        </a>
        <a href="${pageContext.request.contextPath}/admin/students" class="active">
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
            <h3>Approve Student Information List</h3>
            <p>Monitor, query, and manage all active system accounts.</p>
        </div>
        <div class="d-flex align-items-center gap-3">
            <button id="themeToggleBtn" class="theme-toggle-btn">
                <i id="themeIcon" class="bi bi-moon-fill"></i>
                <span id="themeText">Dark Mode</span>
            </button>
        </div>
    </div>

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

    <div class="table-section">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
            <div class="search-container-box">
                <div class="search-control">
                    <i class="bi bi-search"></i>
                    <input type="text" id="userSearchInput" class="form-control" placeholder="Search students instantly by name, roll, branch...">
                </div>
            </div>
        </div>

        <div class="table-responsive rounded-3">
            <table class="table table-hover align-middle shadow-sm" id="userDatatable">
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
                            <tr class="user-row">
                                <td class="fw-bold user-id-text search-target">#${student.id}</td>
                                <td class="fw-semibold text-dark-override search-target">${student.fullName}</td>
                                <td class="search-target">${student.email}</td>
                                <td>${student.mobileNumber}</td>
                                <td class="fw-medium search-target">${not empty student.rollNumber ? student.rollNumber : 'N/A'}</td>
                                <td class="search-target">${student.course}</td>
                                <td>${student.branch}</td>
                                <td>${student.year} Year</td>
                                <td>
                                    <span class="badge-soft badge-student">STUDENT</span>
                                </td>
                                <td>
                                    <span class="badge-soft badge-verified">
                                        <i class="bi bi-patch-check-fill me-1"></i> ACTIVE
                                    </span>
                                </td>
                                <td class="text-end">
                                    <button type="button"
                                            class="btn btn-modern-delete"
                                            data-bs-toggle="modal"
                                            data-bs-target="#deleteConfirmModal"
                                            data-userid="${student.id}"
                                            data-username="${student.fullName}">
                                        <i class="bi bi-trash-fill me-1"></i> Delete
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="11" class="text-center text-muted py-5">
                                <i class="bi bi-folder-x fs-1 d-block mb-2 text-secondary"></i>
                                <span class="fw-semibold">No student database records found.</span>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius:14px;">
            <div class="modal-header border-0 pt-4 px-4">
                <h5 class="modal-title fw-bold text-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i>Confirm Deletion</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body px-4 pb-4">
                <p class="text-muted mb-0">Are you sure you want to permanently delete student <span id="modalTargetUser" class="fw-bold"></span> ?</p>
            </div>
            <div class="modal-footer border-0 p-3" style="border-top: 1px solid var(--border-color) !important;">
                <button type="button" class="btn btn-sm btn-secondary rounded-2 px-3" data-bs-dismiss="modal">Cancel</button>
                <a id="modalDeleteConfirmBtn" href="#" class="btn btn-sm btn-danger rounded-2 px-3 shadow-sm">Confirm Permanent Delete</a>
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
        // LIVE SEARCH FILTER (Synced Across All Target Columns)
        // =====================================
        const searchInput = document.getElementById('userSearchInput');

        searchInput.addEventListener('keyup', function () {
            const searchVal = this.value.toLowerCase().trim();
            const rows = document.querySelectorAll('#userDatatable tbody .user-row');

            rows.forEach(row => {
                const targets = row.querySelectorAll('.search-target');
                let textMatch = (searchVal === '');

                targets.forEach(target => {
                    if (target.textContent.toLowerCase().includes(searchVal)) {
                        textMatch = true;
                    }
                });

                row.style.display = textMatch ? '' : 'none';
            });
        });

        // MODAL LINK GENERATOR

        const deleteModal = document.getElementById('deleteConfirmModal');
        deleteModal.addEventListener('show.bs.modal', function (event) {
            const button = event.relatedTarget;
            const userId = button.getAttribute('data-userid');
            const userName = button.getAttribute('data-username');

            document.getElementById('modalTargetUser').textContent = userName;

            const contextPath = '${pageContext.request.contextPath}';
            document.getElementById('modalDeleteConfirmBtn').setAttribute('href', contextPath + '/admin/delete-user/' + userId);
        });
    });
</script>
</body>
</html>

