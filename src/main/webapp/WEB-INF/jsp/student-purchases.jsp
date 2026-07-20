<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Digital Shelf - LMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .receipt-card { border: none; border-radius: 12px; background-color: #ffffff; transition: box-shadow 0.2s; }
        .receipt-card:hover { box-shadow: 0 8px 24px rgba(0,0,0,0.06); }
        .status-pill { font-size: 0.75rem; font-weight: 700; padding: 4px 12px; border-radius: 20px; text-transform: uppercase; }
        .book-thumbnail-placeholder { width: 60px; height: 80px; border-radius: 6px; background-color: #e9ecef; display: flex; align-items: center; justify-content: center; color: #a0aec0; }
        .action-link { font-weight: 600; font-size: 0.85rem; border-radius: 6px; padding: 6px 14px; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-white bg-white border-bottom sticky-top shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold text-dark" href="${pageContext.request.contextPath}/books/paid">
                <i class="fa-solid fa-chevron-left me-2 text-muted small"></i>Back to Book Store
            </a>
            <span class="navbar-text text-muted">
                <i class="fa-solid fa-folder-closed text-primary me-1"></i> Student Locker System
            </span>
        </div>
    </nav>

    <div class="container my-5">

        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i><strong>Success!</strong> <c:out value="${success}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i><strong>Transaction Denied:</strong> <c:out value="${error}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="row mb-5 align-items-center">
            <div class="col-md-8">
                <h1 class="fw-bold text-dark mb-1">My Digital Textbook Shelf</h1>
                <p class="text-muted mb-0">Authorized license holdings tied to student identity footprint ledger record: <span class="badge bg-dark">ST-<c:out value="${studentId}"/></span></p>
            </div>
            <div class="col-md-4 text-md-end mt-3 mt-md-0">
                <span class="text-muted small">Total Documents Claimed: <strong>${purchases != null ? purchases.size() : 0}</strong></span>
            </div>
        </div>

        <div class="row g-3">
            <c:choose>
                <c:when test="${not empty purchases}">
                    <c:forEach var="purchase" items="${purchases}">
                        <div class="col-12">
                            <div class="card receipt-card shadow-sm p-3">
                                <div class="row align-items-center g-3">

                                    <div class="col-auto">
                                        <div class="book-thumbnail-placeholder">
                                            <i class="fa-solid fa-book-open-reader fa-2x opacity-50"></i>
                                        </div>
                                    </div>

                                    <div class="col col-md-4">
                                        <span class="text-muted font-monospace small d-block mb-1">Invoice Token: #TXN-${purchase.id}</span>
                                        <h5 class="fw-bold text-dark mb-1">Book Identity Catalog File: #BK-<c:out value="${purchase.bookId}"/></h5>

                                        <span class="text-muted small d-block">
                                            <i class="fa-regular fa-clock me-1"></i>Settled:
                                            <fmt:parseDate value="${purchase.purchaseDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                            <fmt:formatDate value="${parsedDate}" pattern="MMM dd, yyyy - hh:mm a" />
                                        </span>
                                    </div>

                                    <div class="col-6 col-md-3 text-md-center">
                                        <c:choose>
                                            <c:when test="${purchase.status == 'SUCCESS'}">
                                                <span class="status-pill bg-success-subtle text-success border border-success border-opacity-10">
                                                    <i class="fa-solid fa-shield-check me-1"></i>Access Approved
                                                </span>
                                            </c:when>
                                            <c:when test="${purchase.status == 'PENDING'}">
                                                <span class="status-pill bg-warning-subtle text-warning-emphasis border border-warning border-opacity-10">
                                                    <i class="fa-solid fa-arrows-rotate fa-spin me-1"></i>Verifying Funds
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-pill bg-danger-subtle text-danger border border-danger border-opacity-10">
                                                    <i class="fa-solid fa-ban me-1"></i>Revoked / Declined
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="col-6 col-md-3 text-end">
                                        <c:choose>
                                            <c:when test="${purchase.status == 'SUCCESS'}">
                                                <div class="d-flex flex-column flex-md-row gap-2 justify-content-md-end">
                                                    <a href="${pageContext.request.contextPath}/student/book-details/${purchase.bookId}" class="btn btn-primary action-link shadow-sm">
                                                        <i class="fa-solid fa-folder-open me-1"></i> Access Content
                                                    </a>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn btn-outline-secondary action-link disabled w-100" disabled>
                                                    <i class="fa-solid fa-lock me-1"></i> Files Vaulted
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>

                <c:otherwise>
                    <div class="col-12 text-center py-5">
                        <div class="text-muted mb-3">
                            <i class="fa-solid fa-boxes-packing fa-4x opacity-25"></i>
                        </div>
                        <h4 class="fw-bold text-dark">Your Digital Shelf is Empty</h4>
                        <p class="text-muted small mb-3">You haven't purchased or checked out any premium textbook materials yet.</p>
                        <a href="${pageContext.request.contextPath}/books/paid" class="btn btn-sm btn-success py-2 px-3 fw-semibold shadow-sm">
                            <i class="fa-solid fa-basket-shopping me-1"></i> Visit Premium Book Store
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>