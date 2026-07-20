<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // SECURE ADMIN SESSION VALIDATION ENGINE
    Object admin = session.getAttribute("loggedInUser");
    if(admin == null){
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Book Matrix | LMS Control</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

    <style>
        :root[data-theme="dark"] {
            --bg-gradient: radial-gradient(circle at 50% 0%, #1e293b 0%, #0f172a 50%, #020617 100%);
            --panel-bg: rgba(30, 41, 59, 0.45);
            --panel-border: rgba(255, 255, 255, 0.08);
            --text-heading: #ffffff;
            --text-body: #cbd5e1;
            --text-muted: #64748b;
            --shadow: rgba(0, 0, 0, 0.5);
            --input-bg: rgba(15, 23, 42, 0.6);
            --input-color: #ffffff;
            --input-placeholder: #475569;
            --glass-panel-heavy: rgba(15, 23, 42, 0.85);
            --accent-glow: rgba(14, 165, 233, 0.15);
            --color-scheme: dark;
            --toggle-card-active: rgba(14, 165, 233, 0.15);
        }

        :root[data-theme="light"] {
            --bg-gradient: radial-gradient(circle at 50% 0%, #f1f5f9 0%, #e2e8f0 70%, #cbd5e1 100%);
            --panel-bg: rgba(255, 255, 255, 0.8);
            --panel-border: rgba(15, 23, 42, 0.08);
            --text-heading: #0f172a;
            --text-body: #334155;
            --text-muted: #94a3b8;
            --shadow: rgba(15, 23, 42, 0.08);
            --input-bg: #ffffff;
            --input-color: #0f172a;
            --input-placeholder: #cbd5e1;
            --glass-panel-heavy: rgba(255, 255, 255, 0.95);
            --accent-glow: rgba(2, 132, 199, 0.08);
            --color-scheme: light;
            --toggle-card-active: rgba(2, 132, 199, 0.1);
        }

        * {
            margin: 0; padding: 0; box-sizing: border-box;
            font-family: 'Plus Jakarta Sans', sans-serif;
            transition: background-color 0.3s ease, border-color 0.3s ease, color 0.3s ease, box-shadow 0.3s ease;
        }

        body {
            background: var(--bg-gradient);
            min-height: 100vh;
            color: var(--text-body);
            padding: 40px 24px;
        }

        .glass-panel {
            background: var(--panel-bg);
            backdrop-filter: blur(24px);
            -webkit-backdrop-filter: blur(24px);
            border: 1px solid var(--panel-border);
            border-radius: 20px;
            box-shadow: 0 10px 40px var(--shadow);
            padding: 35px;
            margin-bottom: 30px;
        }

        /* FLOATING ALERT WRAPPER BOX */
        .alert-container {
            position: fixed;
            top: 25px;
            right: 25px;
            z-index: 1050;
            min-width: 320px;
            max-width: 450px;
        }

        .page-header {
            display: flex; justify-content: space-between;
            align-items: center; flex-wrap: wrap; gap: 20px;
        }

        .page-title {
            font-size: 26px; font-weight: 800; color: var(--text-heading);
            display: flex; align-items: center; gap: 12px; margin: 0;
            letter-spacing: -0.5px;
        }

        .page-title i { color: #0ea5e9; }

        .btn-custom {
            border: none; border-radius: 12px; padding: 12px 22px;
            font-size: 14px; font-weight: 600; text-decoration: none;
            display: inline-flex; align-items: center; justify-content: center;
            gap: 8px; transition: transform 0.2s ease, filter 0.2s ease; cursor: pointer;
        }
        .btn-custom:hover {
            transform: translateY(-2px);
            filter: brightness(1.05);
        }

        .btn-theme-toggle {
            background: var(--panel-bg); color: var(--text-heading);
            border: 1px solid var(--panel-border); border-radius: 12px;
            width: 48px; height: 48px; display: flex; align-items: center; justify-content: center;
            cursor: pointer;
        }

        .btn-home { background: var(--glass-panel-heavy); color: var(--text-heading); border: 1px solid var(--panel-border); }
        .btn-books { background: linear-gradient(135deg, #0ea5e9, #2563eb); color: #ffffff !important; }
        .btn-update { background: linear-gradient(135deg, #10b981, #059669); color: #ffffff; }
        .btn-cancel { background: rgba(239, 68, 68, 0.1); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.15); }
        .btn-cancel:hover { background: #ef4444; color: #ffffff !important; }

        .form-floating { position: relative; }

        .form-floating > .form-control,
        .form-floating > .form-select {
            background: var(--input-bg) !important;
            border: 1px solid var(--panel-border) !important;
            color: var(--input-color) !important;
            border-radius: 12px;
            height: 60px;
            font-size: 14.5px;
            padding: 24px 16px 8px 16px;
            color-scheme: var(--color-scheme);
        }

        /* Form select alignment compatibility override */
        .form-floating > .form-select {
            padding-top: 24px;
            padding-bottom: 0px;
        }

        .form-floating > .form-control:focus,
        .form-floating > .form-select:focus {
            border-color: #0ea5e9 !important;
            box-shadow: 0 0 0 4px var(--accent-glow) !important;
        }

        .form-floating > .form-control:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            background: rgba(0, 0, 0, 0.15) !important;
        }

        .form-floating > label {
            color: var(--text-muted) !important;
            padding: 18px 16px;
            font-size: 14px;
            position: absolute;
            top: 0; left: 0;
            pointer-events: none;
            transform-origin: 0 0;
            transition: opacity .1s ease-in-out, transform .1s ease-in-out;
        }

        .form-floating > .form-control:focus ~ label,
        .form-floating > .form-control:not(:placeholder-shown) ~ label,
        .form-floating > .form-select ~ label {
            opacity: 0.85;
            color: #0ea5e9 !important;
            transform: scale(0.85) translateY(-12px) translateX(0px);
        }

        textarea.form-control {
            min-height: 120px !important;
            height: auto !important;
            padding-top: 30px !important;
        }

        .access-toggle-container {
            display: flex;
            gap: 12px;
            height: 60px;
        }

        .access-wrapper-box {
            flex: 1;
            position: relative;
        }

        .access-wrapper-box input[type="radio"] {
            position: absolute;
            opacity: 0;
            width: 0; height: 0;
        }

        .access-label-card {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            width: 100%; height: 100%;
            background: var(--input-bg);
            border: 1px solid var(--panel-border);
            color: var(--text-body);
            border-radius: 12px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            user-select: none;
            transition: all 0.25s ease;
        }

        .access-wrapper-box input[type="radio"]:checked + .access-label-card {
            background: var(--toggle-card-active);
            border-color: #0ea5e9;
            color: #0ea5e9;
            box-shadow: 0 0 12px var(--accent-glow);
        }

        .file-upload-wrapper {
            background: rgba(0, 0, 0, 0.04);
            border: 1px dashed var(--panel-border);
            border-radius: 12px;
            padding: 20px;
            height: 100%;
        }

        [data-theme="dark"] .file-upload-wrapper { background: rgba(255, 255, 255, 0.02); }
        .file-input-label { display: block; font-size: 13px; font-weight: 600; color: var(--text-heading); margin-bottom: 10px; }

        .current-file-badge {
            display: inline-flex; align-items: center; gap: 8px;
            background: rgba(0,0,0,0.2); border: 1px solid var(--panel-border);
            padding: 8px 14px; border-radius: 8px; font-size: 12.5px; margin-top: 12px;
            color: var(--text-body);
        }
        .current-file-badge a { color: #0ea5e9; text-decoration: none; font-weight: 600; }
        .current-file-badge a:hover { text-decoration: underline; }

        .live-preview-badge {
            display: none; align-items: center; gap: 6px;
            background: rgba(16, 185, 129, 0.1); border: 1px solid rgba(16, 185, 129, 0.2);
            color: #10b981; padding: 8px 14px; border-radius: 8px; font-size: 12.5px; margin-top: 12px;
        }

        .error-message-node {
            color: #ef4444; font-size: 12px; font-weight: 600;
            margin-top: 8px; display: none; align-items: center; gap: 6px;
        }
        .is-invalid { border-color: #ef4444 !important; }

        @media(max-width: 768px) {
            body { padding: 16px; }
            .glass-panel { padding: 20px; }
            .page-header { flex-direction: column; align-items: stretch; }
            .btn-custom, .btn-theme-toggle { width: 100%; }
            .d-flex { flex-direction: column; width: 100%; gap: 10px !important; }
            .access-toggle-container { flex-direction: row !important; }
        }
    </style>
</head>
<body>

<div class="alert-container">
    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show border-0 shadow-lg lms-autoclose-msg" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i> ${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show border-0 shadow-lg lms-autoclose-msg" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
</div>

<div class="glass-panel page-header">
    <h1 class="page-title">
        <i class="bi bi-pencil-square"></i>
        Edit Book Details
    </h1>
    <div class="d-flex gap-2 flex-wrap justify-content-end">
        <button class="btn-theme-toggle" id="themeToggleBtn" title="Change Visual Context">
            <i class="bi bi-moon-stars" id="themeIcon"></i>
        </button>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-custom btn-home">
            <i class="bi bi-house-door"></i> Back Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/admin/books" class="btn-custom btn-books">
            <i class="bi bi-journal-bookmark"></i> View All Books
        </a>
    </div>
</div>

<div class="glass-panel">
    <form action="${pageContext.request.contextPath}/admin/update-book"
          method="post"
          enctype="multipart/form-data"
          id="matrixUpdateEngine"
          onsubmit="return validateFormPipeline()">

        <input type="hidden" name="id" value="${book.id}">

        <div class="row">
            <div class="col-md-6 mb-4">
                <div class="form-floating">
                    <input type="text" name="bookName" id="bookName" value="${book.bookName}" class="form-control" placeholder="Book Name" required>
                    <label for="bookName"><i class="bi bi-book me-1"></i> Book Title</label>
                </div>
            </div>

            <div class="col-md-6 mb-4">
                <div class="form-floating">
                    <input type="text" name="authorName" id="authorName" value="${book.authorName}" class="form-control" placeholder="Author Name" required>
                    <label for="authorName"><i class="bi bi-person me-1"></i> Author Name</label>
                </div>
            </div>

            <div class="col-md-6 mb-4">
                <div class="access-toggle-container">
                    <div class="access-wrapper-box">
                        <input type="radio" name="accessMatrix" id="accessFree" value="free" ${book.price == 0.0 || empty book.price ? 'checked' : ''} onchange="processAccessMatrixMode()">
                        <label for="accessFree" class="access-label-card">
                            <i class="bi bi-unlock-fill text-success"></i> Open Access (Free)
                        </label>
                    </div>
                    <div class="access-wrapper-box">
                        <input type="radio" name="accessMatrix" id="accessPaid" value="paid" ${book.price > 0.0 ? 'checked' : ''} onchange="processAccessMatrixMode()">
                        <label for="accessPaid" class="access-label-card">
                            <i class="bi bi-gem text-warning"></i> Premium Shelf (Paid)
                        </label>
                    </div>
                </div>
            </div>

            <div class="col-md-6 mb-4">
                <div class="form-floating">
                    <input type="number" secret-metric="price" name="price" id="price" value="${book.price}" class="form-control" placeholder="Price" step="0.01" min="0" required>
                    <label for="price"><i class="bi bi-currency-rupee"></i> Pricing Structure</label>
                </div>
                <div id="priceValidationError" class="error-message-node">
                    <i class="bi bi-exclamation-triangle-fill"></i> Premium tier requires asset pricing matrix valuation greater than zero.
                </div>
            </div>

            <div class="col-md-6 mb-4">
                <div class="form-floating">
                    <input type="text" name="category" id="category" value="${book.category}" class="form-control" placeholder="Category">
                    <label for="category"><i class="bi bi-tags me-1"></i>Book Type</label>
                </div>
            </div>

            <div class="col-md-6 mb-4">
                <div class="form-floating">
                    <input type="text" name="publisher" id="publisher" value="${book.publisher}" class="form-control" placeholder="Publisher">
                    <label for="publisher"><i class="bi bi-building me-1"></i> Publisher Name</label>
                </div>
            </div>

            <div class="col-md-6 mb-4">
                <div class="form-floating">
                    <input type="number" name="publishedYear" id="publishedYear" value="${book.publishedYear}" class="form-control" placeholder="Published Year" min="1900" max="2099" step="1">
                    <label for="publishedYear"><i class="bi bi-calendar-event me-1"></i> Published Year</label>
                </div>
            </div>

            <div class="col-md-6 mb-4">
                <div class="form-floating">
                    <select name="language" id="language" class="form-select" required>
                        <option value="English" ${book.language == 'English' ? 'selected' : ''}>English</option>
                        <option value="Hindi" ${book.language == 'Hindi' ? 'selected' : ''}>Hindi</option>
                    </select>
                    <label for="language"><i class="bi bi-translate me-1"></i> Language </label>
                </div>
            </div>

            <div class="col-md-6 mb-4">
                <div class="form-floating">
                    <input type="number" step="1" name="totalPages" id="totalPages" value="${book.totalPages}" class="form-control" placeholder="Total Pages" min="1" required>
                    <label for="totalPages"><i class="bi bi-book-half me-1"></i> Total Page Count</label>
                </div>
                <div id="pagesError" class="error-message-node">
                    <i class="bi bi-exclamation-triangle-fill"></i> Page count must be greater than zero.
                </div>
            </div>

            <div class="col-md-6 mb-4">
                <div class="form-floating">
                    <input type="number" step="1" id="quantity" name="quantity" value="${book.quantity}" class="form-control" placeholder="Total Stock" min="0" required>
                    <label for="quantity"><i class="bi bi-layers me-1"></i> Total Vol Count</label>
                </div>
                <div id="quantityError" class="error-message-node">
                    <i class="bi bi-exclamation-triangle-fill"></i> Volume count configuration mismatch. Cannot be negative.
                </div>
            </div>

            <div class="col-md-6 mb-4">
                <div class="form-floating">
                    <input type="number" step="1" id="availableQuantity" name="availableQuantity" value="${book.availableQuantity}" class="form-control" placeholder="Available Allocation" min="0" required>
                    <label for="availableQuantity"><i class="bi bi-check2-circle me-1"></i> Available Units</label>
                </div>
                <div id="availableError" class="error-message-node">
                    <i class="bi bi-exclamation-triangle-fill"></i> Allocation fault. Available units cannot transcend total stock assets.
                </div>
            </div>

            <div class="col-12 mb-4">
                <div class="form-floating">
                    <textarea name="description" id="description" class="form-control" placeholder="Write Book Description">${book.description}</textarea>
                    <label for="description"><i class="bi bi-file-text me-1"></i> Book Description / Book Overview</label>
                </div>
            </div>

            <div class="col-md-6 mb-4">
                <div class="file-upload-wrapper">
                    <label class="file-input-label"><i class="bi bi-image me-1"></i> Upload Cover Image only</label>
                    <input type="file" name="imageFile" id="imageFileInput" class="form-control" accept="image/*">

                    <c:if test="${book.bookImage != null}">
                        <div class="current-file-badge" id="currentCoverBadge">
                            <i class="bi bi-file-earmark-image text-info"></i> Image File •
                            <a href="${pageContext.request.contextPath}/files/view/${book.bookImage.id}" target="_blank" rel="noopener">View Image</a>
                        </div>
                    </c:if>
                    <div class="live-preview-badge" id="imageLiveBadge"></div>
                </div>
            </div>

            <div class="col-md-6 mb-4">
                <div class="file-upload-wrapper">
                    <label class="file-input-label"><i class="bi bi-file-pdf me-1"></i> Upload Document (PDF) only</label>
                    <input type="file" name="pdfFile" id="pdfFileInput" class="form-control" accept="application/pdf">

                    <c:if test="${book.bookPdf != null}">
                        <div class="current-file-badge" id="currentPdfBadge">
                            <i class="bi bi-file-earmark-pdf text-danger"></i> Document Pdf •
                            <a href="${pageContext.request.contextPath}/files/download/${book.bookPdf.id}">View PDF</a>
                        </div>
                    </c:if>
                    <div class="live-preview-badge" id="pdfLiveBadge"></div>
                </div>
            </div>
        </div>

        <div class="form-actions d-flex gap-3 mt-3 flex-wrap">
            <button type="submit" class="btn-custom btn-update">
                <i class="bi bi-cloud-arrow-up-fill"></i> Submit Updates
            </button>
            <a href="${pageContext.request.contextPath}/admin/books" class="btn-custom btn-cancel">
                <i class="bi bi-slash-circle"></i> Cancel Update
            </a>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // DYNAMIC ALERT TIMEOUT ROUTINE (5 Second Lifecycle Auto-dismiss Engine)
    document.addEventListener("DOMContentLoaded", function () {
        const structuralAlertNodes = document.querySelectorAll('.lms-autoclose-msg, .alert');
        structuralAlertNodes.forEach(function (alertElement) {
            setTimeout(function () {
                const nativeBsAlertInstance = bootstrap.Alert.getOrCreateInstance(alertElement);
                if (nativeBsAlertInstance) {
                    nativeBsAlertInstance.close();
                }
            }, 5000);
        });
    });

    // System Theme Inversion Synced Pipeline
    const themeToggleBtn = document.getElementById('themeToggleBtn');
    const themeIcon = document.getElementById('themeIcon');
    const rootHtml = document.documentElement;

    function applyVisualTheme(theme) {
        rootHtml.setAttribute('data-theme', theme);
        themeIcon.className = theme === 'light' ? 'bi bi-moon-stars' : 'bi bi-sun-fill';
    }

    const savedTheme = localStorage.getItem('theme') || 'dark';
    applyVisualTheme(savedTheme);

    themeToggleBtn.addEventListener('click', () => {
        const activeThemeState = rootHtml.getAttribute('data-theme');
        const modifiedThemeState = activeThemeState === 'light' ? 'dark' : 'light';

        applyVisualTheme(modifiedThemeState);
        localStorage.setItem('theme', modifiedThemeState);
    });

    // DYNAMIC ACCESS PRICING PIPELINE EXECUTION ENGINE
    function processAccessMatrixMode() {
        const isFree = document.getElementById('accessFree').checked;
        const priceInput = document.getElementById('price');

        if (isFree) {
            priceInput.value = '0';
            priceInput.setAttribute('disabled', 'true');
            document.getElementById("priceValidationError").style.display = "none";
            priceInput.classList.remove("is-invalid");
        } else {
            priceInput.removeAttribute('disabled');
            if (parseFloat(priceInput.value) === 0) {
                priceInput.value = '';
            }
        }
    }

    // Initialize state mapping on page construction
    document.addEventListener("DOMContentLoaded", function() {
        processAccessMatrixMode();
    });

    // File selection badges logic
    document.getElementById('imageFileInput').addEventListener('change', function(e) {
        const badge = document.getElementById('imageLiveBadge');
        if(this.files.length > 0) {
            badge.innerHTML = '<i class="bi bi-arrow-repeat me-1"></i> Staged Matrix Cover: <strong>' + this.files[0].name + '</strong>';
            badge.style.display = 'inline-flex';
            if(document.getElementById('currentCoverBadge')) document.getElementById('currentCoverBadge').style.opacity = '0.4';
        }
    });

    document.getElementById('pdfFileInput').addEventListener('change', function(e) {
        const badge = document.getElementById('pdfLiveBadge');
        if(this.files.length > 0) {
            badge.innerHTML = '<i class="bi bi-file-earmark-check me-1"></i> Staged Byte Document: <strong>' + this.files[0].name + '</strong>';
            badge.style.display = 'inline-flex';
            if(document.getElementById('currentPdfBadge')) document.getElementById('currentPdfBadge').style.opacity = '0.4';
        }
    });

    // Integrity Validation Routing Engine
    function validateFormPipeline(){
        const priceInput = document.getElementById("price");
        const isPaid = document.getElementById('accessPaid').checked;

        let quantity = parseInt(document.getElementById("quantity").value) || 0;
        let availableQuantity = parseInt(document.getElementById("availableQuantity").value) || 0;
        let totalPages = parseInt(document.getElementById("totalPages").value) || 0;
        let priceVal = parseFloat(priceInput.value) || 0;

        let quantityError = document.getElementById("quantityError");
        let availableError = document.getElementById("availableError");
        let pagesError = document.getElementById("pagesError");
        let priceValidationError = document.getElementById("priceValidationError");

        let qInput = document.getElementById("quantity");
        let aInput = document.getElementById("availableQuantity");
        let pInput = document.getElementById("totalPages");

        let stateIntegrityValid = true;

        quantityError.style.display = "none";
        availableError.style.display = "none";
        pagesError.style.display = "none";
        priceValidationError.style.display = "none";

        qInput.classList.remove("is-invalid");
        aInput.classList.remove("is-invalid");
        pInput.classList.remove("is-invalid");
        priceInput.classList.remove("is-invalid");

        if (isPaid && priceVal <= 0) {
            priceValidationError.style.display = "flex";
            priceInput.classList.add("is-invalid");
            stateIntegrityValid = false;
        }

        if(totalPages <= 0){
            pagesError.style.display = "flex";
            pInput.classList.add("is-invalid");
            stateIntegrityValid = false;
        }

        if(quantity < 0){
            quantityError.style.display = "flex";
            qInput.classList.add("is-invalid");
            stateIntegrityValid = false;
        }

        if(availableQuantity < 0 || availableQuantity > quantity){
            availableError.style.display = "flex";
            aInput.classList.add("is-invalid");
            stateIntegrityValid = false;
        }

        if (stateIntegrityValid) {
            priceInput.removeAttribute('disabled');
        }

        return stateIntegrityValid;
    }
</script>
</body>
</html>
