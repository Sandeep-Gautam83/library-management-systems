<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Return Book | LMS</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg-body: #f8fafc;
            --bg-card: #ffffff;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --sidebar-gradient: linear-gradient(145deg, #0f172a, #1e293b);
            --border-color: #e2e8f0;
            --hover-row: #f1f5f9;
        }

        [data-bs-theme="dark"] {
            --bg-body: #0b0f19;
            --bg-card: #111827;
            --text-main: #f9fafb;
            --text-muted: #9ca3af;
            --sidebar-gradient: linear-gradient(145deg, #030712, #111827);
            --border-color: #374151;
            --hover-row: #1f2937;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', 'Poppins', sans-serif;
        }

        body {
            background-color: var(--bg-body);
            color: var(--text-main);
            overflow-x: hidden;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .sidebar {
            width: 280px;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            background: var(--sidebar-gradient);
            padding: 30px 20px;
            overflow-y: auto;
            z-index: 100;
            box-shadow: 4px 0 24px rgba(0, 0, 0, 0.15);
            transition: all 0.3s ease;
        }

        .sidebar h2 {
            color: #ffffff;
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 40px;
            padding-left: 10px;
            letter-spacing: 0.5px;
        }

        .sidebar a {
            display: flex;
            align-items: center;
            gap: 14px;
            color: #94a3b8;
            text-decoration: none;
            padding: 12px 16px;
            margin-bottom: 8px;
            border-radius: 12px;
            transition: all 0.2s ease;
            font-size: 15px;
            font-weight: 500;
        }

        .sidebar a:hover {
            background: rgba(255, 255, 255, 0.05);
            color: #f8fafc;
        }

        .sidebar a.active {
            background: #2563eb;
            color: #ffffff;
            box-shadow: 0 4px 14px rgba(37, 99, 235, 0.4);
        }

        .main-content {
            margin-left: 280px;
            padding: 40px;
            min-height: 100vh;
            transition: all 0.3s ease;
        }

        .premium-card {
            background-color: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 30px -10px rgba(0, 0, 0, 0.05);
            margin-bottom: 30px;
            transition: background-color 0.3s, border-color 0.3s;
        }

        .topbar h3 {
            font-weight: 700;
            font-size: 28px;
            margin: 0;
            color: var(--text-main);
        }

        .theme-toggle-btn {
            background: var(--hover-row);
            border: 1px solid var(--border-color);
            color: var(--text-main);
            padding: 10px 16px;
            border-radius: 12px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
            transition: all 0.2s;
        }

        .flow-title {
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 25px;
            color: var(--text-main);
        }

        .flow-container {
            display: grid;
            grid-template-columns: 1fr auto 1fr auto 1fr auto 1fr;
            align-items: center;
            gap: 15px;
        }

        .flow-step {
            background: var(--hover-row);
            border: 1px solid var(--border-color);
            padding: 20px 15px;
            border-radius: 16px;
            text-align: center;
            font-weight: 600;
            font-size: 14px;
            color: var(--text-main);
            transition: all 0.3s;
        }

        .flow-step i {
            font-size: 28px;
            color: #2563eb;
            margin-bottom: 8px;
            display: block;
        }

        .flow-arrow {
            font-size: 22px;
            color: #2563eb;
            text-align: center;
        }

        .table thead th {
            background-color: var(--hover-row);
            color: var(--text-muted);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 12px;
            letter-spacing: 0.5px;
            padding: 16px;
            border-bottom: 1px solid var(--border-color);
        }

        .table tbody td {
            padding: 18px 16px;
            color: var(--text-main);
            border-bottom: 1px solid var(--border-color);
            font-size: 14px;
            vertical-align: middle;
        }

        .table tbody tr:hover {
            background-color: var(--hover-row);
        }

        .status-badge {
            padding: 6px 14px;
            border-radius: 50px;
            font-size: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .badge-issued { background-color: rgba(239, 68, 68, 0.15); color: #ef4444; }
        .badge-returned { background-color: rgba(34, 197, 94, 0.15); color: #22c55e; }

        .due-date {
            background-color: rgba(245, 158, 11, 0.12);
            color: #f59e0b;
            padding: 5px 12px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 13px;
        }

        .fine-amount { color: #ef4444; font-weight: 700; font-size: 15px;}
        .no-fine { color: #22c55e; font-weight: 600; }

        .btn-return {
            border-radius: 10px;
            padding: 8px 16px;
            font-size: 13px;
            font-weight: 600;
            box-shadow: 0 4px 12px rgba(34, 197, 94, 0.2);
            text-decoration: none;
        }

        @media (max-width: 1200px) {
            .flow-container {
                grid-template-columns: 1fr;
                gap: 10px;
            }
            .flow-arrow {
                transform: rotate(90deg);
                margin: 5px 0;
            }
        }

        @media (max-width: 992px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
                padding: 20px;
            }
            .sidebar h2 { margin-bottom: 20px; }
            .main-content { margin-left: 0; padding: 20px; }
        }
    </style>
</head>
<body>

<div class="sidebar">
    <h2><i class="bi bi-columns-gap me-2"></i> LMS Pro</h2>
    <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2"></i> Dashboard</a>
    <a href="${pageContext.request.contextPath}/admin/books"><i class="bi bi-book"></i> View Books</a>
    <a href="${pageContext.request.contextPath}/admin/add-book"><i class="bi bi-plus-circle"></i> Add Book</a>
    <a href="${pageContext.request.contextPath}/admin/issue-book"><i class="bi bi-journal-check"></i> Issue Book</a>
    <a href="${pageContext.request.contextPath}/admin/issue-book/return-book" class="active"><i class="bi bi-arrow-return-left"></i> Return Book</a>
    <a href="${pageContext.request.contextPath}/student-issued-books"><i class="bi bi-journal-bookmark"></i> Issued Books</a>
    <a href="${pageContext.request.contextPath}/auth/logout" class="mt-4 text-danger"><i class="bi bi-box-arrow-right"></i> Logout</a>
</div>

<div class="main-content">

    <div class="premium-card d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
        <div class="topbar">
            <h3>Return Book Panel</h3>
            <p class="text-muted m-0 font-size-14">Manage and track library asset returns efficiently.</p>
        </div>
        <div class="d-flex align-items-center gap-3">
            <button class="theme-toggle-btn" id="themeToggle" aria-label="Toggle Theme">
                <i class="bi bi-moon-stars-fill" id="themeIcon"></i>
                <span id="themeText">Dark Mode</span>
            </button>
            <a href="${pageContext.request.contextPath}/admin/issue-book" class="btn btn-primary px-4 py-2" style="border-radius:12px; font-weight:500; text-decoration:none;">
                <i class="bi bi-journal-check me-2"></i> Issue Book
            </a>
        </div>
    </div>

    <div class="premium-card">
        <div class="flow-title"><i class="bi bi-info-circle me-2 text-primary"></i>Fine Automation Flowchart</div>
        <div class="flow-container">
            <div class="flow-step">
                <i class="bi bi-journal-plus"></i>
                Issue Book
            </div>
            <div class="flow-arrow"><i class="bi bi-chevron-right"></i></div>
            <div class="flow-step">
                <i class="bi bi-arrow-return-left"></i>
                Trigger Return
            </div>
            <div class="flow-arrow"><i class="bi bi-chevron-right"></i></div>
            <div class="flow-step">
                <i class="bi bi-calendar-check"></i>
                Validate Timeline
            </div>
            <div class="flow-arrow"><i class="bi bi-chevron-right"></i></div>
            <div class="flow-step" style="background: rgba(37,99,235,0.08); border-color: #2563eb;">
                <i class="bi bi-cash-coin" style="color:#2563eb;"></i>
                Auto Calculation
            </div>
        </div>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm p-3 mb-4" style="border-radius: 14px;">
            <div class="d-flex align-items-center gap-2">
                <i class="bi bi-check-circle-fill font-size-18"></i>
                <div>${success}</div>
            </div>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm p-3 mb-4" style="border-radius: 14px;">
            <div class="d-flex align-items-center gap-2">
                <i class="bi bi-exclamation-triangle-fill font-size-18"></i>
                <div>${error}</div>
            </div>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="premium-card">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Student Name</th>
                    <th>Roll Number</th>
                    <th>Book Details</th>
                    <th>Issue Date</th>
                    <th>Due Date</th>
                    <th>Return Date</th>
                    <th>Status</th>
                    <th>Fine Assessment</th>
                    <th class="text-end">Action</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty issuedBooks}">
                        <c:forEach items="${issuedBooks}" var="issue">
                            <tr>
                                <td class="fw-bold text-muted">${issue.id}</td>
                                <td class="fw-semibold">${issue.studentName}</td>
                                <td><span class="badge bg-secondary bg-opacity-10 text-secondary px-2 py-1">${issue.rollNumber}</span></td>
                                <td class="fw-medium">${issue.bookName}</td>
                                <td>${issue.issueDate}</td>
                                <td>
                                    <span class="due-date">
                                        ${issue.dueDate}
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty issue.returnDate}">
                                            <span class="fw-medium">${issue.returnDate}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted italic opacity-50">Pending</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${issue.status == 'RETURNED'}">
                                            <span class="status-badge badge-returned">
                                                <span class="spinner-grow spinner-grow-sm" style="animation-duration: 3s;"></span> RETURNED
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge badge-issued">
                                                <i class="bi bi-dot font-size-18"></i> ISSUED
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${issue.fine != null && issue.fine > 0}">
                                            <span class="fine-amount">₹ ${issue.fine}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="no-fine"><i class="bi bi-shield-check me-1"></i> Clear</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end">
                                    <c:if test="${issue.status != 'RETURNED'}">
                                        <a href="${pageContext.request.contextPath}/admin/issue-book/return/${issue.id}"
                                           class="btn btn-success btn-sm btn-return"
                                           onclick="return confirm('Are you sure you want to process this book return?')">
                                            <i class="bi bi-box-arrow-in-left me-1"></i> Return Asset
                                        </a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="10" class="text-center py-5 text-danger fw-medium">
                                <i class="bi bi-folder-x display-6 d-block mb-3 opacity-50"></i>
                                active circulation logs context not found.
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
    const themeToggleBtn = document.getElementById('themeToggle');
    const themeIcon = document.getElementById('themeIcon');
    const themeText = document.getElementById('themeText');
    const htmlElement = document.documentElement;

    const savedTheme = localStorage.getItem('theme') || 'light';
    setTheme(savedTheme);

    themeToggleBtn.addEventListener('click', () => {
        const currentTheme = htmlElement.getAttribute('data-bs-theme');
        const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
        setTheme(newTheme);
    });

    function setTheme(theme) {
        htmlElement.setAttribute('data-bs-theme', theme);
        localStorage.setItem('theme', theme);

        if (theme === 'dark') {
            themeIcon.className = 'bi bi-sun-fill text-warning';
            themeText.textContent = 'Light Mode';
        } else {
            themeIcon.className = 'bi bi-moon-stars-fill';
            themeText.textContent = 'Dark Mode';
        }
    }
</script>
</body>
</html>