<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // SECURE ADMIN SESSION VALIDATION ENGINE
    Object admin = session.getAttribute("loggedInUser");
    if(admin == null){
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fine Management | LMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        *{
            margin: 0; padding: 0; box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
            transition: background-color 0.3s ease, color 0.3s ease, border-color 0.3s ease;
        }
        [data-bs-theme="light"] {
            --bg-body: #f8fafc; --card-bg: #ffffff;
            --text-main: #0f172a; --text-muted: #64748b; --border-color: #e2e8f0;
        }
        [data-bs-theme="dark"] {
            --bg-body: #0f172a; --card-bg: #1e293b;
            --text-main: #f8fafc; --text-muted: #94a3b8; --border-color: #334155;
        }
        body { background-color: var(--bg-body); padding: 30px; color: var(--text-main); }
        .top-header { display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 20px; margin-bottom: 30px; }
        .page-title { font-size: 34px; font-weight: 700; color: var(--text-main); }
        .page-subtitle { color: var(--text-muted); margin-top: 4px; font-size: 15px; }
        .action-btn { padding: 10px 20px; border-radius: 12px; text-decoration: none; font-weight: 600; display: inline-flex; align-items: center; gap: 8px; transition: 0.2s ease-in-out; }
        .home-btn { background: #2563eb; color: white; }
        .home-btn:hover { background: #1d4ed8; color: white; transform: translateY(-2px); }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stats-card { background: var(--card-bg); border: 1px solid var(--border-color); border-radius: 20px; padding: 24px; display: flex; align-items: center; gap: 20px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05); }
        .stats-icon { width: 55px; height: 55px; border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 24px; }
        .stats-info h3 { font-size: 28px; font-weight: 700; margin-bottom: 2px; color: var(--text-main); }
        .stats-info p { margin: 0; font-size: 14px; color: var(--text-muted); }
        .table-card { background: var(--card-bg); border: 1px solid var(--border-color); border-radius: 24px; padding: 28px; box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.05); }
        .controls-bar { display: flex; justify-content: space-between; align-items: center; gap: 15px; margin-bottom: 25px; flex-wrap: wrap; }
        .search-box { position: relative; max-width: 350px; width: 100%; }
        .search-box i { position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--text-muted); }
        .search-box .form-control { padding-left: 42px; border-radius: 12px; background-color: var(--bg-body); border: 1px solid var(--border-color); color: var(--text-main); }
        .search-box .form-control:focus { box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15); border-color: #2563eb; }
        .table { color: var(--text-main) !important; }
        .table thead th { background-color: #2563eb !important; color: white !important; padding: 16px; font-size: 14px; font-weight: 600; border: none; }
        [data-bs-theme="dark"] .table thead th { background-color: #1d4ed8 !important; }
        .table td { padding: 16px; vertical-align: middle; border-color: var(--border-color); color: var(--text-main); font-size: 14px; }
        .table tbody tr:hover { background-color: rgba(37, 99, 235, 0.04) !important; }
        .status-badge { padding: 6px 14px; border-radius: 30px; font-size: 12px; font-weight: 600; display: inline-block; }
        .status-paid { background-color: rgba(22, 163, 74, 0.15); color: #16a34a; }
        .status-unpaid { background-color: rgba(220, 38, 38, 0.15); color: #dc2626; }
        .fine-amount { font-weight: 700; color: #dc2626; }
        [data-bs-theme="dark"] .fine-amount { color: #f87171; }
        .pay-btn-sm { padding: 8px 14px; border-radius: 10px; font-size: 13px; font-weight: 600; border: none; transition: 0.2s; }
        .empty-box { text-align: center; padding: 60px 20px; color: var(--text-muted); }
        .empty-box i { font-size: 55px; margin-bottom: 15px; }
        .student-roll { font-size: 11px; display: block; color: var(--text-muted); font-weight: 500; }
        @media(max-width: 768px) {
            body { padding: 15px; }
            .top-header { flex-direction: column; align-items: flex-start; }
            .home-btn { width: 100%; justify-content: center; }
            .controls-bar { flex-direction: column; align-items: stretch; }
            .search-box { max-width: 100%; }
        }
    </style>
</head>
<body>

<div class="top-header">
    <div>
        <h1 class="page-title">Fine Management</h1>
        <p class="page-subtitle">Track, monitor, and manage library late fee logs efficiently.</p>
    </div>
    <div class="d-flex gap-2 align-items-center w-sm-100">
        <button id="themeToggleBtn" class="btn btn-outline-secondary action-btn border-0" type="button" title="Toggle Theme">
            <i id="themeIcon" class="bi bi-moon-stars-fill"></i>
        </button>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="action-btn home-btn">
            <i class="bi bi-house-door-fill"></i> Back To Home
        </a>
    </div>
</div>

<div class="stats-grid">
    <div class="stats-card">
        <div class="stats-icon bg-success-subtle text-success">
            <i class="bi bi-currency-rupee"></i>
        </div>
        <div class="stats-info">
            <h3>₹ ${totalAmount != null ? totalAmount : '0.0'}</h3>
            <p>Total Revenue Collected</p>
        </div>
    </div>
    <div class="stats-card">
        <div class="stats-icon bg-warning-subtle text-warning">
            <i class="bi bi-exclamation-triangle-fill"></i>
        </div>
        <div class="stats-info">
            <h3 id="unpaidCount">0</h3>
            <p>Pending Unpaid Records</p>
        </div>
    </div>
</div>

<div class="table-card">
    <div class="controls-bar">
        <div class="search-box">
            <i class="bi bi-search"></i>
            <input type="text" id="tableSearch" class="form-control" placeholder="Search roll, student, book...">
        </div>
        <div class="btn-group" role="group" aria-label="Status Filter Log">
            <button type="button" class="btn btn-sm btn-outline-primary active filter-btn" onclick="filterTable('ALL')">All</button>
            <button type="button" class="btn btn-sm btn-outline-primary filter-btn" onclick="filterTable('PAID')">Paid</button>
            <button type="button" class="btn btn-sm btn-outline-primary filter-btn" onclick="filterTable('UNPAID')">Unpaid</button>
        </div>
    </div>

    <div class="table-responsive">
        <table class="table table-hover align-middle" id="fineTable">
            <thead>
                <tr>
                    <th>Fine ID</th>
                    <th>Student Info</th>
                    <th>Book Details</th>
                    <th>Fine Log Date</th>
                    <th>Fine Amount</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty fineList}">
                        <c:forEach var="fine" items="${fineList}">
                            <tr data-status="${fine.fineStatus}">
                                <td>#FN-${fine.id}</td>
                                <td>
                                    <strong><c:out value="${fine.studentName}"/></strong>
                                    <span class="student-roll"><i class="bi bi-person-badge"></i> Roll: ${fine.rollNumber}</span>
                                </td>
                                <td>
                                    <span><c:out value="${fine.bookName}"/></span>
                                    <small class="d-block text-muted" style="font-size: 11px;">Book ID: ${fine.bookId}</small>
                                </td>
                                <td><i class="bi bi-calendar3"></i> ${fine.fineDate}</td>
                                <td><span class="fine-amount">₹ ${fine.fineAmount}</span></td>
                                <td>
                                    <span class="status-badge ${fine.fineStatus == 'PAID' ? 'status-paid' : 'status-unpaid'}">
                                        ${fine.fineStatus}
                                    </span>
                                </td>
                                <td>
                                    <c:if test="${fine.fineStatus == 'UNPAID'}">
                                        <form action="${pageContext.request.contextPath}/admin/fine/pay" method="POST" style="display:inline;">
                                            <input type="hidden" name="fineId" value="${fine.id}">
                                            <button type="submit" class="btn btn-success pay-btn-sm">
                                                <i class="bi bi-check-circle-fill"></i> Pay Now
                                            </button>
                                        </form>
                                    </c:if>
                                    <c:if test="${fine.fineStatus == 'PAID'}">
                                        <span class="text-success fw-bold"><i class="bi bi-shield-check"></i> Cleared</span>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr id="emptyRow">
                            <td colspan="7">
                                <div class="empty-box">
                                    <i class="bi bi-folder-x"></i>
                                    <h5>No Fine Logs Found</h5>
                                    <p>Everything is clear! No student holds penalty fine records right now.</p>
                                </div>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Theme Switcher Logic
    const themeToggleBtn = document.getElementById('themeToggleBtn');
    const themeIcon = document.getElementById('themeIcon');
    const htmlElement = document.documentElement;

    const currentTheme = localStorage.getItem('theme') || 'light';
    htmlElement.setAttribute('data-bs-theme', currentTheme);
    updateThemeIcon(currentTheme);

    themeToggleBtn.addEventListener('click', () => {
        const activeTheme = htmlElement.getAttribute('data-bs-theme');
        const newTheme = activeTheme === 'light' ? 'dark' : 'light';
        htmlElement.setAttribute('data-bs-theme', newTheme);
        localStorage.setItem('theme', newTheme);
        updateThemeIcon(newTheme);
    });

    function updateThemeIcon(theme) {
        if(theme === 'dark') {
            themeIcon.className = 'bi bi-sun-fill text-warning';
        } else {
            themeIcon.className = 'bi bi-moon-stars-fill';
        }
    }

    // Dynamic Client Unpaid Counter Update
    function calculateUnpaidCount() {
        let rows = document.querySelectorAll('#fineTable tbody tr:not(#emptyRow)');
        let count = 0;
        rows.forEach(row => {
            if(row.getAttribute('data-status') === 'UNPAID') count++;
        });
        document.getElementById('unpaidCount').innerText = count;
    }

    // Live search implementation
    document.getElementById('tableSearch').addEventListener('keyup', function() {
        let filter = this.value.toLowerCase();
        let rows = document.querySelectorAll('#fineTable tbody tr:not(#emptyRow)');
        let visibleRows = 0;

        rows.forEach(row => {
            let text = row.innerText.toLowerCase();
            if(text.includes(filter)) {
                row.style.display = '';
                visibleRows++;
            } else {
                row.style.display = 'none';
            }
        });
        handleEmptyMessage(visibleRows);
    });

    // Filtering status implementation
    function filterTable(status) {
        const buttons = document.querySelectorAll('.filter-btn');
        buttons.forEach(btn => btn.classList.remove('active'));
        if (event && event.target) {
            event.target.classList.add('active');
        }

        let rows = document.querySelectorAll('#fineTable tbody tr:not(#emptyRow)');
        let visibleRows = 0;

        rows.forEach(row => {
            let rowStatus = row.getAttribute('data-status');
            if(status === 'ALL' || rowStatus === status) {
                row.style.display = '';
                visibleRows++;
            } else {
                row.style.display = 'none';
            }
        });
        handleEmptyMessage(visibleRows);
    }

    function handleEmptyMessage(visibleCount) {
        let emptyRow = document.getElementById('emptyRow');
        if(visibleCount === 0) {
            if(!emptyRow) {
                let tbody = document.querySelector('#fineTable tbody');
                let tr = document.createElement('tr');
                tr.id = 'emptyRow';
                tr.innerHTML = `<td colspan="7"><div class="empty-box"><i class="bi bi-search"></i><h5>No Matching Results</h5><p>Try modifying your filters or search text.</p></div></td>`;
                tbody.appendChild(tr);
            } else { emptyRow.style.display = ''; }
        } else if (emptyRow) { emptyRow.style.display = 'none'; }
    }

    document.addEventListener("DOMContentLoaded", () => {
        calculateUnpaidCount();
    });
</script>
</body>
</html>
