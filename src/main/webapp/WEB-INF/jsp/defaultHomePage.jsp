<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <script>
        // Critical Execution Block to resolve white theme flicker during visual resource compilation
        (function() {
            const activeTheme = localStorage.getItem('theme') || 'dark';
            document.documentElement.setAttribute('data-theme', activeTheme);
        })();
    </script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>APEX LMS - Integrated Library Management System | Chandigarh Sector 17 Node</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        /* Immersive Ultra-HD Variable Architecture Design Tokens */
        :root[data-theme="dark"] {
            --bg-glass-nav: rgba(9, 13, 26, 0.85);
            --bg-glass-card: rgba(15, 23, 42, 0.75);
            --bg-glass-portal: rgba(13, 20, 38, 0.88);
            --bg-fallback: #030712;
            --border-glow: rgba(56, 189, 248, 0.3);
            --border-subtle: rgba(255, 255, 255, 0.12);
            --text-main: #f3f4f6;
            --text-heading: #ffffff;
            --text-muted: #cbd5e1;
            --accent-color: #38bdf8;
            --accent-gradient: linear-gradient(135deg, #38bdf8 0%, #0284c7 100%);
            --card-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.7);
            --bg-features: rgba(15, 23, 42, 0.92);
            --bg-feature-card: rgba(30, 41, 59, 0.7);
            --img-overlay: linear-gradient(to bottom, rgba(3, 7, 18, 0.45) 0%, rgba(3, 7, 18, 0.8) 100%);
            --watch-bg: rgba(56, 189, 248, 0.18);
            --watch-border: #38bdf8;
            --table-hover: rgba(255, 255, 255, 0.05);
        }

        :root[data-theme="light"] {
            --bg-glass-nav: rgba(255, 255, 255, 0.88);
            --bg-glass-card: rgba(255, 255, 255, 0.92);
            --bg-glass-portal: rgba(241, 245, 249, 0.96);
            --bg-fallback: #f8fafc;
            --border-glow: rgba(2, 132, 199, 0.35);
            --border-subtle: rgba(15, 23, 42, 0.12);
            --text-main: #1e293b;
            --text-heading: #0f172a;
            --text-muted: #475569;
            --accent-color: #0284c7;
            --accent-gradient: linear-gradient(135deg, #0284c7 0%, #0369a1 100%);
            --card-shadow: 0 25px 50px -12px rgba(15, 23, 42, 0.15);
            --bg-features: #e2e8f0;
            --bg-feature-card: #ffffff;
            --img-overlay: linear-gradient(to bottom, rgba(255, 255, 255, 0.45) 0%, rgba(248, 250, 252, 0.9) 100%);
            --watch-bg: rgba(2, 132, 199, 0.15);
            --watch-border: #0284c7;
            --table-hover: rgba(0, 0, 0, 0.04);
        }

        * {
            margin: 0; padding: 0; box-sizing: border-box;
            font-family: 'Plus Jakarta Sans', sans-serif;
            transition: background 0.4s cubic-bezier(0.4, 0, 0.2, 1), color 0.4s ease, border-color 0.4s ease;
        }

        body {
            background-color: var(--bg-fallback);
            color: var(--text-main);
            min-height: 100vh;
            overflow-x: hidden;
            position: relative;
        }

        /* Ambient 4K Engine - Clear Book Stock Background Configuration */
        .cinematic-bg-layer {
            position: fixed; inset: 0;
            background-image: var(--img-overlay), url('https://images.unsplash.com/photo-1521587760476-6c12a4b040da?q=80&w=1920&auto=format&fit=crop');
            background-size: cover;
            background-position: center center;
            background-repeat: no-repeat;
            z-index: -1;
            filter: contrast(1.05) brightness(0.95);
        }

        /* Premium Nav Component */
        .navbar-custom {
            background: var(--bg-glass-nav);
            backdrop-filter: blur(25px); -webkit-backdrop-filter: blur(25px);
            border-bottom: 1px solid var(--border-subtle);
            padding: 14px 28px; z-index: 1000;
        }
        .navbar-brand { font-weight: 800; font-size: 22px; color: var(--text-heading) !important; }
        .navbar-brand span { color: var(--accent-color); }

        /* Realtime Smart Watch Framework */
        .smart-watch-casing {
            display: flex; align-items: center; gap: 10px; background: var(--watch-bg);
            padding: 8px 16px; border-radius: 16px; border: 1px solid var(--border-glow);
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.15); position: relative;
        }
        .watch-screen {
            font-family: 'Courier New', Courier, monospace; font-weight: 800;
            font-size: 16px; color: var(--accent-color); letter-spacing: 0.5px;
        }
        .watch-date-panel {
            font-size: 11px; font-weight: 700; color: var(--text-heading);
            background: rgba(255,255,255,0.15); padding: 3px 8px; border-radius: 6px;
            text-transform: uppercase; letter-spacing: 0.2px;
        }
        :root[data-theme="light"] .watch-date-panel { background: rgba(0,0,0,0.08); }

        .status-pill {
            display: flex; align-items: center; gap: 8px; background: rgba(56, 189, 248, 0.15);
            color: var(--accent-color); font-size: 13px; font-weight: 700; padding: 8px 16px; border-radius: 14px;
        }
        .pulse-dot {
            width: 8px; height: 8px; background: var(--accent-color); border-radius: 50%;
            animation: corePulse 1.6s infinite alternate;
        }
        @keyframes corePulse { 0% { transform: scale(0.8); opacity: 0.5; } 100% { transform: scale(1.4); opacity: 1; } }

        .theme-toggle-btn {
            border: 1px solid var(--border-subtle); background: var(--bg-glass-card);
            color: var(--text-heading); border-radius: 14px; padding: 8px 18px;
            font-size: 14px; font-weight: 600; display: flex; align-items: center; gap: 8px; cursor: pointer;
        }
        .theme-toggle-btn:hover { border-color: var(--accent-color); }

        /* Main Structural Hero Layout */
        .hero-section { position: relative; padding: 90px 0; z-index: 10; }
        .hero-title { font-size: 50px; font-weight: 800; color: var(--text-heading); line-height: 1.2; letter-spacing: -0.02em; text-shadow: 0 4px 12px rgba(0,0,0,0.3); }
        .hero-title span { background: var(--accent-gradient); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .hero-text { color: var(--text-muted); font-size: 16.5px; line-height: 1.75; max-width: 550px; text-shadow: 0 2px 4px rgba(0,0,0,0.4); }

        /* Infinite Slider System Component */
        .library-wrapper { width: 100%; overflow: hidden; position: relative; border-radius: 24px; padding: 4px; }
        .scroll-track { display: flex; gap: 16px; width: max-content; animation: globalMarquee 25s linear infinite; }
        .scroll-track:hover { animation-play-state: paused; }

        .library-card {
            width: 200px; height: 270px; border-radius: 20px; overflow: hidden; position: relative;
            border: 1px solid var(--border-subtle); flex-shrink: 0; box-shadow: var(--card-shadow);
        }
        .library-card img { width: 100%; height: 100%; object-fit: cover; }
        .library-card .overlay {
            position: absolute; inset: 0; background: linear-gradient(to top, rgba(2,6,23,0.95) 20%, rgba(2,6,23,0.1) 100%);
            padding: 16px; display: flex; flex-direction: column; justify-content: flex-end;
        }
        :root[data-theme="light"] .library-card .overlay {
            background: linear-gradient(to top, rgba(255,255,255,0.95) 20%, rgba(255,255,255,0.1) 100%);
        }
        .overlay h3 { color: var(--text-heading); font-size: 15px; font-weight: 700; margin-bottom: 2px; }
        .overlay h4 { color: var(--accent-color); font-size: 11px; font-weight: 700; margin-bottom: 4px; }
        .overlay p { color: var(--text-muted); font-size: 11px; margin: 0; }

        /* Integrated Learner Advice & Advice Hub */
        .advice-dashboard-container {
            background: rgba(0, 0, 0, 0.35); border-radius: 16px; padding: 20px;
            margin-bottom: 22px; border: 1px solid var(--border-glow);
            backdrop-filter: blur(10px);
        }
        :root[data-theme="light"] .advice-dashboard-container { background: rgba(255, 255, 255, 0.75); }
        .advice-header-label { font-size: 13px; font-weight: 800; color: var(--accent-color); text-transform: uppercase; letter-spacing: 0.8px; margin-bottom: 12px; }
        .advice-row-item { display: flex; gap: 12px; font-size: 14px; color: var(--text-main); margin-bottom: 10px; align-items: flex-start; }
        .advice-row-item:last-child { margin-bottom: 0; }
        .advice-row-item i { color: #10b981; font-size: 15px; }

        /* 3D Action Portal Structure with Enhanced Glassmorphism */
        .card-3d-portal {
            background: var(--bg-glass-portal); border: 1px solid var(--border-glow);
            backdrop-filter: blur(30px); -webkit-backdrop-filter: blur(30px);
            padding: 32px; border-radius: 24px; box-shadow: var(--card-shadow);
            margin-top: 5px; transform-style: preserve-3d;
            transition: transform 0.1s ease, box-shadow 0.2s ease;
        }
        .portal-header { font-weight: 800; font-size: 18px; color: var(--text-heading); display: flex; align-items: center; gap: 12px; margin-bottom: 12px; }
        .portal-icon-wrapper {
            width: 38px; height: 38px; background: rgba(56, 189, 248, 0.15); color: var(--accent-color);
            border-radius: 10px; display: flex; align-items: center; justify-content: center;
        }
        .card-desc-text { color: var(--text-muted); font-size: 14px; line-height: 1.6; margin-bottom: 20px; }

        /* High Visibility Statistical Counters */
        .stats-grid-row { margin-top: 50px; }
        .stat-counter-card {
            background: var(--bg-glass-card); border: 1px solid var(--border-subtle);
            backdrop-filter: blur(15px); -webkit-backdrop-filter: blur(15px);
            border-radius: 16px; padding: 22px; text-align: center; box-shadow: var(--card-shadow);
        }
        .stat-number { font-size: 28px; font-weight: 800; color: var(--text-heading); }
        .stat-number span { color: var(--accent-color); }
        .stat-label { font-size: 13px; color: var(--text-muted); font-weight: 600; margin-top: 4px; }

        /* Buttons Infrastructure Matrix */
        .btn-3d {
            height: 50px; border-radius: 14px; font-size: 14.5px; font-weight: 700;
            display: flex; align-items: center; justify-content: center; width: 100%; text-decoration: none;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .btn-3d-primary { background: var(--accent-gradient); color: white !important; box-shadow: 0 6px 20px rgba(56,189,248,0.25); border: none; }
        .btn-3d-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(56,189,248,0.4); }
        .btn-3d-outline { border: 2px solid var(--border-glow); background: transparent; color: var(--text-heading) !important; backdrop-filter: blur(5px); }
        .btn-3d-outline:hover { background: rgba(56, 189, 248, 0.06); transform: translateY(-2px); }

        @keyframes globalMarquee { 0% { transform: translateX(0); } 100% { transform: translateX(-50%); } }

        /* Grid Framework Features Module System */
        .features { padding: 80px 0; background: var(--bg-features); border-top: 1px solid var(--border-subtle); position: relative; z-index: 10; }
        .section-title { text-align: center; color: var(--text-heading); font-size: 34px; font-weight: 800; letter-spacing: -0.01em; }
        .section-subtitle { text-align: center; color: var(--text-muted); font-size: 15px; margin-bottom: 50px; max-width: 600px; margin-left: auto; margin-right: auto; }

        .feature-box {
            background: var(--bg-feature-card); padding: 30px; border-radius: 20px;
            border: 1px solid var(--border-subtle); box-shadow: var(--card-shadow); height: 100%;
            transition: transform 0.3s ease, border-color 0.3s ease;
        }
        .feature-box:hover { transform: translateY(-5px); border-color: var(--accent-color); }
        .feature-icon {
            width: 54px; height: 54px; border-radius: 14px; display: flex; justify-content: center; align-items: center;
            background: rgba(56, 189, 248, 0.12); color: var(--accent-color); font-size: 24px; margin-bottom: 20px;
        }
        .feature-box h4 { font-size: 18px; font-weight: 700; color: var(--text-heading); margin-bottom: 10px; }
        .feature-box p { font-size: 13.5px; color: var(--text-muted); line-height: 1.6; margin: 0; }

        /* Dynamic Asset Inventory Ledger Grid */
        .inventory-ledger-section { padding: 80px 0; background: var(--bg-fallback); position: relative; z-index: 10; border-top: 1px solid var(--border-subtle); }
        .ledger-table-wrapper {
            background: var(--bg-glass-card); border: 1px solid var(--border-subtle);
            backdrop-filter: blur(15px); -webkit-backdrop-filter: blur(15px);
            border-radius: 20px; padding: 24px; box-shadow: var(--card-shadow); overflow-x: auto;
        }
        .custom-ledger-table { width: 100%; margin-bottom: 0; color: var(--text-main); vertical-align: middle; }
        .custom-ledger-table th { font-weight: 700; color: var(--text-heading); border-bottom: 2px solid var(--border-subtle); padding: 14px; font-size: 14px; }
        .custom-ledger-table td { padding: 14px; border-bottom: 1px solid var(--border-subtle); font-size: 13.5px; }
        .custom-ledger-table tbody tr:hover { background-color: var(--table-hover); }
        .badge-status-active { background: rgba(16, 185, 129, 0.15); color: #10b981; padding: 4px 10px; border-radius: 8px; font-size: 11px; font-weight: 700; }
        .badge-status-hold { background: rgba(245, 158, 11, 0.15); color: #f59e0b; padding: 4px 10px; border-radius: 8px; font-size: 11px; font-weight: 700; }

        /* Modernized Footer Architecture */
        .modern-footer { background: var(--bg-fallback); border-top: 1px solid var(--border-subtle); padding-top: 80px; padding-bottom: 30px; position: relative; z-index: 10; }
        .review-scroll-wrapper { overflow: hidden; width: 100%; padding: 4px; }
        .review-scroll-track { display: flex; width: max-content; animation: globalMarquee 32s linear infinite; }
        .review-scroll-wrapper:hover .review-scroll-track { animation-play-state: paused; }
        .virtual-review-card { width: 340px; background: var(--bg-feature-card); border: 1px solid var(--border-subtle); border-radius: 20px; padding: 24px; margin-right: 20px; flex-shrink: 0; box-shadow: var(--card-shadow); }
        .review-top img { width: 46px; height: 46px; border-radius: 50%; object-fit: cover; margin-right: 12px; border: 2px solid var(--accent-color); }
        .review-top h5 { color: var(--text-heading); font-size: 14.5px; font-weight: 700; margin: 0; }
        .review-top span { color: var(--text-muted); font-size: 12px; }
        .virtual-review-card p { color: var(--text-muted) !important; font-size: 13px; line-height: 1.6; }

        .map-container { border-radius: 16px; overflow: hidden; border: 1px solid var(--border-subtle); margin-top: 12px; }
        .footer-links { list-style: none; padding: 0; margin: 0; }
        .footer-links li { margin-bottom: 12px; }
        .footer-links a { text-decoration: none; color: var(--text-muted); transition: all 0.3s ease; font-size: 14px; display: inline-block; }
        .footer-links a:hover { color: var(--accent-color); transform: translateX(4px); }
        .fix-contrast-text { color: var(--text-muted) !important; font-size: 14px; line-height: 1.65; }

        @media (max-width: 991px) {
            .smart-watch-casing { margin: 12px 0; width: 100%; justify-content: center; }
            .hero-title { font-size: 36px; text-align: center; }
            .hero-text { text-align: center; margin: 20px auto !important; }
            .navbar-custom { padding: 12px 20px; }
            .hero-section { padding-top: 40px; padding-bottom: 40px; }
            .badge-wrapper { text-align: center; }
        }
    </style>
</head>
<body>

<div class="cinematic-bg-layer"></div>

<nav class="navbar navbar-expand-lg navbar-dark navbar-custom sticky-top">
    <div class="container-fluid">
        <a class="navbar-brand d-flex align-items-center" href="#">
            <i class="bi bi-building-fill-check text-info me-2" style="color: var(--accent-color) !important;"></i>APEX <span>LMS PLATFORM</span>
        </a>

        <button class="navbar-toggler text-white border-0" type="button" data-bs-toggle="collapse" data-bs-target="#lmsControlGateway">
            <i class="bi bi-list fs-2" style="color: var(--text-heading)"></i>
        </button>

        <div class="collapse navbar-collapse" id="lmsControlGateway">
            <div class="ms-lg-3 smart-watch-casing">
                <i class="bi bi-watch text-info" style="color: var(--accent-color) !important;"></i>
                <div class="watch-screen" id="smartWatchLiveTimer">00:00:00 AM</div>
                <div class="watch-date-panel" id="smartWatchLiveDate">MON, JAN 01</div>
            </div>

            <div class="d-flex flex-column flex-lg-row align-items-stretch align-items-lg-center gap-3 mt-3 mt-lg-0 ms-auto">
                <div class="status-pill d-none d-xl-flex">
                    <div class="pulse-dot"></div>
                    <span>LMS Status: Verified</span>
                </div>

                <button class="theme-toggle-btn justify-content-center" onclick="executeThemeSwitch()" type="button">
                    <i class="bi bi-sun-fill" id="themeEngineIcon" style="color: var(--accent-color)"></i>
                    <span id="themeEngineLabel" class="d-none d-md-inline">Light Mode</span>
                </button>
            </div>
        </div>
    </div>
</nav>

<section class="hero-section">
    <div class="container">
        <div class="row align-items-center g-5">
            <div class="col-lg-6">
                <div class="badge-wrapper">
                    <div class="badge bg-info bg-opacity-10 text-info px-3 py-2 rounded-pill mb-3 fw-bold shadow-sm" style="color: var(--accent-color) !important;">
                        🏛️ CHANDIGARH ACADEMIC CAPITAL • SECTOR 17 ARCHITECTURE
                    </div>
                </div>
                <h1 class="hero-title">
                    APEX LMS <span>Integrated Library</span> Management System
                </h1>
                <p class="hero-text my-4">
                    Welcome to the digital node of Chandigarh's premium knowledge network. Track automated inventory catalogs, trace active serial allocations, manage structural book codes, and preserve historical digital research assets across a secure multi-tier infrastructure layer.
                </p>
            </div>

            <div class="col-lg-6">
                <div class="library-wrapper mb-3">
                    <div class="scroll-track" id="uninterruptedBookSlider">
                        <div class="library-card">
                            <img src="https://images.unsplash.com/photo-1507842217343-583bb7270b66?q=80&w=600" alt="Tech">
                            <div class="overlay">
                                <h4>Shelf: A4-Chandigarh</h4>
                                <h3>Neural Networks v2</h3>
                                <p>Technology & Computing</p>
                            </div>
                        </div>
                        <div class="library-card">
                            <img src="https://images.unsplash.com/photo-1495446815901-a7297e633e8d?q=80&w=600" alt="Science">
                            <div class="overlay">
                                <h4>Shelf: B1-Grid</h4>
                                <h3>Quantum Fields</h3>
                                <p>Theoretical Collection</p>
                            </div>
                        </div>
                        <div class="library-card">
                            <img src="https://images.unsplash.com/photo-1512820790803-83ca734da794?q=80&w=600" alt="Fiction">
                            <div class="overlay">
                                <h4>Shelf: F9-Vault</h4>
                                <h3>The Classic Odyssey</h3>
                                <p>Literature & Fiction</p>
                            </div>
                        </div>
                        <div class="library-card">
                            <img src="https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?q=80&w=600" alt="History">
                            <div class="overlay">
                                <h4>Shelf: H3-Legacy</h4>
                                <h3>Ancient Chronicles</h3>
                                <p>Civilization Horizons</p>
                            </div>
                        </div>
                        <div class="library-card">
                            <img src="https://images.unsplash.com/photo-1507842217343-583bb7270b66?q=80&w=600" alt="Tech">
                            <div class="overlay">
                                <h4>Shelf: A4-Chandigarh</h4>
                                <h3>Neural Networks v2</h3>
                                <p>Technology & Computing</p>
                            </div>
                        </div>
                        <div class="library-card">
                            <img src="https://images.unsplash.com/photo-1495446815901-a7297e633e8d?q=80&w=600" alt="Science">
                            <div class="overlay">
                                <h4>Shelf: B1-Grid</h4>
                                <h3>Quantum Fields</h3>
                                <p>Theoretical Collection</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card-3d-portal" id="interactivePortalCard">
                    <div>
                        <div class="portal-header">
                            <div class="portal-icon-wrapper">
                                <i class="bi bi-mortarboard-fill text-info fs-5" style="color: var(--accent-color) !important;"></i>
                            </div>
                            Student Registration & Login Form
                        </div>
                        <p class="card-desc-text">Access personal digital passbooks, trace active fine ledgers, and hold pending items instantly.</p>


                        <div class="advice-dashboard-container">
                            <div class="advice-header-label"><i class="bi bi-lightbulb-fill me-1"></i> Core Academic Growth Rules & Advice</div>
                            <div class="advice-row-item">
                                <i class="bi bi-check-circle-fill"></i>
                            <span><strong>Daily Inventory Update:</strong> Dedicate time daily to update the catalog with newly arrived and returned books to maintain accurate stock records.</span>

                            </div>
                            <div class="advice-row-item">
                                <i class="bi bi-check-circle-fill"></i>
                          <span><strong>Systematic Categorization:</strong> Organize books systematically by title, subject, and author on the shelves to ensure quick access and easy retrieval.</span>

                            </div>
                            <div class="advice-row-item">
                                <i class="bi bi-check-circle-fill"></i>
                          <span><strong>Circulation Tracking:</strong> Maintain precise records of book issues, due dates, and returns to prevent loss and track overdue fines efficiently.</span>

                            </div>
                        </div>


                    </div>
                    <div class="row g-3">
                        <div class="col-sm-6">
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-3d btn-3d-primary">Student Sign In</a>
                        </div>
                        <div class="col-sm-6">
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-3d btn-3d-outline">Register Account</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4 stats-grid-row">
            <div class="col-md-3 col-sm-6">
                <div class="stat-counter-card">
                    <div class="stat-number" id="totalVolumesCounter">142,800<span>+</span></div>
                    <div class="stat-label">Indexed Print Media Volumes</div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="stat-counter-card">
                    <div class="stat-number" id="digitalJournalsCounter">18,500<span>+</span></div>
                    <div class="stat-label">Active E-Journals Books</div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="stat-counter-card">
                    <div class="stat-number" id="verifiedScholarsCounter">34,200<span>+</span></div>
                    <div class="stat-label">Registered Chandigarh Scholars</div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="stat-counter-card">
                    <div class="stat-number" id="dailyCheckInCounter">1,950<span>+</span></div>
                    <div class="stat-label">Daily Student Learn Books</div>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="features">
    <div class="container">
        <h2 class="section-title">Integrated System Control Modules</h2>
        <p class="section-subtitle">Our centralized data nodes execute lightning-fast operations, keep tracking real-time material logistics, and secure data access points across the loop.</p>
        <div class="row g-4">
            <div class="col-md-4">
                <div class="feature-box">
                    <div class="feature-icon"><i class="bi bi-search-heart-fill"></i></div>
                    <h4>Elastic Search Index Engine</h4>
                    <p>Parallel text tokenizers fetch document records, specific cluster shelves, item accessibility codes instantly within microseconds loop without rendering lags.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-box">
                    <div class="feature-icon"><i class="bi bi-qr-code-scan"></i></div>
                    <h4>RFID Tracking Books</h4>
                    <p>Automated telemetry scanners communicate directly with physical asset tables to trigger immediate updates during transit or drop box arrivals.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-box">
                    <div class="feature-icon"><i class="bi bi-currency-rupee"></i></div>
                    <h4>Automated Fine Settlements</h4>
                    <p>Secured instant integration with merchant UPI gateways tracks overdue parameters and updates outstanding passbooks logs without manual inputs.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="inventory-ledger-section">
    <div class="container">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center mb-4">
            <div>
                <h3 class="fw-bold m-0" style="color: var(--text-heading)">Live Real-time Books Learner</h3>
                <p class="text-muted small m-0">Currently tracked item availability codes across Chandigarh regional nodes.</p>
            </div>
            <span class="badge bg-success bg-opacity-10 text-success fw-bold px-3 py-2 rounded-pill mt-2 mt-md-0"><i class="bi bi-arrow-repeat me-1"></i> Auto Sync Active</span>
        </div>
        <div class="ledger-table-wrapper">
            <table class="table custom-ledger-table">
                <thead>
                    <tr>
                        <th>Material Asset Identification Code</th>
                        <th>Document Books Title</th>
                        <th>Classification Books Name</th>
                        <th>Regional Address Shelf </th>
                        <th>Real-time Availability Books</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><code>ISBN-978-3-16-148410-0</code></td>
                        <td>Advanced Neural Network Architectures</td>
                        <td>Technology & Computer Engineering</td>
                        <td>Sector 17 - Rack A4</td>
                        <td><span class="badge-status-active">Available for Allocation</span></td>
                    </tr>
                    <tr>
                        <td><code>ISBN-978-0-13-235088-4</code></td>
                        <td>Clean Code Principles & Clean Architecture</td>
                        <td>Software Engineering</td>
                        <td>Sector 17 - Rack A1</td>
                        <td><span class="badge-status-active">Available for Allocation</span></td>
                    </tr>
                    <tr>
                        <td><code>ISBN-978-1-49-195235-1</code></td>
                        <td>Designing Data-Intensive Applications</td>
                        <td>Cloud Database Infrastructures</td>
                        <td>Sector 17 - Rack C3</td>
                        <td><span class="badge-status-hold">Currently Allocated (On Hold)</span></td>
                    </tr>
                    <tr>
                        <td><code>ISBN-978-0-262-03384-8</code></td>
                        <td>Introduction to Algorithms (CLRS 4th Ed)</td>
                        <td>Mathematics & Computing</td>
                        <td>Sector 17 - Rack B2</td>
                        <td><span class="badge-status-active">Available for Allocation</span></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</section>

<footer class="modern-footer">
    <div class="container">
        <div class="mb-5">
            <h4 class="text-center fw-bold mb-5" style="color: var(--text-heading)"><i class="bi bi-patch-check-fill text-info me-2" style="color: var(--accent-color) !important;"></i>What Active Researchers Say</h4>
            <div class="review-scroll-wrapper">
                <div class="review-scroll-track" id="uninterruptedReviewSlider">
                    <div class="virtual-review-card">
                        <div class="review-top d-flex align-items-center mb-3">
                            <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=150&auto=format&fit=crop" alt="Priya">
                            <div>
                                <h5>Priya Sharma</h5>
                                <span>M.Tech Research Scholar</span>
                            </div>
                        </div>
                        <div class="text-warning mb-2"><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i></div>
                        <p class="small">The automated fine transaction model and instant elastic item query capabilities on this platform make research work incredibly efficient.</p>
                    </div>

                    <div class="virtual-review-card">
                        <div class="review-top d-flex align-items-center mb-3">
                            <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=150&auto=format&fit=crop" alt="Rohan">
                            <div>
                                <h5>Rohan Batra</h5>
                                <span>MCA Department</span>
                            </div>
                        </div>
                        <div class="text-warning mb-2"><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i></div>
                        <p class="small">Moving search modules directly to the navbar layer has completely optimized my item access velocity. Splendid architecture work.</p>
                    </div>
                    <div class="virtual-review-card">
                        <div class="review-top d-flex align-items-center mb-3">
                            <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=150&auto=format&fit=crop" alt="Priya">
                            <div>
                                <h5>Priya Sharma</h5>
                                <span>M.Tech Research Scholar</span>
                            </div>
                        </div>
                        <div class="text-warning mb-2"><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i></div>
                        <p class="small">The automated fine transaction model and instant elastic item query capabilities on this platform make research work incredibly efficient.</p>
                    </div>
                </div>
            </div>
        </div>

        <hr class="opacity-10 my-5" style="background-color: var(--text-muted)">

        <div class="row g-4">
            <div class="col-lg-4">
                <h4 class="fw-bold mb-3" style="color: var(--text-heading)">APEX Library Management System</h4>
                <p class="fix-contrast-text pe-md-4">
                    Providing multi-threaded terminal inventory monitoring frameworks for academic organizations across Chandigarh region since inception. Built for high elasticity scalability.
                </p>
                <div class="mt-3 text-muted small">
                    <i class="bi bi-hdd-network-fill text-success me-1"></i> Core Stack Latency: <strong>0.04ms (Optimal)</strong>
                </div>
            </div>

            <div class="col-md-6 col-lg-4">
                <h5 class="fw-bold mb-3" style="color: var(--text-heading)">Quick Navigation Form layout</h5>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/login"><i class="bi bi-chevron-right small me-1"></i>Learner Login Form</a></li>
                    <li><a href="${pageContext.request.contextPath}/register"><i class="bi bi-chevron-right small me-1"></i>Create New Account</a></li>
                    <li><a href="#uninterruptedBookSlider"><i class="bi bi-chevron-right small me-1"></i> Public Catalog Index</a></li>
                    <li><a href="#interactivePortalCard"><i class="bi bi-chevron-right small me-1"></i> System Architecture Specifications</a></li>
                </ul>
            </div>

            <div class="col-md-6 col-lg-4">
                <h5 class="fw-bold mb-2" style="color: var(--text-heading)">Address : Chandigarh Sector 17 </h5>
                <div class="map-container">
                    <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3429.345672322588!2d76.782012!3d30.741432!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x390fed0b00000001%3A0x28976b3be373b5df!2sSector%2017%2C%20Chandigarh!5e0!3m2!1sen!2sin!4v1710000000000!5m2!1sen!2sin"
                            width="100%" height="130" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
                </div>
            </div>
        </div>

        <div class="mt-5 pt-4 border-top border-secondary border-opacity-10 text-center text-muted small">
            &copy; 2026 APEX Library Management Systems Corporation. All rights reserved across regional cluster nodes.
        </div>
    </div>
</footer>

<script>
    // Theme Transformation Core Processing Module
    const rootHtml = document.documentElement;
    const themeIcon = document.getElementById('themeEngineIcon');
    const themeLabel = document.getElementById('themeEngineLabel');

    window.addEventListener('DOMContentLoaded', () => {
        const activeTheme = localStorage.getItem('theme') || 'dark';
        rootHtml.setAttribute('data-theme', activeTheme);
        updateThemeUIComponents(activeTheme);
        initializeLiveClockPipeline();
    });

    function executeThemeSwitch() {
        const currentTheme = rootHtml.getAttribute('data-theme');
        const alternateTheme = currentTheme === 'light' ? 'dark' : 'light';
        rootHtml.setAttribute('data-theme', alternateTheme);
        localStorage.setItem('theme', alternateTheme);
        updateThemeUIComponents(alternateTheme);
    }

    function updateThemeUIComponents(theme) {
        if(theme === 'light') {
            themeIcon.className = 'bi bi-moon-stars-fill';
            themeLabel.innerText = 'Dark Mode';
        } else {
            themeIcon.className = 'bi bi-sun-fill';
            themeLabel.innerText = 'Light Mode';
        }
    }

    // High Precision Digital Synchronization Clock
    function initializeLiveClockPipeline() {
        const timerContainer = document.getElementById('smartWatchLiveTimer');
        const dateContainer = document.getElementById('smartWatchLiveDate');

        const dayArray = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
        const monthArray = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];

        function runClockTick() {
            const now = new Date();
            let hours = now.getHours();
            const minutes = String(now.getMinutes()).padStart(2, '0');
            const seconds = String(now.getSeconds()).padStart(2, '0');
            const ampm = hours >= 12 ? 'PM' : 'AM';

            hours = hours % 12;
            hours = hours ? hours : 12; // Handle zero conversion
            const structuredHours = String(hours).padStart(2, '0');

            timerContainer.innerText = structuredHours + ':' + minutes + ':' + seconds + ' ' + ampm;
            dateContainer.innerText = dayArray[now.getDay()] + ', ' + monthArray[now.getMonth()] + ' ' + String(now.getDate()).padStart(2, '0');
        }

        runClockTick();
        setInterval(runClockTick, 1000);
    }

    // Gyroscopic 3D Portal Hover Engine Execution Block
    const portalCardNode = document.getElementById('interactivePortalCard');

    portalCardNode.addEventListener('mousemove', (e) => {
        const cardMetrics = portalCardNode.getBoundingClientRect();
        const axisX = e.clientX - cardMetrics.left - (cardMetrics.width / 2);
        const axisY = e.clientY - cardMetrics.top - (cardMetrics.height / 2);

        // Soft balancing scalar factors to maintain layout crispness
        const rotationX = -(axisY / cardMetrics.height) * 14;
        const rotationY = (axisX / cardMetrics.width) * 14;

        portalCardNode.style.transform = 'perspective(1000px) rotateX(' + rotationX + 'deg) rotateY(' + rotationY + 'deg) scale3d(1.01, 1.01, 1.01)';
        portalCardNode.style.boxShadow = '0 30px 60px rgba(56, 189, 248, 0.15)';
    });

    portalCardNode.addEventListener('mouseleave', () => {
        portalCardNode.style.transform = 'perspective(1000px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)';
        portalCardNode.style.boxShadow = 'var(--card-shadow)';
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>



