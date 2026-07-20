<%@ page contentType="text/html;charset=UTF-8"
         language="java" %>

<%@ taglib prefix="c"
           uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Student Profile | LMS</title>

    <!-- Bootstrap -->

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <!-- Font Awesome -->

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>

    <style>

        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
        }

        body{
            background:#f3f6fb;
            font-family:'Poppins',sans-serif;
        }

        .main-container{
            display:flex;
            min-height:100vh;
        }

        /* SIDEBAR */

        .sidebar{
            width:260px;
            background:#111827;
            color:white;
            padding:30px 20px;
            position:fixed;
            height:100vh;
        }

        .logo{
            text-align:center;
            font-size:30px;
            font-weight:bold;
            margin-bottom:40px;
        }

        .menu{
            display:flex;
            flex-direction:column;
            gap:15px;
        }

        .menu a{
            color:#e5e7eb;
            text-decoration:none;
            padding:14px;
            border-radius:10px;
            transition:0.3s;
        }

        .menu a:hover,
        .menu a.active{
            background:#2563eb;
            color:white;
        }

        /* CONTENT */

        .content{
            margin-left:260px;
            width:100%;
            padding:40px;
        }

        .profile-card{
            background:white;
            border-radius:20px;
            padding:40px;
            box-shadow:0 4px 15px rgba(0,0,0,0.08);
        }

        .profile-header{
            text-align:center;
            margin-bottom:35px;
        }

        .profile-icon{
            width:100px;
            height:100px;
            border-radius:50%;
            background:#2563eb;
            margin:auto;
            display:flex;
            align-items:center;
            justify-content:center;
            color:white;
            font-size:40px;
            margin-bottom:15px;
        }

        .profile-header h2{
            font-weight:bold;
            margin-bottom:5px;
        }

        .profile-header p{
            color:#6b7280;
        }

        .info-box{
            display:grid;
            grid-template-columns:1fr 1fr;
            gap:20px;
        }

        .info-item{
            background:#f9fafb;
            padding:18px;
            border-radius:12px;
        }

        .info-item h6{
            color:#6b7280;
            margin-bottom:8px;
            font-size:14px;
        }

        .info-item p{
            font-size:16px;
            font-weight:600;
            color:#111827;
            margin:0;
        }

        @media(max-width:768px){

            .sidebar{
                display:none;
            }

            .content{
                margin-left:0;
                padding:20px;
            }

            .info-box{
                grid-template-columns:1fr;
            }
        }

    </style>

</head>

<body>

<div class="main-container">

    <!-- SIDEBAR -->

    <div class="sidebar">

        <div class="logo">

            <i class="fa-solid fa-book"></i>
            LMS

        </div>

        <div class="menu">

            <a href="/student/dashboard">

                <i class="fa-solid fa-gauge"></i>
                Dashboard

            </a>

            <a href="/student/view-books">

                <i class="fa-solid fa-book"></i>
                View Books

            </a>

            <a href="/student/student-issued-books">

                <i class="fa-solid fa-book-open"></i>
                My Books

            </a>

            <a href="/student/profile"
               class="active">

                <i class="fa-solid fa-user"></i>
                Profile

            </a>

            <a href="/auth/logout">

                <i class="fa-solid fa-right-from-bracket"></i>
                Logout

            </a>

        </div>

    </div>

    <!-- CONTENT -->

    <div class="content">

        <div class="profile-card">

            <!-- PROFILE HEADER -->

            <div class="profile-header">

                <div class="profile-icon">

                    <i class="fa-solid fa-user"></i>

                </div>

                <h2>${user.fullName}</h2>

                <p>${user.role}</p>

            </div>

            <!-- PROFILE DETAILS -->

            <div class="info-box">

                <div class="info-item">

                    <h6>Full Name</h6>

                    <p>${user.fullName}</p>

                </div>

                <div class="info-item">

                    <h6>Email</h6>

                    <p>${user.email}</p>

                </div>

                <div class="info-item">

                    <h6>Mobile Number</h6>

                    <p>${user.mobileNumber}</p>

                </div>

                <div class="info-item">

                    <h6>Roll Number</h6>

                    <p>${user.rollNumber}</p>

                </div>

                <div class="info-item">

                    <h6>Course</h6>

                    <p>${user.course}</p>

                </div>

                <div class="info-item">

                    <h6>Branch</h6>

                    <p>${user.branch}</p>

                </div>

                <div class="info-item">

                    <h6>Year</h6>

                    <p>${user.year}</p>

                </div>

                <div class="info-item">

                    <h6>Gender</h6>

                    <p>${user.gender}</p>

                </div>

                <div class="info-item">

                    <h6>Status</h6>

                    <p>${user.status}</p>

                </div>

                <div class="info-item">

                    <h6>Address</h6>

                    <p>${user.address}</p>

                </div>

            </div>

        </div>

    </div>

</div>

</body>

</html>

