<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Distribution Audit - LMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .ledger-card { border: none; border-radius: 12px; overflow: hidden; background: #ffffff; }
        .book-profile-strip { background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%); color: white; border-radius: 12px; }
        .table th { background-color: #f8f9fa; color: #495057; font-weight: 600; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.5px; }
        .status-badge { padding: 5px 12px; font-size: 0.75rem; font-weight: 700; border-radius: 30px; display: inline-block; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/books/view-books">
                <i class="fa-solid fa-arrow-left me-2 small text-muted"></i>LMS Catalog Analytics
            </a>
            <span class="navbar-text text-white-50">
                <i class="fa-solid fa-chart-pie me-1"></i> Inventory Allocation Console
            </span>
        </div>
    </nav>

    <div class="container my-5">

        <div class="p-4 p-md-5 mb-5 shadow-sm book-profile-strip d-flex align-items-center justify-content-between position-relative">
            <div>
                <span class="badge bg-white bg-opacity-20 text-white text-uppercase tracking-wider small fw-bold mb-2 px-3 py-1">
                    <i class="fa-solid fa-barcode me-1"></i> Asset Catalog Target ID: #BK-${bookId}
                </span>
                <h1 class="display-6 fw-bold mb-1">Book Allocation Tracking</h1>
                <p class="mb-0 opacity-75">Reviewing active student acquisition records, license authorizations, and transaction histories assigned to this catalog reference id.</p>
            </div>
            <div class="d-none d-lg-block text-end opacity-25">
                <i class="fa-solid fa-book-bookmark fa-7x"></i>
            </div>
        </div>

        <div class="card ledger-card shadow-sm">
            <div class="card-header bg-white border-bottom py-3 d-flex align-items-center justify-content-between">
                <h5 class="mb-0 text-dark fw-bold">
                    <i class="fa-solid fa-user-tag me-2 text-primary"></i>Student Assignment Ledger
                </h5>
                <span class="badge bg-primary px-3 py-2 rounded-pill font-monospace">
                    Total Transactions: ${purchases != null ? purchases.size() : 0}
                </span>
            </div>

            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th class="ps-4">Transaction Token ID</th>
                            <th>Target Student Identifier</th>
                            <th>Settlement Timestamp</th>
                            <th class="text-center">System Processing Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty purchases}">
                                <c:forEach var="purchase" items="${purchases}">
                                    <tr>
                                        <td class="ps-4 font-monospace fw-bold text-secondary">
                                            #TXN-<c:out value="${purchase.id}"/>
                                        </td>

                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="avatar-icon bg-light text-primary border rounded p-1 me-2 text-center" style="width: 32px; height: 32px;">
                                                    <i class="fa-solid fa-user-graduate small"></i>
                                                </div>
                                                <span class="fw-semibold text-dark">
                                                    Student Record #<c:out value="${purchase.studentId}"/>
                                                </span>
                                            </div>
                                        </td>

                                        <td class="text-muted small">
                                            <fmt:parseDate value="${purchase.purchaseDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                            <c:choose>
                                                <c:when test="${not empty parsedDate}">
                                                    <fmt:formatDate value="${parsedDate}" pattern="MMM dd, yyyy - hh:mm a" />
                                                </c:when>
                                                <c:otherwise>
                                                    <c:out value="${purchase.purchaseDate}"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${purchase.status == 'SUCCESS'}">
                                                    <span class="status-badge bg-success-subtle text-success">
                                                        <i class="fa-solid fa-circle-check me-1"></i>SUCCESS
                                                    </span>
                                                </c:when>
                                                <c:when test="${purchase.status == 'PENDING'}">
                                                    <span class="status-badge bg-warning-subtle text-warning-emphasis">
                                                        <i class="fa-solid fa-hourglass-half fa-spin me-1"></i>PENDING
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge bg-danger-subtle text-danger">
                                                        <i class="fa-solid fa-triangle-exclamation me-1"></i>FAILED
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                                <tr>
                                    <td colspan="4" class="text-center py-5">
                                        <div class="text-muted mb-3">
                                            <i class="fa-solid fa-folder-minus fa-4x opacity-25"></i>
                                        </div>
                                        <h5 class="fw-bold text-dark">No Purchases Recorded</h5>
                                        <p class="text-muted small mb-0">This particular textbook has not been checked out or purchased by any student yet.</p>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
