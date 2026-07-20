<%@ page contentType="text/html;charset=UTF-8"
         language="java" %>

<%@ taglib prefix="c"
           uri="http://java.sun.com/jsp/jstl/core" %>

<%
    Object admin = session.getAttribute("loggedInUser");
    if(admin == null){
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Books Management | LMS Admin</title>

    <!-- GOOGLE FONT -->

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
          rel="stylesheet">

    <!-- BOOTSTRAP CSS -->

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <!-- BOOTSTRAP ICONS -->

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
          rel="stylesheet">

    <style>

        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
            font-family:'Poppins',sans-serif;
        }

        body{
            background:#edf2f7;
            min-height:100vh;
            padding:30px;
        }

        /* =========================================
           PAGE HEADER
        ========================================= */

        .page-header{
            background:#ffffff;
            border-radius:24px;
            padding:28px 34px;
            box-shadow:0 6px 20px rgba(15,23,42,0.08);
            display:flex;
            justify-content:space-between;
            align-items:center;
            margin-bottom:28px;
            flex-wrap:wrap;
            gap:20px;
        }

        .page-title{
            display:flex;
            align-items:center;
            gap:14px;
            font-size:34px;
            font-weight:700;
            color:#0f172a;
            margin:0;
        }

        .page-title i{
            color:#2563eb;
        }

        .top-buttons{
            display:flex;
            gap:14px;
            flex-wrap:wrap;
        }

        /* =========================================
           BUTTONS
        ========================================= */

        .btn-custom{
            border:none;
            border-radius:14px;
            padding:12px 20px;
            font-size:14px;
            font-weight:600;
            text-decoration:none;
            display:inline-flex;
            align-items:center;
            justify-content:center;
            gap:8px;
            transition:all 0.3s ease;
            cursor:pointer;
        }

        .btn-home{
            background:#0f172a;
            color:#ffffff;
        }

        .btn-home:hover{
            background:#020617;
            color:#ffffff;
            transform:translateY(-2px);
        }

        .btn-add{
            background:#2563eb;
            color:#ffffff;
        }

        .btn-add:hover{
            background:#1d4ed8;
            color:#ffffff;
            transform:translateY(-2px);
        }

        .btn-edit{
            background:#f59e0b;
            color:#ffffff;
            min-width:100px;
        }

        .btn-edit:hover{
            background:#d97706;
            color:#ffffff;
            transform:translateY(-2px);
        }

        .btn-delete{
            background:#ef4444;
            color:#ffffff;
            min-width:100px;
        }

        .btn-delete:hover{
            background:#dc2626;
            color:#ffffff;
            transform:translateY(-2px);
        }

        /* =========================================
           TABLE CARD
        ========================================= */

        .table-card{
            background:#ffffff;
            border-radius:24px;
            padding:26px;
            box-shadow:0 6px 20px rgba(15,23,42,0.08);
            overflow-x:auto;
        }

        table{
            width:100%;
            border-collapse:collapse;
            min-width:1100px;
        }

        thead tr{
            border-bottom:2px solid #e2e8f0;
        }

        th{
            padding:18px 16px;
            text-align:left;
            font-size:15px;
            font-weight:700;
            color:#0f172a;
            white-space:nowrap;
        }

        td{
            padding:18px 16px;
            font-size:14px;
            color:#475569;
            border-bottom:1px solid #e2e8f0;
            vertical-align:middle;
        }

        tbody tr{
            transition:0.3s;
        }

        tbody tr:hover{
            background:#f8fafc;
        }

        .book-name{
            font-weight:600;
            color:#0f172a;
        }

        /* =========================================
           STATUS BADGE
        ========================================= */

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

        .status-available{
            background:#dcfce7;
            color:#166534;
        }

        .status-low{
            background:#fef3c7;
            color:#92400e;
        }

        .status-out{
            background:#fee2e2;
            color:#991b1b;
        }

        /* =========================================
           ACTION BUTTONS
        ========================================= */

        .action-buttons{
            display:flex;
            align-items:center;
            gap:10px;
            flex-wrap:wrap;
        }

        .file-links{
            display:flex;
            flex-direction:column;
            gap:8px;
            min-width:120px;
        }

        .file-link{
            display:inline-flex;
            align-items:center;
            justify-content:center;
            padding:8px 12px;
            border-radius:12px;
            text-decoration:none;
            font-size:12px;
            font-weight:600;
            background:#dbeafe;
            color:#1d4ed8;
        }

        .file-link.disabled{
            background:#e2e8f0;
            color:#64748b;
        }

        /* =========================================
           EMPTY BOX
        ========================================= */

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
            font-size:28px;
            font-weight:700;
            color:#0f172a;
            margin-bottom:8px;
        }

        .empty-box p{
            color:#64748b;
            margin:0;
            font-size:15px;
        }

        /* =========================================
           ALERT
        ========================================= */

        .alert{
            border:none;
            border-radius:16px;
            padding:16px 18px;
            font-weight:500;
        }

        /* =========================================
           RESPONSIVE
        ========================================= */

        @media(max-width:768px){

            body{
                padding:16px;
            }

            .page-header{
                padding:22px;
            }

            .page-title{
                font-size:26px;
            }

            .top-buttons{
                width:100%;
                flex-direction:column;
            }

            .btn-custom{
                width:100%;
            }

            .table-card{
                padding:18px;
            }

            .action-buttons{
                flex-direction:column;
                width:100%;
            }

            .btn-edit,
            .btn-delete{
                width:100%;
            }
        }

    </style>

</head>

<body>

<!-- =========================================
     PAGE HEADER
========================================= -->

<div class="page-header">

    <h1 class="page-title">

        <i class="bi bi-book-half"></i>

        Books Management

    </h1>

    <div class="top-buttons">

        <!-- BACK TO HOME -->

        <a href="${pageContext.request.contextPath}/admin/dashboard"
           class="btn-custom btn-home">

            <i class="bi bi-house-door-fill"></i>

            Back To Home

        </a>

        <!-- ADD BOOK -->

        <a href="${pageContext.request.contextPath}/admin/add-book"
           class="btn-custom btn-add">

            <i class="bi bi-plus-circle"></i>

            Add New Book

        </a>

    </div>

</div>

<!-- =========================================
     SUCCESS MESSAGE
========================================= -->

<c:if test="${not empty success}">

    <div class="alert alert-success alert-dismissible fade show"
         role="alert">

            ${success}

        <button type="button"
                class="btn-close"
                data-bs-dismiss="alert">
        </button>

    </div>

</c:if>

<!-- =========================================
     ERROR MESSAGE
========================================= -->

<c:if test="${not empty error}">

    <div class="alert alert-danger alert-dismissible fade show"
         role="alert">

            ${error}

        <button type="button"
                class="btn-close"
                data-bs-dismiss="alert">
        </button>

    </div>

</c:if>

<!-- =========================================
     BOOK TABLE
========================================= -->

<div class="table-card">

    <c:choose>

        <c:when test="${empty books}">

            <div class="empty-box">

                <i class="bi bi-journal-x"></i>

                <h3>No Books Available</h3>

                <p>

                    Add books to manage your library inventory.

                </p>

            </div>

        </c:when>

        <c:otherwise>

            <table>

                <thead>

                <tr>

                    <th>ID</th>
                    <th>Book Name</th>
                    <th>Author</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Total Qty</th>
                    <th>Available</th>
                    <th>Status</th>
                    <th>Files</th>
                    <th>Actions</th>

                </tr>

                </thead>

                <tbody>

                <c:forEach items="${books}"
                           var="book">

                    <tr>

                        <td>${book.id}</td>

                        <td class="book-name">

                                ${book.bookName}

                        </td>

                        <td>${book.authorName}</td>

                        <td>${book.category}</td>

                        <td>

                            ₹ ${book.price}

                        </td>

                        <td>${book.quantity}</td>

                        <td>${book.availableQuantity}</td>

                        <td>

                            <c:choose>

                                <c:when test="${book.availableQuantity == 0}">

                                    <span class="status-badge status-out">

                                        Out Of Stock

                                    </span>

                                </c:when>

                                <c:when test="${book.availableQuantity <= 5}">

                                    <span class="status-badge status-low">

                                        Low Stock

                                    </span>

                                </c:when>

                                <c:otherwise>

                                    <span class="status-badge status-available">

                                        Available

                                    </span>

                                </c:otherwise>

                            </c:choose>

                        </td>

                        <td>

                            <div class="file-links">

                                <c:choose>
                                    <c:when test="${book.bookImage != null}">
                                        <a href="${pageContext.request.contextPath}/files/view/${book.bookImage.id}"
                                           class="file-link"
                                           target="_blank"
                                           rel="noopener">
                                            View Cover
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="file-link disabled">
                                            No Cover
                                        </span>
                                    </c:otherwise>
                                </c:choose>

                                <c:choose>
                                    <c:when test="${book.bookPdf != null}">
                                        <a href="${pageContext.request.contextPath}/files/download/${book.bookPdf.id}"
                                           class="file-link">
                                            Download PDF
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="file-link disabled">
                                            No PDF
                                        </span>
                                    </c:otherwise>
                                </c:choose>

                            </div>

                        </td>

                        <!-- ACTION BUTTONS -->

                        <td>

                            <div class="action-buttons">

                                <!-- EDIT -->

                                <a href="${pageContext.request.contextPath}/admin/edit-book/${book.id}"
                                   class="btn-custom btn-edit">

                                    <i class="bi bi-pencil-square"></i>

                                    Edit

                                </a>

                                <!-- DELETE -->

                                <form action="${pageContext.request.contextPath}/admin/delete-book/${book.id}"
                                      method="post"
                                      style="margin:0;"
                                      onsubmit="return confirm('Are you sure you want to delete this book?');">

                                    <button type="submit"
                                            class="btn-custom btn-delete">

                                        <i class="bi bi-trash"></i>

                                        Delete

                                    </button>

                                </form>

                            </div>

                        </td>

                    </tr>

                </c:forEach>

                </tbody>

            </table>

        </c:otherwise>

    </c:choose>

</div>

<!-- BOOTSTRAP JS -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>
