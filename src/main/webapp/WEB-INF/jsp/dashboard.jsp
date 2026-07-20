<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
           uri="http://java.sun.com/jsp/jstl/core" %>

<%
    Object student =  session.getAttribute("loggedInUser");
    if(student == null){
        response.sendRedirect("/login");
        return;
    }
%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Student Dashboard | LMS</title>

    <!-- Bootstrap CSS -->

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <!-- Bootstrap Icons -->

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
          rel="stylesheet">

    <!-- Google Font -->

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
            background:#f4f7fc;
            overflow-x:hidden;
        }

        .sidebar{
            width:260px;
            height:100vh;
            position:fixed;
            top:0;
            left:0;
            background:linear-gradient(180deg,#0f172a,#1e293b);
            padding:25px 18px;
            overflow-y:auto;
            z-index:1000;
        }

        .logo{
            text-align:center;
            margin-bottom:35px;
        }

        .logo i{
            font-size:52px;
            color:#3b82f6;
        }

        .logo h2{
            color:white;
            margin-top:10px;
            font-size:24px;
            font-weight:700;
        }

        .sidebar-menu a{
            display:flex;
            align-items:center;
            gap:14px;
            padding:14px 18px;
            margin-bottom:12px;
            text-decoration:none;
            color:#e2e8f0;
            border-radius:12px;
            transition:0.3s;
            font-size:15px;
            font-weight:500;
        }

        .sidebar-menu a:hover,
        .sidebar-menu a.active{
            background:#2563eb;
            color:white;
            transform:translateX(4px);
        }

        .sidebar-menu i{
            font-size:20px;
        }

        .main-content{
            margin-left:260px;
            padding:30px;
        }

        .topbar{
            background:white;
            border-radius:18px;
            padding:22px 28px;
            box-shadow:0 4px 12px rgba(0,0,0,0.08);

            display:flex;
            justify-content:space-between;
            align-items:center;
            flex-wrap:wrap;

            margin-bottom:30px;
        }

        .topbar h1{
            font-size:30px;
            font-weight:700;
            color:#1e293b;
        }

        .welcome-box{
            background:#198754;
            color:white;
            padding:10px 18px;
            border-radius:10px;
            font-weight:600;
        }

        .dashboard-grid{
            display:grid;
            grid-template-columns:
                    repeat(auto-fit,minmax(250px,1fr));

            gap:25px;
        }

        .dashboard-card{
            border-radius:24px;
            padding:30px;
            text-decoration:none;
            color:white;
            transition:0.3s;
            position:relative;
            overflow:hidden;
            box-shadow:0 6px 16px rgba(0,0,0,0.1);
        }

        .dashboard-card:hover{
            transform:translateY(-6px);
            color:white;
        }

        .dashboard-card i{
            font-size:52px;
            margin-bottom:18px;
        }

        .dashboard-card h3{
            font-size:24px;
            font-weight:700;
            margin-bottom:12px;
        }

        .dashboard-card p{
            font-size:15px;
            opacity:0.95;
            margin:0;
        }

        /* CARD COLORS */

        .books{
            background:linear-gradient(135deg,#2563eb,#3b82f6);
        }

        .issued{
            background:linear-gradient(135deg,#f97316,#fb923c);
        }

        .profile{
            background:linear-gradient(135deg,#06b6d4,#22d3ee);
        }

        .logout{
            background:linear-gradient(135deg,#dc2626,#ef4444);
        }

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

            .topbar{
                flex-direction:column;
                align-items:flex-start;
                gap:15px;
            }
        }

        @media(max-width:576px){

            .topbar h1{
                font-size:24px;
            }

            .dashboard-card{
                padding:24px;
            }

            .dashboard-card h3{
                font-size:20px;
            }
        }

    </style>

</head>

<body>

<div class="sidebar">

    <div class="logo">

        <i class="bi bi-book-half"></i>

        <h2>LMS Student</h2>

    </div>

    <div class="sidebar-menu">

        <a href="/student/dashboard"
           class="active">

            <i class="bi bi-speedometer2"></i>

            Dashboard

        </a>

       <a href="/student/dashboard">

             <i class="bi bi-speedometer2"></i>

             Dashboard

         </a>


        <a href="/student/view-books">

            <i class="bi bi-book"></i>

            Available Books

        </a>

        <a href="/student/student-issued-books">

            <i class="bi bi-journal-bookmark"></i>

            My Issued Books

        </a>

        <a href="/student/profile">

            <i class="bi bi-person-circle"></i>

            My Profile

        </a>

        <a href="/auth/logout">

            <i class="bi bi-box-arrow-right"></i>

            Logout

        </a>

    </div>

</div>


<div class="main-content">

    <!-- TOPBAR -->

    <div class="topbar">

        <div>

            <h1>
                Student Dashboard
            </h1>

            <p class="text-muted mb-0">
                Library Management System
            </p>

        </div>

        <c:if test="${not empty user}">

            <div class="welcome-box">

                Welcome,
                    ${user.fullName}

            </div>

        </c:if>

    </div>

    <!-- DASHBOARD CARDS -->

    <div class="dashboard-grid">

        <!-- AVAILABLE BOOKS -->

        <a href="/student/view-books"
           class="dashboard-card books">

            <i class="bi bi-book-half"></i>

            <h3>Available Books</h3>

            <p>
                Browse all books available in library.
            </p>

        </a>

        <!-- ISSUED BOOKS -->

        <a href="/student/student-issued-books"
           class="dashboard-card issued">

            <i class="bi bi-journal-check"></i>

            <h3>Issued Books</h3>

            <p>
                View books currently issued to you.
            </p>

        </a>

        <!-- PROFILE -->

        <a href="/student/profile"
           class="dashboard-card profile">

            <i class="bi bi-person-circle"></i>

            <h3>My Profile</h3>

            <p>
                Manage your student profile details.
            </p>

        </a>

        <!-- LOGOUT -->

        <a href="/auth/logout"
           class="dashboard-card logout">

            <i class="bi bi-box-arrow-right"></i>

            <h3>Logout</h3>

            <p>
                Securely logout from the LMS system.
            </p>

        </a>

    </div>

</div>

<!-- Bootstrap JS -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>