<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Librarian Dashboard | LMS</title>

    <!-- Bootstrap -->

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <!-- Bootstrap Icons -->

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
          rel="stylesheet">

    <!-- Google Fonts -->

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
          rel="stylesheet">

    <style>

        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
            font-family:'Poppins',sans-serif;
        }

        body{
            background:#f4f7fb;
            overflow-x:hidden;
        }


        .sidebar{
            width:260px;
            height:100vh;
            position:fixed;
            top:0;
            left:0;
            background:linear-gradient(180deg,#0f2027,#203a43,#2c5364);
            padding:25px 18px;
            overflow-y:auto;
        }

        .logo{
            text-align:center;
            margin-bottom:40px;
            color:white;
        }

        .logo i{
            font-size:54px;
            color:#0d6efd;
        }

        .logo h2{
            margin-top:10px;
            font-size:26px;
            font-weight:700;
        }

        .sidebar a{
            display:flex;
            align-items:center;
            gap:12px;
            color:#dce3ea;
            text-decoration:none;
            padding:14px 18px;
            margin-bottom:12px;
            border-radius:12px;
            transition:0.3s;
            font-size:15px;
            font-weight:500;
        }

        .sidebar a:hover,
        .sidebar a.active{
            background:#0d6efd;
            color:white;
            transform:translateX(4px);
        }

        .sidebar a i{
            font-size:18px;
        }

        .main-content{
            margin-left:260px;
            padding:30px;
        }

        /* TOPBAR */

        .topbar{
            background:white;
            padding:24px 28px;
            border-radius:22px;
            box-shadow:0 4px 15px rgba(0,0,0,0.08);
            display:flex;
            justify-content:space-between;
            align-items:center;
            flex-wrap:wrap;
            gap:15px;
            margin-bottom:35px;
        }

        .topbar h1{
            margin:0;
            font-size:32px;
            font-weight:700;
            color:#111827;
        }

        .welcome-box{
            background:linear-gradient(135deg,#0d6efd,#3b82f6);
            color:white;
            padding:12px 20px;
            border-radius:12px;
            font-size:15px;
            font-weight:600;
            box-shadow:0 4px 12px rgba(13,110,253,0.25);
        }

        .dashboard-grid{
            display:grid;
            grid-template-columns:repeat(auto-fit,minmax(260px,1fr));
            gap:25px;
        }

        .dashboard-card{
            position:relative;
            overflow:hidden;
            border-radius:24px;
            padding:30px;
            color:white;
            text-decoration:none;
            transition:0.35s;
            box-shadow:0 6px 18px rgba(0,0,0,0.12);
        }

        .dashboard-card:hover{
            transform:translateY(-8px);
            color:white;
            box-shadow:0 10px 22px rgba(0,0,0,0.15);
        }

        .dashboard-card::before{
            content:'';
            position:absolute;
            width:140px;
            height:140px;
            border-radius:50%;
            background:rgba(255,255,255,0.1);
            top:-40px;
            right:-40px;
        }

        .dashboard-card i{
            font-size:52px;
            margin-bottom:18px;
            position:relative;
            z-index:2;
        }

        .dashboard-card h3{
            font-size:26px;
            font-weight:700;
            margin-bottom:10px;
            position:relative;
            z-index:2;
        }

        .dashboard-card p{
            margin:0;
            font-size:15px;
            opacity:0.95;
            position:relative;
            z-index:2;
            line-height:1.6;
        }

        /* CARD COLORS */

        .books{
            background:linear-gradient(135deg,#0d6efd,#3b82f6);
        }

        .add-book{
            background:linear-gradient(135deg,#198754,#20c997);
        }

        .issue{
            background:linear-gradient(135deg,#dc3545,#ff6b6b);
        }

        .return-book{
            background:linear-gradient(135deg,#fd7e14,#ffb703);
        }

        .profile{
            background:linear-gradient(135deg,#0dcaf0,#3dd5f3);
        }

        .logout{
            background:linear-gradient(135deg,#212529,#495057);
        }

        /* =====================================
           RESPONSIVE
        ===================================== */

        @media(max-width:992px){

            .sidebar{
                width:100%;
                height:auto;
                position:relative;
            }

            .main-content{
                margin-left:0;
                padding:20px;
            }

            .topbar h1{
                font-size:26px;
            }
        }

        @media(max-width:576px){

            .topbar{
                padding:18px;
            }

            .dashboard-card{
                padding:24px;
            }

            .dashboard-card h3{
                font-size:22px;
            }

            .dashboard-card i{
                font-size:45px;
            }
        }

    </style>

</head>

<body>

<!-- =====================================
     SIDEBAR
===================================== -->

<div class="sidebar">

    <div class="logo">

        <i class="bi bi-book-half"></i>

        <h2>LMS Librarian</h2>

    </div>

    <a href="/librarian/dashboard"
       class="active">

        <i class="bi bi-speedometer2"></i>
        Dashboard

    </a>

    <a href="/admin/books">

        <i class="bi bi-book"></i>
        View Books

    </a>

    <a href="/admin/add-book">

        <i class="bi bi-plus-circle"></i>
        Add Book

    </a>

    <a href="/issue-book">

        <i class="bi bi-journal-check"></i>
        Issue Book

    </a>

    <a href="/return-book">

        <i class="bi bi-arrow-return-left"></i>
        Return Book

    </a>

    <a href="/profile">

        <i class="bi bi-person-circle"></i>
        Profile

    </a>

    <a href="/auth/logout">

        <i class="bi bi-box-arrow-right"></i>
        Logout

    </a>

</div>

<!-- =====================================
     MAIN CONTENT
===================================== -->

<div class="main-content">

    <!-- TOPBAR -->

    <div class="topbar">

        <h1>

            Librarian Dashboard

        </h1>

        <div class="welcome-box">

            Welcome Librarian

        </div>

    </div>

    <!-- DASHBOARD GRID -->

    <div class="dashboard-grid">

        <!-- VIEW BOOKS -->

        <a href="/admin/books"
           class="dashboard-card books">

            <i class="bi bi-book-half"></i>

            <h3>View Books</h3>

            <p>
                Manage and view all books available in the library system.
            </p>

        </a>

        <!-- ADD BOOK -->

        <a href="/admin/add-book"
           class="dashboard-card add-book">

            <i class="bi bi-plus-circle-fill"></i>

            <h3>Add Book</h3>

            <p>
                Add new books into the library management system easily.
            </p>

        </a>

        <!-- ISSUE BOOK -->

        <a href="/issue-book"
           class="dashboard-card issue">

            <i class="bi bi-journal-arrow-up"></i>

            <h3>Issue Book</h3>

            <p>
                Issue books to students quickly and manage records securely.
            </p>

        </a>

        <!-- RETURN BOOK -->

        <a href="/return-book"
           class="dashboard-card return-book">

            <i class="bi bi-arrow-return-left"></i>

            <h3>Return Book</h3>

            <p>
                Handle returned books and update stock automatically.
            </p>

        </a>

        <!-- PROFILE -->

        <a href="/profile"
           class="dashboard-card profile">

            <i class="bi bi-person-circle"></i>

            <h3>Profile</h3>

            <p>
                View and update librarian profile information anytime.
            </p>

        </a>

        <!-- LOGOUT -->

        <a href="/auth/logout"
           class="dashboard-card logout">

            <i class="bi bi-box-arrow-right"></i>

            <h3>Logout</h3>

            <p>
                Securely logout from the library management system.
            </p>

        </a>

    </div>

</div>

<!-- Bootstrap JS -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>