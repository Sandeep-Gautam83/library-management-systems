<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library Management System | Catalog Management</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background: #0f172a; /* Matching with your dark theme console dashboard */
            color: #f8fafc;
            min-height: 100vh;
            padding: 30px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
            gap: 15px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
            padding-bottom: 20px;
        }

        .page-title {
            font-size: 28px;
            font-weight: 700;
            color: #f8fafc;
            letter-spacing: -0.5px;
        }

        .top-buttons {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .card-container {
            background: rgba(30, 41, 59, 0.55);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 16px;
            padding: 25px;
            backdrop-filter: blur(16px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1000px;
        }

        thead {
            background: rgba(15, 23, 42, 0.6);
            color: #f8fafc;
        }

        th {
            padding: 16px;
            text-align: center;
            font-size: 14px;
            font-weight: 600;
            white-space: nowrap;
            border-bottom: 2px solid rgba(255, 255, 255, 0.1);
        }

        td {
            padding: 14px;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
            color: #cbd5e1;
            font-size: 14px;
            vertical-align: middle;
        }

        tbody tr:hover {
            background: rgba(255, 255, 255, 0.03);
            transition: 0.2s ease;
        }

        .badge-stock {
            padding: 6px 14px;
            border-radius: 30px;
            font-size: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .in-stock {
            background: rgba(22, 101, 52, 0.2);
            color: #4ade80;
            border: 1px solid rgba(74, 222, 128, 0.2);
        }

        .low-stock {
            background: rgba(146, 64, 14, 0.2);
            color: #fbbf24;
            border: 1px solid rgba(251, 191, 36, 0.2);
        }

        .out-stock {
            background: rgba(153, 27, 27, 0.2);
            color: #f87171;
            border: 1px solid rgba(248, 113, 113, 0.2);
        }

        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn-custom {
            border: none;
            padding: 8px 14px;
            border-radius: 8px;
            color: white;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-edit {
            background: #16a34a;
        }

        .btn-edit:hover {
            background: #15803d;
            color: white;
            transform: translateY(-1px);
        }

        .btn-delete {
            background: #dc2626;
        }

        .btn-delete:hover {
            background: #b91c1c;
            color: white;
            transform: translateY(-1px);
        }

        .btn-add {
            background: linear-gradient(135deg, #0ea5e9 0%, #2563eb 100%);
            color: white;
            padding: 10px 18px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 500;
            box-shadow: 0 4px 12px rgba(14, 165, 233, 0.2);
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-add:hover {
            background: linear-gradient(135deg, #0284c7 0%, #1d4ed8 100%);
            color: white;
        }

        .btn-dashboard {
            background: rgba(255, 255, 255, 0.05);
            color: #f8fafc;
            padding: 10px 18px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 500;
            border: 1px solid rgba(255, 255, 255, 0.08);
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-dashboard:hover {
            background: rgba(255, 255, 255, 0.1);
            color: white;
        }

        .empty-data {
            text-align: center;
            padding: 50px 20px;
            font-size: 16px;
            color: #94a3b8;
            font-weight: 500;
        }

        @media(max-width:768px){
            body{ padding:15px; }
            .page-title { font-size:22px; }
            .card-container { padding:15px; }
            .top-buttons { width: 100%; }
            .btn-add, .btn-dashboard { flex: 1; justify-content: center; }
        }
    </style>
</head>
<body>

<div class="page-header">
    <h1 class="page-title">
        <i class="bi bi-book-half text-info"></i> All Ingested Books
    </h1>
    <div class="top-buttons">
        <a href="${pageContext.request.contextPath}/admin/add-book" class="btn-add">
            <i class="bi bi-plus-circle"></i> Add Book
        </a>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-dashboard">
            <i class="bi bi-speedometer2"></i> Dashboard
        </a>
    </div>
</div>

<c:if test="${not empty success}">
    <div class="alert alert-success alert-dismissible border-0 shadow-lg text-white bg-success rounded-4 p-3 mb-4 fade show" role="alert">
        <div class="d-flex align-items-center gap-2">
            <i class="bi bi-check-circle-fill fs-5"></i>
            <div>${success}</div>
        </div>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible border-0 shadow-lg text-white bg-danger rounded-4 p-3 mb-4 fade show" role="alert">
        <div class="d-flex align-items-center gap-2">
            <i class="bi bi-exclamation-octagon-fill fs-5"></i>
            <div>${error}</div>
        </div>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<div class="card-container">
    <c:choose>
        <c:when test="${empty books}">
            <div class="empty-data">
                <i class="bi bi-exclamation-circle text-warning fs-3 d-block mb-2"></i>
                No Core Catalog System Assets Found
            </div>
        </c:when>
        <c:otherwise>
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Book Name</th>
                    <th>Author</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Total Qty</th>
                    <th>Available</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${books}" var="book">
                    <tr>
                        <td class="font-monospace text-muted">#${book.id}</td>
                        <td>
                            <strong style="color: #f8fafc;">${book.bookName}</strong>
                        </td>
                        <td>${book.authorName}</td>
                        <td><span class="badge bg-secondary bg-opacity-25 text-info border border-info border-opacity-10">${book.category}</span></td>
                        <td class="font-monospace text-warning">₹${book.price}</td>
                        <td>${book.quantity}</td>
                        <td class="fw-bold">${book.availableQuantity}</td>
                        <td>
                            <c:choose>
                                <c:when test="${book.availableQuantity == 0}">
                                    <span class="badge-stock out-stock">
                                        <i class="bi bi-x-circle-fill"></i> Out of Stock
                                    </span>
                                </c:when>
                                <c:when test="${book.availableQuantity <= 5}">
                                    <span class="badge-stock low-stock">
                                        <i class="bi bi-exclamation-triangle-fill"></i> Low Stock
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge-stock in-stock">
                                        <i class="bi bi-check-circle-fill"></i> Available
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <a href="${pageContext.request.contextPath}/admin/edit-book/${book.id}" class="btn-custom btn-edit">
                                    <i class="bi bi-pencil-square"></i> Edit
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/delete-book/${book.id}" class="btn-custom btn-delete"
                                   onclick="return confirm('Are you sure you want to permanently strip this asset from the catalog ecosystem?');">
                                    <i class="bi bi-trash"></i> Delete
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>


