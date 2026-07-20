<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Secure Payment Gateway | LMS</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        body {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, #0f172a, #020617);
            color: white;
            padding: 20px;
            font-family: system-ui, -apple-system, sans-serif;
        }

        .gateway-card {
            width: 100%;
            max-width: 520px;
            background: rgba(255, 255, 255, 0.04);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 24px;
            padding: 35px;
            text-align: center;
            box-shadow: 0 20px 50px rgba(0, 0, 0, .6);
        }

        .gateway-icon {
            width: 76px;
            height: 76px;
            margin: auto;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
            background: rgba(255, 193, 7, 0.15);
            color: #ffc107;
        }

        .ledger-box {
            margin-top: 25px;
            background: rgba(17, 24, 39, 0.7);
            border: 1px solid rgba(255, 255, 255, 0.05);
            border-radius: 16px;
            padding: 20px;
            text-align: left;
        }

        .ledger-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 14px;
            align-items: center;
            gap: 16px;
            font-size: 14px;
            color: #94a3b8;
        }

        .ledger-row:last-child {
            margin-bottom: 0;
            padding-top: 14px;
            border-top: 1px dashed rgba(255, 255, 255, 0.1);
        }

        .price {
            color: #ffc107;
            font-size: 22px;
            font-weight: 700;
        }

        .pay-btn {
            width: 100%;
            margin-top: 25px;
            height: 54px;
            border: none;
            border-radius: 14px;
            background: linear-gradient(135deg, #ffc107, #ff9800);
            color: black;
            font-weight: 600;
            font-size: 16px;
            transition: all 0.2s ease;
        }

        .pay-btn:hover {
            opacity: 0.95;
            transform: translateY(-1px);
        }

        .pay-btn:active {
            transform: translateY(1px);
        }

        .cancel-link {
            display: inline-block;
            margin-top: 18px;
            color: #64748b;
            text-decoration: none;
            font-size: 14px;
            transition: color 0.2s ease;
        }

        .cancel-link:hover {
            color: #ef4444;
        }

        .alert-custom {
            background: rgba(239, 68, 68, 0.12);
            border: 1px solid rgba(239, 68, 68, 0.25);
            color: #f87171;
            border-radius: 14px;
            font-size: 14px;
        }
    </style>
</head>
<body>

<div class="gateway-card">

    <div class="gateway-icon">
        <i class="bi bi-shield-lock-fill"></i>
    </div>

    <h3 class="mt-2">Secure Payment Checkout</h3>

    <p class="text-secondary small">
        Processing dynamic credentials fetched from core database schema.
    </p>

    <%-- Error Notification Management --%>
    <c:if test="${not empty param.error}">
        <div class="alert alert-custom my-3 text-start d-flex align-items-center gap-2" role="alert">
            <i class="bi bi-exclamation-triangle-fill fs-5"></i>
            <div>
                <c:choose>
                    <c:when test="${param.error eq 'missing_config'}">System secure token parameters are unassigned.</c:when>
                    <c:when test="${param.error eq 'payment_init_failed'}">Razorpay API initialization failed on cloud gateway.</c:when>
                    <c:when test="${param.error eq 'invalid_signature'}">Digital payment tamper protection tracking failed.</c:when>
                    <c:otherwise>System pipeline unhandled panic context. Please try again.</c:otherwise>
                </c:choose>
            </div>
        </div>
    </c:if>

    <div class="ledger-box">
        <div class="ledger-row">
            <span>Student Entity</span>
            <span class="text-white"><c:out value="${user.fullName}"/></span>
        </div>

        <div class="ledger-row">
            <span>Book Resource</span>
            <span class="text-white text-truncate" style="max-width: 240px;">
                <c:out value="${book.bookName}"/>
            </span>
        </div>

        <div class="ledger-row">
            <span>Transaction Routing</span>
            <span class="text-success small">
                <i class="bi bi-patch-check-fill"></i> Razorpay API Active
            </span>
        </div>

        <div class="ledger-row">
            <span><b class="text-white">Total Amount (INR)</b></span>
            <span class="price">&#8377;<c:out value="${book.price}"/></span>
        </div>
    </div>

    <%-- Data Context Nodes mapping directly into javascript layout variables --%>
    <button
            id="rzp-button"
            type="button"
            class="pay-btn"
            data-context-path="${pageContext.request.contextPath}"
            data-book-id="<c:out value='${book.id}'/>"
            data-book-title="<c:out value='${book.bookName}'/>"
            data-amount="<c:out value='${amount}'/>"
            data-order-id="<c:out value='${orderId}'/>"
            data-razorpay-key="<c:out value='${razorpayKey}'/>"
            data-student-name="<c:out value='${not empty user ? user.fullName : ""}'/>"
            data-student-email="<c:out value='${not empty user ? user.email : ""}'/>"
            data-student-contact="<c:out value='${not empty user ? user.mobileNumber : ""}'/>"
    >
        <i class="bi bi-credit-card-fill me-2"></i>Pay Now
    </button>

    <a
            href="${pageContext.request.contextPath}/payment/cancel?bookId=${book.id}&orderId=${orderId}"
            class="cancel-link"
    >
        <i class="bi bi-arrow-left-circle me-1"></i>Cancel & Return
    </a>

</div>

<script src="https://checkout.razorpay.com/v1/checkout.js"></script>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const payButton = document.getElementById("rzp-button");
    const contextPath = payButton.dataset.contextPath || "";
    const bookId = payButton.dataset.bookId || "";
    const orderId = payButton.dataset.orderId || "";

    const cancelUrl = contextPath
        + "/payment/cancel?bookId="
        + encodeURIComponent(bookId)
        + "&orderId="
        + encodeURIComponent(orderId);

    const payButtonDefaultContent = payButton.innerHTML;

    function redirectToCancellation() {
        window.location.href = cancelUrl;
    }

    function submitPaymentVerification(response) {
        const form = document.createElement("form");
        form.method = "POST";
        form.action = contextPath + "/payment/verify";

        const inputs = {
            razorpay_payment_id: response.razorpay_payment_id,
            razorpay_order_id: response.razorpay_order_id,
            razorpay_signature: response.razorpay_signature,
            bookId: bookId
        };

        Object.keys(inputs).forEach(function (key) {
            const hiddenField = document.createElement("input");
            hiddenField.type = "hidden";
            hiddenField.name = key;
            hiddenField.value = inputs[key] || "";
            form.appendChild(hiddenField);
        });

        document.body.appendChild(form);
        form.submit();
    }

    const options = {
        key: payButton.dataset.razorpayKey,
        amount: parseInt(payButton.dataset.amount || "0", 10),
        currency: "INR",
        name: "LMS Book Store",
        description: payButton.dataset.bookTitle || "Library Purchase",
        image: contextPath + "/assets/images/logo.png",
        order_id: orderId,
        handler: submitPaymentVerification,
        prefill: {
            name: payButton.dataset.studentName || "",
            email: payButton.dataset.studentEmail || "",
            contact: payButton.dataset.studentContact || ""
        },
        theme: {
            color: "#FFC107"
        },
        modal: {
            ondismiss: redirectToCancellation
        }
    };

    let rzp;
    try {
        rzp = new Razorpay(options);
        rzp.on("payment.failed", function(response) {
            console.error("Transmission Failure Trace:", response.error);
            redirectToCancellation();
        });
    } catch (setupError) {
        console.error("Critical: Cannot initialize instance container:", setupError);
    }

    // Auto trigger block to instantly pop the payment gateway screen
    if (rzp && orderId !== "") {
        setTimeout(function() {
            payButton.disabled = true;
            payButton.innerHTML = '<i class="bi bi-hourglass-split me-2"></i>Launching Gateway...';
            try {
                rzp.open();
            } catch (err) {
                payButton.disabled = false;
                payButton.innerHTML = payButtonDefaultContent;
                redirectToCancellation();
            }
        }, 600);
    }

    payButton.addEventListener("click", function (event) {
        event.preventDefault();
        if (!rzp) {
            redirectToCancellation();
            return;
        }
        payButton.disabled = true;
        payButton.innerHTML = '<i class="bi bi-hourglass-split me-2"></i>Opening Gateway...';
        try {
            rzp.open();
        } catch (error) {
            payButton.disabled = false;
            payButton.innerHTML = payButtonDefaultContent;
            redirectToCancellation();
        }
    });
});
</script>

</body>
</html>
