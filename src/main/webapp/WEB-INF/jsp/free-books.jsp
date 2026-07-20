<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Open Access Library - LMS</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f7f6; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .navbar-brand { font-weight: 700; color: #2c3e50; }
        .book-card { transition: all 0.3s cubic-bezier(.25,.8,.25,1); border: none; border-radius: 12px; overflow: hidden; }
        .book-card:hover { transform: translateY(-4px); box-shadow: 0 12px 20px rgba(0,0,0,0.08) !important; }
        .book-cover { height: 260px; object-fit: cover; background-color: #e9ecef; }
        .free-badge { position: absolute; top: 15px; right: 15px; background-color: #2ecc71; color: white; padding: 4px 14px; font-weight: 700; border-radius: 20px; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; box-shadow: 0 2px 5px rgba(0,0,0,0.15); }
        .rating-star { color: #f1c40f; }
        .action-btn { border-radius: 8px; font-weight: 600; font-size: 0.9rem; }
    </style>
</head>
<body>

    <!-- Main Student Navigation Header -->
    <nav class="navbar navbar-expand-lg navbar-white bg-white border-bottom sticky-top shadow-sm">
        <div class="container">
            <a class="navbar-brand" href="#"><i class="fa-solid fa-book-open text-success me-2"></i>LMS Open Catalog</a>
            <div class="d-flex align-items-center">
                <span class="text-muted small me-3"><i class="fa-solid fa-circle-user text-success me-1"></i>Open Access Mode</span>
                <a href="${pageContext.request.contextPath}/books/paid" class="btn btn-sm btn-outline-dark">
                    <i class="fa-solid fa-gem text-warning me-1"></i> View Premium Store
                </a>
            </div>
        </div>
    </nav>

    <div class="container my-5">

        <!-- Dynamic Header Description Panel -->
        <div class="row mb-5 align-items-center">
            <div class="col-md-7">
                <h1 class="fw-bold text-dark mb-1">Free Knowledge Commons</h1>
                <p class="text-muted">Instant access to open-source educational media, documentation archives, and community-contributed research notes.</p>
            </div>
            <div class="col-md-5 text-md-end">
                <span class="badge bg-success bg-opacity-10 text-success p-2.5 fs-6 border border-success border-opacity-20">
                    <i class="fa-solid fa-unlock me-1"></i> Unlocked Resources: ${books.size()}
                </span>
            </div>
        </div>

        <!-- Books Grid Matrix -->
        <div class="row g-4">
            <c:choose>
                <c:when test="${not empty books}">
                    <c:forEach var="book" items="${books}">
                        <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                            <div class="card h-100 book-card shadow-sm position-relative">

                                <!-- Floating "FREE" Ribbon Badge -->
                                <div class="free-badge">
                                    <i class="fa-solid fa-gift me-1"></i>Free
                                </div>

                                <!-- Dynamic Cover Image Fallback Render -->
                                <c:choose>
                                    <c:when test="${not empty book.bookImage}">
                                        <img src="${pageContext.request.contextPath}/files/download/${book.bookImage.id}" class="card-img-top book-cover" alt="Book Cover Image">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="card-img-top book-cover d-flex flex-column align-items-center justify-content-center text-muted">
                                            <i class="fa-solid fa-book-bookmark fa-3x mb-2 opacity-25 text-success"></i>
                                            <span class="small fw-medium">No Custom Artwork</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <!-- Card Metadata Body -->
                                <div class="card-body d-flex flex-column">
                                    <span class="text-uppercase tracking-wider text-success fw-bold small mb-1"><c:out value="${book.category}"/></span>
                                    <h5 class="card-title text-dark fw-bold text-truncate mb-1" title="${book.bookName}">
                                        <c:out value="${book.bookName}"/>
                                    </h5>
                                    <p class="text-muted small mb-2">By <c:out value="${book.authorName}"/></p>

                                    <!-- Pages & Star Ratings Layer -->
                                    <div class="mb-3 mt-auto border-top pt-2">
                                        <span class="rating-star"><i class="fa-solid fa-star small"></i></span>
                                        <span class="fw-bold small text-dark"><c:out value="${book.rating != null ? book.rating : '5.0'}"/></span>
                                        <span class="text-muted small mx-1">|</span>
                                        <span class="text-muted small"><i class="fa-regular fa-file-lines me-1"></i><c:out value="${book.totalPages}"/> Pages</span>
                                    </div>

                                    <!-- Quick Action Button Layout Block -->
                                    <div class="d-grid gap-2">
                                        <!-- Action A: Read Link Redirection -->
                                        <c:choose>
                                            <c:when test="${not empty book.readLink}">
                                                <a href="<c:out value='${book.readLink}'/>" target="_blank" class="btn btn-outline-success action-btn py-2">
                                                    <i class="fa-solid fa-arrow-up-right-from-square me-1"></i> Read Online
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn btn-outline-secondary action-btn py-2 disabled" disabled>
                                                    <i class="fa-solid fa-laptop-code me-1"></i> Web Reader N/A
                                                </button>
                                            </c:otherwise>
                                        </c:choose>

                                        <!-- Action B: Local Storage System PDF Stream Downloader -->
                                        <c:choose>
                                            <c:when test="${not empty book.bookPdf}">
                                                <a href="${pageContext.request.contextPath}/files/download/${book.bookPdf.id}" class="btn btn-success action-btn py-2 shadow-sm">
                                                    <i class="fa-solid fa-cloud-arrow-down me-1"></i> Download PDF
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn btn-secondary action-btn py-2 disabled" disabled>
                                                    <i class="fa-solid fa-circle-minus me-1"></i> No PDF Attached
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
                    <!-- Fallback Structure if Database has no items matching FREE -->
                    <div class="col-12 text-center py-5">
                        <div class="text-muted mb-3">
                            <i class="fa-solid fa-face-meh fa-4x opacity-25 text-success"></i>
                        </div>
                        <h4 class="text-dark fw-bold">No Public Resources Listed</h4>
                        <p class="text-muted">Our librarians haven't uploaded open-access digital files to this section yet. Check back soon!</p>
                        <a href="${pageContext.request.contextPath}/books/paid" class="btn btn-primary mt-2">
                            Browse Premium Catalogue
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Bootstrap 5 JavaScript Execution Core -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>