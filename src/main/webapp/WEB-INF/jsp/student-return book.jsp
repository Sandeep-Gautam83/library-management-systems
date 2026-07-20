<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% Object student = session.getAttribute("loggedInUser");
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

    <title>Student Return Book</title>

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
            background:#f1f5f9;
            min-height:100vh;
            padding:30px;
        }

        .page-header{
            background:#ffffff;
            border-radius:22px;
            padding:24px 30px;
            margin-bottom:28px;
            display:flex;
            justify-content:space-between;
            align-items:center;
            flex-wrap:wrap;
            gap:15px;
            box-shadow:0 6px 18px rgba(0,0,0,0.08);
        }

        .page-title{
            font-size:34px;
            font-weight:700;
            color:#0f172a;
            display:flex;
            align-items:center;
            gap:12px;
        }

        .page-title i{
            color:#16a34a;
        }

        .btn-home{
            background:#0f172a;
            color:white;
            text-decoration:none;
            padding:12px 22px;
            border-radius:12px;
            font-size:14px;
            font-weight:600;
            display:flex;
            align-items:center;
            gap:8px;
            transition:0.3s;
        }

        .btn-home:hover{
            background:#020617;
            color:white;
            transform:translateY(-2px);
        }

        .table-card{
            background:white;
            border-radius:22px;
            padding:25px;
            box-shadow:0 6px 18px rgba(0,0,0,0.08);
            overflow-x:auto;
        }

        table{
            width:100%;
            border-collapse:collapse;
            min-width:1000px;
        }

        thead tr{
            background:#eff6ff;
        }

        th{
            padding:16px;
            text-align:left;
            font-size:15px;
            font-weight:700;
            color:#0f172a;
        }

        td{
            padding:16px;
            border-bottom:1px solid #e2e8f0;
            font-size:14px;
            color:#475569;
        }

        tbody tr:hover{
            background:#f8fafc;
        }

        .book-name{
            font-weight:600;
            color:#0f172a;
        }

        .status-badge{
            display:inline-flex;
            align-items:center;
            justify-content:center;
            min-width:120px;
            padding:8px 14px;
            border-radius:30px;
            font-size:12px;
            font-weight:700;
        }

        .status-issued{
            background:#dbeafe;
            color:#1d4ed8;
        }

        .status-returned{
            background:#dcfce7;
            color:#166534;
        }

        .fine{
            font-weight:700;
            color:#dc2626;
        }

        .btn-return{
            background:#16a34a;
            color:white;
            border:none;
            padding:10px 16px;
            border-radius:10px;
            font-size:13px;
            font-weight:600;
            display:inline-flex;
            align-items:center;
            gap:6px;
            text-decoration:none;
            transition:0.3s;
        }

        .btn-return:hover{
            background:#15803d;
            color:white;
            transform:translateY(-2px);
        }

        .returned-text{
            color:#16a34a;
            font-weight:700;
        }

        .empty-box{
            text-align:center;
            padding:60px 20px;
        }

        .empty-box i{
            font-size:60px;
            color:#94a3b8;
            margin-bottom:16px;
        }

        .empty-box h3{
            font-size:30px;
            font-weight:700;
            color:#0f172a;
        }

        .alert{
            border-radius:14px;
            margin-bottom:20px;
        }

        @media(max-width:768px){

            body{
                padding:16px;
            }

            .page-header{
                flex-direction:column;
                align-items:flex-start;
            }

            .btn-home{
                width:100%;
                justify-content:center;
            }
        }

    </style>

</head>

<body>

<!-- PAGE HEADER -->

<div class="page-header">

    <h1 class="page-title">

        <i class="bi bi-arrow-return-left"></i>

        Student Return Book

    </h1>

    <!-- BACK TO HOME BUTTON -->

    <a href="/student/dashboard"
       class="btn-home">

        <i class="bi bi-house-door-fill"></i>

        Back To Home

    </a>

</div>

<!-- SUCCESS MESSAGE -->

<c:if test="${not empty success}">

    <div class="alert alert-success alert-dismissible fade show">

        ${success}

        <button type="button"
                class="btn-close"
                data-bs-dismiss="alert">
        </button>

    </div>

</c:if>

<!-- ERROR MESSAGE -->

<c:if test="${not empty error}">

    <div class="alert alert-danger alert-dismissible fade show">

        ${error}

        <button type="button"
                class="btn-close"
                data-bs-dismiss="alert">
        </button>

    </div>

</c:if>

<!-- TABLE SECTION -->

<div class="table-card">

    <c:choose>

        <!-- EMPTY DATA -->

        <c:when test="${empty issuedBooks}">

            <div class="empty-box">

                <i class="bi bi-journal-x"></i>

                <h3>No Issued Books Found</h3>

            </div>

        </c:when>

        <!-- BOOK LIST -->

        <c:otherwise>

            <table>

                <thead>

                <tr>

                    <th>ID</th>
                    <th>Book Name</th>
                    <th>Issue Date</th>
                    <th>Due Date</th>
                    <th>Return Date</th>
                    <th>Status</th>
                    <th>Fine</th>
                    <th>Action</th>

                </tr>

                </thead>

                <tbody>

                <c:forEach items="${issuedBooks}"
                           var="issue">

                    <tr>

                        <td>${issue.id}</td>

                        <td class="book-name">

                            ${issue.bookName}

                        </td>

                        <td>${issue.issueDate}</td>

                        <td>${issue.dueDate}</td>

                        <!-- RETURN DATE -->

                        <td>

                            <c:choose>

                                <c:when test="${not empty issue.returnDate}">

                                    ${issue.returnDate}

                                </c:when>

                                <c:otherwise>

                                    <span class="text-muted">

                                        Not Returned

                                    </span>

                                </c:otherwise>

                            </c:choose>

                        </td>

                        <!-- STATUS -->

                        <td>

                            <c:choose>

                                <c:when test="${issue.status == 'RETURNED'}">

                                    <span class="status-badge status-returned">

                                        RETURNED

                                    </span>

                                </c:when>

                                <c:otherwise>

                                    <span class="status-badge status-issued">

                                        ISSUED

                                    </span>

                                </c:otherwise>

                            </c:choose>

                        </td>

                        <!-- FINE -->

                        <td>

                            <c:choose>

                                <c:when test="${issue.fine != null && issue.fine > 0}">

                                    <span class="fine">

                                        ₹ ${issue.fine}

                                    </span>

                                </c:when>

                                <c:otherwise>

                                    ₹ 0

                                </c:otherwise>

                            </c:choose>

                        </td>

                        <!-- ACTION BUTTON -->

                        <td>

                            <c:choose>

                                <c:when test="${issue.status != 'RETURNED'}">

                                    <a href="/student/return-book/${issue.id}"
                                       class="btn-return"
                                       onclick="return confirm('Are you sure want to return this book ?')">

                                        <i class="bi bi-check-circle-fill"></i>

                                        Return Book

                                    </a>

                                </c:when>

                                <c:otherwise>

                                    <span class="returned-text">

                                        Already Returned

                                    </span>

                                </c:otherwise>

                            </c:choose>

                        </td>

                    </tr>

                </c:forEach>

                </tbody>

            </table>

        </c:otherwise>

    </c:choose>

</div>

<!-- Bootstrap JS -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>