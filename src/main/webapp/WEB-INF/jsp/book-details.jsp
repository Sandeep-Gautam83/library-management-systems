<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${book.bookName} | LMS Premium Matrix</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        [data-theme="dark"] {
            --bg-gradient: radial-gradient(circle at 50% 50%, #0f172a 0%, #020617 100%);
            --card-bg: rgba(30, 41, 59, 0.45);
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --border-color: rgba(255, 255, 255, 0.08);
            --glass-panel: rgba(255, 255, 255, 0.03);
            --panel-dark: #0f172a;
            --accent-blue: #0ea5e9;
            --left-frame-bg: rgba(15, 23, 42, 0.6);
        }

        [data-theme="light"] {
            --bg-gradient: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%);
            --card-bg: rgba(255, 255, 255, 0.85);
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border-color: rgba(15, 23, 42, 0.08);
            --glass-panel: rgba(15, 23, 42, 0.02);
            --panel-dark: #f8fafc;
            --accent-blue: #0284c7;
            --left-frame-bg: #e2e8f0;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
            transition: background 0.3s ease, color 0.3s ease, border-color 0.3s ease;
        }

        body {
            background: var(--bg-gradient) !important;
            background-attachment: fixed !important;
            color: var(--text-main);
            min-height: 100vh;
            overflow-x: hidden;
            padding-bottom: 60px;
        }

        .utility-bar {
            width: 92%;
            max-width: 1300px;
            margin: 20px auto 0 auto;
            display: flex;
            justify-content: flex-end;
            align-items: center;
        }

        .theme-toggle-btn {
            background: var(--card-bg);
            color: var(--text-main);
            border: 1px solid var(--border-color);
            padding: 10px 18px;
            border-radius: 14px;
            font-weight: 500;
            font-size: 14px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        .theme-toggle-btn:hover {
            transform: translateY(-1px);
            border-color: var(--accent-blue);
        }

        /* ======================================= */
        /* PREMIUM MAIN CONTAINER WRAPPER          */
        /* ======================================= */
        .book-container {
            width: 92%;
            max-width: 1300px;
            margin: 20px auto 40px auto;
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 24px;
            overflow: hidden;
            backdrop-filter: blur(16px);
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        }

        .book-left {
            background: var(--left-frame-bg);
            padding: 40px 30px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100%;
            border-right: 1px solid var(--border-color);
        }

        .book-left img {
            width: 100%;
            max-width: 290px;
            height: 410px;
            object-fit: cover;
            border-radius: 16px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.25);
            border: 1px solid rgba(255, 255, 255, 0.05);
            transition: transform 0.4s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .book-left img:hover {
            transform: scale(1.03) translateY(-4px);
        }

        .book-right {
            padding: 45px 50px;
        }

        .badge-stock {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 16px;
            border-radius: 10px;
            font-size: 12.5px;
            font-weight: 600;
            margin-bottom: 20px;
            letter-spacing: 0.3px;
        }
        .available { background: rgba(34, 197, 94, 0.15); color: #22c55e; border: 1px solid rgba(34, 197, 94, 0.2); }
        [data-theme="dark"] .available { color: #4ade80; }
        .out { background: rgba(239, 68, 68, 0.15); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.2); }
        [data-theme="dark"] .out { color: #f87171; }
        .badge-premium { background: rgba(234, 179, 8, 0.15); color: #d97706; border: 1px solid rgba(234, 179, 8, 0.3); }
        [data-theme="dark"] .badge-premium { color: #eab308; }

        .book-title {
            font-size: 36px;
            font-weight: 700;
            margin-bottom: 12px;
            line-height: 46px;
            letter-spacing: -0.5px;
            color: var(--text-main);
        }

        .book-author {
            color: var(--accent-blue);
            font-size: 19px;
            font-weight: 500;
            margin-bottom: 20px;
        }

        .rating-wrapper {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(250, 204, 21, 0.1);
            border: 1px solid rgba(250, 204, 21, 0.2);
            padding: 6px 14px;
            border-radius: 10px;
            margin-bottom: 25px;
            color: #eab308;
            font-weight: 600;
            font-size: 14.5px;
        }

        .book-description {
            color: var(--text-muted);
            font-size: 14.5px;
            line-height: 26px;
            margin-bottom: 30px;
            background: var(--glass-panel);
            padding: 20px;
            border-radius: 14px;
            border: 1px solid var(--border-color);
        }

        /* METRIC PACK GRID SYSTEM */
        .book-info {
            background: var(--panel-dark);
            padding: 24px;
            border-radius: 18px;
            margin-bottom: 35px;
            border: 1px solid var(--border-color);
        }

        .book-info p {
            margin-bottom: 12px;
            font-size: 14.5px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 10px;
        }

        .book-info p:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }

        .book-info strong {
            color: var(--text-muted);
            font-weight: 500;
        }

        .book-info span {
            color: var(--text-main);
            font-weight: 600;
        }

        .lang-text {
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* ======================================= */
        /* ACTION LAYOUT CONTROL SYSTEMS           */
        /* ======================================= */
        .action-buttons {
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
        }

        .btn-custom {
            height: 52px;
            padding: 0 28px;
            border: none;
            border-radius: 14px;
            font-size: 15px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            cursor: pointer;
        }

        .btn-read { background: linear-gradient(135deg, #0ea5e9 0%, #2563eb 100%); color: white !important; box-shadow: 0 4px 15px rgba(14, 165, 233, 0.25); }
        .btn-download { background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%); color: white !important; box-shadow: 0 4px 15px rgba(34, 197, 94, 0.25); }
        .btn-payment { background: linear-gradient(135deg, #eab308 0%, #ca8a04 100%); color: #020617 !important; box-shadow: 0 4px 15px rgba(234, 179, 8, 0.3); }
        .btn-back { background: transparent; color: var(--text-main) !important; border: 1px solid var(--border-color); }

        .btn-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
        }
        .btn-back:hover {
            background: var(--glass-panel);
            border-color: var(--text-muted);
        }

        /* ======================================= */
        /* SIMILAR BOOKS STRUCTURAL SECTIONS       */
        /* ======================================= */
        .similar-section {
            width: 92%;
            max-width: 1300px;
            margin: 60px auto 20px auto;
        }

        .section-title {
            font-size: 26px;
            font-weight: 700;
            margin-bottom: 30px;
            color: var(--text-main);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .section-title::before {
            content: '';
            width: 4px;
            height: 24px;
            background: var(--accent-blue);
            border-radius: 4px;
            display: inline-block;
        }

        .similar-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
            height: 100%;
            display: flex;
            flex-direction: column;
            backdrop-filter: blur(10px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        }

        .similar-card:hover {
            transform: translateY(-6px);
            border-color: rgba(14, 165, 233, 0.3);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
        }

        .similar-img-wrapper {
            width: 100%;
            height: 250px;
            background: rgba(15, 23, 42, 0.05);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            border-bottom: 1px solid var(--border-color);
        }
        [data-theme="dark"] .similar-img-wrapper { background: rgba(15, 23, 42, 0.4); }

        .similar-card img {
            max-width: 100%;
            max-height: 100%;
            object-fit: cover;
            border-radius: 10px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }

        .similar-content {
            padding: 20px;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
            justify-content: space-between;
        }

        .similar-content h5 {
            color: var(--text-main);
            font-size: 15.5px;
            font-weight: 600;
            margin-bottom: 6px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            height: 44px;
            line-height: 22px;
        }

        .similar-content p {
            color: var(--text-muted);
            font-size: 13px;
            margin-bottom: 20px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .similar-btn {
            display: block;
            background: var(--glass-panel);
            color: var(--text-main);
            border: 1px solid var(--border-color);
            padding: 11px 15px;
            border-radius: 12px;
            text-decoration: none;
            font-size: 13.5px;
            font-weight: 600;
            text-align: center;
            transition: all 0.2s ease;
        }

        .similar-btn:hover {
            background: var(--accent-blue);
            border-color: var(--accent-blue);
            color: white;
            box-shadow: 0 4px 12px rgba(14, 165, 233, 0.2);
        }

        /* ======================================= */
        /* MEDIA GRID RESPONSIVE OVERRIDES        */
        /* ======================================= */
        @media(max-width: 1200px) {
            .book-title { font-size: 30px; line-height: 40px; }
            .book-right { padding: 35px; }
        }

        @media(max-width: 992px) {
            .book-left { border-right: none; border-bottom: 1px solid var(--border-color); padding: 35px; }
            .book-left img { max-height: 380px; }
            .book-right { padding: 30px; }
            .btn-custom { width: 100%; }
        }

        @media(max-width: 768px) {
            .book-title { font-size: 24px; line-height: 34px; }
            .book-info p { flex-direction: column; align-items: flex-start; gap: 4px; border-bottom: none; padding-bottom: 0; margin-bottom: 14px;}
            .book-info p strong { font-size: 12.5px; }
            .book-info p span { font-size: 14.5px; }
        }

        @media(max-width: 576px) {
            .book-container { width: 100%; border-radius: 0; margin: 10px 0 0 0; border: none; }
            .similar-section { width: 95%; }
            .utility-bar { width: 95%; }
        }
    </style>
</head>
<body>

<div class="utility-bar">
    <button class="theme-toggle-btn" id="themeToggle" onclick="toggleDisplayTheme()">
        <i class="bi bi-sun-fill d-none" id="sunIcon"></i>
        <i class="bi bi-moon-stars-fill" id="moonIcon"></i>
        <span id="themeText">Switch Interface Mode</span>
    </button>
</div>

<c:set var="sessionPurchaseKey" value="purchased_book_${book.id}" />
<c:set var="hasBookAccess" value="${isBookPurchased or sessionScope[sessionPurchaseKey] == true}" />

<div class="container mt-4">
    <c:if test="${param.payment == 'success'}">
        <div class="alert alert-success border-0 shadow-sm">
            Payment completed successfully. Book access is now unlocked.
        </div>
    </c:if>

    <c:if test="${param.payment == 'already_purchased'}">
        <div class="alert alert-info border-0 shadow-sm">
            This book is already unlocked for your account.
        </div>
    </c:if>

    <c:if test="${param.payment == 'cancelled'}">
        <div class="alert alert-warning border-0 shadow-sm">
            Payment was cancelled before completion.
        </div>
    </c:if>

    <c:if test="${param.error == 'payment_init_failed'}">
        <div class="alert alert-danger border-0 shadow-sm">
            Payment gateway initialization failed. Please try again.
        </div>
    </c:if>

    <c:if test="${param.error == 'invalid_signature'}">
        <div class="alert alert-danger border-0 shadow-sm">
            Payment verification failed because the payment signature was invalid.
        </div>
    </c:if>

    <c:if test="${param.error == 'invalid_payment_request'}">
        <div class="alert alert-danger border-0 shadow-sm">
            Payment request validation failed. Please restart checkout for this book.
        </div>
    </c:if>

    <c:if test="${param.error == 'verification_exception'}">
        <div class="alert alert-danger border-0 shadow-sm">
            Payment verification failed due to an unexpected server error.
        </div>
    </c:if>
</div>

<div class="book-container">
    <div class="row g-0">

        <div class="col-lg-5 col-xl-4">
            <div class="book-left">
                <c:choose>
                    <c:when test="${book.bookImage != null}">
                        <img src="${pageContext.request.contextPath}/files/view/${book.bookImage.id}" alt="Book Graphic Core">
                    </c:when>
                    <c:otherwise>
                        <img src="https://images.unsplash.com/photo-1543002588-bfa74002ed7e?auto=format&fit=crop&w=260&h=340&q=80" alt="Placeholder Stream">
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="col-lg-7 col-xl-8">
            <div class="book-right">

                <div class="d-flex gap-2 flex-wrap">
                    <c:choose>
                        <c:when test="${book.availableQuantity > 0}">
                            <div class="badge-stock available"><i class="bi bi-shield-check"></i> In Stock</div>
                        </c:when>
                        <c:otherwise>
                            <div class="badge-stock out"><i class="bi bi-shield-slash"></i> Out of Stock</div>
                        </c:otherwise>
                    </c:choose>

                    <c:choose>
                        <c:when test="${book.price == 0.0 || empty book.price}">
                            <div class="badge-stock available"><i class="bi bi-unlock"></i> Open Access (Free)</div>
                        </c:when>
                        <c:otherwise>
                            <div class="badge-stock badge-premium"><i class="bi bi-gem"></i> Premium Shelf (Paid)</div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <h1 class="book-title">${book.bookName}</h1>
                <h4 class="book-author">By ${book.authorName}</h4>

                <div class="rating-wrapper">
                    <i class="bi bi-star-fill" style="color: #facc15;"></i> <span>${book.rating != null ? book.rating : '4.5'} / 5  Rating</span>
                </div>

                <c:if test="${not empty book.description}">
                    <p class="book-description">${book.description}</p>
                </c:if>

                <div class="book-info">
                    <p><strong>Book Category</strong> <span>${book.category}</span></p>
                    <p>
                        <strong>Language</strong>
                        <span class="lang-text">
                            <c:choose>
                                <c:when test="${book.language == 'en'}">English</c:when>
                                <c:when test="${book.language == 'hi'}">Hindi</c:when>
                                <c:otherwise>${book.language}</c:otherwise>
                            </c:choose>
                        </span>
                    </p>
                    <p><strong>Enterprise Publisher</strong> <span>${book.publisher}</span></p>
                    <p><strong>Published Year</strong> <span>${book.publishedYear}</span></p>
                    <p><strong>Total Pages</strong> <span>${book.totalPages}</span></p>
                    <p>
                        <strong>Total Book Price    </strong>
                        <span style="color: #22c55e; font-family: monospace; font-size: 16px; font-weight: 700;">
                            <c:choose>
                                <c:when test="${book.price == 0.0 || empty book.price}">FREE</c:when>
                                <c:otherwise>&#8377; ${book.price}</c:otherwise>
                            </c:choose>
                        </span>
                    </p>
                </div>

                <div class="action-buttons">
                    <c:choose>
                        <%-- CONDITION 1: BOOK IS FREE OR USER HAS ALREADY PURCHASED --%>
                        <c:when test="${book.price == 0.0 || empty book.price || hasBookAccess == true}">
                            <c:if test="${book.bookPdf != null}">
                                <a href="${pageContext.request.contextPath}/files/view/${book.bookPdf.id}" target="_blank" class="btn-custom btn-read">
                                    <i class="bi bi-book-half"></i> Read Books
                                </a>
                                <a href="${pageContext.request.contextPath}/files/download/${book.bookPdf.id}" class="btn-custom btn-download">
                                    <i class="bi bi-cloud-arrow-up"></i> Download PDF
                                </a>
                            </c:if>
                        </c:when>

                        <%-- CONDITION 2: BOOK IS PAID AND NOT UNLOCKED YET --%>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/payment/checkout?bookId=${book.id}" class="btn-custom btn-payment">
                                <i class="bi bi-credit-card-2-back-fill"></i> Unlock Book (Pay &#8377; ${book.price})
                            </a>
                        </c:otherwise>
                    </c:choose>

                    <a href="${pageContext.request.contextPath}/student/dashboard" class="btn-custom btn-back">
                        <i class="bi bi-house-door"></i> Back to Home
                    </a>
                </div>

            </div>
        </div>
    </div>
</div>

<div class="container similar-section">
    <h2 class="section-title">Similar Type Books</h2>
    <div class="row g-4">
        <c:choose>
            <c:when test="${not empty similarBooks}">
                <c:forEach items="${similarBooks}" var="similarBook">
                    <div class="col-xl-3 col-lg-4 col-sm-6">
                        <div class="similar-card">
                            <div class="similar-img-wrapper">
                                <c:choose>
                                    <c:when test="${similarBook.bookImage != null}">
                                        <img src="${pageContext.request.contextPath}/files/view/${similarBook.bookImage.id}" alt="${similarBook.bookName}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="https://images.unsplash.com/photo-1543002588-bfa74002ed7e?auto=format&fit=crop&w=260&h=340&q=80" alt="Placeholder Stream">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="similar-content">
                                <div>
                                    <h5>${similarBook.bookName}</h5>
                                    <p>By ${similarBook.authorName}</p>
                                </div>
                                <a href="${pageContext.request.contextPath}/student/book-details/${similarBook.id}" class="similar-btn">
                                    Read Books
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="col-12 text-center py-4">
                    <p class="text-muted font-monospace" style="font-size: 14px;"><i class="bi bi-info-circle me-1"></i> No matching secondary book data found.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>

<script>
    /* ======================================= */
    /* ENHANCED LIVE CORE THEME CONTROLLER     */
    /* ======================================= */
    document.addEventListener("DOMContentLoaded", function () {
        const savedTheme = localStorage.getItem("lms-theme") || "dark";
        document.documentElement.setAttribute("data-theme", savedTheme);
        updateToggleIcons(savedTheme);
    });

    function toggleDisplayTheme() {
        const currentTheme = document.documentElement.getAttribute("data-theme");
        const targetTheme = currentTheme === "dark" ? "light" : "dark";

        document.documentElement.setAttribute("data-theme", targetTheme);
        localStorage.setItem("lms-theme", targetTheme);
        updateToggleIcons(targetTheme);
    }

    function updateToggleIcons(theme) {
        const sunIcon = document.getElementById("sunIcon");
        const moonIcon = document.getElementById("moonIcon");
        const themeText = document.getElementById("themeText");

        if (theme === "dark") {
            sunIcon.classList.add("d-none");
            moonIcon.classList.remove("d-none");
            themeText.textContent = "Light Mode";
        } else {
            moonIcon.classList.add("d-none");
            sunIcon.classList.remove("d-none");
            themeText.textContent = "Dark Mode";
        }
    }
</script>
</body>
</html>


