<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lms.dto.UserDto" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
    UserDto loggedInUserDto = (UserDto) session.getAttribute("loggedInUser");
    if (loggedInUserDto == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en" class="h-full w-full">
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Student Chat Dashboard</title>
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
        .custom-scrollbar::-webkit-scrollbar { width: 6px; height: 6px; }
        .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: #94a3b8; border-radius: 10px; }
        .dark .custom-scrollbar::-webkit-scrollbar-thumb { background: #334155; }
        .msg-bubble .delete-btn-trigger { opacity: 0; transition: opacity 0.15s ease-in-out; }
        .msg-bubble:hover .delete-btn-trigger { opacity: 1; }

        .ai-msg-node-wrapper { position: relative; }
        .ai-msg-delete-btn, .ai-msg-stop-btn { opacity: 0; transition: opacity 0.2s ease; }
        .ai-msg-node-wrapper:hover .ai-msg-delete-btn, .ai-msg-node-wrapper:hover .ai-msg-stop-btn { opacity: 1; }

        .premium-wallpaper-dots {
            background-color: #f1f5f9;
            background-image: radial-gradient(#cbd5e1 1.5px, transparent 1.5px), radial-gradient(#cbd5e1 1.5px, #f1f5f9 1.5px);
            background-size: 24px 24px;
            background-position: 0 0, 12px 12px;
        }
        .dark .premium-wallpaper-dots {
            background-color: #090d16;
            background-image: radial-gradient(#1e293b 1.5px, transparent 1.5px), radial-gradient(#1e293b 1.5px, #090d16 1.5px);
            background-size: 24px 24px;
            background-position: 0 0, 12px 12px;
        }

        html:not(.dark) .light-sidebar-bg { background-color: #ffffff !important; border-color: #e2e8f0 !important; color: #0f172a !important; }
        html:not(.dark) .light-header-bg { background-color: #ffffff !important; border-color: #e2e8f0 !important; }
        html:not(.dark) #chatMessageStream { background-color: #f8fafc !important; }
        html:not(.dark) #workspaceSearchInput { color: #0f172a !important; }
        html:not(.dark) #content { color: #0f172a !important; }
        html:not(.dark) .student-name-text { color: #0f172a !important; }
        html:not(.dark) .student-roll-text { color: #475569 !important; }

        @media (max-width: 1023px) {
            .sidebar-slider { position: fixed; top: 0; bottom: 0; left: 0; transform: translateX(-100%); transition: transform 0.3s ease-in-out; z-index: 50; }
            .sidebar-slider.open { transform: translateX(0); }
        }

        .chat-date-separator { position: relative; text-align: center; margin: 2rem 0; display: flex; align-items: center; justify-content: center; width: 100%; }
        .chat-date-separator::before { content: ''; position: absolute; width: 100%; height: 1px; background: currentColor; opacity: 0.12; z-index: 1; }
        .chat-date-text { position: relative; z-index: 2; background: #e2e8f0; color: #475569; padding: 6px 16px; border-radius: 20px; font-size: 11px; font-weight: 600; letter-spacing: 0.05em; box-shadow: 0 2px 4px rgba(0,0,0,0.02); }
        .dark .chat-date-text { background: #1e293b; color: #94a3b8; }
        @keyframes messageFlowSlideUp { from { opacity: 0; transform: translateY(12px); } to { opacity: 1; transform: translateY(0); } }

        .ai-drawer-panel {
            position: fixed;
            top: 16px;
            right: -850px;
            height: calc(100vh - 32px);
            z-index: 100;
            transition: right 0.4s cubic-bezier(0.16, 1, 0.3, 1), width 0.1s linear;
        }
        .ai-drawer-panel.open-panel {
            right: 16px;
        }

        .ai-resize-handler {
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 6px;
            cursor: ew-resize;
            background: transparent;
            transition: background 0.2s;
            z-index: 110;
        }
        .ai-resize-handler:hover, .ai-resize-handler.active-dragging {
            background: rgba(99, 102, 241, 0.4);
            box-shadow: 0 0 8px rgba(99, 102, 241, 0.6);
        }

        @media (max-width: 768px) {
            .ai-drawer-panel {
                top: 0;
                right: -100%;
                width: 100% !important;
                height: 100vh;
                border-radius: 0px !important;
            }
            .ai-drawer-panel.open-panel {
                right: 0;
            }
            .ai-resize-handler { display: none !important; }
        }
    </style>
</head>
<body class="bg-slate-50 text-slate-900 dark:bg-[#090d16] dark:text-slate-100 h-screen w-screen overflow-hidden flex flex-col antialiased relative">

    <div class="flex flex-1 h-full w-full overflow-hidden relative" id="mainLayoutContainer">

        <div id="sidebarBackdrop" onclick="toggleMobileSidebar()" class="hidden fixed inset-0 bg-slate-950/40 dark:bg-black/60 z-40 lg:hidden backdrop-blur-sm"></div>

        <aside id="leftSidebar" class="sidebar-slider w-80 bg-[#0b1426] text-slate-200 flex flex-col lg:flex min-w-[290px] max-w-[340px] select-none flex-shrink-0 z-40 border-r border-slate-200 dark:border-slate-800/80 light-sidebar-bg h-full">
            <div class="p-5 flex items-center justify-between border-b border-slate-200 dark:border-slate-800/60 flex-shrink-0">
                <div class="flex items-center space-x-3">
                    <div class="bg-blue-600 text-white p-2.5 rounded-xl shadow-md shadow-blue-600/20"><i class="fa-solid fa-comments text-base"></i></div>
                    <span class="text-base font-bold tracking-wide truncate text-slate-800 dark:text-white">Student Portal</span>
                </div>
                <button onclick="toggleMobileSidebar()" class="lg:hidden text-slate-400 hover:text-slate-600 dark:hover:text-white p-2 rounded-lg transition-colors">
                    <i class="fa-solid fa-xmark text-xl"></i>
                </button>
            </div>

            <div class="p-4 border-b border-slate-200 dark:border-slate-800/40 flex-shrink-0 bg-slate-50/50 dark:bg-slate-950/20">
                <div class="relative flex items-center bg-slate-100 dark:bg-slate-900/80 rounded-xl px-3.5 py-2.5 border border-slate-200 dark:border-slate-800/60 focus-within:border-blue-500 focus-within:ring-1 focus-within:ring-blue-500/30 transition-all">
                    <i class="fa-solid fa-magnifying-glass text-sm text-slate-400 mr-2.5"></i>
                    <input type="text" id="workspaceSearchInput" oninput="executeLiveMessageSearch(this)" placeholder="Search messages..." class="w-full bg-transparent text-sm text-slate-800 dark:text-white outline-none placeholder-slate-400 font-medium">
                </div>
            </div>

            <div class="px-5 py-2.5 bg-slate-100 dark:bg-slate-900/40 border-b border-slate-200 dark:border-slate-800/60 flex items-center justify-between text-xs flex-shrink-0">
                <span class="text-slate-400 dark:text-slate-400 font-semibold tracking-wider uppercase">Connection</span>
                <span id="wsStatusBadge" class="flex items-center space-x-1.5 text-red-500 font-semibold">
                    <span class="w-2 h-2 rounded-full bg-red-500 animate-pulse inline-block"></span>
                    <span id="wsStatusText" class="dark:text-red-400">Disconnected</span>
                </span>
            </div>

            <div class="flex-1 overflow-y-auto custom-scrollbar p-4 space-y-4">
                <div class="text-xs text-slate-400 dark:text-slate-400 uppercase tracking-widest font-bold px-1">Active User Profile</div>
                <div class="flex items-center space-x-3 p-3.5 bg-slate-50 dark:bg-[#15213b] text-slate-800 dark:text-white rounded-xl border border-slate-200 dark:border-slate-700/50 border-l-4 border-l-2563eb shadow-sm">
                    <div class="w-11 h-11 rounded-full bg-blue-600/10 text-blue-600 dark:text-blue-400 flex items-center justify-center font-bold text-base border border-blue-500/20 shadow-inner flex-shrink-0">
                        <c:choose>
                            <c:when test="${not empty sessionScope.loggedInUser.fullName}">
                                <c:out value="${fn:substring(sessionScope.loggedInUser.fullName, 0, 1)}" />
                            </c:when>
                            <c:otherwise>S</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="flex-1 min-w-0">
                        <p class="text-sm font-bold truncate student-name-text text-slate-900 dark:text-white"><c:out value="${not empty sessionScope.loggedInUser.fullName ? sessionScope.loggedInUser.fullName : 'Student User'}" /></p>
                        <p class="text-xs student-roll-text text-slate-500 dark:text-slate-300 truncate font-mono mt-0.5 font-medium">Roll No: <c:out value="${not empty sessionScope.loggedInUser.rollNumber ? sessionScope.loggedInUser.rollNumber : 'N/A'}"/></p>
                    </div>
                </div>
            </div>

            <div class="p-4 border-t border-slate-200 dark:border-slate-800/80 bg-slate-50 dark:bg-slate-950/40 flex-shrink-0">
                <a href="${pageContext.request.contextPath}/logout" class="flex items-center justify-center space-x-2 w-full py-3 px-4 bg-gradient-to-r from-red-500 to-rose-600 hover:from-red-600 hover:to-rose-700 text-white rounded-xl font-bold text-sm tracking-wide shadow-md hover:shadow-lg transition-all duration-200 transform hover:-translate-y-0.5">
                    <i class="fa-solid fa-sign-out-alt text-sm"></i>
                    <span>Logout Session</span>
                </a>
            </div>
        </aside>

        <section class="flex-1 flex flex-col h-full min-w-0 overflow-hidden bg-white text-slate-900 dark:bg-[#0f172a] dark:text-slate-100 relative">

            <header class="h-20 border-b border-slate-200 dark:border-slate-800/80 bg-slate-50/80 dark:bg-slate-900/80 backdrop-blur-md flex items-center justify-between px-4 md:px-6 shadow-sm z-10 flex-shrink-0 select-none light-header-bg">
                <div class="flex items-center space-x-3 min-w-0">
                    <button onclick="toggleMobileSidebar()" class="lg:hidden text-slate-500 dark:text-slate-300 hover:text-blue-600 p-2 rounded-lg mr-1 flex-shrink-0 transition-colors">
                        <i class="fa-solid fa-bars text-xl"></i>
                    </button>
                    <div class="truncate flex items-center space-x-3">
                        <span id="activeHeaderPresenceDot" class="w-3 h-3 bg-slate-400 rounded-full border-2 border-white dark:border-slate-900"></span>
                        <div>
                            <h3 class="font-bold text-sm md:text-base text-slate-800 dark:text-slate-200 tracking-wide truncate">Student Chat Dashboard</h3>
                            <p id="liveConnectedIdentityState" class="text-xs text-slate-400 dark:text-slate-400 flex items-center font-medium mt-0.5">
                                Offline
                            </p>
                        </div>
                    </div>
                </div>

                <div class="flex items-center space-x-3 flex-shrink-0">
                    <a href="${pageContext.request.contextPath}/student/dashboard" class="flex items-center space-x-2 py-2.5 px-4 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-sm font-semibold shadow-sm transition-all">
                        <i class="fa-solid fa-gauge-high text-xs"></i>
                        <span class="hidden sm:inline">Dashboard</span>
                    </a>

                    <button id="openAiAssistantBtn" type="button" onclick="toggleAiAssistantDrawer(true)" class="w-11 h-11 rounded-xl bg-gradient-to-br from-indigo-600 to-blue-600 hover:from-indigo-500 hover:to-blue-500 flex items-center justify-center text-white shadow-md hover:shadow-indigo-500/20 transition-all transform hover:scale-105 outline-none">
                        <i class="fa-solid fa-robot text-lg animate-pulse"></i>
                    </button>

                    <button id="themeToggleBtn" type="button" onclick="toggleSystemTheme()" class="p-2.5 rounded-xl bg-slate-200/80 dark:bg-slate-800 hover:bg-slate-300 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300 outline-none transition-all shadow-sm w-11 h-11 flex items-center justify-center">
                        <i id="themeIcon" class="fa-solid fa-moon dark:fa-sun text-sm"></i>
                    </button>
                </div>
            </header>

            <div id="chatMessageStream" class="flex-1 p-4 md:p-6 overflow-y-auto space-y-5 custom-scrollbar flex flex-col premium-wallpaper-dots relative">
                <c:choose>
                    <c:when test="${empty complaints}">
                        <div id="emptyWorkspaceStateCard" class="my-auto mx-auto text-center max-w-sm p-8 bg-white dark:bg-slate-900/60 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-md select-none backdrop-blur-md">
                            <div class="w-14 h-14 rounded-2xl bg-blue-50 dark:bg-blue-950/40 flex items-center justify-center mx-auto mb-4 text-blue-500 border border-blue-100 dark:border-blue-900/30"><i class="fa-solid fa-shield-halved text-2xl"></i></div>
                            <h4 class="text-sm font-bold text-slate-800 dark:text-slate-200">No Chat History Available</h4>
                            <p class="text-xs text-slate-400 dark:text-slate-400 mt-2 leading-relaxed">Type your query in the workspace layout box below to build a dynamic sync connection channel directly with active administrative support lines.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="comp" items="${complaints}">
                            <c:if test="${not comp.deletedByUser && (empty comp.messageType || comp.messageType == 'CHAT')}">
                                <c:set var="contentLower" value="${fn:toLowerCase(comp.content)}" />
                                <c:set var="isImg" value="${fn:contains(contentLower,'[img_payload]:') or fn:endsWith(contentLower,'.jpg') or fn:endsWith(contentLower,'.png') or fn:endsWith(contentLower,'.jpeg') or fn:endsWith(contentLower,'.webp')}" />
                                <c:set var="isPdf" value="${fn:contains(contentLower,'[pdf_payload:') or fn:contains(contentLower,'[pdf_payload]') or fn:contains(contentLower,'/pdfs/') or fn:endsWith(contentLower,'.pdf')}" />
                                <c:set var="isMessageFromAdmin" value="${fn:toUpperCase(comp.senderRole) == 'ADMIN'}" />

                                <div id="msg-node-${comp.id}" class="msg-bubble flex items-end space-x-2.5 max-w-[85%] md:max-w-[70%] ${(isMessageFromAdmin) ? '' : 'ml-auto flex-row-reverse space-x-reverse'}" data-message-epoch="${comp.timestamp}">
                                    <div class="w-7 h-7 rounded-full bg-slate-500 dark:bg-slate-700 text-white flex items-center justify-center text-[10px] font-bold select-none flex-shrink-0 shadow-sm">
                                        <c:out value="${(isMessageFromAdmin) ? 'A' : 'U'}" />
                                    </div>
                                    <div class="flex flex-col ${(isMessageFromAdmin) ? 'items-start' : 'items-end'} group relative max-w-full">
                                        <div class="${(isImg || isPdf) ? 'p-0 bg-transparent shadow-none' : ((isMessageFromAdmin) ? 'p-3.5 rounded-2xl text-sm bg-white text-slate-800 border border-slate-200 dark:bg-slate-800 dark:border-slate-700/80 dark:text-slate-200 rounded-bl-none shadow-sm font-medium' : 'p-3.5 rounded-2xl text-sm bg-blue-600 text-white rounded-br-none shadow-md shadow-blue-600/10 font-medium')}">
                                            <c:choose>
                                                <c:when test="${isImg}">
                                                    <c:set var="rawPath" value="${comp.content}" />
                                                    <c:if test="${fn:startsWith(fn:toLowerCase(rawPath),'[img_payload]:')}"><c:set var="rawPath" value="${fn:substring(rawPath, 14, fn:length(rawPath))}" /></c:if>
                                                    <div class="relative max-w-xs overflow-hidden rounded-2xl shadow-md border border-slate-200 dark:border-slate-800 bg-slate-200 dark:bg-slate-800">
                                                        <img src="${pageContext.request.contextPath}${rawPath}" class="w-full h-auto max-h-64 object-cover cursor-pointer block hover:scale-[1.01] transition-transform" alt="Shared Image" onclick="window.open(this.src)">
                                                    </div>
                                                </c:when>
                                                <c:when test="${isPdf}">
                                                    <c:set var="pdfMetadata" value="${comp.content}" />
                                                    <c:choose>
                                                        <c:when test="${fn:contains(pdfMetadata, ']:')}">
                                                            <c:set var="pdfParts" value="${fn:split(pdfMetadata, ']:')}" />
                                                            <c:set var="resolvedPdfUrl" value="${pdfParts[1]}" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:set var="resolvedPdfUrl" value="${fn:replace(pdfMetadata, '[pdf_payload]:', '')}" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <c:set var="resolvedPdfUrl" value="${fn:trim(resolvedPdfUrl)}" />
                                                    <c:if test="${!fn:contains(resolvedPdfUrl, '/uploads/')}">
                                                        <c:set var="resolvedPdfUrl" value="/uploads/pdfs/${resolvedPdfUrl}" />
                                                    </c:if>

                                                    <a href="${pageContext.request.contextPath}${resolvedPdfUrl}" target="_blank" class="flex items-center space-x-3 p-3.5 bg-emerald-500/10 border border-emerald-500/30 text-emerald-600 dark:text-emerald-400 rounded-2xl text-sm font-semibold shadow-sm hover:bg-emerald-500/25 transition-all">
                                                        <i class="fa-solid fa-file-pdf text-2xl flex-shrink-0 text-emerald-500"></i>
                                                        <span class="truncate max-w-[180px] md:max-w-[240px] block text-slate-800 dark:text-slate-200">
                                                            <c:choose>
                                                                <c:when test="${fn:contains(comp.content, '[pdf_payload:')}">
                                                                    <c:out value="${fn:substringBefore(fn:substringAfter(comp.content, '[pdf_payload:'), ']:')}" />
                                                                </c:when>
                                                                <c:otherwise>Document.pdf</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="leading-relaxed whitespace-pre-wrap select-text break-words max-w-full"><c:out value="${comp.content}"/></p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="flex items-center space-x-2.5 mt-1.5 px-1 text-xs text-slate-400 dark:text-slate-500 font-medium select-none">
                                            <span class="chat-timestamp-field" data-raw-time="${comp.timestamp}"></span>
                                            <c:if test="${!isMessageFromAdmin}">
                                                <span class="whatsapp-tick-status"><i class="fa-solid fa-check-double text-xs text-blue-400"></i></span>
                                            </c:if>
                                            <button onclick="triggerMessagePurge('${comp.id}')" class="delete-btn-trigger text-red-400 hover:text-red-500 outline-none transition-colors ml-1"><i class="fa-solid fa-trash-can text-xs"></i></button>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <div id="typingIndicatorElement" class="hidden px-6 py-3 bg-white/80 dark:bg-slate-900/80 backdrop-blur-sm text-slate-400 dark:text-slate-400 text-xs italic font-semibold absolute bottom-24 left-4 rounded-xl shadow-sm z-20 flex items-center space-x-1.5 select-none border border-slate-200 dark:border-slate-800/80">
                <i class="fa-solid fa-pen-nib animate-bounce text-xs text-blue-500"></i> Admin typing...
            </div>

            <footer class="p-4 bg-slate-50 dark:bg-slate-900 border-t border-slate-200 dark:border-slate-800/80 z-10 flex-shrink-0 select-none">
                <form id="complaintForm" onsubmit="dispatchLiveChat(event)" class="flex items-center space-x-2 md:space-x-3 bg-white dark:bg-slate-800 rounded-xl px-4 py-2.5 border border-slate-200 dark:border-slate-700/80 shadow-inner">
                    <input type="hidden" id="sessionUserId" value="${sessionScope.loggedInUser.id}">
                    <input type="hidden" id="detectedRecipientId" value="0">

                    <input type="file" id="imageFileInput" accept="image/*" class="hidden" onchange="processAttachmentAsyncUpload(event, 'IMAGE')">
                    <input type="file" id="pdfFileInput" accept="application/pdf" class="hidden" onchange="processAttachmentAsyncUpload(event, 'PDF')">

                    <input type="text" id="content" oninput="broadcastTypingNotificationStream()" placeholder="Type a message here..." autocomplete="off" class="flex-1 bg-transparent py-1.5 text-sm text-slate-800 dark:text-slate-100 outline-none placeholder-slate-400 font-medium select-text">

                    <button type="button" onclick="document.getElementById('imageFileInput').click()" class="text-slate-400 hover:text-blue-600 dark:text-slate-400 dark:hover:text-slate-300 p-2 flex-shrink-0 transition-colors outline-none"><i class="fa-regular fa-image text-xl"></i></button>
                    <button type="button" onclick="document.getElementById('pdfFileInput').click()" class="text-slate-400 hover:text-red-500 dark:text-slate-400 dark:hover:text-slate-300 p-2 flex-shrink-0 transition-colors outline-none"><i class="fa-regular fa-file-pdf text-xl"></i></button>
                    <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white p-3 rounded-xl flex-shrink-0 transition-colors shadow-sm outline-none transform active:scale-95"><i class="fa-solid fa-paper-plane text-sm"></i></button>
                </form>
            </footer>
        </section>
    </div>

    <!-- Premium Resizable Offscreen AI Assistant Drawer Component -->
    <div id="aiAssistantDrawer" style="width: 440px;" class="ai-drawer-panel bg-gradient-to-br from-[#0b0f19] to-[#111827] border border-slate-800 sm:rounded-2xl shadow-2xl flex flex-col overflow-hidden font-sans">

        <div id="aiPanelResizeHandler" class="ai-resize-handler"></div>

        <!-- Scroll Navigation Buttons -->
        <div class="absolute right-4 top-24 flex flex-col space-y-2 z-50 select-none">
            <button type="button" onclick="scrollAiAssistantTo('top')" title="Scroll to Top" class="w-8 h-8 rounded-full bg-slate-800/80 hover:bg-indigo-600 border border-slate-700 text-white flex items-center justify-center transition-all shadow-md outline-none">
                <i class="fa-solid fa-arrow-up text-xs"></i>
            </button>
            <button type="button" onclick="scrollAiAssistantTo('bottom')" title="Scroll to Bottom" class="w-8 h-8 rounded-full bg-slate-800/80 hover:bg-indigo-600 border border-slate-700 text-white flex items-center justify-center transition-all shadow-md outline-none">
                <i class="fa-solid fa-arrow-down text-xs"></i>
            </button>
        </div>

        <div class="px-5 py-4.5 bg-[#111827]/90 border-b border-slate-800/80 flex items-center justify-between flex-shrink-0 select-none">
            <div class="flex items-center space-x-2.5 text-white">
                <i class="fa-solid fa-robot text-indigo-500 text-base"></i>
                <span class="font-bold text-sm md:text-base tracking-wide">AI Assistant</span>
                <span class="bg-indigo-600/20 text-indigo-400 border border-indigo-500/30 text-[10px] font-bold px-2 py-0.5 rounded-md uppercase tracking-wider">Live</span>
            </div>
            <button onclick="toggleAiAssistantDrawer(false)" class="text-slate-400 hover:text-rose-400 text-sm transition-colors outline-none p-1.5">
                <i class="fa-solid fa-xmark text-lg"></i>
            </button>
        </div>

        <div id="aiScrollArea" class="flex-1 p-5 overflow-y-auto custom-scrollbar flex flex-col space-y-4 relative">

            <div id="aiWelcomePanel" class="flex flex-col space-y-4">
                <div class="text-center py-4 select-none">
                    <div class="w-14 h-14 rounded-full bg-indigo-600/10 border border-indigo-500/20 flex items-center justify-center mx-auto mb-3 shadow-inner">
                        <i class="fa-solid fa-face-smile-beam text-2xl text-indigo-400"></i>
                    </div>
                    <h3 class="text-white font-bold text-base tracking-wide">Interactive Matrix AI Core</h3>
                    <p class="text-slate-400 text-xs mt-1.5 leading-relaxed px-4 font-medium">I'm initialized to instantly scan systemic catalogs, evaluate outstanding fee schedules, and process active library tracking histories via live RAG frameworks.</p>
                </div>

                <div class="grid grid-cols-2 gap-3.5">
                    <button type="button" onclick="populateAiPromptBox('Check my active books issue status')" class="bg-slate-900/60 border border-slate-800/80 rounded-xl p-3.5 text-left hover:bg-slate-800/50 hover:border-slate-700 transition-all outline-none group">
                        <span class="text-white font-bold text-xs flex items-center group-hover:text-indigo-400 transition-colors"><i class="fa-solid fa-graduation-cap text-emerald-400 mr-2 text-sm"></i>Study Help</span>
                        <p class="text-xs text-slate-400 mt-1.5 leading-snug font-medium">Verify live tracking logs</p>
                    </button>
                    <button type="button" onclick="populateAiPromptBox('Check my current outstanding fine amount')" class="bg-slate-900/60 border border-slate-800/80 rounded-xl p-3.5 text-left hover:bg-slate-800/50 hover:border-slate-700 transition-all outline-none group">
                        <span class="text-white font-bold text-xs flex items-center group-hover:text-indigo-400 transition-colors"><i class="fa-solid fa-calculator text-red-400 mr-2 text-sm"></i>Academic Info</span>
                        <p class="text-xs text-slate-400 mt-1.5 leading-snug font-medium">Fines & accounts ledger</p>
                    </button>
                    <button type="button" onclick="populateAiPromptBox('Search for available Java Programming books')" class="bg-slate-900/60 border border-slate-800/80 rounded-xl p-3.5 text-left hover:bg-slate-800/50 hover:border-slate-700 transition-all outline-none group">
                        <span class="text-white font-bold text-xs flex items-center group-hover:text-indigo-400 transition-colors"><i class="fa-solid fa-magnifying-glass text-blue-400 mr-2 text-sm"></i>Catalog Search</span>
                        <p class="text-xs text-slate-400 mt-1.5 leading-snug font-medium">Query backend libraries</p>
                    </button>
                    <button type="button" onclick="populateAiPromptBox('Recommend popular technical resources')" class="bg-slate-900/60 border border-slate-800/80 rounded-xl p-3.5 text-left hover:bg-slate-800/50 hover:border-slate-700 transition-all outline-none group">
                        <span class="text-white font-bold text-xs flex items-center group-hover:text-indigo-400 transition-colors"><i class="fa-solid fa-file-invoice text-purple-400 mr-2 text-sm"></i>Resources</span>
                        <p class="text-xs text-slate-400 mt-1.5 leading-snug font-medium">Locate structural stacks</p>
                    </button>
                </div>

                <div class="flex flex-col space-y-2.5 pt-2">
                    <label class="text-xs text-slate-500 font-bold tracking-wider uppercase px-0.5 select-none">Quick Suggestions</label>
                    <button type="button" onclick="populateAiPromptBox('What is the maximum number of books a student can borrow?')" class="w-full text-left bg-indigo-600/10 border border-indigo-500/20 text-indigo-300 hover:bg-indigo-600/20 text-xs px-4 py-3 rounded-xl font-semibold transition-all outline-none truncate">
                        What is the maximum number of books a student can borrow?
                    </button>
                    <button type="button" onclick="populateAiPromptBox('How can I request a book renewal online?')" class="w-full text-left bg-indigo-600/10 border border-indigo-500/20 text-indigo-300 hover:bg-indigo-600/20 text-xs px-4 py-3 rounded-xl font-semibold transition-all outline-none truncate">
                        How can I request a book renewal online?
                    </button>
                </div>
            </div>

            <div id="aiChatStream" class="hidden flex flex-col space-y-4 pt-2"></div>
        </div>

        <div class="px-4 py-4 bg-[#111827] border-t border-slate-800/80 flex flex-col space-y-2 flex-shrink-0 select-none">
            <div class="flex items-center space-x-2 bg-slate-900 border border-slate-800 rounded-xl px-4 py-2 focus-within:border-indigo-500/60 transition-all shadow-inner">
                <input type="text" id="aiInputField" onkeypress="handleAiInputEnterKey(event)" placeholder="Ask the portal AI assistant..." autocomplete="off" class="flex-1 bg-transparent py-2 text-sm text-white outline-none placeholder-slate-500 font-medium select-text">
                <button type="button" onclick="submitAiQueryRequest()" class="w-9 h-9 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white flex items-center justify-center transition-colors shadow-sm outline-none transform active:scale-95">
                    <i class="fa-solid fa-paper-plane text-xs"></i>
                </button>
            </div>
            <div class="text-center text-[11px] text-slate-500 font-medium pt-0.5">AI ChatBot Library Management System @2026</div>
        </div>
    </div>

    <script>
        const appGlobalRoot = "${pageContext.request.contextPath}";
        const currentUserId = document.getElementById("sessionUserId").value;
        const messageInput = document.getElementById("content");
        let stompClient = null;
        let typingTimeoutTracker = null;
        let internalLastTrackedDateString = "";

        let activeAiAbortController = null;

        let fallbackAdminId = parseInt(localStorage.getItem('tracked_admin_id_' + currentUserId)) || 0;
        document.getElementById("detectedRecipientId").value = fallbackAdminId;

        function parseMarkdownToHtmlText(rawText) {
            if (!rawText) return "";

            if (rawText.trim().startsWith("<div") || rawText.trim().startsWith("<i ") || rawText.trim().startsWith("<span ")) {
                return rawText;
            }

            let cleanedText = rawText.replace(/\n{3,}/g, '\n\n').trim();

            let escaped = cleanedText
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt bridge;");

            escaped = escaped.replace(/^###\s+(.*?)$/gm, '<h3 class="text-sm font-bold text-indigo-400 mt-3 mb-1">$1</h3>');
            escaped = escaped.replace(/^##\s+(.*?)$/gm, '<h2 class="text-sm font-bold text-indigo-300 mt-4 mb-1.5">$1</h2>');
            escaped = escaped.replace(/\*\*(.*?)\*\*/g, '<strong class="text-white font-semibold">$1</strong>');
            escaped = escaped.replace(/^\s*[-*]\s+(.*?)$/gm, '<div class="flex items-start my-1 pl-1"><span class="text-indigo-400 mr-2 font-bold select-none">•</span><span class="flex-1 text-slate-300 font-medium leading-relaxed">$1</span></div>');
            escaped = escaped.replace(/\n/g, '<br>');
            escaped = escaped.replace(/(<br>){2,}/g, '<br>');

            return escaped;
        }

        (function initializeResizablePanel() {
            const drawer = document.getElementById("aiAssistantDrawer");
            const handler = document.getElementById("aiPanelResizeHandler");
            if (!drawer || !handler) return;

            let isDraggingActive = false;

            handler.addEventListener("mousedown", (e) => {
                isDraggingActive = true;
                handler.classList.add("active-dragging");
                document.body.style.userSelect = "none";
                document.body.style.cursor = "ew-resize";
            });

            document.addEventListener("mousemove", (e) => {
                if (!isDraggingActive) return;
                let absoluteWidthCalculated = window.innerWidth - e.clientX - 16;
                if (absoluteWidthCalculated >= 320 && absoluteWidthCalculated <= 850) {
                    drawer.style.width = absoluteWidthCalculated + "px";
                }
            });

            document.addEventListener("mouseup", () => {
                if (isDraggingActive) {
                    isDraggingActive = false;
                    handler.classList.remove("active-dragging");
                    document.body.style.userSelect = "";
                    document.body.style.cursor = "";
                }
            });
        })();

        function toggleAiAssistantDrawer(displayState) {
            const drawer = document.getElementById('aiAssistantDrawer');
            if(displayState) {
                drawer.classList.add('open-panel');
                syncAiAssistantHistoryLogs();
            } else {
                drawer.classList.remove('open-panel');
            }
        }

        function populateAiPromptBox(promptText) {
            const input = document.getElementById('aiInputField');
            if(input) {
                input.value = promptText;
                input.focus();
            }
        }

        function handleAiInputEnterKey(event) {
            if(event.key === 'Enter') {
                submitAiQueryRequest();
            }
        }

        function scrollAiAssistantTo(direction) {
            const container = document.getElementById('aiScrollArea');
            if (!container) return;
            if (direction === 'top') {
                container.scrollTo({ top: 0, behavior: 'smooth' });
            } else if (direction === 'bottom') {
                container.scrollTo({ top: container.scrollHeight, behavior: 'smooth' });
            }
        }

        // FIXED: लोड करते समय यह चेक करेगा कि मैसेज आईडी लोकल ब्लैकलिस्ट में तो नहीं है
        function syncAiAssistantHistoryLogs() {
            fetch(appGlobalRoot + '/api/chatbot/history')
            .then(res => res.json())
            .then(data => {
                const stream = document.getElementById('aiChatStream');
                if(data && data.length > 0) {
                    stream.classList.remove('hidden');
                    stream.innerHTML = '';

                    // LocalStorage से डिलीट की गई आईडी की सूची निकालें
                    const deletedIds = JSON.parse(localStorage.getItem('ai_deleted_msg_ids_' + currentUserId) || '[]');

                    data.forEach((item, index) => {
                        // प्रत्येक मैसेज जोड़े को एक यूनिक वर्चुअल आईडी असाइन करें
                        const qId = 'ai-msg-q-' + index;
                        const aId = 'ai-msg-a-' + index;

                        if (!deletedIds.includes(qId)) {
                            appendAiBubbleNode(item.question, true, qId);
                        }
                        if (!deletedIds.includes(aId)) {
                            appendAiBubbleNode(item.answer, false, aId);
                        }
                    });
                    scrollAiContainerBottom();
                }
            }).catch(e => console.error("Error updating AI records context:", e));
        }

        function submitAiQueryRequest() {
            const field = document.getElementById('aiInputField');
            const questionText = field.value.trim();
            if(!questionText) return;

            const stream = document.getElementById('aiChatStream');
            stream.classList.remove('hidden');

            const userUniqueId = 'ai-msg-q-live-' + Date.now();
            appendAiBubbleNode(questionText, true, userUniqueId);
            field.value = '';
            scrollAiContainerBottom();

            const dynamicTrackerId = 'ai-pulse-id-' + Date.now();
            appendAiBubbleNode('<i class="fa-solid fa-circle-notch fa-spin mr-2 text-indigo-400"></i> please wait...', false, dynamicTrackerId, true);
            scrollAiContainerBottom();

            activeAiAbortController = new AbortController();

            fetch(appGlobalRoot + '/api/chatbot/ask', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ question: questionText }),
                signal: activeAiAbortController.signal
            })
            .then(res => res.json())
            .then(data => {
                const node = document.getElementById(dynamicTrackerId);
                if(node) {
                    var cleanId = 'ai-msg-a-live-' + Date.now();
                    node.id = cleanId;

                    var contentSpan = node.querySelector('.ai-msg-content');
                    if(contentSpan) contentSpan.innerHTML = parseMarkdownToHtmlText(data.answer);

                    var btnWrapper = node.querySelector('.ai-action-btn-placeholder');
                    if(btnWrapper) {
                        btnWrapper.innerHTML = '<button onclick="deleteAiMessageBubble(this)" class="ai-msg-delete-btn mx-2 text-slate-500 hover:text-red-400 transition-colors duration-150 outline-none" title="Delete message"><i class="fa-solid fa-trash-can text-xs"></i></button>';
                    }
                }
                activeAiAbortController = null;
                scrollAiContainerBottom();
            })
            .catch(err => {
                if (err.name === 'AbortError') return;
                const node = document.getElementById(dynamicTrackerId);
                if(node) {
                    var contentSpan = node.querySelector('.ai-msg-content');
                    if(contentSpan) contentSpan.innerHTML = "<span class='text-rose-400'><i class='fa-solid fa-triangle-exclamation mr-1.5'></i> Network connection error. Try again.</span>";
                    var btnWrapper = node.querySelector('.ai-action-btn-placeholder');
                    if(btnWrapper) btnWrapper.remove();
                }
                activeAiAbortController = null;
            });
        }

        function terminateActiveAiGeneration(buttonElement) {
            if(activeAiAbortController) { activeAiAbortController.abort(); activeAiAbortController = null; }
            const messageWrapper = buttonElement.closest('.ai-msg-node-wrapper');
            if (messageWrapper) { messageWrapper.remove(); }
        }

        // FIXED: परमानेंटली केवल क्लिक किया गया मैसेज ही डिलीट होगा और हिस्ट्री में सेव रहेगा
        function deleteAiMessageBubble(buttonElement) {
            const messageWrapper = buttonElement.closest('.ai-msg-node-wrapper');
            if (messageWrapper && messageWrapper.id) {
                const targetMsgId = messageWrapper.id;

                messageWrapper.classList.add('opacity-0', 'scale-95');

                // लोकल ब्लैकलिस्ट अपडेट करें ताकि रिफ्रेश पर लोड न हो
                let deletedIds = JSON.parse(localStorage.getItem('ai_deleted_msg_ids_' + currentUserId) || '[]');
                if (!deletedIds.includes(targetMsgId)) {
                    deletedIds.push(targetMsgId);
                    localStorage.setItem('ai_deleted_msg_ids_' + currentUserId, JSON.stringify(deletedIds));
                }

                setTimeout(() => {
                    messageWrapper.remove();
                    const stream = document.getElementById('aiChatStream');
                    if (stream && stream.children.length === 0) { stream.classList.add('hidden'); }
                }, 200);
            }
        }

        function appendAiBubbleNode(msgContent, isUserSide, uniqueNodeId, isLoadingStateMarker) {
            var stream = document.getElementById('aiChatStream');
            var wrapper = document.createElement('div');

            wrapper.className = "ai-msg-node-wrapper flex items-center group w-full " + (isUserSide ? "justify-end" : "justify-start");
            if(uniqueNodeId) { wrapper.id = uniqueNodeId; }

            var actionButtonHtml = '';
            if (isLoadingStateMarker) {
                actionButtonHtml = '<div class="ai-action-btn-placeholder"><button onclick="terminateActiveAiGeneration(this)" class="ai-msg-stop-btn mx-2 text-indigo-400 hover:text-red-400 transition-colors duration-150 outline-none" title="Stop generation"><i class="fa-regular fa-circle-stop text-sm"></i></button></div>';
            } else {
                actionButtonHtml = '<div class="ai-action-btn-placeholder"><button onclick="deleteAiMessageBubble(this)" class="ai-msg-delete-btn mx-2 text-slate-500 hover:text-red-400 transition-colors duration-150 outline-none" title="Delete message"><i class="fa-solid fa-trash-can text-xs"></i></button></div>';
            }

            var bubbleClass = isUserSide ? "bg-indigo-600 text-white rounded-br-none shadow-sm" : "bg-slate-800 text-slate-200 border border-slate-700/60 rounded-bl-none shadow-sm";
            var parsedContent = isUserSide ? msgContent.replace(/</g, "&lt;").replace(/>/g, "&gt;") : parseMarkdownToHtmlText(msgContent);

            var bubbleHtml = '<div class="p-3.5 rounded-xl text-sm leading-relaxed max-w-[80%] break-words font-medium ' + bubbleClass + '"><span class="ai-msg-content">' + parsedContent + '</span></div>';

            if (isUserSide) { wrapper.innerHTML = actionButtonHtml + bubbleHtml; } else { wrapper.innerHTML = bubbleHtml + actionButtonHtml; }
            stream.appendChild(wrapper);
        }

        function scrollAiContainerBottom() {
            const container = document.getElementById('aiScrollArea');
            if(container) container.scrollTop = container.scrollHeight;
        }

        function toggleMobileSidebar() {
            const sidebar = document.getElementById('leftSidebar');
            const backdrop = document.getElementById('sidebarBackdrop');
            if(sidebar.classList.contains('open')) {
                sidebar.classList.remove('open');
                backdrop.classList.add('hidden');
            } else {
                sidebar.classList.add('open');
                backdrop.classList.remove('hidden');
            }
        }

        // Theme management
        function toggleSystemTheme() {
            const isDark = document.documentElement.classList.toggle('dark');
            localStorage.setItem('theme', isDark ? 'dark' : 'light');
            adjustThemeIcon(isDark ? 'dark' : 'light');
        }

        function adjustThemeIcon(theme) {
            const icon = document.getElementById('themeIcon');
            if(icon) { icon.className = theme === 'dark' ? 'fa-solid fa-sun text-sm' : 'fa-solid fa-moon text-sm'; }
        }

        function parseRealFilenameAndPath(payloadString) {
            let result = { filename: "Attached Document.pdf", webUrl: "#" };
            if(!payloadString) return result;

            if(payloadString.includes('[pdf_payload:') && payloadString.includes(']:')) {
                const matchData = payloadString.match(/\[pdf_payload:(.*?)\]:/i);
                if(matchData && matchData[1]) result.filename = matchData[1];
                let rawUri = payloadString.substring(payloadString.indexOf(']:') + 2).trim();
                if (!rawUri.includes('/uploads/')) { rawUri = "/uploads/pdfs/" + rawUri; }
                result.webUrl = rawUri.startsWith("/") ? (appGlobalRoot + rawUri) : (appGlobalRoot + "/" + rawUri);
            } else {
                let cleanStr = payloadString.replace(/\[pdf_payload\]:/i, "").replace(/\[pdf_payload\]/i, "").trim();
                let rawUri = cleanStr.startsWith(":") ? cleanStr.substring(1).trim() : cleanStr;
                if (!rawUri.includes('/uploads/')) { rawUri = "/uploads/pdfs/" + rawUri; }
                result.webUrl = rawUri.startsWith("/") ? (appGlobalRoot + rawUri) : (appGlobalRoot + "/" + rawUri);
                let baseName = rawUri.substring(rawUri.lastIndexOf('/') + 1);
                if (baseName.includes('_')) { result.filename = baseName.substring(baseName.indexOf('_') + 1); } else { result.filename = baseName || "Attached Document.pdf"; }
            }
            return result;
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

        var computeDateSeparatorBadgeLabel = function(timestampField) {
            let d = parseTimestampSafely(timestampField);
            if (isNaN(d.getTime())) return "";
            const today = new Date(); const yesterday = new Date(); yesterday.setDate(today.getDate() - 1);
            if (d.toDateString() === today.toDateString()) return "TODAY";
            if (d.toDateString() === yesterday.toDateString()) return "YESTERDAY";
            return d.toLocaleDateString([], { day: 'numeric', month: 'short', year: 'numeric' });
        }

        function formatClientTime(timestampField) {
            let date = parseTimestampSafely(timestampField);
            if (isNaN(date.getTime())) return "";
            let hours = date.getHours(), minutes = date.getMinutes(); const ampm = hours >= 12 ? 'PM' : 'AM';
            hours = hours % 12; hours = hours ? hours : 12; minutes = minutes < 10 ? '0' + minutes : minutes;
            return hours + ':' + minutes + ' ' + ampm;
        }

        function injectHistoricalDateSeparators() {
            const stream = document.getElementById("chatMessageStream");
            if (!stream) return;
            const bubbles = Array.from(stream.querySelectorAll(".msg-bubble"));
            let lastLabel = "";

            bubbles.forEach(bubble => {
                const rawTime = bubble.getAttribute("data-message-epoch");
                if (rawTime) {
                    let currentLabel = computeDateSeparatorBadgeLabel(rawTime);
                    if (currentLabel && currentLabel !== lastLabel) {
                        lastLabel = currentLabel;
                        const separator = document.createElement("div");
                        separator.className = "chat-date-separator";
                        separator.innerHTML = '<span class="chat-date-text shadow-sm">' + currentLabel + '</span>';
                        stream.insertBefore(separator, bubble);
                    }
                }
            });
            internalLastTrackedDateString = lastLabel;
        }

        if (typeof SockJS !== 'undefined' && typeof Stomp !== 'undefined') {
            const socket = new SockJS(appGlobalRoot + '/ws-chat');
            stompClient = Stomp.over(socket); stompClient.debug = null;
            stompClient.connect({}, function () {
                const statusBadge = document.getElementById("wsStatusBadge");
                if(statusBadge) statusBadge.className = "flex items-center space-x-1.5 text-emerald-600 dark:text-emerald-500 font-semibold";
                if(document.getElementById("wsStatusText")) document.getElementById("wsStatusText").textContent = "Online";

                stompClient.send("/app/chat.sendMessage", {}, JSON.stringify({
                    id: null, content: "ONLINE", senderId: parseInt(currentUserId),
                    recipientId: null, senderRole: "USER", messageType: "PRESENCE"
                }));

                stompClient.subscribe('/topic/public', function (res) {
                    const dto = JSON.parse(res.body);

                    if(dto.messageType === "PRESENCE") {
                        if(dto.senderRole === "ADMIN") {
                            updateAdminHeaderPresence(dto.content);

                            if (dto.content === "ONLINE") {
                                fallbackAdminId = dto.senderId;
                                localStorage.setItem('tracked_admin_id_' + currentUserId, fallbackAdminId);
                                document.getElementById("detectedRecipientId").value = fallbackAdminId;

                                stompClient.send("/app/chat.sendMessage", {}, JSON.stringify({
                                    id: null, content: "ONLINE", senderId: parseInt(currentUserId),
                                    recipientId: parseInt(fallbackAdminId), senderRole: "USER", messageType: "PRESENCE"
                                }));
                            }
                        }
                        return;
                    }

                    if(dto.messageType === "TYPING" && dto.senderRole.toUpperCase() === "ADMIN" && (String(dto.recipientId) == String(currentUserId) || !dto.recipientId)) {
                        showLiveTypingAnimation();
                        return;
                    }
                    if(dto.messageType !== "CHAT") return;

                    if (dto.senderRole.toUpperCase() === 'ADMIN' && (String(dto.recipientId) == String(currentUserId) || dto.recipientId == 0 || !dto.recipientId)) {
                        fallbackAdminId = dto.senderId;
                        localStorage.setItem('tracked_admin_id_' + currentUserId, fallbackAdminId);
                        document.getElementById("detectedRecipientId").value = fallbackAdminId;
                        renderMessageBubble(dto, true);
                        updateAdminHeaderPresence("ONLINE");
                    } else if (String(dto.senderId) == String(currentUserId)) {
                        const trackingTimeId = Array.isArray(dto.timestamp) ? dto.timestamp.join("-") : new Date(dto.timestamp).getTime();
                        const clientTempNode = document.getElementById("msg-node-temp-" + trackingTimeId) || document.querySelector(`[id^='msg-node-temp-']`);
                        if (clientTempNode) {
                            clientTempNode.id = "msg-node-" + dto.id;
                            const statusTick = clientTempNode.querySelector('.whatsapp-tick-status');
                            if(statusTick) statusTick.innerHTML = '<i class="fa-solid fa-check-double text-xs text-blue-400"></i>';
                            const delBtn = clientTempNode.querySelector('.delete-btn-trigger');
                            if(delBtn) delBtn.setAttribute("onclick", "triggerMessagePurge('" + dto.id + "')");
                        } else if (!document.getElementById("msg-node-" + dto.id)) {
                            renderMessageBubble(dto, false);
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
                                stream.innerHTML = '<div id="emptyWorkspaceStateCard" class="my-auto mx-auto text-center max-w-sm p-8 bg-white dark:bg-slate-900/60 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-md select-none backdrop-blur-md"><div class="w-14 h-14 rounded-2xl bg-blue-50 dark:bg-blue-950/40 flex items-center justify-center mx-auto mb-4 text-blue-500 border border-blue-100 dark:border-blue-900/30"><i class="fa-solid fa-shield-halved text-2xl"></i></div><h4 class="text-sm font-bold text-slate-800 dark:text-slate-200">No Chat History Available</h4><p class="text-xs text-slate-400 dark:text-slate-400 mt-2 leading-relaxed">Type your query in the workspace layout box below to build a dynamic sync connection channel directly with active administrative support lines.</p></div>';
                            }
                        }, 250);
                    }
                });
            }, () => {
                const statusBadge = document.getElementById("wsStatusBadge");
                if(statusBadge) statusBadge.className = "flex items-center space-x-1.5 text-red-500 font-semibold";
                if(document.getElementById("wsStatusText")) document.getElementById("wsStatusText").textContent = "Disconnected";
            });
        }

        function updateAdminHeaderPresence(status) {
            const hDot = document.getElementById("activeHeaderPresenceDot");
            const hText = document.getElementById("liveConnectedIdentityState");
            if(status === "ONLINE") {
                if(hDot) hDot.className = "w-3 h-3 bg-emerald-500 rounded-full border-2 border-white dark:border-slate-900 animate-pulse";
                if(hText) {
                    hText.innerHTML = '<span class="w-1.5 h-1.5 bg-emerald-500 mr-2 rounded-full inline-block animate-pulse"></span>Active Support Desk Agent';
                    hText.className = "text-xs text-emerald-500 font-semibold tracking-wide flex items-center mt-0.5";
                }
            } else {
                if(hDot) hDot.className = "w-3 h-3 bg-slate-400 rounded-full border-2 border-white dark:border-slate-900";
                if(hText) {
                    hText.innerHTML = '<span class="w-1.5 h-1.5 bg-slate-400 mr-2 rounded-full inline-block"></span>Agent Offline';
                    hText.className = "text-xs text-slate-400 dark:text-slate-400 font-semibold tracking-wide flex items-center mt-0.5";
                }
            }
        }

        function showLiveTypingAnimation() {
            const ti = document.getElementById('typingIndicatorElement'); if(ti) ti.classList.remove('hidden');
            clearTimeout(typingTimeoutTracker); typingTimeoutTracker = setTimeout(() => ti && ti.classList.add('hidden'), 2000);
        }

        function dispatchLiveChat(event, forcedPayload = null) {
            if(event) event.preventDefault();
            let txt = forcedPayload ? forcedPayload : messageInput.value.trim(); if (txt === "") return;

            const emptyCard = document.getElementById('emptyWorkspaceStateCard'); if(emptyCard) emptyCard.remove();
            const currentTimeISO = new Date().toISOString();

            let targetRecipientId = (fallbackAdminId === 0 || !fallbackAdminId) ? null : parseInt(fallbackAdminId);

            const chatPayload = {
                id: null, content: txt, senderId: parseInt(currentUserId),
                recipientId: targetRecipientId, senderRole: "USER",
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

            fetch(appGlobalRoot + '/student/chat/api/upload', { method: 'POST', body: fd })
            .then(res => res.text()).then(url => {
                if(url && url.trim() !== "") {
                    if (fileTypeCheck === 'PDF') {
                        dispatchLiveChat(null, '[pdf_payload:' + originalFileName + ']:' + url.trim());
                    } else {
                        dispatchLiveChat(null, '[img_payload]:' + url.trim());
                    }
                }
            }).catch(err => console.error(err));
        }

        function triggerMessagePurge(id) {
            if (String(id).startsWith("temp-")) {
                document.getElementById("msg-node-" + id)?.remove();
                return;
            }
            const targetNode = document.getElementById("msg-node-" + id);
            if (targetNode) targetNode.classList.add('opacity-50', 'pointer-events-none');

            fetch(appGlobalRoot + '/student/chat/api/delete/' + id, { method: 'DELETE' })
            .then(res => {
                if(res.ok) {
                    if (targetNode) {
                        targetNode.classList.add('opacity-0', 'scale-95');
                        setTimeout(() => {
                            targetNode.remove();
                            const stream = document.getElementById("chatMessageStream");
                            if (stream && stream.querySelectorAll('.msg-bubble').length === 0) {
                                stream.innerHTML = '<div id="emptyWorkspaceStateCard" class="my-auto mx-auto text-center max-w-sm p-8 bg-white dark:bg-slate-900/60 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-md select-none backdrop-blur-md"><div class="w-14 h-14 rounded-2xl bg-blue-50 dark:bg-blue-950/40 flex items-center justify-center mx-auto mb-4 text-blue-500 border border-blue-100 dark:border-blue-900/30"><i class="fa-solid fa-shield-halved text-2xl"></i></div><h4 class="text-sm font-bold text-slate-800 dark:text-slate-200">No Chat History Available</h4><p class="text-xs text-slate-400 dark:text-slate-400 mt-2 leading-relaxed">Type your query in the workspace layout box below to build a dynamic sync connection channel directly with active administrative support lines.</p></div>';
                            }
                        }, 200);
                    }
                } else {
                    if (targetNode) targetNode.classList.remove('opacity-50', 'pointer-events-none');
                }
            })
            .catch(err => {
                if (targetNode) targetNode.classList.remove('opacity-50', 'pointer-events-none');
            });
        }

        function broadcastTypingNotificationStream() {
            if (stompClient && stompClient.connected) {
                let targetRecipientId = (fallbackAdminId === 0 || !fallbackAdminId) ? null : parseInt(fallbackAdminId);
                stompClient.send("/app/chat.typing", {}, JSON.stringify({
                    id: null, content: "typing", senderId: parseInt(currentUserId),
                    recipientId: targetRecipientId, senderRole: "USER", messageType: "TYPING"
                }));
            }
        }

        function renderMessageBubble(dto, isAdmin, targetedNodeCustomId = null) {
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
            row.className = "msg-bubble flex items-end space-x-2.5 max-w-[85%] md:max-w-[70%] " + (isAdmin ? '' : 'ml-auto flex-row-reverse space-x-reverse');
            row.style.animation = "messageFlowSlideUp 0.25s cubic-bezier(0.16, 1, 0.3, 1) forwards";

            const contentLower = dto.content.toLowerCase();
            const isImg = contentLower.includes('[img_payload]:') || contentLower.endsWith('.jpg') || contentLower.endsWith('.png') || contentLower.endsWith('.jpeg') || contentLower.endsWith('.webp');
            const isPdf = contentLower.includes('[pdf_payload:') || contentLower.endsWith('.pdf') || contentLower.includes('[pdf_payload]') || contentLower.includes('/pdfs/');

            let bodyHtml = "";
            if (isImg) {
                let cleanPath = dto.content;
                if (cleanPath.toLowerCase().startsWith('[img_payload]:')) cleanPath = cleanPath.substring(14);
                let imgUrl = cleanPath.startsWith("/") ? (appGlobalRoot + cleanPath) : (appGlobalRoot + "/" + cleanPath);
                bodyHtml = '<div class="relative max-w-xs overflow-hidden rounded-2xl border border-slate-200 dark:border-slate-800 bg-gray-200 dark:bg-slate-800"><img src="' + imgUrl + '" class="w-full h-auto max-h-64 object-cover cursor-pointer block" onclick="window.open(this.src)"></div>';
            } else if (isPdf) {
                let pdfMetadata = parseRealFilenameAndPath(dto.content);
                bodyHtml = '<a href="' + pdfMetadata.webUrl + '" target="_blank" class="flex items-center space-x-3 p-3.5 bg-emerald-500/10 border border-emerald-500/30 text-emerald-600 dark:text-emerald-400 rounded-2xl text-sm font-semibold shadow-sm hover:bg-emerald-500/25 transition-all"><i class="fa-solid fa-file-pdf text-2xl flex-shrink-0 text-emerald-500"></i><span class="truncate max-w-[180px] md:max-w-[240px] block text-slate-800 dark:text-slate-200">' + pdfMetadata.filename + '</span></a>';
            } else {
                bodyHtml = '<p class="leading-relaxed whitespace-pre-wrap select-text break-words max-w-full">' + dto.content.replace(/</g, "&lt;").replace(/>/g, "&gt;") + '</p>';
            }

            let styleClass = (isImg || isPdf) ? "p-0 bg-transparent shadow-none" : (isAdmin ? "p-3.5 rounded-2xl text-sm bg-white text-slate-800 border border-slate-200 dark:bg-slate-800 dark:border-slate-700/80 dark:text-slate-200 rounded-bl-none shadow-sm font-medium" : "p-3.5 rounded-2xl text-sm bg-blue-600 text-white rounded-br-none shadow-md shadow-blue-700/10 font-medium");

            let tickHtml = !isAdmin ? (dto.id ? '<span class="whatsapp-tick-status"><i class="fa-solid fa-check-double text-xs text-blue-400"></i></span>' : '<span class="whatsapp-tick-status"><i class="fa-solid fa-check text-xs text-slate-300"></i></span>') : '';

            row.innerHTML = '<div class="w-7 h-7 rounded-full bg-slate-500 text-white flex items-center justify-center text-[10px] font-bold flex-shrink-0 shadow-sm">' + (isAdmin ? 'A' : 'U') + '</div>' +
                '<div class="flex flex-col ' + (isAdmin ? 'items-start' : 'items-end') + ' group relative max-w-full">' +
                    '<div class="' + styleClass + ' break-words max-w-full">' + bodyHtml + '</div>' +
                    '<div class="flex items-center space-x-2.5 mt-1.5 px-1 text-xs text-slate-400 dark:text-slate-500 font-medium"><span>' + formatClientTime(dto.timestamp) + '</span>' + tickHtml + '<button onclick="triggerMessagePurge(\'' + (dto.id ? dto.id : finalNodeIdentifier) + '\')" class="delete-btn-trigger text-red-400 hover:text-red-500 outline-none transition-colors ml-1"><i class="fa-solid fa-trash-can text-xs"></i></button></div>' +
                '</div>';
            stream.appendChild(row); stream.scrollTop = stream.scrollHeight;
        }

        window.onload = function() {
            injectHistoricalDateSeparators();
            const stream = document.getElementById("chatMessageStream"); if(stream) stream.scrollTop = stream.scrollHeight;
            document.querySelectorAll(".chat-timestamp-field").forEach(el => { const raw = el.getAttribute("data-raw-time"); if(raw) el.textContent = formatClientTime(raw); });

            const activeTheme = document.documentElement.classList.contains('dark') ? 'dark' : 'light';
            adjustThemeIcon(activeTheme);
        };

        window.onbeforeunload = function() {
            if(stompClient && stompClient.connected) {
                stompClient.send("/app/chat.sendMessage", {}, JSON.stringify({
                    id: null, content: "OFFLINE", senderId: parseInt(currentUserId),
                    recipientId: null, senderRole: "USER", messageType: "PRESENCE"
                }));
            }
        };
    </script>
</body>
</html>
