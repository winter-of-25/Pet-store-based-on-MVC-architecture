<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JPetStore - Login</title>
    <link href="https://cdn.jsdelivr.net/npm/font-awesome@4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            /* 与欢迎页保持一致的温馨蓝白调 */
            --primary-blue: #4facfe;
            --warm-blue: #00f2fe;
            --dark-blue: #094b65;
            --glass-bg: rgba(255, 255, 255, 0.92);
            --glass-border: rgba(255, 255, 255, 0.6);
            --input-bg: #f3f8ff;
            --shadow-card: 0 20px 50px rgba(0, 100, 200, 0.15), inset 0 0 20px rgba(255,255,255,0.5);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            min-height: 100vh;
            font-family: 'Poppins', sans-serif;
            /* 1. 背景统一：使用与欢迎页相同的温馨背景 */
            background: url('https://images.unsplash.com/photo-1623387641168-d9803ddd3f35?q=80&w=2070&auto=format&fit=crop') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        /* 2. 暖色遮罩：统一光感 */
        body::before {
            content: '';
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background: linear-gradient(to bottom, rgba(255, 255, 255, 0.2) 0%, rgba(79, 172, 254, 0.5) 100%);
            backdrop-filter: blur(5px);
            z-index: 0;
        }

        /* --- 3. 氛围装饰：漂浮动物元素 (解决空旷感) --- */
        .floating-elements {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            overflow: hidden; z-index: 1; pointer-events: none;
        }
        .float-icon {
            position: absolute;
            color: rgba(255, 255, 255, 0.4);
            filter: drop-shadow(0 0 5px rgba(100, 200, 255, 0.2));
            animation: floatAround 25s linear infinite;
        }
        .i1 { top: 15%; left: 10%; font-size: 45px; animation-duration: 28s; }
        .i2 { bottom: 20%; right: 15%; font-size: 35px; animation-duration: 22s; animation-delay: -5s;}
        .i3 { bottom: 10%; left: 20%; font-size: 55px; animation-duration: 35s; animation-delay: -10s;}
        .i4 { top: 20%; right: 10%; font-size: 40px; animation-duration: 30s; animation-delay: -2s;}

        @keyframes floatAround {
            0% { transform: translate(0, 0) rotate(0deg); }
            50% { transform: translate(30px, -30px) rotate(15deg); }
            100% { transform: translate(0, 0) rotate(0deg); }
        }

        /* --- 4. 登录卡片：改为居中毛玻璃风格 --- */
        .login-card {
            position: relative;
            z-index: 10;
            width: 100%;
            max-width: 420px;
            background: var(--glass-bg);
            border-radius: 24px;
            box-shadow: var(--shadow-card);
            padding: 40px 35px;
            border: 1px solid var(--glass-border);
            backdrop-filter: blur(20px);
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* 顶部 Logo 区 */
        .header { text-align: center; margin-bottom: 30px; }
        .paw-logo {
            font-size: 50px;
            background: linear-gradient(135deg, #00c6ff 0%, #0072ff 100%);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
            display: inline-block;
        }
        .header h2 { color: var(--dark-blue); font-size: 24px; font-weight: 700; }
        .header p { color: #668; font-size: 14px; margin-top: 5px; }

        /* 表单控件 */
        .form-group { margin-bottom: 20px; position: relative; }
        .form-label {
            display: block; font-size: 13px; font-weight: 600;
            color: #556; margin-bottom: 8px; margin-left: 5px;
        }

        .input-container { position: relative; }

        .form-input {
            width: 100%;
            padding: 14px 16px 14px 45px; /* 左侧留出图标位置 */
            font-size: 15px;
            border: 2px solid transparent;
            border-radius: 15px; /* 更圆润 */
            background: var(--input-bg);
            color: #333;
            outline: none;
            transition: all 0.3s;
        }

        .form-input:focus {
            background: #fff;
            border-color: var(--primary-blue);
            box-shadow: 0 5px 15px rgba(79, 172, 254, 0.2);
        }

        /* 输入框内的图标 */
        .input-icon {
            position: absolute; left: 15px; top: 50%; transform: translateY(-50%);
            color: #aab; font-size: 16px; transition: color 0.3s;
        }
        .form-input:focus + .input-icon { color: var(--primary-blue); }

        /* 密码切换眼睛 */
        .toggle-password {
            position: absolute; right: 15px; top: 50%; transform: translateY(-50%);
            color: #aab; cursor: pointer; font-size: 16px; border: none; background: none;
        }
        .toggle-password:hover { color: var(--primary-blue); }

        /* 验证码区域 */
        .captcha-row { display: flex; gap: 10px; align-items: center; }
        .captcha-input { flex: 1; }
        .captcha-img {
            height: 48px; border-radius: 12px; cursor: pointer;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            transition: transform 0.2s;
        }
        .captcha-img:active { transform: scale(0.95); }

        /* 提交按钮 - 统一渐变色 */
        .btn-submit {
            width: 100%;
            padding: 16px;
            background: linear-gradient(90deg, #00c6ff 0%, #0072ff 100%);
            color: white;
            border: none;
            border-radius: 50px; /* 胶囊按钮 */
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            box-shadow: 0 10px 20px rgba(0, 114, 255, 0.3);
            transition: transform 0.2s, box-shadow 0.2s;
            margin-top: 10px;
        }
        .btn-submit:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 30px rgba(0, 114, 255, 0.4);
        }

        /* 错误提示 */
        .alert-box {
            background: #ffecec; color: #ff5252; padding: 12px;
            border-radius: 12px; font-size: 13px; margin-bottom: 20px;
            display: flex; align-items: center; gap: 8px; border: 1px solid #ffcaca;
        }

        /* 底部链接 */
        .footer-links {
            margin-top: 25px; text-align: center; font-size: 13px; color: #778;
        }
        .link { color: var(--dark-blue); font-weight: 600; text-decoration: none; transition: color 0.2s; }
        .link:hover { color: var(--primary-blue); text-decoration: underline; }

        /* 返回首页 */
        .back-home {
            position: absolute; top: 30px; left: 30px;
            color: white; text-decoration: none; font-weight: 600;
            display: flex; align-items: center; gap: 8px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.2); z-index: 20;
        }
        .back-home:hover { opacity: 0.8; }
    </style>
</head>
<body>

<div class="floating-elements">
    <i class="fa fa-paw float-icon i1"></i>
    <i class="fa fa-heart float-icon i2"></i>
    <i class="fa fa-linux float-icon i3"></i> <i class="fa fa-bone float-icon i4"></i>
</div>

<a href="${pageContext.request.contextPath}/index.html" class="back-home">
    <i class="fa fa-arrow-left"></i> Back to Home
</a>

<div class="login-card">
    <div class="header">
        <i class="fa fa-paw paw-logo"></i>
        <h2>Welcome Back</h2>
        <p>Sign in to continue your pet journey</p>
    </div>

    <form action="signOn" method="post" id="loginForm">

        <c:if test="${requestScope.loginMsg != null}">
            <div class="alert-box">
                <i class="fa fa-exclamation-circle"></i> ${requestScope.loginMsg}
            </div>
        </c:if>

        <div class="form-group">
            <label class="form-label">Username</label>
            <div class="input-container">
                <input class="form-input" type="text" name="username" placeholder="Enter your username" required>
                <i class="fa fa-user input-icon"></i>
            </div>
        </div>

        <div class="form-group">
            <label class="form-label">Password</label>
            <div class="input-container">
                <input class="form-input" type="password" name="password" id="password" placeholder="Enter your password" required>
                <i class="fa fa-lock input-icon"></i>
                <button type="button" class="toggle-password" onclick="togglePwd()">
                    <i class="fa fa-eye-slash" id="eyeIcon"></i>
                </button>
            </div>
            <div style="text-align: right; margin-top: 6px;">
                <a href="#" style="font-size: 12px; color: #889; text-decoration: none;">Forgot Password?</a>
            </div>
        </div>

        <div class="form-group">
            <label class="form-label">Security Code</label>
            <div class="captcha-row">
                <div class="input-container captcha-input">
                    <input class="form-input" type="text" name="captcha" placeholder="Code" maxlength="4" required>
                    <i class="fa fa-shield input-icon"></i>
                </div>
                <img id="captchaImg" class="captcha-img" src="CaptchaServlet" alt="Captcha" onclick="refreshCaptcha()" title="Tap to refresh">
            </div>
        </div>

        <button type="submit" class="btn-submit">
            Sign In
        </button>

        <div class="footer-links">
            Don't have an account? <a href="registerForm" class="link">Create Account</a>
        </div>
    </form>
</div>

<script>
    // 刷新验证码
    function refreshCaptcha(){
        var img = document.getElementById('captchaImg');
        if (img) img.src = 'CaptchaServlet?ts=' + Date.now();
    }

    // 密码显隐切换
    function togglePwd(){
        var input = document.getElementById('password');
        var icon = document.getElementById('eyeIcon');
        if (input.type === "password") {
            input.type = "text";
            icon.className = "fa fa-eye";
            icon.style.color = "#4facfe";
        } else {
            input.type = "password";
            icon.className = "fa fa-eye-slash";
            icon.style.color = "#aab";
        }
    }
</script>
</body>
</html>