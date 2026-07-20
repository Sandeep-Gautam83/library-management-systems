<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (session == null || session.getAttribute("loggedInUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard-LMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
         :root[data-theme="dark"] {
            --bg-gradient: radial-gradient(circle at top right, #1e1b4b, #0f172a);
            --sidebar-bg: rgba(15, 23, 42, 0.6);
            --card-bg: rgba(255, 255, 255, 0.03);
            --card-border: rgba(255, 255, 255, 0.08);
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --text-content: #cbd5e1;
            --topbar-bg: rgba(15, 23, 42, 0.4);
            --shadow: rgba(0, 0, 0, 0.4);
            --input-bg: rgba(255, 255, 255, 0.05);
            --input-placeholder: rgba(255, 255, 255, 0.4);
            --footer-bg: #090d16;
            --slider-card-bg: rgba(30, 41, 59, 0.4);
            --accent-glow: rgba(99, 102, 241, 0.15);
        }

        :root[data-theme="light"] {
            --bg-gradient: radial-gradient(circle at top right, #eff6ff, #f8fafc);
            --sidebar-bg: rgba(255, 255, 255, 0.7);
            --card-bg: rgba(255, 255, 255, 0.8);
            --card-border: rgba(15, 23, 42, 0.06);
            --text-main: #0f172a;
            --text-muted: #64748b;
            --text-content: #334155;
            --topbar-bg: rgba(255, 255, 255, 0.5);
            --shadow: rgba(0, 0, 0, 0.03);
            --input-bg: rgba(15, 23, 42, 0.04);
            --input-placeholder: rgba(15, 23, 42, 0.5);
            --footer-bg: #f1f5f9;
            --slider-card-bg: rgba(255, 255, 255, 0.9);
            --accent-glow: rgba(37, 99, 235, 0.05);
        }

        * {
            margin: 0; padding: 0; box-sizing: border-box;
            font-family: 'Plus Jakarta Sans', sans-serif;
            transition: background 0.3s cubic-bezier(0.4, 0, 0.2, 1), color 0.3s ease, border-color 0.3s ease;
        }

        body {
            background: var(--bg-gradient);
            min-height: 100vh;
            color: var(--text-main);
            overflow-x: hidden;
        }

        /* Custom Scrollbar */
        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #6366f1; border-radius: 10px; }

        /* SIDEBAR PANEL */
        .sidebar {
            width: 280px; height: 100vh; position: fixed;
            top: 0; left: 0; background: var(--sidebar-bg);
            backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px);
            border-right: 1px solid var(--card-border);
            padding: 40px 24px; z-index: 1040; transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .logo { display: flex; align-items: center; gap: 12px; margin-bottom: 40px; }
        .logo i { font-size: 32px; color: #6366f1; }
        .logo h2 { color: var(--text-main); font-weight: 800; margin: 0; font-size: 22px; letter-tight: -0.05em; }

        .sidebar-menu a {
            display: flex; align-items: center; gap: 14px;
            padding: 12px 16px; margin-bottom: 8px; border-radius: 12px;
            text-decoration: none; color: var(--text-content); font-weight: 500; font-size: 14px;
        }
        .sidebar-menu a:hover {
            background: var(--card-bg); color: var(--text-main); transform: translateX(4px);
        }
        .sidebar-menu a.active {
            background: #6366f1; color: white !important;
            box-shadow: 0 10px 20px rgba(99, 102, 241, 0.25);
            font-weight: 600;
        }

        /* MAIN LAYOUT */
        .main-content { margin-left: 280px; padding: 40px; min-height: 100vh; display: flex; flex-direction: column; }
        .content-body { flex: 1 0 auto; }

        /* TOPBAR NAVIGATION */
        .modern-topbar {
            background: var(--topbar-bg); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--card-border); border-radius: 16px;
            padding: 14px 28px; display: flex; justify-content: space-between;
            align-items: center; position: sticky; top: 20px; z-index: 1000;
            box-shadow: 0 10px 30px var(--shadow); margin-bottom: 40px;
        }

        .topbar-logo { display: flex; align-items: center; gap: 12px; text-decoration: none; }
        .topbar-logo img { width: 38px; height: 38px; object-fit: contain; }
        .topbar-logo-text h2 { margin: 0; color: var(--text-main); font-size: 18px; font-weight: 800; }
        .topbar-logo-text span { color: var(--text-muted); font-size: 11px; }

        .topbar-menu { display: flex; align-items: center; gap: 24px; }
        .topbar-menu a {
            text-decoration: none; color: var(--text-muted);
            font-size: 14px; font-weight: 600; display: flex; align-items: center; gap: 8px;
        }
        .topbar-menu a:hover, .topbar-menu a.active { color: #6366f1; }

        .topbar-right { display: flex; align-items: center; gap: 12px; }
        .theme-toggle-btn, .menu-btn {
            border: 1px solid var(--card-border); background: var(--input-bg);
            width: 40px; height: 40px; border-radius: 10px; color: var(--text-main);
            display: flex; justify-content: center; align-items: center; cursor: pointer;
        }
        .theme-toggle-btn:hover { background: var(--card-bg); border-color: #6366f1; color: #6366f1; }
        .menu-btn { display: none; }

        /* SEARCH BAR */
        .search-box { max-width: 540px; margin: 0 auto 40px auto; width: 100%; position: relative; }
        .search-box input {
            background: var(--input-bg) !important;
            border: 1px solid var(--card-border);
            color: var(--text-main) !important;
            height: 50px; border-radius: 14px;
            padding-left: 20px; padding-right: 55px; font-size: 14px;
        }
        .search-box input::placeholder { color: var(--input-placeholder) !important; }
        .search-box input:focus {
            border-color: #6366f1; box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.15);
        }
        .search-box button {
            position: absolute; right: 6px; top: 6px; bottom: 6px;
            border-radius: 10px; border: none; width: 38px;
            background: #6366f1; color: white; display: flex; align-items: center; justify-content: center;
        }
        .search-box button:hover { background: #4f46e5; }

        /* INFINITE SCROLL CAROUSEL */
        .library-marquee-container {
            width: 100%; overflow: hidden; position: relative; padding: 15px 0;
            background: var(--card-bg); border-radius: 20px;
            border: 1px solid var(--card-border); margin-bottom: 40px;
        }
        .library-marquee-container::before, .library-marquee-container::after {
            content: ""; height: 100%; width: 80px; position: absolute; z-index: 2; top: 0; pointer-events: none;
        }
        .library-marquee-container::before { left: 0; background: linear-gradient(to right, var(--sidebar-bg), transparent); }
        .library-marquee-container::after { right: 0; background: linear-gradient(to left, var(--sidebar-bg), transparent); }

        .marquee-track {
            display: flex; width: calc(300px * 20); animation: infiniteMarquee 40s linear infinite;
        }
        .marquee-track:hover { animation-play-state: paused; }

        .marquee-item {
            width: 280px; flex-shrink: 0; margin: 0 10px;
            background: var(--slider-card-bg); border: 1px solid var(--card-border);
            border-radius: 14px; padding: 12px; display: flex; align-items: center; gap: 15px;
        }
        .marquee-item img { width: 65px; height: 90px; object-fit: cover; border-radius: 8px; }
        .marquee-details { flex-grow: 1; overflow: hidden; }
        .marquee-details h5 { font-size: 13px; font-weight: 700; margin-bottom: 4px; color: var(--text-main); white-space: nowrap; text-overflow: ellipsis; overflow: hidden; }
        .marquee-details p { font-size: 11px; color: var(--text-muted); margin-bottom: 8px; white-space: nowrap; text-overflow: ellipsis; overflow: hidden; }
        .marquee-btn { font-size: 11px; padding: 5px 12px; border-radius: 8px; background: #6366f1; color: white !important; text-decoration: none; font-weight: 600; display: inline-block; }
        .marquee-btn:hover { background: #4f46e5; }

        @keyframes infiniteMarquee {
            0% { transform: translateX(0); }
            100% { transform: translateX(calc(-300px * 10)); }
        }

        /* STATS CARDS */
        .stats-card {
            background: var(--card-bg); border: 1px solid var(--card-border); border-radius: 16px;
            padding: 24px; height: 100%; position: relative; overflow: hidden;
        }
        .stats-card:hover { transform: translateY(-4px); border-color: #6366f1; box-shadow: 0 12px 24px var(--accent-glow); }
        .stats-icon {
            width: 48px; height: 48px; border-radius: 12px;
            display: flex; justify-content: center; align-items: center; margin-bottom: 16px;
            background: rgba(99, 102, 241, 0.1); color: #6366f1; font-size: 20px;
        }
        .stats-card h3 { font-size: 28px; font-weight: 800; margin: 0; color: var(--text-main); }
        .stats-card p { color: var(--text-muted); margin: 6px 0 0 0; font-size: 13px; font-weight: 500; }

        /* BOOK GRID - 5 COLUMNS DYNAMIC */
        .section-title { font-size: 18px; font-weight: 800; margin: 40px 0 20px 0; color: var(--text-main); letter-spacing: -0.02em; }

        .book-slider {
            display: grid; grid-template-columns: repeat(5, 1fr); gap: 20px; margin-bottom: 20px;
        }

        .book-card {
            background: var(--card-bg); border: 1px solid var(--card-border); border-radius: 14px;
            overflow: hidden; height: 100%; display: flex; flex-direction: column;
        }
        .book-card:hover { transform: translateY(-6px); border-color: #6366f1; box-shadow: 0 12px 24px var(--accent-glow); }
        .book-card img { width: 100%; aspect-ratio: 3/4; object-fit: cover; }
        .book-content { padding: 16px; display: flex; flex-direction: column; flex-grow: 1; justify-content: space-between; }
        .book-content h4 { font-size: 13px; font-weight: 700; margin-bottom: 4px; color: var(--text-main); overflow: hidden; white-space: nowrap; text-overflow: ellipsis; }
        .book-content p { color: var(--text-muted); font-size: 12px; margin-bottom: 8px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; }
        .book-rating { color: #facc15; font-size: 12px; font-weight: 700; margin-bottom: 12px; }
        .book-status {
            padding: 4px 10px; border-radius: 6px; background: rgba(16, 185, 129, 0.1);
            color: #10b981; font-size: 11px; font-weight: 700; text-align: center; width: fit-content;
        }
        .book-status.out-stock { background: rgba(239, 68, 68, 0.1); color: #ef4444; }

        /* FOOTER */
        .modern-footer {
            margin-top: 60px; background: var(--footer-bg);
            border-top: 1px solid var(--card-border); padding: 60px 40px 30px 40px;
            border-radius: 20px 20px 0 0;
        }
        .footer-title { font-size: 14px; font-weight: 700; margin-bottom: 20px; color: var(--text-main); text-transform: uppercase; letter-spacing: 0.05em; }
        .footer-desc { color: var(--text-muted); font-size: 13px; line-height: 1.6; margin-bottom: 20px; }
        .footer-links { list-style: none; padding: 0; margin: 0; }
        .footer-links li { margin-bottom: 10px; }
        .footer-links a { color: var(--text-muted); text-decoration: none; font-size: 13px; display: flex; align-items: center; gap: 6px; }
        .footer-links a:hover { color: #6366f1; transform: translateX(3px); }

        .newsletter-box .form-control {
            background: var(--input-bg); border: 1px solid var(--card-border);
            color: var(--text-main); border-radius: 10px; padding: 10px 14px; font-size: 13px;
        }
        .newsletter-box .btn {
            background: #6366f1; color: white; border: none; border-radius: 10px; padding: 10px 18px; font-weight: 600; font-size: 13px;
        }
        .newsletter-box .btn:hover { background: #4f46e5; }

        .social-icons { display: flex; gap: 8px; margin-top: 15px; }
        .social-icons a {
            width: 36px; height: 36px; display: flex; justify-content: center; align-items: center;
            border-radius: 8px; background: var(--input-bg); color: var(--text-main); text-decoration: none; font-size: 14px;
        }
        .social-icons a:hover { background: #6366f1; color: white; transform: translateY(-2px); }

        /* RESPONSIVE BREAKPOINTS */
        @media(max-width: 1400px) { .book-slider { grid-template-columns: repeat(4, 1fr); } }
        @media(max-width: 1100px) { .book-slider { grid-template-columns: repeat(3, 1fr); } }
        @media(max-width: 992px) {
            .sidebar { transform: translateX(-100%); }
            .sidebar.active { transform: translateX(0); }
            .main-content { margin-left: 0; padding: 20px; }
            .topbar-menu { display: none; }
            .menu-btn { display: flex; }
            .book-slider { grid-template-columns: repeat(3, 1fr); }
        }
        @media(max-width: 768px) { .book-slider { grid-template-columns: repeat(2, 1fr); } }
        @media(max-width: 480px) { .book-slider { grid-template-columns: repeat(1, 1fr); } }
    </style>
</head>
<body>

<div class="sidebar" id="sidebarNav">
    <div class="logo">
        <i class="bi bi-book-half"></i>
        <h2>LMS Student</h2>
    </div>
    <div class="sidebar-menu">
        <a href="${pageContext.request.contextPath}/student/dashboard" class="active"><i class="bi bi-speedometer2"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/student/available-books"><i class="bi bi-book"></i> Available Books</a>
        <a href="${pageContext.request.contextPath}/student/student-issued-books"><i class="bi bi-journal-bookmark"></i> My Issued Books</a>
        <a href="${pageContext.request.contextPath}/student/chat"><i class="bi bi-chat-dots"></i> Student Chat</a>
        <a href="${pageContext.request.contextPath}/student/profile"><i class="bi bi-person-circle"></i> My Profile</a>
        <a href="${pageContext.request.contextPath}/auth/logout" style="margin-top: 40px; color: #ef4444;"><i class="bi bi-box-arrow-right"></i> Logout</a>
    </div>
</div>



<div class="main-content">
    <div class="content-body">

        <div class="modern-topbar">
            <a href="${pageContext.request.contextPath}/student/dashboard" class="topbar-logo">
                <img src="https://cdn-icons-png.flaticon.com/512/2232/2232688.png" alt="logo">
                <div class="topbar-logo-text">
                    <h2>Let's Read</h2>
                    <span>Library Management Systems</span>
                </div>
            </a>

            <div class="topbar-menu">
                <a href="${pageContext.request.contextPath}/student/dashboard" class="active"><i class="bi bi-house"></i> Home</a>
                <a href="${pageContext.request.contextPath}/student/student-issued-books"><i class="bi bi-book"></i> My Books</a>
                <a href="${pageContext.request.contextPath}/student/profile"><i class="bi bi-person"></i> Profile</a>
            </div>

            <div class="topbar-right">
                <button class="theme-toggle-btn" id="themeToggle" title="Toggle Light/Dark Mode">
                    <i class="bi bi-moon-stars" id="themeIcon"></i>
                </button>
                <button class="menu-btn" id="menuToggleBtn">
                    <i class="bi bi-list"></i>
                </button>
            </div>
        </div>


        <form action="${pageContext.request.contextPath}/student/available-books" method="get" class="search-box">
            <input type="text" name="keyword" class="form-control" placeholder="Search by name, author, or publisher..." required>
            <button type="submit"><i class="bi bi-search"></i></button>
        </form>

        <div class="library-marquee-container">
            <div class="marquee-track">

                <div class="marquee-item">
                    <img src="https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400" alt="Java">
                    <div class="marquee-details">
                        <h5>Effective Java</h5>
                        <p>Joshua Bloch</p>
                        <a href="#" class="marquee-btn">Read Now</a>
                    </div>
                </div>

                <div class="marquee-item">
                    <img src="https://images.unsplash.com/photo-1532012197267-da84d127e765?w=400" alt="Clean Code">
                    <div class="marquee-details">
                        <h5>Clean Code</h5>
                        <p>Robert C. Martin</p>
                        <a href="#" class="marquee-btn">Read Now</a>
                    </div>
                </div>
                <div class="marquee-item">
                    <img src="https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=400" alt="Web Dev">
                    <div class="marquee-details">
                        <h5>Fullstack UI Modules</h5>
                        <p>David Flanagan</p>
                        <a href="#" class="marquee-btn">Read Now</a>
                    </div>
                </div>
                <div class="marquee-item">
                    <img src="https://images.unsplash.com/photo-1543002588-bfa74002ed7e?w=400" alt="Python">
                    <div class="marquee-details">
                        <h5>Python Data Handbook</h5>
                        <p>Jake VanderPlas</p>
                        <a href="#" class="marquee-btn">Read Now</a>
                    </div>
                </div>
                <div class="marquee-item">
                    <img src="https://images.unsplash.com/photo-1610116306796-6fea9f4fae38?w=400" alt="Algorithms">
                    <div class="marquee-details">
                        <h5>Introduction to Algos</h5>
                        <p>Thomas H. Cormen</p>
                        <a href="#" class="marquee-btn">Read Now</a>
                    </div>
                </div>
                <div class="marquee-item">
                    <img src="https://images.unsplash.com/photo-1506880018603-83d5b814b5a6?w=400" alt="Cloud">
                    <div class="marquee-details">
                        <h5>Cloud Architecture</h5>
                        <p>Enterprise Edition</p>
                        <a href="#" class="marquee-btn">Read Now</a>
                    </div>
                </div>
                <div class="marquee-item">
                    <img src="https://images.unsplash.com/photo-1589829545856-d10d557cf95f?w=400" alt="SQL">
                    <div class="marquee-details">
                        <h5>SQL Performance</h5>
                        <p>Markus Winand</p>
                        <a href="#" class="marquee-btn">Read Now</a>
                    </div>
                </div>
                <div class="marquee-item">
                    <img src="https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=400" alt="AI">
                    <div class="marquee-details">
                        <h5>Modern AI Systems</h5>
                        <p>Stuart Russell</p>
                        <a href="#" class="marquee-btn">Read Now</a>
                    </div>
                </div>
                <div class="marquee-item">
                    <img src="https://images.unsplash.com/photo-1563206767-5b18f218e8de?w=400" alt="Cyber">
                    <div class="marquee-details">
                        <h5>Network Protocol</h5>
                        <p>William Stallings</p>
                        <a href="#" class="marquee-btn">Read Now</a>
                    </div>
                </div>
                <div class="marquee-item">
                    <img src="https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400" alt="Spring">
                    <div class="marquee-details">
                        <h5>Spring Boot in Action</h5>
                        <p>Craig Walls</p>
                        <a href="#" class="marquee-btn">Read Now</a>
                    </div>
                </div>

                <div class="marquee-item">
                    <img src="https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400" alt="Java">
                    <div class="marquee-details">
                        <h5>Effective Java</h5>
                        <p>Joshua Bloch</p>
                        <a href="#" class="marquee-btn">Read Now</a>
                    </div>
                </div>
                <div class="marquee-item">
                    <img src="https://images.unsplash.com/photo-1532012197267-da84d127e765?w=400" alt="Clean Code">
                    <div class="marquee-details">
                        <h5>Clean Code</h5>
                        <p>Robert C. Martin</p>
                        <a href="#" class="marquee-btn">Read Now</a>
                    </div>
                </div>
                <div class="marquee-item">
                    <img src="https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=400" alt="Web Dev">
                    <div class="marquee-details">
                        <h5>Fullstack UI Modules</h5>
                        <p>David Flanagan</p>
                        <a href="#" class="marquee-btn">Read Now</a>
                    </div>
                </div>
                <div class="marquee-item">
                    <img src="https://images.unsplash.com/photo-1543002588-bfa74002ed7e?w=400" alt="Python">
                    <div class="marquee-details">
                        <h5>Python Data Handbook</h5>
                        <p>Jake VanderPlas</p>
                        <a href="#" class="marquee-btn">Read Now</a>
                    </div>
                </div>
                <div class="marquee-item">
                    <img src="https://images.unsplash.com/photo-1610116306796-6fea9f4fae38?w=400" alt="Algorithms">
                    <div class="marquee-details">
                        <h5>Introduction to Algos</h5>
                        <p>Thomas H. Cormen</p>
                        <a href="#" class="marquee-btn">Read Now</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-xl-3 col-sm-6">
                <div class="stats-card">
                    <div class="stats-icon"><i class="bi bi-book"></i></div>
                    <h3><c:out value="${totalBooks}" default="0"/></h3>
                    <p>Total Books</p>
                </div>
            </div>
            <div class="col-xl-3 col-sm-6">
                <div class="stats-card">
                    <div class="stats-icon"><i class="bi bi-journal-check"></i></div>
                    <h3><c:out value="${issuedBookCount}" default="0"/></h3>
                    <p>Books Issued</p>
                </div>
            </div>
            <div class="col-xl-3 col-sm-6">
                <div class="stats-card">
                    <div class="stats-icon"><i class="bi bi-bookmark-check"></i></div>
                    <h3><c:out value="${availableBooksCount}" default="0"/></h3>
                    <p>Books Available</p>
                </div>
            </div>
            <div class="col-xl-3 col-sm-6">
                <div class="stats-card">
                    <div class="stats-icon"><i class="bi bi-exclamation-circle"></i></div>
                    <h3><c:out value="${lowStockBooks}" default="0"/></h3>
                    <p>Low Stock Books</p>
                </div>
            </div>
        </div>

        <div class="section-title"><span>Latest Dynamic Releases</span></div>
        <div class="book-slider">
            <c:forEach items="${books}" var="book">
                <div class="book-card">
                    <a href="${pageContext.request.contextPath}/student/book-details/${book.id}">
                        <c:choose>
                            <c:when test="${book.bookImage != null}">
                                <img src="${pageContext.request.contextPath}/files/view/${book.bookImage.id}" alt="book cover">
                            </c:when>
                            <c:otherwise>
                                <img src="https://via.placeholder.com/400x530" alt="no image available">
                            </c:otherwise>
                        </c:choose>
                    </a>
                    <div class="book-content">
                        <div>
                            <h4>${book.bookName}</h4>
                            <p>${book.authorName}</p>
                            <div class="book-rating">⭐ ${book.rating}/5</div>
                        </div>
                        <c:choose>
                            <c:when test="${book.availableQuantity > 0}">
                                <span class="book-status">Available</span>
                            </c:when>
                            <c:otherwise>
                                <span class="book-status out-stock">Out Of Stock</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:forEach>
        </div>



        <div class="section-title">
            <span>Computer Science & Programming</span>
        </div>
        <div class="book-slider">
            <c:forEach items="${books}" var="book">
                <c:if test="${book.category == 'Programming'}">
                    <div class="book-card">
                        <a href="${pageContext.request.contextPath}/student/book-details/${book.id}">
                            <c:choose>
                                <c:when test="${book.bookImage != null}">
                                    <img src="${pageContext.request.contextPath}/files/view/${book.bookImage.id}" alt="book cover">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://via.placeholder.com/400x530" alt="no image">
                                </c:otherwise>
                            </c:choose>
                        </a>
                        <div class="book-content">
                            <div>
                                <h4>${book.bookName}</h4>
                                <p>${book.authorName}</p>
                                <div class="book-rating">⭐ ${book.rating}/5</div>
                            </div>
                            <span class="book-status">Programming</span>
                        </div>
                    </div>
                </c:if>
            </c:forEach>
        </div>
    </div>

    <footer class="modern-footer">
        <div class="row g-5">
            <div class="col-xl-4 col-lg-6">
                <div class="topbar-logo mb-3">
                    <img src="https://cdn-icons-png.flaticon.com/512/2232/2232688.png" alt="logo">
                    <div class="topbar-logo-text">
                        <h2 class="m-0 text-white">Let's Read</h2>
                    </div>
                </div>
                <p class="footer-desc">A premium corporate dynamic learning platform built to provide instant digital educational content. Engineered with secure micro-modules.</p>
                <div class="social-icons">
                    <a href="#"><i class="bi bi-facebook"></i></a>
                    <a href="#"><i class="bi bi-twitter-x"></i></a>
                    <a href="#"><i class="bi bi-linkedin"></i></a>
                    <a href="#"><i class="bi bi-instagram"></i></a>
                </div>
            </div>
            <div class="col-xl-2 col-md-4 col-sm-6">
                <h4 class="footer-title">Explore Hub</h4>
                <ul class="footer-links">
                    <li><a href="#"><i class="bi bi-chevron-right"></i> Digital Catalog</a></li>
                    <li><a href="#"><i class="bi bi-chevron-right"></i> Research Papers</a></li>
                    <li><a href="#"><i class="bi bi-chevron-right"></i> Audio Books</a></li>
                </ul>
            </div>
            <div class="col-xl-2 col-md-4 col-sm-6">
                <h4 class="footer-title">Support</h4>
                <ul class="footer-links">
                    <li><a href="#"><i class="bi bi-chevron-right"></i> Help Center</a></li>
                    <li><a href="#"><i class="bi bi-chevron-right"></i> Privacy Protocol</a></li>
                    <li><a href="#"><i class="bi bi-chevron-right"></i> API Reference</a></li>
                </ul>
            </div>
            <div class="col-xl-4 col-md-4 newsletter-box">
                <h4 class="footer-title">Subscribe</h4>
                <p class="footer-desc">Get update logs on newly added library catalogs.</p>
                <div class="input-group mb-3">
                    <input type="email" class="form-control" placeholder="Academic email address">
                    <button class="btn" type="button">Join</button>
                </div>
            </div>
        </div>

        <hr style="border-color: var(--card-border); margin: 40px 0 20px 0;">
        <div class="row align-items-center">
            <div class="col-md-6 text-center text-md-start">
                <p class="m-0 text-muted" style="font-size:12px;">&copy; 2026 The Asia Foundation. Institutional Platform Access.</p>
            </div>
            <div class="col-md-6 text-center text-md-end mt-2 mt-md-0">
                <p class="m-0 text-muted" style="font-size:12px;">Powered by Secure JSTL Stack Architecture.</p>
            </div>
        </div>
    </footer>
</div>

<script>
    const themeToggleBtn = document.getElementById('themeToggle');
    const themeIcon = document.getElementById('themeIcon');
    const htmlElement = document.documentElement;
    const menuToggleBtn = document.getElementById('menuToggleBtn');
    const sidebarNav = document.getElementById('sidebarNav');

    const currentSavedTheme = localStorage.getItem('lms-theme') || 'dark';
    htmlElement.setAttribute('data-theme', currentSavedTheme);
    adjustThemeIcon(currentSavedTheme);

    themeToggleBtn.addEventListener('click', () => {
        const activeTheme = htmlElement.getAttribute('data-theme');
        const updatedTheme = activeTheme === 'dark' ? 'light' : 'dark';
        htmlElement.setAttribute('data-theme', updatedTheme);
        localStorage.setItem('lms-theme', updatedTheme);
        adjustThemeIcon(updatedTheme);
    });

    function adjustThemeIcon(theme) {
        themeIcon.className = theme === 'dark' ? 'bi bi-moon-stars' : 'bi bi-sun';
    }

    menuToggleBtn.addEventListener('click', (e) => {
        sidebarNav.classList.toggle('active');
        e.stopPropagation();
    });

    document.addEventListener('click', (e) => {
        if (!sidebarNav.contains(e.target) && sidebarNav.classList.contains('active')) {
            sidebarNav.classList.remove('active');
        }
    });
</script>
</body>
</html>
