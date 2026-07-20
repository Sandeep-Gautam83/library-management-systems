<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AI Assistant Portal Window</title>
    <!-- Add FontAwesome Icons library for standard vector graphics assets -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* Modern Dark AI Assistant Styling Theme */
        .ai-assistant-toggle-btn {
            background: #1e1b4b;
            border: 2px solid #6366f1;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 0 15px rgba(99, 102, 241, 0.4);
            transition: all 0.3s ease;
        }
        .ai-assistant-toggle-btn:hover {
            transform: scale(1.08);
            box-shadow: 0 0 20px rgba(99, 102, 241, 0.7);
        }
        .ai-assistant-toggle-btn img {
            width: 32px;
            height: 32px;
        }

        /* Fixed Right Sidebar Overlay Container */
        .ai-panel-container {
            position: fixed;
            top: 20px;
            right: -420px; /* Hidden default offscreen state */
            width: 380px;
            height: calc(100vh - 40px);
            background: linear-gradient(145deg, #0b0f19, #111827);
            border: 1px solid #1f2937;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.7);
            display: flex;
            flex-direction: column;
            z-index: 9999;
            transition: right 0.4s cubic-bezier(0.16, 1, 0.3, 1);
            overflow: hidden;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .ai-panel-container.active {
            right: 20px;
        }

        /* Header Layout Banner */
        .ai-header {
            padding: 15px 20px;
            background: #111827;
            border-bottom: 1px solid #1f2937;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .ai-header-info {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #ffffff;
        }
        .ai-beta-tag {
            background: #6366f1;
            color: #ffffff;
            font-size: 10px;
            font-weight: bold;
            padding: 2px 6px;
            border-radius: 6px;
            text-transform: uppercase;
        }
        .ai-close-btn {
            color: #9ca3af;
            background: transparent;
            border: none;
            font-size: 18px;
            cursor: pointer;
            transition: color 0.2s;
        }
        .ai-close-btn:hover {
            color: #ef4444;
        }

        /* Content Area Body Scroll Window */
        .ai-body-content {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        /* Welcome & Core Features Layout Cards */
        .ai-welcome-box {
            text-align: center;
            color: #e5e7eb;
        }
        .ai-welcome-box h3 {
            margin: 10px 0 5px 0;
            font-size: 18px;
        }
        .ai-welcome-box p {
            font-size: 12px;
            color: #9ca3af;
            margin: 0;
        }
        .ai-features-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }
        .feature-card {
            background: #1f2937;
            border: 1px solid #374151;
            border-radius: 12px;
            padding: 12px;
            color: #ffffff;
            display: flex;
            flex-direction: column;
            gap: 5px;
            cursor: pointer;
            transition: background 0.2s;
            outline: none;
            text-align: left;
            border: none;
        }
        .feature-card:hover {
            background: #374151;
        }
        .feature-card span {
            font-size: 13px;
            font-weight: 600;
        }
        .feature-card small {
            font-size: 10px;
            color: #9ca3af;
        }

        /* Quick Suggestion Chips Layout */
        .ai-suggestions-section {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .ai-suggestions-section label {
            font-size: 12px;
            color: #9ca3af;
            font-weight: 500;
        }
        .suggestion-chip {
            background: rgba(99, 102, 241, 0.1);
            border: 1px solid rgba(99, 102, 241, 0.3);
            color: #a5b4fc;
            padding: 10px 14px;
            border-radius: 10px;
            font-size: 12px;
            cursor: pointer;
            text-align: left;
            transition: all 0.2s ease;
            outline: none;
        }
        .suggestion-chip:hover {
            background: rgba(99, 102, 241, 0.25);
            border-color: #6366f1;
        }

        /* Active Chat Message Display Threads */
        .chat-messages-area {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .msg-bubble {
            max-width: 85%;
            padding: 10px 14px;
            border-radius: 14px;
            font-size: 13px;
            line-height: 1.5;
            word-wrap: break-word;
        }
        .msg-user {
            background: #6366f1;
            color: #ffffff;
            align-self: flex-end;
            border-bottom-right-radius: 2px;
        }
        .msg-ai {
            background: #1f2937;
            color: #e5e7eb;
            align-self: flex-start;
            border-bottom-left-radius: 2px;
            border: 1px solid #374151;
        }

        /* Input Form Fixed Bottom Action Bar */
        .ai-footer-input-bar {
            padding: 15px 20px;
            background: #111827;
            border-top: 1px solid #1f2937;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .ai-input-field {
            flex: 1;
            background: #1f2937;
            border: 1px solid #374151;
            border-radius: 10px;
            padding: 10px 14px;
            color: #ffffff;
            font-size: 13px;
            outline: none;
        }
        .ai-input-field::placeholder {
            color: #6b7280;
        }
        .ai-send-btn {
            background: #6366f1;
            color: #ffffff;
            border: none;
            border-radius: 10px;
            width: 38px;
            height: 38px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: background 0.2s;
            outline: none;
        }
        .ai-send-btn:hover {
            background: #4f46e5;
        }

        /* Attribution footer label */
        .ai-brand-footer {
            text-align: center;
            font-size: 10px;
            color: #4b5563;
            padding-bottom: 5px;
            background: #111827;
            font-family: sans-serif;
        }
    </style>
</head>
<body>

    <!-- 1. AI Assistant Trigger Icon Button -->
    <button class="ai-assistant-toggle-btn" id="openAiBtn" title="Open AI Assistant">
        <i class="fa-solid fa-robot" style="color:#a5b4fc; font-size:24px;"></i>
    </button>

    <!-- 2. Interactive Sliding Dynamic Panel Element Layout -->
    <div class="ai-panel-container" id="aiAssistantPanel">

        <!-- Header Window Block -->
        <div class="ai-header">
            <div class="ai-header-info">
                <i class="fa-solid fa-circle-nodes" style="color:#6366f1;"></i>
                <span style="font-weight: 600; font-size: 15px;">AI Assistant</span>
                <span class="ai-beta-tag">Beta</span>
            </div>
            <button class="ai-close-btn" id="closeAiBtn"><i class="fa-solid fa-xmark"></i></button>
        </div>

        <!-- Scrollable Conversation Content Area -->
        <div class="ai-body-content" id="aiBodyScrollContainer">

            <!-- Default Initialization View Panel Component -->
            <div id="aiDefaultPromoView" style="display: flex; flex-direction: column; gap: 20px;">
                <div class="ai-welcome-box">
                    <i class="fa-solid fa-face-smile-wink" style="color: #fbbf24; font-size: 32px; margin-bottom: 8px;"></i>
                    <h3>Hi! I'm your AI Assistant</h3>
                    <p>I can help with your queries, active fines, book search and study materials.</p>
                </div>

                <!-- Features Grid Layout Quick Tags -->
                <div class="ai-features-grid">
                    <button class="feature-card" onclick="setQuickQuery('Check my outstanding book fine status')">
                        <span><i class="fa-solid fa-graduation-cap" style="color:#34d399; margin-right:5px;"></i> Fine Help</span>
                        <small>Get details on fines</small>
                    </button>
                    <button class="feature-card" onclick="setQuickQuery('Show active books issued on my name')">
                        <span><i class="fa-solid fa-calendar-days" style="color:#f87171; margin-right:5px;"></i> Issue Info</span>
                        <small>Check due schedules</small>
                    </button>
                    <button class="feature-card" onclick="setQuickQuery('Is Java programming book available in catalog?')">
                        <span><i class="fa-solid fa-magnifying-glass" style="color:#60a5fa; margin-right:5px;"></i> Book Search</span>
                        <small>Find books dynamically</small>
                    </button>
                    <button class="feature-card" onclick="setQuickQuery('Recommend some popular coding resources')">
                        <span><i class="fa-solid fa-book-bookmark" style="color:#c084fc; margin-right:5px;"></i> Resources</span>
                        <small>Find study records</small>
                    </button>
                </div>

                <!-- Interactive Chips Layout Section Prompts Links -->
                <div class="ai-suggestions-section">
                    <label>Try asking me something...</label>
                    <button class="suggestion-chip" onclick="setQuickQuery('What is the fine penalty rate per day for late return?')">
                        What is the fine penalty rate per day for late return?
                    </button>
                    <button class="suggestion-chip" onclick="setQuickQuery('Show me books related to Data Structures')">
                        Show me books related to Data Structures
                    </button>
                    <button class="suggestion-chip" onclick="setQuickQuery('How do I download book PDF materials from portal?')">
                        How do I download book PDF materials from portal?
                    </button>
                </div>
            </div>

            <!-- Active User-AI Interactive Exchange Container -->
            <div class="chat-messages-area" id="chatStreamBox" style="display: none;"></div>

        </div>

        <!-- Dynamic Form Operations Input Footer -->
        <div class="ai-footer-input-bar">
            <input type="text" class="ai-input-field" id="aiMessageInput" placeholder="Ask me anything..." onkeypress="handleKeyPress(event)">
            <button class="ai-send-btn" id="sendAiMsgBtn" onclick="processUserChatMessage()">
                <i class="fa-solid fa-paper-plane"></i>
            </button>
        </div>
        <div class="ai-brand-footer">Powered by Gemini AI • Accurate • Live RAG Sync</div>
    </div>

    <!-- JavaScript Event Control System Script Block -->
    <script>
        const openBtn = document.getElementById('openAiBtn');
        const closeBtn = document.getElementById('closeAiBtn');
        const panel = document.getElementById('aiAssistantPanel');
        const defaultView = document.getElementById('aiDefaultPromoView');
        const streamBox = document.getElementById('chatStreamBox');
        const messageInput = document.getElementById('aiMessageInput');
        const scrollContainer = document.getElementById('aiBodyScrollContainer');

        // Toggle UI panel container window states
        openBtn.addEventListener('click', () => {
            panel.classList.add('active');
            loadExistingChatLogHistory();
        });
        closeBtn.addEventListener('click', () => {
            panel.classList.remove('active');
        });

        // Click selection utility setting text prompt input field state
        function setQuickQuery(text) {
            messageInput.value = text;
            messageInput.focus();
        }

        function handleKeyPress(e) {
            if(e.key === 'Enter') {
                processUserChatMessage();
            }
        }

        // ChatGPT Markdown Response Text Elements Formatter Parser
        function formatAiResponseToHtmlText(rawText) {
            if (!rawText) return "";

            // FIXED: Detect if rawText contains standard HTML tag structures to completely prevent string literal prints
            if (rawText.trim().startsWith("<i ") || rawText.trim().startsWith("<span ")) {
                return rawText;
            }

            // Escape HTML entities to protect layouts safely
            let formatted = rawText
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;");

            // 1. Transform Markdown Bold (**text** -> HTML strong)
            formatted = formatted.replace(/\*\*(.*?)\*\*/g, '<strong class="text-white font-bold">$1</strong>');

            // 2. Transform Markdown Lists (- item -> bullet elements)
            formatted = formatted.replace(/^\s*-\s+(.*?)$/gm, '<div class="flex items-start my-1"><span class="text-indigo-400 mr-2 font-bold">•</span><span class="flex-1 text-slate-300">$1</span></div>');

            // 3. Preserve basic newline paragraph breaks
            formatted = formatted.replace(/\n/g, '<br>');

            return formatted;
        }

        // Load chat logs asynchronously on trigger context setup
        function loadExistingChatLogHistory() {
            fetch('/api/chatbot/history')
                .then(res => res.json())
                .then(data => {
                    if(data && data.length > 0) {
                        defaultView.style.display = 'none';
                        streamBox.style.display = 'flex';
                        streamBox.innerHTML = '';

                        data.forEach(msg => {
                            appendMessageBubble(msg.question, 'user');
                            appendMessageBubble(msg.answer, 'ai');
                        });
                        scrollToBottomElement();
                    }
                }).catch(err => console.error("Error pulling conversation records:", err));
        }

        // Dynamic API transaction handler
        function processUserChatMessage() {
            const queryText = messageInput.value.trim();
            if(!queryText) return;

            // Switch presentation modes immediately upon query submission
            if(defaultView.style.display !== 'none') {
                defaultView.style.display = 'none';
                streamBox.style.display = 'flex';
            }

            // Append User Question bubble
            appendMessageBubble(queryText, 'user');
            messageInput.value = '';
            scrollToBottomElement();

            // Create placeholder loading bubble for AI response
            const loadingBubbleId = 'ai-load-' + Date.now();
            appendMessageBubble('<i class="fa-solid fa-circle-notch fa-spin mr-1.5 text-indigo-400"></i> ChatGPT is thinking...', 'ai', loadingBubbleId);
            scrollToBottomElement();

            // Execute asynchronous backend transmission payload block
            fetch('/api/chatbot/ask', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ question: queryText })
            })
            .then(res => res.json())
            .then(data => {
                const loadingBubble = document.getElementById(loadingBubbleId);
                if(loadingBubble) {
                    loadingBubble.id = ''; // Clear tracking ID track
                    loadingBubble.innerHTML = formatAiResponseToHtmlText(data.answer); // Render clean structural formats
                }
                scrollToBottomElement();
            })
            .catch(err => {
                const loadingBubble = document.getElementById(loadingBubbleId);
                if(loadingBubble) {
                    loadingBubble.innerHTML = "<span class='text-red-400'><i class='fa-solid fa-triangle-exclamation mr-1'></i> Service down. Please retry later.</span>";
                }
            });
        }

        // Dynamic list rendering item execution
        function appendMessageBubble(text, sender, elementId = '') {
            const bubble = document.createElement('div');
            bubble.className = `msg-bubble ${sender === 'user' ? 'msg-user' : 'msg-ai'}`;
            if(elementId) bubble.id = elementId;

            // Apply formatting dynamically if response originates from the AI assistant engine
            bubble.innerHTML = (sender === 'user') ? text : formatAiResponseToHtmlText(text);
            streamBox.appendChild(bubble);
        }

        function scrollToBottomElement() {
            scrollContainer.scrollTop = scrollContainer.scrollHeight;
        }
    </script>
</body>
</html>