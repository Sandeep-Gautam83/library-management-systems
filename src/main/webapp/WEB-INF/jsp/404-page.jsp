<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en" class="h-full w-full">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${not empty errorCode ? errorCode : '404'}" /> Error | Page</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Google Fonts (Ubuntu/Inter Blend for EXACT typography look) -->
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Ubuntu:wght@700&family=Inter:wght@400;500&display=swap');
        .font-error-heading { font-family: 'Ubuntu', sans-serif; color: #4e45c3; }
        .font-error-body { font-family: 'Inter', sans-serif; color: #515ba9; }
        .bg-exact-canvas { background-color: #e5f6ff; }
        .bg-exact-btn { background-color: #1dc5d8; }
        .bg-exact-btn:hover { background-color: #17b0c2; }

        /* Subtle animation to match vector quality */
        @keyframes floatEffect {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-8px); }
        }
        .vector-floating { animation: floatEffect 6s ease-in-out infinite; }
    </style>
</head>
<body class="bg-exact-canvas min-h-screen w-full flex flex-col items-center justify-center p-4 md:p-8 antialiased overflow-x-hidden">

    <div class="w-full max-w-5xl mx-auto grid grid-cols-1 lg:grid-cols-12 gap-8 items-center justify-center">

        <!-- LEFT CONTENT BLOCK: DYNAMIC TEXT & ACTION BUTTON -->
        <div class="lg:col-span-5 flex flex-col items-center lg:items-start text-center lg:text-left space-y-6 md:space-y-8 px-4 order-2 lg:order-1">
            <div class="space-y-1">
                <!-- Dynamically prints 404, 500, or 403 based on controller data -->
                <h1 class="text-6xl md:text-[85px] font-bold font-error-heading tracking-tight leading-none">
                    <c:out value="${not empty errorCode ? errorCode : '404'}" />
                </h1>
                <h2 class="text-5xl md:text-[70px] font-bold font-error-heading tracking-tight leading-none">error</h2>
            </div>

            <!-- Dynamically changes the message descriptive text -->
            <p class="font-error-body text-base md:text-xl font-normal leading-relaxed max-w-sm md:max-w-md">
                <c:out value="${not empty errorMessage ? errorMessage : 'The page you are looking for was moved, removed, renamed or might never existed.'}" />
            </p>

            <a href="${pageContext.request.contextPath}/" class="bg-exact-btn text-white font-bold text-xs md:text-sm tracking-widest uppercase px-8 py-3.5 shadow-md transition-all duration-200 transform active:scale-95 inline-block rounded-none">
                Go to Homepage
            </a>
        </div>

        <!-- RIGHT CONTENT BLOCK: NATIVE VECTOR ILLUSTRATION COMPOSITION -->
        <div class="lg:col-span-7 w-full flex flex-col items-center justify-center order-1 lg:order-2 select-none vector-floating">
            <div class="relative w-full max-w-[480px] sm:max-w-[550px] aspect-[5/4] flex items-center justify-center">

                <svg viewBox="0 0 500 400" xmlns="http://www.w3.org/2000/svg" class="w-full h-full drop-shadow-sm">
                    <!-- Background Soft Abstract Wave Shapes -->
                    <path d="M 120,260 C 90,200 180,120 280,100 C 380,80 450,140 430,220 C 410,300 320,310 240,300 C 160,290 150,320 120,260 Z" fill="#bce4ff" opacity="0.75" />
                    <path d="M 160,280 C 190,220 270,140 350,150 C 430,160 460,240 410,290 C 360,340 240,320 160,280 Z" fill="#9cd6ff" opacity="0.4" />

                    <!-- Water Reflection Puddles on Floor -->
                    <ellipse cx="280" cy="330" rx="100" ry="12" fill="#b4e4ff" />
                    <ellipse cx="320" cy="345" rx="60" ry="8" fill="#a5ddff" />
                    <ellipse cx="210" cy="335" rx="45" ry="6" fill="#b4e4ff" />

                    <!-- Vector White Clouds Background -->
                    <!-- Cloud Left -->
                    <path d="M 90,170 A 20,20 0 0,1 120,150 A 25,25 0 0,1 160,155 A 15,15 0 0,1 175,170 L 90,170 Z" fill="#ffffff" opacity="0.9" />
                    <!-- Cloud Right -->
                    <path d="M 330,185 A 25,25 0 0,1 370,160 A 30,30 0 0,1 420,165 A 20,20 0 0,1 440,185 L 330,185 Z" fill="#ffffff" opacity="0.9" />

                    <!-- Flag Element inside the '0' -->
                    <path d="M 324,220 L 305,275" stroke="#48435c" stroke-width="4" stroke-linecap="round" />
                    <path d="M 324,218 C 330,215 335,230 342,225 C 348,220 350,245 342,248 C 335,250 330,235 324,238 Z" fill="#8862cf" />

                    <!-- Giant 3D '4 0 4' White Numbers -->
                    <!-- First 4 -->
                    <g transform="translate(20, 0)">
                        <!-- Side 3D extrusion shadows -->
                        <path d="M 230,195 L 242,190 L 242,260 L 230,268 Z" fill="#8cb9ff" />
                        <path d="M 195,268 L 242,268 L 242,260 L 195,260 Z" fill="#7ba8f0" />
                        <path d="M 195,268 L 195,310 L 225,310 L 225,268 Z" fill="#8cb9ff" />
                        <!-- Front Face -->
                        <path d="M 230,195 L 180,260 L 230,260 L 230,310 L 242,310 L 242,190 Z" fill="#ffffff" />
                        <path d="M 205,250 L 230,215 L 230,250 Z" fill="#e2f1ff" />
                    </g>

                    <!-- Middle 0 -->
                    <g transform="translate(15, 0)">
                        <!-- 3D extrusion shadows -->
                        <ellipse cx="310" cy="275" rx="36" ry="46" fill="#8cb9ff" />
                        <ellipse cx="310" cy="275" rx="16" ry="26" fill="#e5f6ff" />
                        <!-- Front Face -->
                        <ellipse cx="304" cy="270" rx="36" ry="46" fill="#ffffff" />
                        <ellipse cx="304" cy="270" rx="15" ry="25" fill="#a2d4ff" />
                    </g>

                    <!-- Last 4 -->
                    <g transform="translate(0, 0)">
                        <!-- Side 3D extrusion shadows -->
                        <path d="M 405,200 L 415,195 L 415,265 L 405,273 Z" fill="#8cb9ff" />
                        <path d="M 370,273 L 415,273 L 415,265 L 370,265 Z" fill="#7ba8f0" />
                        <!-- Front Face -->
                        <path d="M 405,200 L 355,265 L 405,265 L 405,315 L 415,315 L 415,195 Z" fill="#ffffff" />
                        <path d="M 380,255 L 405,220 L 405,255 Z" fill="#e2f1ff" />
                    </g>

                    <!-- CHARACTER ARTWORK (Man Searching via Telescope) -->
                    <!-- Legs standing on the first 4 -->
                    <path d="M 252,192 C 248,225 246,245 256,262" stroke="#1ad2ad" stroke-width="15" stroke-linecap="round" fill="none" /> <!-- Left Leg -->
                    <path d="M 270,158 C 285,180 288,210 286,245" stroke="#1ad2ad" stroke-width="15" stroke-linecap="round" fill="none" /> <!-- Right Leg -->
                    <!-- Shoes -->
                    <ellipse cx="250" cy="265" rx="10" ry="6" fill="#0d1f3d" />
                    <ellipse cx="288" cy="248" rx="10" ry="6" fill="#0d1f3d" />

                    <!-- Torso / Purple Clothes Shirt -->
                    <path d="M 265,110 C 255,120 258,160 270,165 C 285,165 292,145 290,110 Z" fill="#785fd6" />

                    <!-- Telescope held up to eye -->
                    <path d="M 278,92 L 225,97" stroke="#b0df68" stroke-width="8" stroke-linecap="round" />
                    <path d="M 240,95 L 223,96.5" stroke="#1cc2d4" stroke-width="10" stroke-linecap="round" />

                    <!-- Arms holding Telescope -->
                    <path d="M 285,115 C 270,110 260,100 252,105" stroke="#785fd6" stroke-width="10" stroke-linecap="round" fill="none" />
                    <path d="M 275,130 C 250,120 245,100 236,108" stroke="#785fd6" stroke-width="8" stroke-linecap="round" fill="none" />

                    <!-- Head & Face Configuration -->
                    <circle cx="282" cy="95" r="10" fill="#ffc38c" /> <!-- Face -->
                    <path d="M 286,88 C 292,90 292,102 286,104 Z" fill="#090d16" /> <!-- Hair -->
                </svg>

            </div>
        </div>
    </div>

    <!-- SUB-FOOTER ATTRIBUTION TRADEMARK MARKER -->
    <div class="w-full text-center text-xs font-medium font-error-body opacity-60 pt-12 select-none">
    </div>
</body>
</html>
