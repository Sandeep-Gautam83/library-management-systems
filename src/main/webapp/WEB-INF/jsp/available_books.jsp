<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Server-side Route Protection / Session Integrity Interceptor
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
    <title>Available Books | Enterprise LMS Portal</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2 family=Inter:wght@300;400;500;600;700&family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet">
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
            --card-book-bg: #ffffff;
            --search-focus-ring: rgba(79, 70, 229, 0.15);
        }

        [data-theme="dark"] {
            --bg-body: #0f172a;
            --card-bg: #1e293b;
            --text-main: #f1f5f9;
            --text-muted: #cbd5e1;
            --border-color: #334155;
            --text-dark-override: #f1f5f9;
            --bg-light-override: #0f172a;
            --table-thead-bg: #0b0f19;
            --table-thead-text: #ffffff;
            --table-row-hover: #1e293b;
            --card-book-bg: #1e293b;
            --search-focus-ring: rgba(79, 70, 229, 0.3);
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
            padding: 40px;
        }

        /* Glassmorphic Blocks */
        .glass-panel {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02), 0 10px 20px -5px rgba(0,0,0,0.03);
            padding: 28px 32px;
            margin-bottom: 28px;
        }

        .page-header {
            display: flex; justify-content: space-between;
            align-items: center; flex-wrap: wrap; gap: 18px;
        }

        .page-title {
            font-size: 24px; font-weight: 700; color: var(--text-dark-override) !important;
            display: flex; align-items: center; gap: 14px; margin: 0;
        }

        .page-title i {
            color: var(--primary-color);
        }

        /* Interactive Controls */
        .action-button {
            background: var(--primary-color); color: #ffffff !important;
            text-decoration: none; padding: 12px 24px; border-radius: 10px;
            font-size: 14px; font-weight: 600; display: inline-flex;
            align-items: center; gap: 8px; border: none; transition: 0.3s;
        }

        .action-button:hover {
            background: var(--primary-hover); transform: translateY(-2px); box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
        }

        .btn-theme-toggle {
            background: var(--bg-light-override); color: var(--text-main);
            border: 1px solid var(--border-color); border-radius: 10px;
            width: 48px; height: 48px; display: flex; align-items: center; justify-content: center;
            cursor: pointer;
        }

        /* Smart Controls Container */
        .controls-wrapper {
            display: flex; gap: 15px; flex-wrap: wrap; align-items: center; width: 100%;
        }

        /* PREMIUM MODERN SEARCH BOX STYLE */
        .search-container-box {
            background: var(--card-bg); border-radius: 12px; padding: 4px;
            border: 1px solid var(--border-color); transition: all 0.3s ease; flex-grow: 1; min-width: 280px;
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

        .filter-select {
            height: 52px; border-radius: 12px; min-width: 170px;
            background: var(--card-bg); border: 1px solid var(--border-color); color: var(--text-main);
            padding: 0 20px; font-weight: 500; cursor: pointer; outline: none;
        }

        .view-switcher-btn {
            height: 52px; width: 52px; border-radius: 12px; border: 1px solid var(--border-color);
            background: var(--card-bg); color: var(--text-main); display: flex; align-items: center; justify-content: center;
            cursor: pointer; font-size: 16px;
        }
        .view-switcher-btn.active { background: var(--primary-color); color: #ffffff; border-color: var(--primary-color); }

        /* Datatable Elements */
        .table-responsive-container { overflow-x: auto; }
        .custom-table { width: 100%; border-collapse: separate; border-spacing: 0; min-width: 1000px; }
        .custom-table thead tr { background-color: var(--table-thead-bg) !important; }
        .custom-table th {
            color: var(--table-thead-text) !important; font-weight: 600; font-size: 14px; letter-spacing: 0.3px;
            padding: 18px 16px; border-bottom: none !important; background: transparent !important;
        }
        .custom-table td { padding: 16px; font-size: 14px; color: var(--text-main) !important; border-bottom: 1px solid var(--border-color) !important; white-space: nowrap; background: transparent !important; }
        .custom-table tbody tr:hover { background-color: var(--table-row-hover) !important; }

        /* Hidden Field Variable Configurations */
        .ref-id-cell { color: var(--text-muted) !important; }
        .valuation-cell { color: var(--text-main) !important; font-weight: 600; }
        .book-title-cell { font-weight: 600; color: var(--text-dark-override) !important; }

        /* Badge Status Pipeline */
        .badge-pipeline {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 6px 14px; border-radius: 100px; font-size: 12px; font-weight: 600;
        }
        .bg-available { background: rgba(34, 197, 94, 0.1); color: #22c55e; }
        .bg-lowstock { background: rgba(245, 158, 11, 0.1); color: #f59e0b; }
        .bg-outofstock { background: rgba(239, 68, 68, 0.1); color: #ef4444; }

        /* Action Mini triggers */
        .btn-table-action {
            padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 500;
            text-decoration: none; display: inline-flex; align-items: center; gap: 5px;
            background: rgba(79, 70, 229, 0.1); color: var(--primary-color); border: none; transition: 0.2s;
        }
        .btn-table-action:hover { background: var(--primary-color); color: #ffffff !important; }

        /* Alternative Grid Card Architecture */
        .books-grid-layout { display: none; grid-template-columns: repeat(auto-fill, minmax(290px, 1fr)); gap: 24px; }
        .interactive-book-card {
            background: var(--card-book-bg); border: 1px solid var(--border-color);
            border-radius: 16px; padding: 24px; display: flex; flex-direction: column;
            justify-content: space-between; box-shadow: 0 1px 3px rgba(0,0,0,0.02), 0 10px 20px -5px rgba(0,0,0,0.03);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .interactive-book-card:hover { transform: translateY(-4px); }
        .card-meta-category { font-size: 12px; font-weight: 600; text-transform: uppercase; color: var(--primary-color); letter-spacing: 0.5px; }
        .card-book-title { font-size: 16px; font-weight: 700; color: var(--text-dark-override); margin: 6px 0; }
        .card-author { font-size: 13px; color: var(--text-muted); margin-bottom: 15px; }

        /* Empty Framework Boundary Box */
        .empty-state-card { text-align: center; padding: 80px 20px; }
        .empty-state-card i { font-size: 70px; color: var(--text-muted); display: block; margin-bottom: 20px; }
        .empty-state-card h3 { font-size: 26px; font-weight: 700; color: var(--text-main); }

        @media(max-width: 768px) {
            body { padding: 15px; }
            .glass-panel { padding: 20px; }
            .page-header { flex-direction: column; align-items: stretch; }
            .action-button { width: 100%; justify-content: center; }
        }
    </style>
</head>
<body>

<div class="glass-panel page-header">
    <h1 class="page-title">
        <i class="bi bi-book-half"></i>
        Available Books Manifest
    </h1>
    <div class="d-flex gap-2 w-sm-100 justify-content-end align-items-center">
        <button class="btn-theme-toggle" id="themeToggleBtn" title="Change Visual Context">
            <i class="bi bi-moon-fill" id="themeIcon"></i>
        </button>
        <a href="${pageContext.request.contextPath}/student/dashboard" class="action-button">
            <i class="bi bi-arrow-left-short fs-5"></i> Dashboard Portal
        </a>
    </div>
</div>

<div class="glass-panel">
    <div class="controls-wrapper">
        <div class="search-container-box">
            <div class="search-control">
                <i class="bi bi-search"></i>
                <input type="text" id="liveSearchEngine" class="form-control" placeholder="Search by book title, author name, tag identifiers...">
            </div>
        </div>

        <select id="filterCategory" class="filter-select">
            <option value="ALL">All Categories</option>
            <c:set var="categoriesTracked" value="" />
            <c:forEach items="${books}" var="book">
                <c:if test="${!categoriesTracked.contains(book.category)}">
                    <option value="${book.category}">${book.category}</option>
                    <c:set var="categoriesTracked" value="${categoriesTracked},${book.category}" />
                </c:if>
            </c:forEach>
        </select>

        <select id="filterStatus" class="filter-select">
            <option value="ALL">All Stock Status</option>
            <option value="Available">In Stock</option>
            <option value="Low Stock">Critical Stock</option>
            <option value="Out Of Stock">Depleted</option>
        </select>
        <div class="d-flex gap-1 ms-auto">
            <button class="view-switcher-btn active" id="triggerTableView" title="Tabular Matrix View"><i class="bi bi-table"></i></button>
            <button class="view-switcher-btn" id="triggerGridView" title="Fluid Canvas Grid View"><i class="bi bi-grid-3x3-gap-fill"></i></button>
        </div>
    </div>
</div>

<div class="glass-panel">
    <c:choose>
        <c:when test="${empty books}">
            <div class="empty-state-card">
                <i class="bi bi-folder-x"></i>
                <h3>Repository Is Empty</h3>
                <p class="text-muted">No institutional books match the central library manifest currently.</p>
            </div>
        </c:when>

        <c:otherwise>
            <div class="table-responsive-container" id="tabularViewMatrix">
                <table class="custom-table" id="centralBooksTable">
                    <thead>
                        <tr>
                            <th>Ref ID</th>
                            <th>Title</th>
                            <th>Author</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Total Stock</th>
                            <th>Available</th>
                            <th>Status</th>
                            <th class="text-end">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${books}" var="book">
                            <tr class="book-data-row" data-category="${book.category}">
                                <td class="ref-id-cell">#STB-${book.id}</td>
                                <td class="book-title-cell">${book.bookName}</td>
                                <td>${book.authorName}</td>
                                <td><span class="badge-soft badge-student">${book.category}</span></td>
                                <td class="valuation-cell">₹ ${book.price}</td>
                                <td>${book.quantity} Units</td>
                                <td class="fw-semibold">${book.availableQuantity}</td>
                                <td data-search-status="<c:choose><c:when test='${book.availableQuantity == 0}'>Out Of Stock</c:when><c:when test='${book.availableQuantity <= 5}'>Low Stock</c:when><c:otherwise>Available</c:otherwise></c:choose>">
                                    <c:choose>
                                        <c:when test="${book.availableQuantity == 0}">
                                            <span class="badge-pipeline bg-outofstock"><i class="bi bi-x-circle-fill"></i> Out Of Stock</span>
                                        </c:when>
                                        <c:when test="${book.availableQuantity <= 5}">
                                            <span class="badge-pipeline bg-lowstock"><i class="bi bi-exclamation-triangle-fill"></i> Low Stock</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-pipeline bg-available"><i class="bi bi-check-circle-fill"></i> Available</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end">
                                    <a href="${pageContext.request.contextPath}/student/book-details/${book.id}" class="btn-table-action">
                                        Inspect <i class="bi bi-arrow-right-short"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="books-grid-layout" id="canvasGridViewDeck">
                <c:forEach items="${books}" var="book">
                    <div class="interactive-book-card card-data-element" data-category="${book.category}" data-card-status="<c:choose><c:when test='${book.availableQuantity == 0}'>Out Of Stock</c:when><c:when test='${book.availableQuantity <= 5}'>Low Stock</c:when><c:otherwise>Available</c:otherwise></c:choose>">
                        <div>
                            <div class="d-flex justify-content-between align-items-start">
                                <span class="card-meta-category">${book.category}</span>
                                <span class="text-muted small">#STB-${book.id}</span>
                            </div>
                            <h4 class="card-book-title">${book.bookName}</h4>
                            <p class="card-author">By ${book.authorName}</p>
                        </div>
                        <div>
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <span class="fw-bold fs-5 text-success">₹ ${book.price}</span>
                                <span class="small text-muted">Stock: ${book.availableQuantity}/${book.quantity}</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <c:choose>
                                    <c:when test="${book.availableQuantity == 0}">
                                        <span class="badge-pipeline bg-outofstock"><i class="bi bi-x-circle-fill"></i> Depleted</span>
                                    </c:when>
                                    <c:when test="${book.availableQuantity <= 5}">
                                        <span class="badge-pipeline bg-lowstock"><i class="bi bi-exclamation-triangle-fill"></i> Critical</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-pipeline bg-available"><i class="bi bi-check-circle-fill"></i> Active</span>
                                    </c:otherwise>
                                </c:choose>
                                <a href="${pageContext.request.contextPath}/student/book-details/${book.id}" class="btn-table-action">
                                    View <i class="bi bi-box-arrow-in-up-right"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        // Theme Engine State Configuration
        const themeToggleBtn = document.getElementById('themeToggleBtn');
        const themeIcon = document.getElementById('themeIcon');
        const rootHtml = document.documentElement;

        const initializationTheme = localStorage.getItem('theme') || 'light';
        setTheme(initializationTheme);

        themeToggleBtn.addEventListener('click', () => {
            const activeThemeState = rootHtml.getAttribute('data-theme');
            const modifiedThemeState = activeThemeState === 'light' ? 'dark' : 'light';
            setTheme(modifiedThemeState);
        });

        function setTheme(theme) {
            rootHtml.setAttribute('data-theme', theme);
            localStorage.setItem('theme', theme);

            if (theme === 'dark') {
                themeIcon.className = 'bi bi-sun-fill';
            } else {
                themeIcon.className = 'bi bi-moon-fill';
            }
        }

        // Canvas UI View Switcher Engine
        const triggerTableView = document.getElementById('triggerTableView');
        const triggerGridView = document.getElementById('triggerGridView');
        const tabularViewMatrix = document.getElementById('tabularViewMatrix');
        const canvasGridViewDeck = document.getElementById('canvasGridViewDeck');

        if(triggerTableView && triggerGridView) {
            triggerTableView.addEventListener('click', () => {
                triggerTableView.classList.add('active');
                triggerGridView.classList.remove('active');
                tabularViewMatrix.style.display = 'block';
                canvasGridViewDeck.style.display = 'none';
            });

            triggerGridView.addEventListener('click', () => {
                triggerGridView.classList.add('active');
                triggerTableView.classList.remove('active');
                tabularViewMatrix.style.display = 'none';
                canvasGridViewDeck.style.display = 'grid';
            });
        }

        // Dynamic Realtime Search & Multi-layer Filtering Architecture
        const searchInput = document.getElementById('liveSearchEngine');
        const filterCategory = document.getElementById('filterCategory');
        const filterStatus = document.getElementById('filterStatus');

        if(searchInput) {
            [searchInput, filterCategory, filterStatus].forEach(element => {
                element.addEventListener('keyup', executeSearchPipelineEngine);
                element.addEventListener('change', executeSearchPipelineEngine);
            });
        }

        function executeSearchPipelineEngine() {
            const queryTerm = searchInput.value.toLowerCase().trim();
            const selectedCategory = filterCategory.value;
            const selectedStatus = filterStatus.value;

            // Process Matrix View Rows (Table View Search)
            const tableRows = document.querySelectorAll('.book-data-row');
            tableRows.forEach(row => {
                const rawContent = row.textContent.toLowerCase();
                const categoryMeta = row.getAttribute('data-category');
                const statusMeta = row.querySelector('td[data-search-status]').getAttribute('data-search-status');

                const searchConditionMatched = rawContent.includes(queryTerm);
                const categoryConditionMatched = (selectedCategory === 'ALL' || categoryMeta === selectedCategory);
                const statusConditionMatched = (selectedStatus === 'ALL' || statusMeta === selectedStatus);

                if(searchConditionMatched && categoryConditionMatched && statusConditionMatched) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });

            // Process Fluid Block Cards (Grid View Search)
            const deckCards = document.querySelectorAll('.card-data-element');
            deckCards.forEach(card => {
                const textContentStream = card.textContent.toLowerCase();
                const cardCategoryMeta = card.getAttribute('data-category');
                const cardStatusMeta = card.getAttribute('data-card-status');

                const searchGridMatched = textContentStream.includes(queryTerm);
                const categoryGridMatched = (selectedCategory === 'ALL' || cardCategoryMeta === selectedCategory);
                const statusGridMatched = (selectedStatus === 'ALL' || cardStatusMeta === selectedStatus);

                if(searchGridMatched && categoryGridMatched && statusGridMatched) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            });
        }
    });
</script>
</body>
</html>

