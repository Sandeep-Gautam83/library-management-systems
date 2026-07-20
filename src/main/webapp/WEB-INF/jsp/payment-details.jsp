<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Details - LMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-dark text-white">
                    <h4 class="mb-0">Payment Details</h4>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <strong>Transaction ID</strong>
                            <div><c:out value="${payment.transactionId}"/></div>
                        </div>
                        <div class="col-md-6">
                            <strong>Order ID</strong>
                            <div><c:out value="${payment.orderId}"/></div>
                        </div>
                        <div class="col-md-6">
                            <strong>Student</strong>
                            <div><c:out value="${payment.studentName}"/></div>
                        </div>
                        <div class="col-md-6">
                            <strong>Student Email</strong>
                            <div><c:out value="${payment.studentEmail}"/></div>
                        </div>
                        <div class="col-md-6">
                            <strong>Book</strong>
                            <div><c:out value="${payment.bookTitle}"/></div>
                        </div>
                        <div class="col-md-6">
                            <strong>Amount</strong>
                            <div>&#8377;<c:out value="${payment.amount}"/></div>
                        </div>
                        <div class="col-md-6">
                            <strong>Status</strong>
                            <div><c:out value="${payment.status}"/></div>
                        </div>
                        <div class="col-md-6">
                            <strong>Gateway</strong>
                            <div><c:out value="${payment.paymentGateway}"/></div>
                        </div>
                        <div class="col-md-6">
                            <strong>Payment Date</strong>
                            <div><c:out value="${payment.purchaseDate}"/></div>
                        </div>
                        <div class="col-md-6">
                            <strong>Access Granted</strong>
                            <div><c:out value="${payment.accessGranted}"/></div>
                        </div>
                    </div>
                </div>
                <div class="card-footer bg-white">
                    <a href="${pageContext.request.contextPath}/payment/list" class="btn btn-outline-dark">
                        Back to Payments
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>