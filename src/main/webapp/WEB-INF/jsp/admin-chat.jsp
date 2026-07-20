<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
    if (session == null || session.getAttribute("loggedInUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en" class="h-full">
<head>
    <script>
        (function() {
            const activeTheme = localStorage.getItem('theme') || 'dark';
            if (activeTheme === 'dark') {
                document.documentElement.classList.add('dark');
            } else {
                document.documentElement.classList.remove('dark');
            }
        })();
    </script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | LMS Matrix Portal</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: {
                        chatbg: {
                            sidebar: '#0b1426',
                            activeUser: '#15213b',
                            centerLight: '#f8fafc',
                            centerDark: '#0f172a',
                            bubbleUser: '#2563eb',
                            bubbleAdmin: '#374151'
                        }
                    }
                }
            }
        }
    </script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
        body { font-family: 'Inter', sans-serif; transition: background-color 0.3s ease, color 0.3s ease; }
        .custom-scrollbar::-webkit-scrollbar { width: 5px; height: 5px; }
        .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: #64748b; border-radius: 10px; }
        .msg-bubble .delete-btn-trigger { opacity: 0; transition: opacity 0.15s ease-in-out; }
        .msg-bubble:hover .delete-btn-trigger { opacity: 1; }

        /* WhatsApp Inspired Premium Wallpaper */
        .premium-wallpaper-dots {
            background-color: #efeae2;
            background-image: radial-gradient(#dfdcd6 1.5px, transparent 1.5px), radial-gradient(#dfdcd6 1.5px, #efeae2 1.5px);
            background-size: 24px 24px;
            background-position: 0 0, 12px 12px;
        }
        .dark .premium-wallpaper-dots {
            background-color: #0b1426;
            background-image: radial-gradient(#152238 1.5px, transparent 1.5px), radial-gradient(#152238 1.5px, #0b1426 1.5px);
            background-size: 24px 24px;
            background-position: 0 0, 12px 12px;
        }

        html:not(.dark) .light-sidebar-bg { background-color: #ffffff !important; border-color: #e2e8f0 !important; color: #0f172a !important; }
        html:not(.dark) .light-header-bg { background-color: #ffffff !important; border-color: #e2e8f0 !important; }
        html:not(.dark) #chatMessageStream { background-color: #efeae2 !important; }
        html:not(.dark) .sidebar-user-item { color: #334155 !important; }
        html:not(.dark) .sidebar-user-item:hover { background-color: #f1f5f9 !important; }
        html:not(.dark) .sidebar-user-item.active-thread { background-color: #e2e8f0 !important; color: #1e40af !important; }
        html:not(.dark) #wsStatusText { color: #047857 !important; }
        html:not(.dark) #workspaceSearchInput { color: #0f172a !important; }
        html:not(.dark) #content { color: #0f172a !important; }

        @media (max-width: 767px) {
            .sidebar-slider { position: fixed; top: 0; bottom: 0; left: 0; transform: translateX(-100%); transition: transform 0.3s ease-in-out; z-index: 50; }
            .sidebar-slider.open { transform: translateX(0); }
        }

        .chat-date-separator { position: relative; text-align: center; margin: 1.5rem 0; display: flex; align-items: center; justify-content: center; width: 100%; }
        .chat-date-separator::before { content: ''; position: absolute; width: 100%; height: 1px; background: currentColor; opacity: 0.15; z-index: 1; }
        .chat-date-text { position: relative; z-index: 2; background: #e2e8f0; color: #475569; padding: 4px 14px; border-radius: 9px; font-size: 10px; font-weight: 700; letter-spacing: 0.05em; }
        .dark .chat-date-text { background: #1e293b; color: #94a3b8; }
        @keyframes messageFlowSlideUp { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body class="bg-slate-100 text-slate-900 dark:bg-slate-950 dark:text-slate-100 h-full overflow-hidden flex flex-col antialiased">
    <div class="flex flex-1 h-full overflow-hidden relative" id="mainLayoutContainer">

        <div id="sidebarBackdrop" onclick="toggleMobileSidebar()" class="hidden fixed inset-0 bg-black/50 z-40 md:hidden animate-fade-in"></div>

        <aside id="leftSidebarContainer" class="sidebar-slider w-80 bg-[#0b1426] text-slate-200 flex flex-col md:flex min-w-[280px] max-w-[450px] select-none flex-shrink-0 border-r border-slate-800 dark:border-slate-800 light-sidebar-bg h-full">
            <div class="p-4 flex items-center justify-between border-b border-slate-800 dark:border-slate-800 flex-shrink-0">
                <div class="flex items-center space-x-3">
                    <div class="bg-blue-600 text-white p-2 rounded-xl shadow-md shadow-blue-900/30"><i class="fa-solid fa-comments text-base"></i></div>
                    <span class="text-lg font-bold tracking-wide truncate text-slate-800 dark:text-white">Admin Panel</span>
                </div>
                <button onclick="toggleMobileSidebar()" class="md:hidden text-slate-500 hover:text-slate-800 dark:hover:text-white p-1">
                    <i class="fa-solid fa-xmark text-lg"></i>
                </button>
            </div>

            <div class="p-3 border-b border-slate-800/60 flex-shrink-0 bg-slate-950/20">
                <div class="relative flex items-center bg-slate-200 dark:bg-slate-900/80 rounded-xl px-3 py-2 border border-slate-300 dark:border-slate-800/60 focus-within:border-blue-500/50 transition-all">
                    <i class="fa-solid fa-magnifying-glass text-xs text-slate-500 mr-2"></i>
                    <input type="text" id="workspaceSearchInput" oninput="executeLiveMessageSearch(this)" placeholder="Search message text..." class="w-full bg-transparent text-xs text-slate-900 dark:text-white outline-none placeholder-slate-500 font-medium">
                </div>
            </div>

            <div class="px-4 py-2 bg-slate-200/50 dark:bg-slate-900/40 border-b border-slate-300 dark:border-slate-800/60 flex items-center justify-between text-[10px] flex-shrink-0">
                <span class="text-slate-500 dark:text-slate-400 font-semibold tracking-wider uppercase">Network Status:</span>
                <span id="wsStatusBadge" class="flex items-center space-x-1.5 text-red-500 font-semibold">
                    <span class="w-1.5 h-1.5 rounded-full bg-red-500 animate-pulse inline-block"></span>
                    <span id="wsStatusText" class="dark:text-red-400">Disconnected</span>
                </span>
            </div>

            <div id="activeUsersSidebarStream" class="flex-1 overflow-y-auto custom-scrollbar p-3 space-y-2">
                <div class="text-[10px] text-slate-500 dark:text-slate-400 uppercase tracking-widest font-bold px-1 mb-2">Active Student Streams</div>
                <c:forEach var="student" items="${chatUsers != null ? chatUsers : complaints}">
                    <c:set var="resolvedId" value="${student.id != null ? student.id : (student.senderId != null ? student.senderId : student.recipientId)}" />
                    <c:set var="resolvedName" value="${student.fullName != null ? student.fullName : (student.senderRole == 'USER' ? student.fullName : student.recipientName)}" />
                    <c:set var="resolvedRoll" value="${student.rollNumber != null ? student.rollNumber : 'N/A'}" />

                    <c:if test="${not empty resolvedId && not empty resolvedName}">
                        <div id="sidebar-user-card-${resolvedId}" data-student-id="${resolvedId}" onclick="selectActiveUserThread('${resolvedId}', '${fn:escapeXml(resolvedName)}', '${fn:escapeXml(resolvedRoll)}')" class="sidebar-user-item flex items-center space-x-3 p-3 hover:bg-slate-200 dark:hover:bg-slate-800/40 text-slate-700 dark:text-slate-300 rounded-xl cursor-pointer transition-all border border-transparent relative select-none">
                            <div class="relative flex-shrink-0">
                                <div class="w-10 h-10 rounded-full bg-blue-600/20 text-blue-600 dark:text-blue-400 flex items-center justify-center font-bold text-sm border border-blue-500/20">
                                    <c:out value="${fn:substring(resolvedName, 0, 1)}" />
                                </div>
                                <span id="sidebar-status-dot-${resolvedId}" class="w-2.5 h-2.5 bg-slate-400 rounded-full absolute bottom-0 right-0 border-2 border-[#0b1426] block"></span>
                            </div>
                            <div class="flex-1 min-w-0">
                                <p class="text-xs font-bold truncate text-slate-900 dark:text-slate-200"><c:out value="${resolvedName}" /></p>
                                <p class="text-[10px] text-slate-500 dark:text-slate-400 truncate mt-0.5 font-mono font-semibold">Roll No: <c:out value="${resolvedRoll}" /></p>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>

            <div class="p-4 border-t border-slate-300 dark:border-slate-800/80 bg-slate-200/50 dark:bg-slate-900/60 flex-shrink-0">
                <a href="${pageContext.request.contextPath}/admin/logout" class="flex items-center justify-center space-x-2 w-full py-2.5 px-4 rounded-xl bg-red-500 hover:bg-red-600 text-white font-bold text-xs shadow-md transition-all duration-200">
                    <i class="fa-solid fa-box-arrow-right text-sm"></i>
                    <span>Logout Account</span>
                </a>
            </div>
        </aside>

        <section class="flex-1 flex flex-col h-full relative min-w-[320px] overflow-hidden bg-white text-slate-900 dark:bg-slate-950 dark:text-slate-100">

            <header class="h-16 border-b border-slate-200 dark:border-slate-800/80 bg-slate-50 dark:bg-slate-800 flex items-center justify-between px-4 md:px-6 shadow-sm z-10 flex-shrink-0 select-none light-header-bg">
                <div class="flex items-center space-x-3">
                    <button onclick="toggleMobileSidebar()" class="md:hidden text-slate-600 dark:text-slate-300 hover:text-blue-600 p-1 mr-1">
                        <i class="fa-solid fa-bars text-lg"></i>
                    </button>
                    <span id="activeHeaderPresenceDot" class="w-2.5 h-2.5 bg-slate-400 rounded-full"></span>
                    <div>
                        <h3 id="mainWorkspaceChatTitle" class="font-bold text-sm text-slate-800 dark:text-slate-200 tracking-wide">Admin Workspace</h3>
                        <p id="liveConnectedIdentityState" class="text-[10px] text-slate-500 dark:text-slate-400 flex items-center font-semibold"><span id="statePulseNode" class="w-1.5 h-1.5 bg-slate-400 mr-1.5 rounded-full inline-block"></span>Offline</p>
                    </div>
                </div>

                <div class="flex items-center space-x-2">
                    <button id="themeToggleBtn" type="button" onclick="toggleSystemTheme()" class="p-2 rounded-lg bg-slate-200 dark:bg-slate-700 hover:bg-slate-300 dark:hover:bg-slate-600 text-slate-700 dark:text-slate-300 outline-none transition-all">
                        <i id="themeIcon" class="fa-solid fa-sun dark:fa-moon text-sm"></i>
                    </button>

                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="flex items-center space-x-1.5 p-2 px-3 rounded-lg bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold shadow-sm transition-all duration-200">
                        <i class="fa-solid fa-chart-pie"></i>
                        <span>Dashboard</span>
                    </a>
                </div>
            </header>

            <div id="chatMessageStream" class="flex-1 p-4 md:p-6 overflow-y-auto space-y-4 custom-scrollbar flex flex-col premium-wallpaper-dots relative">
                <div id="emptyWorkspaceStateCard" class="my-auto mx-auto text-center max-w-xs p-6 bg-white dark:bg-slate-800/40 rounded-2xl border border-slate-200 dark:border-slate-700 shadow-sm select-none">
                    <h4 class="text-xs font-bold text-slate-700 dark:text-slate-300">No Student Selected</h4>
                    <p class="text-[11px] text-slate-400 dark:text-slate-500 mt-1.5">Select a student user thread context from the left side panel directory map stream to load conversations.</p>
                </div>
            </div>

            <div id="typingIndicatorElement" class="hidden px-6 py-2 bg-transparent text-slate-400 dark:text-slate-500 text-[10px] italic font-medium absolute bottom-20 left-0 z-20 flex items-center space-x-1 animate-pulse">
                <i class="fa-solid fa-pen-nib animate-bounce text-xs mr-1 text-blue-500"></i> Student typing...
            </div>

            <footer class="p-4 bg-white dark:bg-slate-800 border-t border-slate-200 dark:border-slate-800/80 z-10 flex-shrink-0 select-none">
                <form id="complaintForm" onsubmit="dispatchLiveChat(event)" class="flex items-center space-x-2 md:space-x-3 bg-slate-100 dark:bg-slate-900 rounded-xl px-3 md:px-4 py-2 border border-slate-200 dark:border-slate-700/80">
                    <input type="hidden" id="sessionAdminId" value="${sessionScope.loggedInUser.id}">
                    <input type="file" id="imageFileInput" accept="image/*" class="hidden" onchange="processAttachmentAsyncUpload(event, 'IMAGE')">
                    <input type="file" id="pdfFileInput" accept="application/pdf" class="hidden" onchange="processAttachmentAsyncUpload(event, 'PDF')">

                    <input type="text" id="content" disabled oninput="broadcastTypingNotificationStream()" placeholder="Select a student thread to start chatting..." autocomplete="off" class="flex-1 bg-transparent py-2 text-xs text-slate-900 dark:text-slate-100 outline-none placeholder-slate-500 dark:placeholder-slate-400 font-medium opacity-50 select-text">
                    <button type="button" onclick="document.getElementById('imageFileInput').click()" class="text-slate-500 hover:text-blue-600 dark:text-slate-400 dark:hover:text-slate-200 p-1 md:p-2 transition-colors"><i class="fa-regular fa-image text-base md:text-lg"></i></button>
                    <button type="button" onclick="document.getElementById('pdfFileInput').click()" class="text-slate-500 hover:text-green-500 dark:text-slate-400 dark:hover:text-slate-200 p-1 md:p-2 transition-colors"><i class="fa-regular fa-file-pdf text-base md:text-lg"></i></button>
                    <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white p-2 md:p-2.5 rounded-xl transition-colors shadow-sm"><i class="fa-solid fa-paper-plane text-xs"></i></button>
                </form>
            </footer>
        </section>
    </div>

    <script>
        const appGlobalRoot = "${pageContext.request.contextPath}";
        const currentAdminId = document.getElementById("sessionAdminId").value;
        const messageInput = document.getElementById("content");
        let stompClient = null;
        let typingTimeoutTracker = null;
        let selectedTargetUserId = "self-hud";
        let internalLastTrackedDateString = "";
        let globalActiveStudentsList = {};

        function toggleMobileSidebar() {
            const sidebar = document.getElementById('leftSidebarContainer');
            const backdrop = document.getElementById('sidebarBackdrop');
            if(sidebar.classList.contains('open')) {
                sidebar.classList.remove('open');
                backdrop.classList.add('hidden');
            } else {
                sidebar.classList.add('open');
                backdrop.classList.remove('hidden');
            }
        }

        function toggleSystemTheme() {
            const isDark = document.documentElement.classList.toggle('dark');
            localStorage.setItem('theme', isDark ? 'dark' : 'light');
        }

        function deduplicateStudentChannels() {
            const registrySet = new Set();
            document.querySelectorAll('#activeUsersSidebarStream .sidebar-user-item').forEach(card => {
                const sId = card.getAttribute('data-student-id');
                if (!sId || registrySet.has(sId)) {
                    card.remove();
                } else {
                    registrySet.add(sId);
                }
            });
        }

        function executeLiveMessageSearch(inputElement) {
            const filterKeyword = inputElement.value.toLowerCase().trim();
            document.querySelectorAll('#chatMessageStream .msg-bubble').forEach(bubble => {
                const p = bubble.querySelector('p, span, a');
                if(p) bubble.style.display = p.textContent.toLowerCase().includes(filterKeyword) ? "flex" : "none";
            });
        }

        function parseTimestampSafely(timestampField) {
            if (!timestampField) return new Date();
            if (Array.isArray(timestampField)) return new Date(timestampField[0], timestampField[1] - 1, timestampField[2], timestampField[3] || 0, timestampField[4] || 0, timestampField[5] || 0);
            return new Date(timestampField.toString().replace(" ", "T"));
        }

        function computeDateSeparatorBadgeLabel(timestampField) {
            let d = parseTimestampSafely(timestampField);
            if (isNaN(d.getTime())) return "";
            const today = new Date(); const yesterday = new Date(); yesterday.setDate(today.getDate() - 1);
            if (d.toDateString() === today.toDateString()) return "TODAY";
            if (d.toDateString() === yesterday.toDateString()) return "YESTERDAY";
            return d.toLocaleDateString([], { day: 'numeric', month: 'short', year: 'numeric' });
        }

        function formatClientTime(timestampField) {
            let date = parseTimestampSafely(timestampField);
            if(isNaN(date.getTime())) return "";
            let hours = date.getHours(), minutes = date.getMinutes(); const ampm = hours >= 12 ? 'PM' : 'AM';
            hours = hours % 12; hours = hours ? hours : 12; minutes = minutes < 10 ? '0' + minutes : minutes;
            return hours + ':' + minutes + ' ' + ampm;
        }

        if (typeof SockJS !== 'undefined' && typeof Stomp !== 'undefined') {
            const socket = new SockJS(appGlobalRoot + '/ws-chat');
            stompClient = Stomp.over(socket); stompClient.debug = null;
            stompClient.connect({}, function () {
                const badge = document.getElementById("wsStatusBadge");
                badge.className = "flex items-center space-x-1.5 text-emerald-600 dark:text-emerald-500 font-semibold";
                document.getElementById("wsStatusText").textContent = "Online";

                stompClient.send("/app/chat.sendMessage", {}, JSON.stringify({
                    id: null, content: "ONLINE", senderId: parseInt(currentAdminId),
                    recipientId: null, senderRole: "ADMIN", messageType: "PRESENCE"
                }));

                stompClient.subscribe('/topic/public', function (res) {
                    const dto = JSON.parse(res.body);

                    if(dto.messageType === "PRESENCE") {
                        if(dto.senderRole === "USER" || dto.senderRole === "STUDENT") {
                            globalActiveStudentsList[String(dto.senderId)] = dto.content;
                            updateStudentUIOnlineStatus(String(dto.senderId), dto.content);
                        }
                        return;
                    }

                    if(dto.messageType === "TYPING" && (dto.senderRole === "USER" || dto.senderRole === "STUDENT") && String(dto.senderId) == String(selectedTargetUserId)) {
                        showLiveTypingAnimation();
                        return;
                    }
                    if(dto.messageType !== "CHAT") return;

                    if (selectedTargetUserId !== "self-hud") {
                        const isCurrentActiveThreadMessage =
                            (String(dto.senderId) == String(selectedTargetUserId) && String(dto.recipientId) == String(currentAdminId)) ||
                            (String(dto.senderId) == String(currentAdminId) && String(dto.recipientId) == String(selectedTargetUserId));

                        if (isCurrentActiveThreadMessage) {
                            if (dto.senderRole === 'USER' || dto.senderRole === 'STUDENT') {
                                renderMessageBubble(dto, true);
                            } else {
                                const trackingTimeId = Array.isArray(dto.timestamp) ? dto.timestamp.join("-") : new Date(dto.timestamp).getTime();
                                const tempNode = document.getElementById("msg-node-temp-" + trackingTimeId) || document.querySelector("[id^='msg-node-temp-']");
                                if (tempNode) {
                                    tempNode.id = "msg-node-" + dto.id;
                                    const statusTick = tempNode.querySelector('.whatsapp-tick-status');
                                    if(statusTick) statusTick.innerHTML = '<i class="fa-solid fa-check-double text-[10px] text-blue-400"></i>';
                                    const delBtn = tempNode.querySelector('.delete-btn-trigger');
                                    if(delBtn) delBtn.setAttribute("onclick", "triggerMessagePurge('" + dto.id + "')");
                                } else if (!document.getElementById("msg-node-" + dto.id)) {
                                    renderMessageBubble(dto, false);
                                }
                            }
                        } else {
                            injectBackgroundBadgeAlert(dto.senderId);
                        }
                    }
                });

                stompClient.subscribe('/topic/chat.delete', function (res) {
                    const deletedId = res.body.replace(/"/g, "").trim();
                    const targetNode = document.getElementById("msg-node-" + deletedId);
                    if (targetNode) {
                        targetNode.classList.add('opacity-0', 'scale-95');
                        setTimeout(() => {
                            targetNode.remove();
                            const stream = document.getElementById("chatMessageStream");
                            if (stream && stream.querySelectorAll('.msg-bubble').length === 0) {
                                stream.innerHTML = '<div class="flex-1 flex items-center justify-center text-slate-500 italic text-xs">Pipeline empty. Start secure streaming.</div>';
                            }
                        }, 250);
                    }
                });
            });
        }

        function updateStudentUIOnlineStatus(studentId, status) {
            const dot = document.getElementById("sidebar-status-dot-" + studentId);
            if(dot) {
                if(status === "ONLINE") {
                    dot.className = "w-2.5 h-2.5 bg-emerald-500 rounded-full absolute bottom-0 right-0 border-2 border-[#0b1426] block";
                } else {
                    dot.className = "w-2.5 h-2.5 bg-slate-400 rounded-full absolute bottom-0 right-0 border-2 border-[#0b1426] block";
                }
            }

            if(String(selectedTargetUserId) == String(studentId)) {
                const headerDot = document.getElementById("activeHeaderPresenceDot");
                const stateText = document.getElementById("liveConnectedIdentityState");
                if(status === "ONLINE") {
                    if(headerDot) headerDot.className = "w-2.5 h-2.5 bg-emerald-500 rounded-full animate-pulse";
                    if(stateText) {
                        stateText.innerHTML = '<span class="w-1.5 h-1.5 bg-emerald-500 mr-1.5 rounded-full inline-block animate-pulse"></span>Online';
                        stateText.className = "text-[10px] text-emerald-500 font-semibold tracking-wide flex items-center";
                    }
                } else {
                    if(headerDot) headerDot.className = "w-2.5 h-2.5 bg-slate-400 rounded-full";
                    if(stateText) {
                        stateText.innerHTML = '<span class="w-1.5 h-1.5 bg-slate-400 mr-1.5 rounded-full inline-block"></span>Offline';
                        stateText.className = "text-[10px] text-slate-400 font-semibold tracking-wide flex items-center";
                    }
                }
            }
        }

        function injectBackgroundBadgeAlert(studentId) {
            const userCard = document.getElementById("sidebar-user-card-" + studentId);
            if (userCard) {
                let dot = userCard.querySelector(".sidebar-notification-dot");
                if (!dot) {
                    dot = document.createElement("span");
                    dot.className = "sidebar-notification-dot w-2.5 h-2.5 bg-red-500 rounded-full absolute right-4 top-1/2 -translate-y-1/2 animate-pulse shadow-md";
                    userCard.appendChild(dot);
                }
            }
        }

        function showLiveTypingAnimation() {
            const ti = document.getElementById('typingIndicatorElement'); ti.classList.remove('hidden');
            clearTimeout(typingTimeoutTracker); typingTimeoutTracker = setTimeout(() => ti.classList.add('hidden'), 2000);
        }

        function selectActiveUserThread(userId, profileDisplayName, rollNumber) {
            selectedTargetUserId = String(userId);
            internalLastTrackedDateString = "";

            messageInput.removeAttribute("disabled");
            messageInput.placeholder = "Type your response here...";
            messageInput.classList.remove("opacity-50");

            document.querySelectorAll('#activeUsersSidebarStream .sidebar-user-item').forEach(el => {
                el.classList.remove('bg-[#15213b]', 'text-white', 'border-l-4', 'border-blue-500', 'active-thread');
            });
            const card = document.getElementById("sidebar-user-card-" + userId);
            if(card) {
                card.classList.add('bg-[#15213b]', 'text-white', 'border-l-4', 'border-blue-500', 'active-thread');
                const existingBadge = card.querySelector(".sidebar-notification-dot");
                if(existingBadge) existingBadge.remove();
            }

            document.getElementById("mainWorkspaceChatTitle").textContent = profileDisplayName;

            if (stompClient && stompClient.connected) {
                stompClient.send("/app/chat.sendMessage", {}, JSON.stringify({
                    id: null, content: "ONLINE", senderId: parseInt(currentAdminId),
                    recipientId: parseInt(userId), senderRole: "ADMIN", messageType: "PRESENCE"
                }));
            }

            const status = globalActiveStudentsList[String(userId)] || "OFFLINE";
            updateStudentUIOnlineStatus(userId, status);

            if (window.innerWidth < 768) { toggleMobileSidebar(); }

            const stream = document.getElementById("chatMessageStream"); stream.innerHTML = "";
            fetch(appGlobalRoot + "/admin/chat/api/history/" + userId + "?adminId=" + currentAdminId)
            .then(res => res.json()).then(historyArrayData => {
                const emptyCard = document.getElementById('emptyWorkspaceStateCard'); if(emptyCard) emptyCard.remove();
                if(Array.isArray(historyArrayData) && historyArrayData.length > 0) {
                    historyArrayData.forEach(msgDto => renderMessageBubble(msgDto, (msgDto.senderRole === 'USER' || msgDto.senderRole === 'STUDENT')));
                } else {
                    stream.innerHTML = '<div class="flex-1 flex items-center justify-center text-slate-500 italic text-xs">Pipeline empty. Start secure streaming.</div>';
                }
            });
        }

        function dispatchLiveChat(event, forcedPayload = null) {
            if(event) event.preventDefault();
            if(selectedTargetUserId === "self-hud") return;

            let txt = forcedPayload ? forcedPayload : messageInput.value.trim(); if (txt === "") return;
            const currentTimeISO = new Date().toISOString();

            const chatPayload = {
                id: null, content: txt, senderId: parseInt(currentAdminId),
                recipientId: parseInt(selectedTargetUserId), senderRole: "ADMIN",
                messageType: "CHAT", timestamp: currentTimeISO
            };

            if (stompClient && stompClient.connected) {
                const localTrackId = "temp-" + new Date(currentTimeISO).getTime();
                renderMessageBubble(chatPayload, false, localTrackId);
                stompClient.send("/app/chat.sendMessage", {}, JSON.stringify(chatPayload));
                if(!forcedPayload) messageInput.value = "";
            }
        }

        function processAttachmentAsyncUpload(event, fileTypeCheck) {
            const file = event.target.files[0]; if (!file) return;
            const originalFileName = file.name;
            const fd = new FormData(); fd.append("file", file);

            fetch(appGlobalRoot + '/admin/chat/api/upload', { method: 'POST', body: fd })
            .then(res => res.text()).then(url => {
                if(url && url.trim() !== "") {
                    if (fileTypeCheck === 'PDF') {
                        dispatchLiveChat(null, '[pdf_payload:' + originalFileName + ']:' + url.trim());
                    } else {
                        dispatchLiveChat(null, '[img_payload]:' + url.trim());
                    }
                }
            });
        }

        function triggerMessagePurge(id) {
            if (String(id).startsWith("temp-")) {
                document.getElementById("msg-node-" + id)?.remove();
                return;
            }
            const targetNode = document.getElementById("msg-node-" + id);
            if (targetNode) targetNode.classList.add('opacity-50', 'pointer-events-none');

            fetch(appGlobalRoot + '/admin/chat/api/delete/' + id, { method: 'DELETE' })
            .then(res => {
                if(res.ok) {
                    if (targetNode) {
                        targetNode.classList.add('opacity-0', 'scale-95');
                        setTimeout(() => targetNode.remove(), 200);
                    }
                } else {
                    if (targetNode) targetNode.classList.remove('opacity-50', 'pointer-events-none');
                }
            });
        }

        function broadcastTypingNotificationStream() {
            if (stompClient && stompClient.connected && selectedTargetUserId !== "self-hud") {
                stompClient.send("/app/chat.typing", {}, JSON.stringify({
                    id: null, content: "typing", senderId: parseInt(currentAdminId),
                    recipientId: parseInt(selectedTargetUserId), senderRole: "ADMIN", messageType: "TYPING"
                }));
            }
        }

        function renderMessageBubble(dto, isStudentSender, targetedNodeCustomId = null) {
            if (dto.messageType && dto.messageType !== "CHAT") return;

            const stream = document.getElementById("chatMessageStream");
            if(!stream || (dto.id && document.getElementById("msg-node-" + dto.id))) return;

            let computedCurrentDateLabel = computeDateSeparatorBadgeLabel(dto.timestamp);
            if (computedCurrentDateLabel !== "" && computedCurrentDateLabel !== internalLastTrackedDateString) {
                internalLastTrackedDateString = computedCurrentDateLabel;
                const separator = document.createElement("div"); separator.className = "chat-date-separator";
                separator.innerHTML = '<span class="chat-date-text shadow-sm">' + computedCurrentDateLabel + '</span>';
                stream.appendChild(separator);
            }

            const row = document.createElement("div");
            const finalNodeIdentifier = targetedNodeCustomId ? targetedNodeCustomId : ("temp-" + new Date().getTime());
            row.id = dto.id ? "msg-node-" + dto.id : "msg-node-" + finalNodeIdentifier;
            row.className = "msg-bubble flex items-end space-x-2 max-w-[85%] md:max-w-[70%] " + (!isStudentSender ? 'ml-auto flex-row-reverse space-x-reverse' : '');
            row.style.animation = "messageFlowSlideUp 0.25s cubic-bezier(0.16, 1, 0.3, 1) forwards";

            const contentLower = dto.content.toLowerCase();
            const isImg = contentLower.includes('[img_payload]:') || contentLower.endsWith('.jpg') || contentLower.endsWith('.png') || contentLower.endsWith('.jpeg') || contentLower.endsWith('.webp');
            const isPdf = contentLower.includes('[pdf_payload:') || contentLower.endsWith('.pdf');

            let bodyHtml = "";
            if (isImg) {
                let cleanPath = dto.content.replace(/\[img_payload\]:/i, "").trim();
                let imgUrl = cleanPath.startsWith("/") ? (appGlobalRoot + cleanPath) : (appGlobalRoot + "/" + cleanPath);
                bodyHtml = '<div class="relative max-w-xs overflow-hidden rounded-2xl border border-slate-200 dark:border-slate-800 bg-gray-200 dark:bg-slate-800"><img src="' + imgUrl + '" class="w-full h-auto max-h-64 object-cover cursor-pointer block" onclick="window.open(this.src)"></div>';
            } else if (isPdf) {
                let displayFileName = "View Attached Document.pdf";
                let cleanPath = dto.content;
                if(dto.content.includes('[pdf_payload:') && dto.content.includes(']:')) {
                    const matchData = dto.content.match(/\[pdf_payload:(.*?)\]:/i);
                    if(matchData && matchData[1]) displayFileName = matchData[1];
                    cleanPath = dto.content.substring(dto.content.indexOf(']:') + 2).trim();
                } else {
                    cleanPath = dto.content.replace(/\[pdf_payload\]:/i, "").trim();
                }
                let pdfUrl = cleanPath.startsWith("/") ? (appGlobalRoot + cleanPath) : (appGlobalRoot + "/" + cleanPath);

                /* Green WhatsApp style PDF Card layout */
                bodyHtml = '<a href="' + pdfUrl + '" target="_blank" class="flex items-center space-x-3 p-3 bg-emerald-500/10 border border-emerald-500/30 text-emerald-600 dark:text-emerald-400 rounded-2xl text-xs font-semibold shadow-sm hover:bg-emerald-500/25 transition-all"><i class="fa-solid fa-file-pdf text-xl flex-shrink-0 text-emerald-500"></i><span class="truncate max-w-[180px] md:max-w-[240px] block text-slate-800 dark:text-slate-200">' + displayFileName + '</span></a>';
            } else {
                bodyHtml = '<p class="leading-relaxed whitespace-pre-wrap select-text break-words max-w-full">' + dto.content.replace(/</g, "&lt;").replace(/>/g, "&gt;") + '</p>';
            }

            let styleClass = (isImg || isPdf) ? "p-0 bg-transparent shadow-none" : (!isStudentSender ? "p-3 rounded-2xl text-xs bg-blue-600 text-white rounded-br-none shadow-md shadow-blue-700/10" : "p-3 rounded-2xl text-xs bg-white text-slate-800 border border-slate-200 dark:bg-slate-800 dark:border-slate-700/80 dark:text-slate-200 rounded-bl-none shadow-sm");

            let tickHtml = !isStudentSender ? (dto.id ? '<span class="whatsapp-tick-status ml-1"><i class="fa-solid fa-check-double text-[10px] text-blue-400"></i></span>' : '<span class="whatsapp-tick-status ml-1"><i class="fa-solid fa-check text-[10px] text-slate-300"></i></span>') : '';

            row.innerHTML = '<div class="w-6 h-6 rounded-full bg-slate-600 text-white flex items-center justify-center text-[9px] font-bold flex-shrink-0 shadow-sm">' + (isStudentSender ? 'U' : 'A') + '</div>' +
                '<div class="flex flex-col ' + (!isStudentSender ? 'items-end' : 'items-start') + ' group relative max-w-full">' +
                    '<div class="' + styleClass + ' break-words max-w-full">' + bodyHtml + '</div>' +
                    '<div class="flex items-center space-x-2 mt-1 px-1 text-[9px] text-slate-400 dark:text-slate-500"><span>' + formatClientTime(dto.timestamp) + '</span>' + tickHtml + '<button onclick="triggerMessagePurge(\'' + (dto.id ? dto.id : finalNodeIdentifier) + '\')" class="delete-btn-trigger text-red-500 hover:text-red-600 outline-none transition-colors"><i class="fa-solid fa-trash-can text-[10px]"></i></button></div>' +
                '</div>';

            stream.appendChild(row); stream.scrollTop = stream.scrollHeight;
        }

        window.onload = function() {
            deduplicateStudentChannels();
            const stream = document.getElementById("chatMessageStream"); if(stream) stream.scrollTop = stream.scrollHeight;
        };

        window.onbeforeunload = function() {
            if(stompClient && stompClient.connected) {
                stompClient.send("/app/chat.sendMessage", {}, JSON.stringify({
                    id: null, content: "OFFLINE", senderId: parseInt(currentAdminId),
                    recipientId: null, senderRole: "ADMIN", messageType: "PRESENCE"
                }));
            }
        };
    </script>
</body>
</html>
