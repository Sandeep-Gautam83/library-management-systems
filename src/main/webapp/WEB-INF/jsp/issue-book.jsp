<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%
    Object admin = session.getAttribute("loggedInUser");
    if(admin == null){
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Issue Book | LMS Admin</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root[data-theme="light"] {
            --bg-main: #f8fafc;
            --bg-card: #ffffff;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border-color: #cbd5e1;
            --input-bg: #ffffff;
            --table-row-bg: #ffffff;
            --search-hover: #f1f5f9;
            --input-placeholder: #94a3b8;
            --color-scheme: light;
        }

        :root[data-theme="dark"] {
            --bg-main: #0f172a;
            --bg-card: #1e293b;
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --border-color: #334155;
            --input-bg: #1e293b;
            --table-row-bg: #1e293b;
            --search-hover: #334155;
            --input-placeholder: #64748b;
            --color-scheme: dark;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
            transition: background-color 0.3s ease, border-color 0.3s ease, color 0.3s ease;
        }

        body {
            background: var(--bg-main);
            color: var(--text-main);
            min-height: 100vh;
        }

        .main-content {
            padding: 40px 30px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .top-navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 35px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .top-buttons {
            display: flex;
            gap: 12px;
        }

        .btn-custom {
            padding: 12px 22px;
            border: none;
            border-radius: 12px;
            text-decoration: none;
            color: white !important;
            font-weight: 500;
            font-size: 14px;
            transition: all 0.2s ease-in-out;
            display: flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .btn-home { background: #475569; }
        .btn-return { background: #2563eb; }
        .btn-theme-toggle {
            background: var(--bg-card);
            color: var(--text-main) !important;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            width: 45px;
            height: 45px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }

        .btn-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            filter: brightness(1.1);
        }

        .card-box {
            background: var(--bg-card) !important;
            border-radius: 20px;
            padding: 35px;
            border: 1px solid var(--border-color) !important;
            box-shadow: 0 4px 20px rgba(0,0,0,0.02);
            margin-bottom: 35px;
        }

        .card-title {
            font-size: 24px;
            font-weight: 600;
            color: var(--text-main);
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .card-title i {
            color: #2563eb;
        }

        .form-label {
            font-weight: 500;
            margin-bottom: 8px;
            color: var(--text-main);
            font-size: 14px;
        }

        .form-control {
            height: 52px;
            border-radius: 12px;
            border: 1px solid var(--border-color);
            background-color: var(--input-bg) !important;
            color: var(--text-main) !important;
            font-size: 15px;
            padding: 0 18px;
            color-scheme: var(--color-scheme) !important;
        }

        .form-control::placeholder {
            color: var(--input-placeholder) !important;
            opacity: 1;
        }

        .form-control:focus {
            background-color: var(--input-bg) !important;
            color: var(--text-main) !important;
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.15);
        }

        .btn-issue {
            width: 100%;
            height: 54px;
            border: none;
            border-radius: 12px;
            background: #2563eb;
            color: white;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.2s;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2);
        }

        .btn-issue:hover {
            background: #1d4ed8;
            transform: translateY(-1px);
        }

        .search-container {
            position: relative;
        }

        .search-result-box {
            position: absolute;
            width: 100%;
            background: var(--bg-card);
            border-radius: 12px;
            margin-top: 6px;
            max-height: 250px;
            overflow-y: auto;
            border: 1px solid var(--border-color);
            display: none;
            z-index: 999;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }

        .search-item {
            padding: 12px 16px;
            cursor: pointer;
            border-bottom: 1px solid var(--border-color);
            font-size: 14px;
            color: var(--text-main);
        }

        .search-item:hover {
            background: var(--search-hover);
            color: #2563eb;
        }

        .table-box {
            overflow-x: auto;
        }

        .custom-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 8px;
            background: transparent !important;
        }

        .custom-table th {
            background: transparent !important;
            color: var(--text-muted) !important;
            padding: 16px;
            font-size: 13px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border: none !important;
        }

        .custom-table tbody tr {
            background: var(--table-row-bg) !important;
        }

        .custom-table td {
            padding: 18px 16px;
            vertical-align: middle;
            color: var(--text-main) !important;
            background: var(--table-row-bg) !important;
            border-top: 1px solid var(--border-color) !important;
            border-bottom: 1px solid var(--border-color) !important;
        }

        .custom-table td:first-child {
            border-left: 1px solid var(--border-color) !important;
            border-top-left-radius: 12px;
            border-bottom-left-radius: 12px;
            font-weight: 600;
        }

        .custom-table td:last-child {
            border-right: 1px solid var(--border-color) !important;
            border-top-right-radius: 12px;
            border-bottom-right-radius: 12px;
        }

        .text-custom-muted {
            color: var(--text-muted) !important;
        }

        .student-title {
            color: var(--text-main);
            font-weight: 600;
        }

        .book-title-cell {
            color: var(--text-main);
            font-weight: 500;
        }

        .date-badge {
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 500;
            display: inline-block;
        }

        .issue-date { background: rgba(37, 99, 235, 0.1) !important; color: #2563eb !important; }
        .due-date { background: rgba(217, 119, 6, 0.1) !important; color: #d97706 !important; }
        .return-date { background: rgba(22, 163, 74, 0.1) !important; color: #16a34a !important; }

        .status-badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }

        .badge-issued { background: rgba(37, 99, 235, 0.15) !important; color: #2563eb !important; }
        .badge-returned { background: rgba(22, 163, 74, 0.15) !important; color: #16a34a !important; }
        .badge-overdue { background: rgba(220, 38, 38, 0.15) !important; color: #dc2626 !important; }

        .fine-badge { background: rgba(220, 38, 38, 0.1) !important; color: #dc2626 !important; padding: 6px 12px; border-radius: 8px; font-weight: 600; }
        .no-fine { background: rgba(22, 163, 74, 0.1) !important; color: #16a34a !important; padding: 6px 12px; border-radius: 8px; font-weight: 500; }

        .empty-box {
            text-align: center;
            padding: 50px 20px;
            color: var(--text-muted);
            font-size: 16px;
        }

        @media(max-width: 768px){
            .main-content { padding: 20px 15px; }
            .card-box { padding: 20px; }
            .top-navbar { flex-direction: column; align-items: stretch; }
            .top-buttons { width: 100%; }
            .btn-custom { flex: 1; justify-content: center; }
        }
    </style>
</head>
<body>

<div class="main-content">

    <div class="top-navbar">
        <div class="top-buttons">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-custom btn-home">
                <i class="bi bi-house-door-fill"></i> Back To Home
            </a>
            <a href="${pageContext.request.contextPath}/admin/issue-book/return-book" class="btn-custom btn-return">
                <i class="bi bi-arrow-return-left"></i> Return Book
            </a>
        </div>
        <button class="btn-theme-toggle" id="themeToggleBtn" title="Toggle Theme">
            <i class="bi bi-moon-fill" id="themeIcon"></i>
        </button>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4" style="border-radius: 12px;">
            <i class="bi bi-check-circle-fill me-2"></i> ${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm mb-4" style="border-radius: 12px;">
            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="card-box">
        <h2 class="card-title">
            <i class="bi bi-journal-arrow-up"></i> Issue New Book
        </h2>

        <form action="${pageContext.request.contextPath}/admin/issue-book/save" method="post">
            <div class="row">
                <div class="col-md-6 mb-4 search-container">
                    <label class="form-label">Search Student</label>
                    <input type="text" id="studentSearch" class="form-control" placeholder="Type student name or roll no..." autocomplete="off" required>
                    <input type="hidden" name="studentId" id="studentId">

                    <div id="studentResult" class="search-result-box">
                        <c:forEach items="${students}" var="student">
                            <div class="search-item student-item" data-id="${student.id}" data-name="${student.fullName} - ${student.rollNumber}">
                                <i class="bi bi-person me-2"></i> ${student.fullName} <span class="text-custom-muted">(${student.rollNumber})</span>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <div class="col-md-6 mb-4 search-container">
                    <label class="form-label">Search Book</label>
                    <input type="text" id="bookSearch" class="form-control" placeholder="Type book title..." autocomplete="off" required>
                    <input type="hidden" name="bookId" id="bookId">

                    <div id="bookResult" class="search-result-box">
                        <c:forEach items="${books}" var="book">
                            <div class="search-item book-item" data-id="${book.id}" data-name="${book.bookName}">
                                <i class="bi bi-book me-2"></i> ${book.bookName}
                                <span class="badge bg-success ms-2" style="font-size: 11px;">Qty: ${book.availableQuantity}</span>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <div class="col-md-6 mb-4">
                    <label class="form-label">Issue Date</label>
                    <input type="date" name="issueDate" id="issueDate" class="form-control" required>
                </div>

                <div class="col-md-6 mb-4">
                    <label class="form-label">Return Date</label>
                    <input type="date" name="returnDate" id="returnDate" class="form-control" required>
                </div>
            </div>

            <button type="submit" class="btn-issue mt-2">
                <i class="bi bi-journal-check me-2"></i> Issue Book To Student
            </button>
        </form>
    </div>

    <div class="card-box">
        <h2 class="card-title">
            <i class="bi bi-book-half"></i> Issued Books Registry
        </h2>

        <c:choose>
            <c:when test="${empty issuedBooks}">
                <div class="empty-box">
                    <i class="bi bi-inbox fs-1 d-block mb-3 text-custom-muted"></i>
                    No books have been issued yet.
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-box">
                    <table class="table custom-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Student Details</th>
                                <th>Book Title</th>
                                <th>Issue Date</th>
                                <th>Due Date</th>
                                <th>Return Date</th>
                                <th>Fine Status</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${issuedBooks}" var="issue">
                                <tr>
                                    <td><span class="text-custom-muted">#${issue.id}</span></td>
                                    <td>
                                        <div class="student-title">${issue.studentName}</div>
                                        <small class="text-custom-muted">${issue.rollNumber}</small>
                                    </td>
                                    <td class="book-title-cell">${issue.bookName}</td>
                                    <td><span class="date-badge issue-date">${issue.issueDate}</span></td>
                                    <td><span class="date-badge due-date">${issue.dueDate}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty issue.returnDate}">
                                                <span class="date-badge return-date">${issue.returnDate}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-custom-muted" style="font-style: italic; font-size: 13px;">Pending</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${issue.fine > 0}">
                                                <span class="fine-badge">₹ ${issue.fine}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="no-fine">No Fine</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${issue.fine > 0}">
                                                <span class="status-badge badge-overdue">OVERDUE</span>
                                            </c:when>
                                            <c:when test="${issue.status == 'RETURNED'}">
                                                <span class="status-badge badge-returned">RETURNED</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge badge-issued">ISSUED</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    const themeToggleBtn = document.getElementById("themeToggleBtn");
    const themeIcon = document.getElementById("themeIcon");
    const htmlEl = document.documentElement;

    function setTheme(theme) {
        htmlEl.setAttribute("data-theme", theme);
        if (theme === "dark") {
            themeIcon.className = "bi bi-sun-fill";
        } else {
            themeIcon.className = "bi bi-moon-fill";
        }
    }

    const savedTheme = localStorage.getItem("lms-theme");
    const systemPrefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches;

    if (savedTheme === "dark" || (!savedTheme && systemPrefersDark)) {
        setTheme("dark");
    } else {
        setTheme("light");
    }

    themeToggleBtn.addEventListener("click", () => {
        const currentTheme = htmlEl.getAttribute("data-theme");
        if (currentTheme === "light") {
            setTheme("dark");
            localStorage.setItem("lms-theme", "dark");
        } else {
            setTheme("light");
            localStorage.setItem("lms-theme", "light");
        }
    });

    const issueDate = document.getElementById("issueDate");
    const returnDate = document.getElementById("returnDate");

    window.onload = function () {
        let today = new Date();
        let year = today.getFullYear();
        let month = String(today.getMonth() + 1).padStart(2, '0');
        let day = String(today.getDate()).padStart(2, '0');
        let currentDate = year + "-" + month + "-" + day;

        issueDate.value = currentDate;
        issueDate.min = currentDate;
        issueDate.max = currentDate;
        returnDate.min = currentDate;
    };

    function setupSearch(inputId, resultId, itemClass, hiddenId) {
        const input = document.getElementById(inputId);
        const resultBox = document.getElementById(resultId);
        const items = document.querySelectorAll(itemClass);
        const hiddenInput = document.getElementById(hiddenId);

        input.addEventListener("keyup", function () {
            let value = this.value.toLowerCase().trim();
            if(value === "") {
                resultBox.style.display = "none";
                return;
            }

            let hasResults = false;
            resultBox.style.display = "block";

            items.forEach(function(item){
                let text = item.innerText.toLowerCase();
                if(text.includes(value)){
                    item.style.display = "block";
                    hasResults = true;
                } else {
                    item.style.display = "none";
                }
            });

            if(!hasResults) resultBox.style.display = "none";
        });

        items.forEach(function(item){
            item.addEventListener("click", function () {
                input.value = this.getAttribute("data-name");
                hiddenInput.value = this.getAttribute("data-id");
                resultBox.style.display = "none";
            });
        });
    }

    setupSearch("studentSearch", "studentResult", ".student-item", "studentId");
    setupSearch("bookSearch", "bookResult", ".book-item", "bookId");

    document.addEventListener("click", function(e){
        if(!document.getElementById("studentSearch").contains(e.target) && !document.getElementById("studentResult").contains(e.target)){
            document.getElementById("studentResult").style.display = "none";
        }
        if(!document.getElementById("bookSearch").contains(e.target) && !document.getElementById("bookResult").contains(e.target)){
            document.getElementById("bookResult").style.display = "none";
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>