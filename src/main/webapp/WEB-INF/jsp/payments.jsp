<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction Audit Ledger - LMS Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .kpi-card { border: none; border-radius: 12px; transition: transform 0.2s; }
        .kpi-card:hover { transform: translateY(-3px); }
        .icon-box { width: 50px; height: 50px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; }
        .table-container { background: #ffffff; border-radius: 12px; border: none; overflow: hidden; }
        .table th { background-color: #f8f9fa; color: #495057; font-weight: 600; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.5px; }
        .status-badge { padding: 6px 12px; font-size: 0.75rem; font-weight: 700; border-radius: 30px; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#">
                <i class="fa-solid fa-screwdriver-wrench text-warning me-2"></i>LMS Control Center
            </a>
            <span class="navbar-text text-white-50">
                <i class="fa-solid fa-user-shield me-1"></i> Staff Accounting Console
            </span>
        </div>
    </nav>

    <div class="container my-5">

        <div class="row mb-4">
            <div class="col-12">
                <h1 class="fw-bold text-dark mb-1">Financial Processing Ledger</h1>
                <p class="text-muted">Review, monitor, and track real-time textbook invoice purchases processed across the digital catalog interface portal.</p>
            </div>
        </div>

        <div class="row g-4 mb-5">
            <div class="col-12 col-md-4">
                <div class="card shadow-sm kpi-card p-3 bg-white">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-muted text-uppercase small fw-bold d-block mb-1">System Transactions</span>
                            <h2 class="fw-bold text-dark mb-0">${purchases != null ? purchases.size() : 0}</h2>
                        </div>
                        <div class="icon-box bg-primary-subtle text-primary">
                            <i class="fa-solid fa-receipt"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-12 col-md-4">
                <div class="card shadow-sm kpi-card p-3 bg-white">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-muted text-uppercase small fw-bold d-block mb-1">Active Accounts Clear</span>
                            <h2 class="fw-bold text-success mb-0">
                                <c:set var="successCount" value="0" />
                                <c:forEach var="p" items="${purchases}">
                                    <c:if test="${p.status == 'SUCCESS'}">
                                        <c:set var="successCount" value="${successCount + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${successCount}
                            </h2>
                        </div>
                        <div class="icon-box bg-success-subtle text-success">
                            <i class="fa-solid fa-circle-check"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-12 col-md-4">
                <div class="card shadow-sm kpi-card p-3 bg-white">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-muted text-uppercase small fw-bold d-block mb-1">Unresolved Rejections</span>
                            <h2 class="fw-bold text-danger mb-0">
                                <c:set var="failCount" value="0" />
                                <c:forEach var="p" items="${purchases}">
                                    <c:if test="${p.status == 'FAILED'}">
                                        <c:set var="failCount" value="${failCount + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${failCount}
                            </h2>
                        </div>
                        <div class="icon-box bg-danger-subtle text-danger">
                            <i class="fa-solid fa-circle-exclamation"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card table-container shadow-sm border-0">
            <div class="card-header bg-white border-bottom py-3 d-flex align-items-center justify-content-between">
                <h5 class="mb-0 text-dark fw-bold"><i class="fa-solid fa-list-check me-2 text-muted"></i>Historical Journal Postings</h5>
                <button onclick="window.print();" class="btn btn-outline-secondary btn-sm">
                    <i class="fa-solid fa-print me-1"></i> Export Log Sheet
                </button>
            </div>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th class="ps-4">Reference Invoice ID</th>
                            <th>Identity Student ID</th>
                            <th>Resource Book ID</th>
                            <th>Processing Date/Timestamp</th>
                            <th class="text-center">Gateway Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty purchases}">
                                <c:forEach var="purchase" items="${purchases}">
                                    <tr>
                                        <td class="ps-4 fw-bold text-dark">
                                            #TXN-<c:out value="${purchase.id}"/>
                                        </td>

                                        <td>
                                            <span class="badge bg-light text-dark border px-2 py-1">
                                                <i class="fa-solid fa-user text-muted me-1"></i>ST-<c:out value="${purchase.studentId}"/>
                                            </span>
                                        </td>

                                        <td>
                                            <span class="badge bg-light text-dark border px-2 py-1">
                                                <i class="fa-solid fa-book text-muted me-1"></i>BK-<c:out value="${purchase.bookId}"/>
                                            </span>
                                        </td>

                                        <td class="text-muted small">
                                            <fmt:parseDate value="${purchase.purchaseDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                            <fmt:formatDate value="${parsedDate}" pattern="MMM dd, yyyy - hh:mm a" />
                                        </td>

                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${purchase.status == 'SUCCESS'}">
                                                    <span class="status-badge bg-success-subtle text-success">
                                                        <i class="fa-solid fa-circle-check me-1"></i>SETTLED
                                                    </span>
                                                </c:when>
                                                <c:when test="${purchase.status == 'PENDING'}">
                                                    <span class="status-badge bg-warning-subtle text-warning-emphasis">
                                                        <i class="fa-solid fa-spinner fa-spin me-1"></i>PENDING
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge bg-danger-subtle text-danger">
                                                        <i class="fa-solid fa-circle-xmark me-1"></i>DECLINED
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" class="text-center py-5 text-muted">
                                        <div class="mb-2"><i class="fa-solid fa-folder-open fa-3x opacity-25"></i></div>
                                        <h5 class="fw-bold mb-1">No Processing Activity Logged</h5>
                                        <p class="small text-muted mb-0">No purchase records have been saved to the ledger journal yet.</p>
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