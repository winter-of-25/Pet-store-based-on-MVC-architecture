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
    <title>JPetStore - Create Account</title>
    <link href="https://cdn.jsdelivr.net/npm/font-awesome@4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-blue: #4facfe;
            --dark-blue: #094b65;
            --glass-bg: rgba(255, 255, 255, 0.94); /* 稍微不透明一点，因为内容多 */
            --glass-border: rgba(255, 255, 255, 0.8);
            --input-bg: #f8fbff;
            --text-color: #334;
            --radius: 12px;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            min-height: 100vh;
            font-family: 'Poppins', sans-serif;
            /* 保持一致的阳光背景 */
            background: url('https://images.unsplash.com/photo-1623387641168-d9803ddd3f35?q=80&w=2070&auto=format&fit=crop') no-repeat center center fixed;
            background-size: cover;
            padding: 40px 20px;
            color: var(--text-color);
            position: relative;
            /* 允许页面滚动 */
            overflow-y: auto;
        }

        /* 暖色光晕遮罩 */
        body::before {
            content: '';
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            background: linear-gradient(to bottom, rgba(255, 255, 255, 0.2) 0%, rgba(79, 172, 254, 0.4) 100%);
            backdrop-filter: blur(5px);
            z-index: 0;
            position: fixed; /* 固定遮罩，防止滚动时背景断裂 */
        }

        /* --- 漂浮装饰元素 --- */
        .floating-elements {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            overflow: hidden; z-index: 1; pointer-events: none;
        }
        .float-icon {
            position: absolute; color: rgba(255, 255, 255, 0.45);
            filter: drop-shadow(0 0 5px rgba(100, 200, 255, 0.2));
            animation: floatAround 25s linear infinite;
        }
        .i1 { top: 10%; left: 8%; font-size: 40px; animation-duration: 28s; }
        .i2 { top: 20%; right: 10%; font-size: 30px; animation-duration: 22s; animation-delay: -5s;}
        .i3 { bottom: 15%; left: 15%; font-size: 50px; animation-duration: 35s; animation-delay: -10s;}

        @keyframes floatAround {
            0% { transform: translate(0, 0) rotate(0deg); }
            50% { transform: translate(30px, -30px) rotate(15deg); }
            100% { transform: translate(0, 0) rotate(0deg); }
        }

        /* --- 返回按钮 --- */
        .back-btn {
            position: fixed; top: 30px; left: 30px; z-index: 100;
            color: white; text-decoration: none; font-weight: 600;
            text-shadow: 0 2px 4px rgba(0,0,0,0.2); transition: transform 0.2s;
        }
        .back-btn:hover { transform: translateX(-5px); }

        /* --- 主注册卡片 --- */
        .register-card {
            position: relative; z-index: 10;
            max-width: 900px; /* 宽一点，放双列 */
            margin: 0 auto;
            background: var(--glass-bg);
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(0, 50, 100, 0.15);
            border: 1px solid var(--glass-border);
            backdrop-filter: blur(20px);
            padding: 40px 50px;
        }

        .card-header { text-align: center; margin-bottom: 40px; }
        .card-header h2 {
            font-size: 32px; color: var(--dark-blue); font-weight: 700;
            margin-bottom: 10px;
        }
        .card-header p { color: #667; }

        /* --- 表单分块 --- */
        .form-section { margin-bottom: 35px; }
        .section-title {
            font-size: 16px; color: var(--primary-blue); font-weight: 700;
            margin-bottom: 20px; padding-bottom: 10px;
            border-bottom: 2px dashed #e0e7ff;
            display: flex; align-items: center; gap: 10px;
        }

        /* 网格布局：PC端两列，手机端一列 */
        .form-grid {
            display: grid; grid-template-columns: 1fr 1fr; gap: 20px 30px;
        }

        /* 输入框样式 */
        .form-group { position: relative; }
        .form-label {
            display: block; font-size: 13px; font-weight: 600;
            color: #556; margin-bottom: 8px;
        }

        .input-wrapper { position: relative; }

        .form-input, .form-select {
            width: 100%;
            padding: 12px 15px 12px 40px; /* 左侧留图标位 */
            border: 2px solid transparent;
            background: var(--input-bg);
            border-radius: 12px;
            font-size: 14px;
            color: #333;
            outline: none;
            transition: all 0.3s;
            font-family: inherit;
        }

        .form-input:focus, .form-select:focus {
            background: #fff;
            border-color: var(--primary-blue);
            box-shadow: 0 4px 12px rgba(79, 172, 254, 0.15);
        }

        /* 输入框图标 */
        .input-icon {
            position: absolute; left: 14px; top: 50%; transform: translateY(-50%);
            color: #aab; font-size: 14px; transition: color 0.3s;
            pointer-events: none;
        }
        .form-input:focus + .input-icon, .form-select:focus + .input-icon { color: var(--primary-blue); }

        /* 验证码特殊处理 */
        .captcha-row { display: flex; gap: 15px; align-items: center; }
        .captcha-img {
            height: 45px; border-radius: 8px; cursor: pointer;
            border: 1px solid #ddd;
        }
        .refresh-text { font-size: 12px; color: var(--primary-blue); cursor: pointer; text-decoration: none;}

        /* 复选框美化 */
        .checkbox-group {
            display: flex; gap: 20px; margin-top: 10px;
            background: #f0f7ff; padding: 15px; border-radius: 12px;
        }
        .checkbox-item { display: flex; align-items: center; gap: 8px; font-size: 13px; cursor: pointer; }
        .checkbox-item input { accent-color: var(--primary-blue); width: 16px; height: 16px;}

        /* 提交按钮 */
        .submit-area { margin-top: 40px; text-align: center; }
        .btn-submit {
            background: linear-gradient(90deg, #00c6ff 0%, #0072ff 100%);
            color: white; border: none; padding: 16px 60px;
            border-radius: 50px; font-size: 16px; font-weight: 700;
            cursor: pointer; box-shadow: 0 10px 25px rgba(0, 114, 255, 0.3);
            transition: all 0.3s; display: inline-block;
        }
        .btn-submit:hover {
            transform: translateY(-3px); box-shadow: 0 15px 35px rgba(0, 114, 255, 0.4);
        }
        .btn-submit:disabled { background: #ccc; cursor: not-allowed; transform: none; box-shadow: none; }

        /* 提示信息 */
        .msg-tip { font-size: 12px; margin-top: 5px; min-height: 18px; }

        @media (max-width: 768px) {
            .form-grid { grid-template-columns: 1fr; }
            .register-card { padding: 30px 20px; }
        }
    </style>

    <script>
        // 1. AJAX 检查用户名逻辑 (保持不变)
        function checkUsername() {
            var usernameInput = document.getElementById("username");
            var tip = document.getElementById("usernameTip");
            var val = usernameInput.value.trim();
            var submitBtn = document.getElementById("submitBtn");

            tip.innerHTML = "";
            usernameInput.style.borderColor = "";

            if (val === "") return;

            var xhr = new XMLHttpRequest();
            xhr.open("GET", "usernameCheck?username=" + encodeURIComponent(val) + "&t=" + new Date().getTime(), true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    var result = xhr.responseText;
                    if (result === "EXIST") {
                        tip.innerHTML = "<i class='fa fa-times-circle'></i> Username already taken";
                        tip.style.color = "#ff5252";
                        usernameInput.style.borderColor = "#ff5252";
                        if(submitBtn) submitBtn.disabled = true;
                    } else if (result === "OK") {
                        tip.innerHTML = "<i class='fa fa-check-circle'></i> Username available";
                        tip.style.color = "#4caf50";
                        usernameInput.style.borderColor = "#4caf50";
                        if(submitBtn) submitBtn.disabled = false;
                    }
                }
            };
            xhr.send();
        }

        // 2. 验证码刷新
        function logRefreshCaptcha(e){
            if (e) e.preventDefault();
            var img = document.getElementById('captchaImg');
            if (img) img.src = 'CaptchaServlet?ts=' + Date.now();
            return false;
        }

        // 3. 密码显隐
        function togglePwd(){
            var el = document.querySelector('input[name="password"]');
            var icon = document.getElementById('pwdIcon');
            if(!el) return;
            if (el.type === 'password') {
                el.type = 'text';
                icon.className = 'fa fa-eye';
            } else {
                el.type = 'password';
                icon.className = 'fa fa-eye-slash';
            }
        }
    </script>
</head>
<body>

<div class="floating-elements">
    <i class="fa fa-paw float-icon i1"></i>
    <i class="fa fa-heart float-icon i2"></i>
    <i class="fa fa-bone float-icon i3"></i>
</div>

<a href="signOnForm" class="back-btn">
    <i class="fa fa-arrow-left"></i> Back to Login
</a>

<div class="register-card">
    <div class="card-header">
        <h2>Create Account</h2>
        <p>Join our community to give your pets the best love.</p>
    </div>

    <form action="register" method="post">

        <c:if test="${requestScope.loginMsg != null}">
            <div style="background:#ffebee; color:#d32f2f; padding:10px; border-radius:8px; margin-bottom:20px; text-align:center;">
                    ${requestScope.loginMsg}
            </div>
        </c:if>

        <div class="form-section">
            <div class="section-title"><i class="fa fa-id-card"></i> Account Info</div>
            <div class="form-grid">
                <div class="form-group">
                    <label class="form-label">Username</label>
                    <div class="input-wrapper">
                        <input class="form-input" type="text" id="username" name="username" placeholder="Choose a username" onblur="checkUsername()" required>
                        <i class="fa fa-user input-icon"></i>
                    </div>
                    <div id="usernameTip" class="msg-tip"></div>
                </div>
                <div class="form-group">
                    <label class="form-label">Password</label>
                    <div class="input-wrapper">
                        <input class="form-input" type="password" name="password" placeholder="Min. 8 characters" required>
                        <i class="fa fa-lock input-icon"></i>
                        <span onclick="togglePwd()" style="position:absolute; right:15px; top:50%; transform:translateY(-50%); cursor:pointer; color:#999;">
                                <i class="fa fa-eye-slash" id="pwdIcon"></i>
                            </span>
                    </div>
                </div>
            </div>
        </div>

        <div class="form-section">
            <div class="section-title"><i class="fa fa-user-circle"></i> Personal Details</div>
            <div class="form-grid">
                <div class="form-group">
                    <label class="form-label">First Name</label>
                    <div class="input-wrapper">
                        <input class="form-input" type="text" name="firstName" placeholder="First Name">
                        <i class="fa fa-pencil input-icon"></i>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Last Name</label>
                    <div class="input-wrapper">
                        <input class="form-input" type="text" name="lastName" placeholder="Last Name">
                        <i class="fa fa-pencil input-icon"></i>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Email</label>
                    <div class="input-wrapper">
                        <input class="form-input" type="email" name="email" placeholder="email@example.com">
                        <i class="fa fa-envelope input-icon"></i>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Phone</label>
                    <div class="input-wrapper">
                        <input class="form-input" type="text" name="phone" placeholder="Phone Number">
                        <i class="fa fa-phone input-icon"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="form-section">
            <div class="section-title"><i class="fa fa-map-marker"></i> Address</div>
            <div class="form-grid">
                <div class="form-group">
                    <label class="form-label">Address 1</label>
                    <div class="input-wrapper">
                        <input class="form-input" type="text" name="address1" placeholder="Street Address">
                        <i class="fa fa-home input-icon"></i>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Address 2</label>
                    <div class="input-wrapper">
                        <input class="form-input" type="text" name="address2" placeholder="Apt, Suite, etc. (Optional)">
                        <i class="fa fa-building input-icon"></i>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">City</label>
                    <div class="input-wrapper">
                        <input class="form-input" type="text" name="city" placeholder="City">
                        <i class="fa fa-building-o input-icon"></i>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">State</label>
                    <div class="input-wrapper">
                        <input class="form-input" type="text" name="state" placeholder="State/Province">
                        <i class="fa fa-map input-icon"></i>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Zip Code</label>
                    <div class="input-wrapper">
                        <input class="form-input" type="text" name="zip" placeholder="Zip Code">
                        <i class="fa fa-thumb-tack input-icon"></i>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Country</label>
                    <div class="input-wrapper">
                        <input class="form-input" type="text" name="country" placeholder="Country">
                        <i class="fa fa-globe input-icon"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="form-section">
            <div class="section-title"><i class="fa fa-sliders"></i> Preferences</div>
            <div class="form-grid">
                <div class="form-group">
                    <label class="form-label">Language</label>
                    <div class="input-wrapper">
                        <select class="form-select" name="languagePreference">
                            <option value="en-US">English</option>
                            <option value="zh-CN">Chinese</option>
                        </select>
                        <i class="fa fa-language input-icon"></i>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Favorite Category</label>
                    <div class="input-wrapper">
                        <select class="form-select" name="favouriteCategoryId">
                            <option value="DOGS">Dogs</option>
                            <option value="CATS">Cats</option>
                            <option value="BIRDS">Birds</option>
                            <option value="FISH">Fish</option>
                            <option value="REPTILES">Reptiles</option>
                        </select>
                        <i class="fa fa-heart input-icon"></i>
                    </div>
                </div>
                <div style="grid-column: 1 / -1;">
                    <div class="checkbox-group">
                        <label class="checkbox-item">
                            <input type="checkbox" name="listOption" value="true">
                            Enable MyList
                        </label>
                        <label class="checkbox-item">
                            <input type="checkbox" name="bannerOption" value="true">
                            Enable MyBanner
                        </label>
                    </div>
                </div>
            </div>
        </div>

        <div class="form-section">
            <div class="section-title"><i class="fa fa-shield"></i> Security Check</div>
            <div class="form-grid">
                <div class="form-group">
                    <div class="captcha-row">
                        <div class="input-wrapper" style="flex:1;">
                            <input class="form-input" type="text" name="captcha" placeholder="Enter code" maxlength="4" required>
                            <i class="fa fa-key input-icon"></i>
                        </div>
                        <img id="captchaImg" class="captcha-img" src="CaptchaServlet" onclick="logRefreshCaptcha(event)" title="Click to refresh">
                        <a href="#" class="refresh-text" onclick="return logRefreshCaptcha(event)">
                            <i class="fa fa-refresh"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="submit-area">
            <button type="submit" class="btn-submit" id="submitBtn">
                Create My Account <i class="fa fa-arrow-right" style="margin-left:8px;"></i>
            </button>
        </div>

    </form>
</div>

</body>
</html>