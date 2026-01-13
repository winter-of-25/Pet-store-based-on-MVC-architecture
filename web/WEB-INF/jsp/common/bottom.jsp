<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
%>

<style>
    #Footer {
        /* 定义变量 */
        --footer-bg: #ffffff;
        --footer-border: #e2e8f0;
        --text-color: #64748b;
        --link-hover: #3b82f6;

        width: 100%;
        background-color: var(--footer-bg);
        border-top: 1px solid var(--footer-border);
        padding: 15px 0;
        margin-top: auto;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        font-size: 13px;
        color: var(--text-color);
        line-height: 1.5;
    }

    .footer-inner {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 24px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        flex-wrap: wrap;
        gap: 20px;
    }

    .footer-nav {
        display: flex;
        gap: 24px;
    }

    .footer-nav a {
        text-decoration: none;
        color: var(--text-color);
        font-weight: 500;
        transition: color 0.2s;
        position: relative;
    }

    .footer-nav a:hover {
        color: var(--link-hover);
    }

    .footer-right {
        display: flex;
        align-items: center;
        gap: 20px;
    }

    .copyright {
        opacity: 0.8;
    }

    .banner-pill {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        background-color: #f1f5f9;
        padding: 4px 12px;
        border-radius: 50px;
        font-size: 12px;
        color: #475569;
        border: 1px solid #e2e8f0;
    }

    @media (max-width: 700px) {
        .footer-inner {
            flex-direction: column;
            justify-content: center;
            padding: 20px;
        }
        .footer-nav { gap: 15px; }
        .footer-right { flex-direction: column; gap: 10px; }
    }
</style>

<script>
    window.addEventListener('DOMContentLoaded', function(){
        var y = document.getElementById('year-span');
        if (y) y.textContent = new Date().getFullYear();
    });
</script>

<footer id="Footer">
    <div class="footer-inner">
        <nav class="footer-nav">
            <a href="mainForm">Home</a>
            <a href="help.html">Help Center</a>
            <a href="http://www.csu.edu.cn" target="_blank">CSU</a>
            <a href="#">Privacy Policy</a>
        </nav>

        <div class="footer-right">
            <c:if test="${sessionScope.loginAccount != null && sessionScope.loginAccount.bannerOption}">
                <div class="banner-pill">
                    <span style="color:#f59e0b">★</span>
                        ${sessionScope.loginAccount.bannerName}
                </div>
            </c:if>

            <div class="copyright">
                &copy; <span id="year-span">2025</span> JPetStore Demo. All rights reserved.
            </div>
        </div>
    </div>
</footer>

<style>
    /* 悬浮按钮 */
    #ai-chat-btn {
        position: fixed;
        bottom: 20px;
        right: 20px;
        width: 60px;
        height: 60px;
        background-color: #3b82f6;
        border-radius: 50%;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        cursor: pointer;
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 99999;
        transition: transform 0.3s;
    }
    #ai-chat-btn:hover { transform: scale(1.1); }
    #ai-chat-btn svg { fill: white; width: 30px; height: 30px; }

    /* 聊天窗口 */
    #ai-chat-window {
        position: fixed;
        bottom: 90px;
        right: 20px;
        width: 350px;
        height: 500px;
        background: white;
        border-radius: 12px;
        box-shadow: 0 5px 20px rgba(0,0,0,0.2);
        display: none;
        flex-direction: column;
        overflow: hidden;
        z-index: 99999;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        border: 1px solid #e2e8f0;
    }

    .chat-header {
        background: #3b82f6;
        color: white;
        padding: 15px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-weight: bold;
    }
    .close-chat { cursor: pointer; font-size: 20px; opacity: 0.8; }
    .close-chat:hover { opacity: 1; }

    .chat-messages {
        flex: 1;
        padding: 15px;
        overflow-y: auto;
        background: #f8f9fa;
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .message {
        max-width: 85%;
        padding: 10px 14px;
        border-radius: 12px;
        font-size: 14px;
        line-height: 1.5;
        word-wrap: break-word;
    }
    .message.user {
        background-color: #3b82f6;
        color: white;
        align-self: flex-end;
        border-bottom-right-radius: 2px;
    }
    .message.ai {
        background-color: #ffffff;
        color: #333;
        align-self: flex-start;
        border-bottom-left-radius: 2px;
        border: 1px solid #e2e8f0;
    }

    .chat-input-area {
        padding: 12px;
        border-top: 1px solid #eee;
        display: flex;
        background: white;
        gap: 8px;
    }
    .chat-input-area input {
        flex: 1;
        padding: 10px 12px;
        border: 1px solid #ddd;
        border-radius: 20px;
        outline: none;
        font-size: 14px;
    }
    .chat-input-area input:focus { border-color: #3b82f6; }

    .chat-input-area button {
        padding: 0 16px;
        background: #3b82f6;
        color: white;
        border: none;
        border-radius: 20px;
        cursor: pointer;
        font-weight: 500;
        transition: background 0.2s;
    }
    .chat-input-area button:hover { background: #2563eb; }
    .chat-input-area button:disabled { background: #cbd5e1; cursor: not-allowed; }
</style>

<div id="ai-chat-btn" onclick="toggleChat()">
    <svg viewBox="0 0 24 24"><path d="M12 2a2 2 0 0 1 2 2c0 .74-.4 1.39-1 1.73V7h1a7 7 0 0 1 7 7h1a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1h-1v1a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-1H2a1 1 0 0 1-1-1v-3a1 1 0 0 1 1-1h1a7 7 0 0 1 7-7h1V5.73c-.6-.34-1-.99-1-1.73a2 2 0 0 1 2-2M7.5 13A2.5 2.5 0 0 0 5 15.5A2.5 2.5 0 0 0 7.5 18a2.5 2.5 0 0 0 2.5-2.5A2.5 2.5 0 0 0 7.5 13m9 0a2.5 2.5 0 0 0-2.5 2.5a2.5 2.5 0 0 0 2.5 2.5a2.5 2.5 0 0 0 2.5-2.5a2.5 2.5 0 0 0-2.5-2.5"/></svg>
</div>

<div id="ai-chat-window">
    <div class="chat-header">
        <span>DeepSeek 宠物顾问</span>
        <span class="close-chat" onclick="toggleChat()">×</span>
    </div>
    <div class="chat-messages" id="chat-messages">
        <div class="message ai">你好！我是你的智能宠物顾问。无论你在哪个页面，都可以随时问我关于宠物的问题哦！🐶🐱</div>
    </div>
    <div class="chat-input-area">
        <input type="text" id="chat-input" placeholder="输入问题..." onkeypress="handleKeyPress(event)">
        <button id="send-btn" onclick="sendMessage()">发送</button>
    </div>
</div>

<script>
    function toggleChat() {
        const chatWindow = document.getElementById('ai-chat-window');
        if (chatWindow.style.display === 'none' || chatWindow.style.display === '') {
            chatWindow.style.display = 'flex';
            // 延时聚焦，防止移动端键盘弹出问题
            setTimeout(() => document.getElementById('chat-input').focus(), 100);
        } else {
            chatWindow.style.display = 'none';
        }
    }

    function handleKeyPress(e) {
        if (e.key === 'Enter') {
            sendMessage();
        }
    }

    async function sendMessage() {
        const inputField = document.getElementById('chat-input');
        const sendBtn = document.getElementById('send-btn');
        const messageText = inputField.value.trim();

        if (!messageText) return;

        addMessage(messageText, 'user');
        inputField.value = '';
        inputField.disabled = true;
        sendBtn.disabled = true;

        const loadingId = addMessage('Thinking...', 'ai');

        try {
            // 使用 contextPath 确保路径正确
            const apiUrl = '${pageContext.request.contextPath}/chatApi';

            const response = await fetch(apiUrl, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ message: messageText })
            });

            const data = await response.json();
            removeMessage(loadingId);
            addMessage(data.reply, 'ai');

        } catch (error) {
            console.error('API Error:', error);
            removeMessage(loadingId);
            addMessage('抱歉，AI 暂时无法连接。', 'ai');
        } finally {
            inputField.disabled = false;
            sendBtn.disabled = false;
            inputField.focus();
        }
    }

    function addMessage(text, sender) {
        const messagesDiv = document.getElementById('chat-messages');
        const msgDiv = document.createElement('div');
        msgDiv.className = `message ${sender}`;
        msgDiv.textContent = text;
        const id = 'msg-' + Date.now();
        msgDiv.id = id;
        messagesDiv.appendChild(msgDiv);
        messagesDiv.scrollTop = messagesDiv.scrollHeight;
        return id;
    }

    function removeMessage(id) {
        const el = document.getElementById(id);
        if (el) el.remove();
    }
</script>

</body>
</html>