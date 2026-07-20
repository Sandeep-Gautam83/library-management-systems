<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Paid Books Store - LMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .navbar-brand { font-weight: 700; color: #2c3e50; }
        .book-card { transition: transform 0.2s, box-shadow 0.2s; border: none; border-radius: 12px; overflow: hidden; }
        .book-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
        .book-cover { height: 260px; object-fit: cover; background-color: #e9ecef; }
        .price-badge { position: absolute; top: 15px; right: 15px; background-color: #e74c3c; color: white; padding: 5px 12px; font-weight: bold; border-radius: 20px; font-size: 0.9rem; }
        .rating-star { color: #f1c40f; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-white bg-white border-bottom sticky-top shadow-sm">
        <div class="container">
            <a class="navbar-brand" href="#"><i class="fa-solid fa-book-open text-primary me-2"></i>LMS Student Portal</a>
            <div class="d-flex align-items-center gap-2 flex-wrap justify-content-end">
                <span class="text-muted">Welcome, <strong><c:out value="${not empty user ? user.fullName : 'Guest'}"/></strong></span>
                <c:choose>
                    <c:when test="${not empty studentId}">
                        <a href="${pageContext.request.contextPath}/payment/student/${studentId}" class="btn btn-outline-primary btn-sm">
                            <i class="fa-solid fa-clock-rotate-left me-1"></i> My Payment History
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary btn-sm">
                            <i class="fa-solid fa-right-to-bracket me-1"></i> Login to Purchase
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>

    <div class="container my-5">

        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm border-0 mb-4" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> <c:out value="${success}"/>
                <button type="submit" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm border-0 mb-4" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i> <c:out value="${error}"/>
                <button type="submit" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="row mb-5 align-items-center">
            <div class="col-md-6">
                <h1 class="fw-bold text-dark mb-1">Premium Books Collection</h1>
                <p class="text-muted">Expand your catalog library by purchasing handpicked industrial documentation resources.</p>
            </div>
            <div class="col-md-6 text-md-end">
                <span class="badge bg-secondary p-2"><i class="fa-solid fa-layer-group me-1"></i> Total Available: ${books.size()} Premium Titles</span>
            </div>
        </div>

        <div class="row g-4">
            <c:choose>
                <c:when test="${not empty books}">
                    <c:forEach var="book" items="${books}">
                        <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                            <div class="card h-100 book-card shadow-sm position-relative">

                                <div class="price-badge">
                                    <fmt:formatNumber value="${book.price}" type="currency" currencySymbol="₹" />
                                </div>

                                <c:choose>
                                    <c:when test="${not empty book.bookImage}">
                                        <img src="${pageContext.request.contextPath}/files/download/${book.bookImage.id}" class="card-img-top book-cover" alt="Book Cover">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="card-img-top book-cover d-flex flex-column align-items-center justify-content-center text-muted">
                                            <i class="fa-solid fa-book fa-3x mb-2 opacity-50"></i>
                                            <span class="small">No Cover Art Available</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <div class="card-body d-flex flex-column">
                                    <span class="text-uppercase tracking-wider text-primary fw-semibold small mb-1"><c:out value="${book.category}"/></span>
                                    <h5 class="card-title text-dark fw-bold text-truncate mb-1" title="${book.bookName}">
                                        <c:out value="${book.bookName}"/>
                                    </h5>
                                    <p class="text-muted small mb-2">By <c:out value="${book.authorName}"/></p>

                                    <div class="mb-3 mt-auto">
                                        <span class="rating-star"><i class="fa-solid fa-star small"></i></span>
                                        <span class="fw-bold small text-dark"><c:out value="${book.rating != null ? book.rating : '0.0'}"/></span>
                                        <span class="text-muted small mx-1">|</span>
                                        <span class="text-muted small"><c:out value="${book.totalPages}"/> Pages</span>
                                    </div>

                                    <div class="mb-3">
                                        <c:choose>
                                            <c:when test="${book.availableQuantity <= 0}">
                                                <span class="badge bg-danger-subtle text-danger w-100 py-2"><i class="fa-solid fa-circle-xmark me-1"></i> Temporary Out of Stock</span>
                                            </c:when>
                                            <c:when test="${book.availableQuantity <= 5}">
                                                <span class="badge bg-warning-subtle text-warning-emphasis w-100 py-2"><i class="fa-solid fa-fire me-1"></i> Only ${book.availableQuantity} copies left!</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted small"><i class="fa-solid fa-boxes-stacked me-1"></i> Stock Available: ${book.availableQuantity} copies</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <c:choose>
                                        <c:when test="${book.availableQuantity <= 0}">
                                            <button type="button" class="btn btn-secondary w-100 py-2 disabled" disabled>
                                                <i class="fa-solid fa-ban me-1"></i> Unavailable
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/payment/checkout?bookId=${book.id}" class="btn btn-primary w-100 py-2 fw-semibold">
                                                <i class="fa-solid fa-cart-shopping me-1"></i> Purchase Now
                                            </a>
                                        </c:otherwise>
                                    </c:choose>

                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12 text-center py-5">
                        <div class="text-muted mb-3">
                            <i class="fa-solid fa-box-open fa-4x opacity-20"></i>
                        </div>
                        <h4 class="text-dark fw-bold">No Premium Books Found</h4>
                        <p class="text-muted">There are no paid books listing profiles active in the registry system catalog right now.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>