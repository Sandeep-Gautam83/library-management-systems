<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    // SECURE ADMIN SESSION VALIDATION ENGINE
    Object admin = session.getAttribute("loggedInUser");
    if(admin == null){
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>


<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catalog Control: Add New Book | LMS Matrix</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root[data-theme="dark"] {
            --bg-gradient: radial-gradient(circle at 50% 50%, #0f172a 0%, #020617 100%);
            --card-bg: rgba(30, 41, 59, 0.45);
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --border-color: rgba(255, 255, 255, 0.12);
            --glass-panel: rgba(255, 255, 255, 0.04);
            --input-bg: #1e293b;
            --input-text: #f8fafc;
            --input-placeholder: #64748b;
            --focus-glow: rgba(14, 165, 233, 0.35);
            --navbar-bg: rgba(15, 23, 42, 0.85);
            --sidebar-bg: rgba(30, 41, 59, 0.7);
            --dropdown-option-color: #f8fafc;
        }

        :root[data-theme="light"] {
            --bg-gradient: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%);
            --card-bg: rgba(255, 255, 255, 0.95);
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border-color: rgba(15, 23, 42, 0.15);
            --glass-panel: rgba(15, 23, 42, 0.05);
            --input-bg: #ffffff;
            --input-text: #0f172a;
            --input-placeholder: #94a3b8;
            --focus-glow: rgba(37, 99, 235, 0.2);
            --navbar-bg: rgba(255, 255, 255, 0.9);
            --sidebar-bg: #ffffff;
            --dropdown-option-color: #0f172a;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background: var(--bg-gradient) !important;
            background-attachment: fixed !important;
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
            transition: color 0.3s ease;
        }

        .custom-navbar {
            height: 80px;
            background: var(--navbar-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--border-color);
            padding: 0 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 1000;
            transition: background 0.3s ease, border-color 0.3s ease;
        }

        .header-system-title {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 20px;
            font-weight: 700;
            color: var(--text-main);
            cursor: pointer;
            position: relative;
        }

        .console-dropdown-menu {
            position: absolute;
            top: 65px;
            left: 0;
            background: var(--sidebar-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            width: 290px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
            display: none;
            backdrop-filter: blur(25px);
            -webkit-backdrop-filter: blur(25px);
            z-index: 9999 !important;
            padding: 15px 0;
        }

        .console-dropdown-menu.show-menu {
            display: block !important;
        }

        .menu-title {
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--text-muted);
            padding: 0 20px 10px 20px;
            border-bottom: 1px solid var(--border-color);
            font-weight: 600;
        }

        .menu-links {
            list-style: none;
            padding: 10px 0 0 0;
            margin: 0;
        }

        .menu-links li a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 20px;
            color: var(--text-muted);
            text-decoration: none;
            font-size: 13.5px;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .menu-links li:hover a, .menu-links li.active a {
            color: #38bdf8 !important;
            background: rgba(56, 189, 248, 0.08);
        }

        .system-hub-logo {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 3px;
            width: 20px;
            height: 20px;
        }

        .system-hub-logo span {
            background: #38bdf8;
            border-radius: 2px;
        }
        .system-hub-logo span:nth-child(1),
        .system-hub-logo span:nth-child(4) { background: #0ea5e9; }

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
            transition: all 0.3s ease;
        }

        .main-content {
            flex: 1;
            padding: 40px 30px;
            max-width: 1550px;
            width: 100%;
            margin: 0 auto;
        }

        .catalog-form-workspace {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 24px;
            padding: 40px;
            backdrop-filter: blur(16px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.12);
            animation: formEntrance 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards;
            transition: background 0.3s ease, border-color 0.3s ease, box-shadow 0.3s ease;
        }

        .modern-matrix-sidebar {
            background: var(--sidebar-bg);
            border: 1px solid var(--border-color);
            border-radius: 24px;
            padding: 30px;
            backdrop-filter: blur(16px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.08);
            height: fit-content;
            position: sticky;
            top: 110px;
            transition: background 0.3s ease, border-color 0.3s ease, box-shadow 0.3s ease;
        }

        .matrix-table {
            width: 100%;
            margin-top: 15px;
        }

        .matrix-table tr {
            border-bottom: 1px solid var(--border-color);
        }

        .matrix-table tr:last-child {
            border-bottom: none;
        }

        .matrix-table td {
            padding: 14px 10px;
            font-size: 14px;
            color: var(--text-main);
        }

        .matrix-label {
            color: var(--text-muted) !important;
            font-weight: 500;
        }

        .matrix-value {
            text-align: right;
            font-weight: 600;
        }

        @keyframes formEntrance {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .form-label {
            font-weight: 600;
            margin-bottom: 10px;
            color: var(--text-main);
            font-size: 14px;
            letter-spacing: 0.3px;
        }

        .form-control, .form-select {
            background: var(--input-bg) !important;
            border: 1px solid var(--border-color) !important;
            color: var(--input-text) !important;
            border-radius: 14px;
            padding: 12px 18px;
            font-size: 14.5px;
            height: 52px;
            transition: border-color 0.3s ease, box-shadow 0.3s ease, background-color 0.3s ease, color 0.3s ease;
        }

        .form-control::placeholder {
            color: var(--input-placeholder) !important;
            opacity: 1;
        }

        .form-select option {
            background-color: var(--input-bg) !important;
            color: var(--dropdown-option-color) !important;
        }

        .form-control:focus, .form-select:focus {
            border-color: #0ea5e9 !important;
            box-shadow: 0 0 0 4px var(--focus-glow) !important;
            outline: none;
        }

        .form-control:disabled, .form-control[readonly] {
            background-color: rgba(0, 0, 0, 0.2) !important;
            color: var(--text-muted) !important;
            opacity: 0.6;
            cursor: not-allowed;
        }

        .input-group-text {
            background-color: var(--input-bg) !important;
            color: var(--text-muted) !important;
            border: 1px solid var(--border-color) !important;
        }

        textarea.form-control {
            min-height: 120px;
            height: auto;
            resize: none;
        }

        .upload-interactive-node {
            border: 2px dashed var(--border-color);
            background: var(--glass-panel);
            border-radius: 18px;
            padding: 20px;
            text-align: center;
            position: relative;
            transition: all 0.3s ease;
        }

        .upload-interactive-node:hover {
            border-color: #0ea5e9;
        }

        .image-preview-frame {
            width: 100%;
            max-width: 150px;
            height: 210px;
            border-radius: 12px;
            object-fit: cover;
            border: 1px solid var(--border-color);
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            margin-bottom: 15px;
        }

        .btn-custom {
            height: 50px;
            border-radius: 14px;
            padding: 10px 28px;
            font-weight: 600;
            font-size: 15px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: all 0.3s ease;
        }

        .btn-custom:hover {
            transform: translateY(-2px);
        }

        .btn-submit-save {
            background: linear-gradient(135deg, #0ea5e9 0%, #2563eb 100%);
            color: white !important;
            border: none;
            box-shadow: 0 6px 20px rgba(14, 165, 233, 0.3);
        }

        .btn-submit-save:hover {
            box-shadow: 0 8px 25px rgba(14, 165, 233, 0.45);
        }

        .btn-terminal-cancel {
            background: transparent;
            border: 1px solid #f43f5e;
            color: #f43f5e !important;
        }

        .btn-terminal-cancel:hover {
            background: #f43f5e;
            color: white !important;
            box-shadow: 0 6px 20px rgba(244, 63, 94, 0.2);
        }

        .alert-timed-destruction {
            transition: opacity 0.5s ease, transform 0.5s ease, max-height 0.5s ease, margin-bottom 0.5s ease, padding 0.5s ease;
            max-height: 200px;
            opacity: 1;
            transform: translateY(0);
        }
        .alert-timed-destruction.collapse-node {
            opacity: 0 !important;
            transform: translateY(-20px) !important;
            max-height: 0 !important;
            padding-top: 0 !important;
            padding-bottom: 0 !important;
            margin-bottom: 0 !important;
            border: none !important;
        }

        @media (max-width: 992px) {
            .catalog-form-workspace, .modern-matrix-sidebar { padding: 25px 20px; }
            .modern-matrix-sidebar { position: static; margin-top: 30px; }
            .custom-navbar { padding: 0 15px; }
            .main-content { padding: 25px 15px; }
            .btn-custom { width: 100%; }
        }
    </style>
</head>
<body>

<nav class="custom-navbar">
    <div class="header-system-title" id="consoleMenuTrigger">
        <div class="system-hub-logo">
            <span></span><span></span><span></span><span></span>
        </div>
        <span>LMS Console <i class="bi bi-chevron-down ms-1" style="font-size: 12px; color: var(--text-muted);"></i></span>

        <div class="console-dropdown-menu" id="consoleDropdown">
            <div class="menu-title">Main Infrastructure Systems</div>
            <ul class="menu-links">
                 <li class="${fn:contains(pageContext.request.requestURI, '/admin/dashboard') ? 'active' : ''}">
                     <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-house-door-fill"></i> Dashboard Core</a>
                 </li>

                 <li class="${fn:contains(pageContext.request.requestURI, '/admin/add-book') ? 'active' : ''}">
                     <a href="${pageContext.request.contextPath}/admin/add-book"><i class="bi bi-plus-circle-fill"></i> Add New Book</a>
                 </li>
                 <li class="${fn:contains(pageContext.request.requestURI, '/admin/books') ? 'active' : ''}">
                     <a href="${pageContext.request.contextPath}/admin/books"><i class="bi bi-journal-bookmark-fill"></i> Edit & Delete Books</a>
                 </li>
                 <li class="${fn:contains(pageContext.request.requestURI, '/admin/pending-students') ? 'active' : ''}">
                     <a href="${pageContext.request.contextPath}/admin/pending-students"><i class="bi bi-person-check-fill"></i> Approve Students</a>
                 </li>
                 <li class="${fn:contains(pageContext.request.requestURI, '/admin/issue-book') ? 'active' : ''}">
                     <a href="${pageContext.request.contextPath}/admin/issue-book"><i class="bi bi-arrow-left-right"></i> Issue & Return Book</a>
                 </li>
                 <li class="${fn:contains(pageContext.request.requestURI, '/admin/fine') ? 'active' : ''}">
                     <a href="${pageContext.request.contextPath}/admin/fine/all"><i class="bi bi-patch-exclamation-fill"></i> Fine Management</a>
                 </li>
                 <li class="${fn:contains(pageContext.request.requestURI, '/admin/students') ? 'active' : ''}">
                     <a href="${pageContext.request.contextPath}/admin/students"><i class="bi bi-people-fill"></i> Access & User Control</a>
                 </li>
                 <li class="${fn:contains(pageContext.request.requestURI, '/admin/chat') ? 'active' : ''}">
                     <a href="${pageContext.request.contextPath}/admin/chat/dashboard"><i class="bi bi-chat-dots-fill"></i> Admin-chat</a>
                 </li>
                 <li style="border-top: 1px solid var(--border-color); margin-top: 10px; padding-top: 10px;">
                     <a href="${pageContext.request.contextPath}/admin/logout" style="color: #f43f5e;"><i class="bi bi-box-arrow-right"></i> Logout</a>
                 </li>
            </ul>
        </div>
    </div>

    <div class="d-flex align-items-center gap-3">
        <button class="action-icon-trigger" onclick="toggleTheme()" title="Invert Theme Visuals">
            <i class="bi bi-moon-stars" id="themeIcon"></i>
        </button>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-custom" style="height: 42px; border-radius: 12px; font-size: 13.5px; background: var(--glass-panel); border: 1px solid var(--border-color); color: var(--text-main);">
            <i class="bi bi-arrow-left-square"></i> Back to Dashboard
        </a>
    </div>
</nav>

<div class="main-content">

    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible border-0 shadow-lg text-white bg-danger rounded-4 p-3 mb-4 fade show alert-timed-destruction dynamic-secure-alert">
            <div class="d-flex align-items-center gap-2">
                <i class="bi bi-exclamation-octagon-fill fs-5"></i>
                <div><strong>Operation Execution Fault:</strong> ${error}</div>
            </div>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible border-0 shadow-lg text-white bg-success rounded-4 p-3 mb-4 fade show alert-timed-destruction dynamic-secure-alert">
            <div class="d-flex align-items-center gap-2">
                <i class="bi bi-check-circle-fill fs-5"></i>
                <div><strong>Transaction Successful:</strong> New book has been successfully cataloged. ${success}</div>
            </div>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="row g-4">

        <div class="col-xl-9 col-lg-8">
            <div class="catalog-form-workspace">
                <div class="d-flex align-items-center gap-3 mb-5 border-bottom pb-4" style="border-color: var(--border-color) !important;">
                    <div class="action-icon-trigger bg-info-subtle text-info border-0 fs-5" style="width: 50px; height: 50px; border-radius: 16px;">
                        <i class="bi bi-journal-plus"></i>
                    </div>
                    <div>
                        <h4 class="m-0 font-weight-bold" style="letter-spacing: -0.5px; color: var(--text-main);">Add New Book Details</h4>
                        <p class="m-0 text-muted" style="font-size: 13px;">Deploy and ingest structural data matrices directly into global database racks.</p>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/books/save" method="post" enctype="multipart/form-data">
                    <div class="row">

                        <div class="col-lg-6 mb-4">
                            <label class="form-label">Resource / Book Title</label>
                            <input type="text" id="inputBookName" name="bookName" class="form-control" placeholder="Enter complete core publication title" oninput="updateLiveSidebarTable()" required>
                        </div>

                        <div class="col-lg-6 mb-4">
                            <label class="form-label"> Author / Originator Name</label>
                            <input type="text" id="inputAuthorName" name="authorName" class="form-control" placeholder="Enter standard author credentials" oninput="updateLiveSidebarTable()" required>
                        </div>

                        <div class="col-md-6 mb-4">
                            <label class="form-label">Select Book Type</label>
                            <select name="category" class="form-select" required>
                                <option value="" disabled selected hidden>Select Books Classification</option>
                                <option>Programming</option>
                                <option>Computer Science</option>
                                <option>Artificial Intelligence</option>
                                <option>Machine Learning</option>
                                <option>Data Structures</option>
                                <option>Algorithms</option>
                                <option>Mathematics</option>
                                <option>Software Engineering</option>
                            </select>
                        </div>

                        <div class="col-md-6 mb-4">
                            <label class="form-label">Select Language </label>
                            <select name="language" class="form-select" required>
                                <option value="" disabled selected hidden>Select Language type</option>
                                <option value="English">English</option>
                                <option value="Hindi">Hindi</option>
                            </select>
                        </div>

                        <div class="col-md-4 mb-4">
                            <label class="form-label">Access Modality (Free / Paid)</label>
                            <select name="accessType" id="accessTypeSelect" class="form-select" onchange="adjustPriceConstraintModality()" required>
                                <option value="FREE" selected>FREE (Open Access)</option>
                                <option value="PAID">PAID (Premium Shelf)</option>
                            </select>
                        </div>

                        <div class="col-md-4 mb-4">
                            <label class="form-label">Total Amount (INR)</label>
                            <div class="input-group">
                                <span class="input-group-text" style="border-radius: 14px 0 0 14px; padding: 0 16px;">₹</span>
                                <input type="number" step="0.01" min="0" value="0.00" name="price" id="bookPriceInputField" class="form-control" style="border-radius: 0 14px 14px 0;" placeholder="0.00" oninput="updateLiveSidebarTable()" required>
                            </div>
                        </div>

                        <div class="col-md-4 mb-4">
                            <label class="form-label">Publisher Name</label>
                            <input type="text" name="publisher" class="form-control" placeholder="Enter enterprise publisher house" required>
                        </div>

                        <div class="col-md-4 mb-4">
                            <label class="form-label">Publication Year</label>
                            <input type="number" min="1000" id="publishedYearInput" name="publishedYear" class="form-control" placeholder="YYYY" required>
                        </div>

                        <div class="col-md-4 mb-4">
                            <label class="form-label">Total Copies</label>
                            <input type="number" min="1" id="totalQuantityInput" name="quantity" class="form-control" placeholder="Units count" oninput="synchronizeQuantityMetrics()" required>
                        </div>

                        <div class="col-md-4 mb-4">
                            <label class="form-label">Available Units </label>
                            <input type="number" min="0" id="availableQuantityInput" name="availableQuantity" class="form-control" placeholder="Allocated copies" oninput="updateLiveSidebarTable()">
                        </div>

                        <div class="col-md-4 mb-4">
                            <label class="form-label">Total Pages</label>
                            <input type="number" min="1" name="totalPages" class="form-control" placeholder="Total inner leaves count" required>
                        </div>

                        <div class="col-12 mb-4">
                            <label class="form-label">Description</label>
                            <textarea name="description" class="form-control" placeholder="Compile extensive abstracts or reference documentation..."></textarea>
                        </div>

                        <div class="col-md-6 mb-4">
                            <label class="form-label">Upload Cover Image</label>
                            <div class="upload-interactive-node">
                                <img id="imagePreview" src="https://images.unsplash.com/photo-1543002588-bfa74002ed7e?auto=format&fit=crop&w=260&h=340&q=80" class="image-preview-frame" alt="LMS Placeholder Stream">
                                <input type="file" name="imageFile" id="imageFileInput" class="form-control" accept="image/*" onchange="previewImageCoverStream(event)" style="display: none;">
                                <div>
                                    <button type="button" class="btn btn-secondary btn-sm rounded-3 px-3" onclick="document.getElementById('imageFileInput').click();">
                                        <i class="bi bi-camera"></i> Scan File Stream
                                    </button>
                                    <div class="file-note mt-2 text-muted" style="font-size: 11.5px;" id="imageFileNameDisplay">Supported: JPEG, PNG graphic nodes.</div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6 mb-4">
                            <label class="form-label">Upload pdf</label>
                            <div class="upload-interactive-node d-flex flex-column align-items-center justify-content-center" style="min-height: 315px;">
                                <div class="action-icon-trigger fs-1 text-danger mb-3 bg-danger-subtle border-0" style="width: 70px; height: 70px; border-radius: 20px;">
                                    <i class="bi bi-file-earmark-pdf-fill"></i>
                                </div>
                                <input type="file" name="pdfFile" id="pdfFileInput" class="form-control" accept="application/pdf" onchange="updatePdfMetadataDisplay(event)" style="display: none;">
                                <button type="button" class="btn btn-secondary btn-sm rounded-3 px-3" onclick="document.getElementById('pdfFileInput').click();">
                                    <i class="bi bi-cloud-arrow-up"></i> Map Document Vector
                                </button>
                                <div class="file-note mt-2 text-muted" style="font-size: 11.5px;" id="pdfFileNameDisplay">Only application/pdf formats parsed.</div>
                            </div>
                        </div>

                    </div>

                    <div class="d-flex gap-3 mt-4 border-top pt-4 flex-wrap" style="border-color: var(--border-color) !important;">
                        <button type="submit" class="btn btn-submit-save btn-custom">
                            <i class="bi bi-shield-fill-check"></i> Submit Details
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-terminal-cancel btn-custom">
                            <i class="bi bi-x-circle"></i> Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <div class="col-xl-3 col-lg-4">
            <div class="modern-matrix-sidebar">
                <h5 class="fw-bold mb-3 border-bottom pb-2" style="border-color: var(--border-color) !important; color: var(--text-main);">
                    <i class="bi bi-cpu text-info me-2"></i>Live Validation Grid
                </h5>

                <table class="matrix-table">
                    <tr>
                        <td class="matrix-label">Title</td>
                        <td class="matrix-value text-truncate" id="sideTitle" style="max-width: 140px;">---</td>
                    </tr>
                    <tr>
                        <td class="matrix-label">Author</td>
                        <td class="matrix-value text-truncate" id="sideAuthor" style="max-width: 140px;">---</td>
                    </tr>
                    <tr>
                        <td class="matrix-label">Access State</td>
                        <td class="matrix-value" id="sideAccessState">
                            <span class="badge bg-success-subtle text-success">FREE</span>
                        </td>
                    </tr>
                    <tr>
                        <td class="matrix-label">Settlement Price</td>
                        <td class="matrix-value text-info font-monospace" id="sidePrice">₹ 0.00</td>
                    </tr>
                    <tr>
                        <td class="matrix-label">Allocation Status</td>
                        <td class="matrix-value" id="sideAllocationStatus">
                            <span class="text-danger"><i class="bi bi-dash-circle me-1"></i>No Units</span>
                        </td>
                    </tr>
                </table>

                <div class="mt-4 p-3 rounded-3 text-center" style="background: rgba(14, 165, 233, 0.06); border: 1px dashed rgba(14, 165, 233, 0.2); font-size: 12px; color: var(--text-muted);">
                    <i class="bi bi-info-circle text-info me-1"></i> Data matches target entities instantly.
                </div>
            </div>
        </div>

    </div>
</div>

<script>
    window.addEventListener('DOMContentLoaded', () => {
        const savedTheme = localStorage.getItem('theme') || 'dark';
        document.documentElement.setAttribute('data-theme', savedTheme);
        updateIconStateMetrics(savedTheme);
        adjustPriceConstraintModality();

        // FIXED TRIGGER BINDINGS Safely
        const trigger = document.getElementById('consoleMenuTrigger');
        if(trigger) {
            trigger.addEventListener('click', function(e) {
                if (e.target.closest('a')) return;

                e.stopPropagation();
                const dropdown = document.getElementById('consoleDropdown');
                if (dropdown) {
                    dropdown.classList.toggle('show-menu');
                }
            });
        }

        document.addEventListener('click', function(e) {
            const dropdown = document.getElementById('consoleDropdown');
            const targetTrigger = document.getElementById('consoleMenuTrigger');
            if(dropdown && !dropdown.contains(e.target) && targetTrigger && !targetTrigger.contains(e.target)) {
                dropdown.classList.remove('show-menu');
            }
        });

        const currentYear = new Date().getFullYear();
        const yearInput = document.getElementById('publishedYearInput');
        if(yearInput) {
            yearInput.max = currentYear;
            yearInput.placeholder = "Max " + currentYear;

            yearInput.addEventListener('input', function() {
                if (this.value.length > 4) {
                    this.value = this.value.slice(0, 4);
                }
                if (parseInt(this.value) > currentYear) {
                    this.value = currentYear;
                }
            });
        }

        const secureAlerts = document.querySelectorAll('.dynamic-secure-alert');
        secureAlerts.forEach(alertNode => {
            setTimeout(() => {
                alertNode.classList.add('collapse-node');
                alertNode.addEventListener('transitionend', function executionCleanup() {
                    alertNode.remove();
                });
            }, 5000);
        });
    });

    function toggleTheme() {
        const currentTheme = document.documentElement.getAttribute('data-theme');
        const targetTheme = currentTheme === 'dark' ? 'light' : 'dark';
        document.documentElement.setAttribute('data-theme', targetTheme);
        localStorage.setItem('theme', targetTheme);
        updateIconStateMetrics(targetTheme);
    }

    function adjustPriceConstraintModality() {
        const accessSelect = document.getElementById('accessTypeSelect');
        const priceInput = document.getElementById('bookPriceInputField');

        if (accessSelect && priceInput) {
            if (accessSelect.value === 'FREE') {
                priceInput.value = "0.00";
                priceInput.setAttribute('readonly', 'readonly');
            } else {
                if (priceInput.value === "0.00" || priceInput.value === "") {
                    priceInput.value = "";
                }
                priceInput.removeAttribute('readonly');
                priceInput.focus();
            }
        }
        updateLiveSidebarTable();
    }

    function updateLiveSidebarTable() {
        const name = document.getElementById('inputBookName').value;
        const author = document.getElementById('inputAuthorName').value;
        const access = document.getElementById('accessTypeSelect').value;
        const price = document.getElementById('bookPriceInputField').value;
        const available = document.getElementById('availableQuantityInput').value;

        document.getElementById('sideTitle').innerText = name.trim() !== "" ? name : "---";
        document.getElementById('sideAuthor').innerText = author.trim() !== "" ? author : "---";

        const sidePriceNode = document.getElementById('sidePrice');
        if(access === 'FREE') {
            document.getElementById('sideAccessState').innerHTML = `<span class="badge bg-success-subtle text-success"><i class="bi bi-unlock-fill me-1"></i>FREE</span>`;
            sidePriceNode.innerText = "FREE";
            sidePriceNode.style.color = "#22c55e";
        } else {
            document.getElementById('sideAccessState').innerHTML = `<span class="badge bg-warning-subtle text-warning"><i class="bi bi-gem me-1"></i>PAID</span>`;
            sidePriceNode.innerText = "₹ " + (price !== "" ? parseFloat(price).toFixed(2) : "0.00");
            sidePriceNode.style.color = "#ef4444";
        }

        const allocNode = document.getElementById('sideAllocationStatus');
        if(available !== "" && parseInt(available) > 0) {
            allocNode.innerHTML = `<span class="text-success"><i class="bi bi-check-circle-fill me-1"></i>` + available + ` Units</span>`;
        } else {
            allocNode.innerHTML = `<span class="text-danger"><i class="bi bi-dash-circle-fill me-1"></i>No Units</span>`;
        }
    }

    function updateIconStateMetrics(theme) {
        const icon = document.getElementById('themeIcon');
        if(icon) {
            icon.className = theme === 'dark' ? 'bi bi-sun-fill' : 'bi bi-moon-stars-fill';
        }
    }

    function previewImageCoverStream(event) {
        const outputImage = document.getElementById('imagePreview');
        const file = event.target.files[0];
        if (file && outputImage) {
            outputImage.src = URL.createObjectURL(file);
            document.getElementById('imageFileNameDisplay').innerHTML = `<span class="badge bg-success-subtle text-success border border-success-subtle"><i class="bi bi-image"></i> ` + file.name + `</span>`;
        }
    }

    function updatePdfMetadataDisplay(event) {
        const file = event.target.files[0];
        if (file) {
            const fileSizeMB = (file.size / (1024 * 1024)).toFixed(2);
            document.getElementById('pdfFileNameDisplay').innerHTML = `<span class="badge bg-danger-subtle text-danger border border-danger-subtle"><i class="bi bi-file-pdf"></i> ` + file.name + ` (` + fileSizeMB + ` MB)</span>`;
        }
    }

    function synchronizeQuantityMetrics() {
        const totalQuantityInput = document.getElementById('totalQuantityInput');
        const availableQuantityInput = document.getElementById('availableQuantityInput');
        if(totalQuantityInput && availableQuantityInput) {
            availableQuantityInput.value = totalQuantityInput.value;
        }
        updateLiveSidebarTable();
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>

1. check it complete code add book page open nahi ho raha hai
2. complete code write