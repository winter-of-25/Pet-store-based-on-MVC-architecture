<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>MyPetStore</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<!--
PET STORE THEME - HEADER
风格：蓝白商业风格 (Blue & White Commerce)
-->
<style>
    :root {
        /* 核心配色 */
        --brand-primary: #3b82f6;       /* 主蓝色 */
        --brand-hover: #2563eb;         /* 悬停深蓝 */
        --header-bg: #ffffff;           /* 头部背景 */
        --text-main: #1e293b;           /* 主要文字 */
        --text-sub: #64748b;            /* 次要文字 */
        --border-color: #e2e8f0;        /* 边框灰 */
        --bg-light: #f8fafc;            /* 浅灰背景 */

        --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
        --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);

        --radius: 8px;
    }

    /* 头部容器 */
    #Header {
        background-color: var(--header-bg);
        border-bottom: 1px solid var(--border-color);
        box-shadow: var(--shadow-sm);
        position: sticky;
        top: 0;
        z-index: 100;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    }

    #Header .container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 15px 20px;
    }

    /* --- 第一行：Logo 与 右侧菜单 --- */
    .top-row {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 15px;
    }

    #LogoContent a {
        display: flex;
        align-items: center;
        text-decoration: none;
    }
    #LogoContent img {
        height: 40px; /* 稍微调大一点Logo */
        width: auto;
    }

    /* 右侧功能菜单 */
    #MenuContent {
        display: flex;
        align-items: center;
        gap: 15px;
    }

    #MenuContent a {
        color: var(--text-sub);
        text-decoration: none;
        font-size: 13px;
        font-weight: 500;
        transition: color 0.2s;
        display: flex;
        align-items: center;
        gap: 6px;
    }
    #MenuContent a:hover {
        color: var(--brand-primary);
    }

    #MenuContent img[name="img_cart"] {
        height: 20px;
        width: auto;
    }

    .sep {
        width: 1px;
        height: 14px;
        background-color: var(--border-color);
        display: inline-block;
    }

    /* --- 第二行：搜索条 --- */
    #Search {
        margin-bottom: 15px;
        display: flex;
        justify-content: center;
    }

    #SearchContent {
        position: relative;
        width: 100%;
        max-width: 600px; /* 限制搜索框最大宽度 */
    }

    #SearchContent form {
        display: flex;
        gap: 0; /* 紧贴 */
        box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        border-radius: 50px;
        overflow: hidden; /* 保证圆角 */
        border: 2px solid var(--brand-primary); /* 蓝色边框 */
    }

    #SearchContent input[type="text"] {
        flex: 1;
        padding: 12px 20px;
        border: none;
        outline: none;
        font-size: 14px;
        color: var(--text-main);
    }

    #SearchContent input[type="submit"] {
        background-color: var(--brand-primary);
        color: white;
        border: none;
        padding: 0 25px;
        font-weight: 600;
        font-size: 14px;
        cursor: pointer;
        transition: background-color 0.2s;
    }
    #SearchContent input[type="submit"]:hover {
        background-color: var(--brand-hover);
    }

    /* --- 自动补全列表 (白卡风格) --- */
    #suggestion-list {
        position: absolute;
        top: 100%;
        left: 0;
        right: 0; /* 宽度与搜索框一致 */
        background: white;
        border: 1px solid var(--border-color);
        border-top: none;
        border-radius: 0 0 12px 12px;
        margin-top: 2px;
        padding: 5px 0;
        list-style: none;
        display: none;
        z-index: 1000;
        box-shadow: var(--shadow-lg);
    }

    #suggestion-list li {
        padding: 10px 20px;
        cursor: pointer;
        font-size: 14px;
        color: var(--text-main);
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid var(--bg-light);
    }
    #suggestion-list li:last-child { border-bottom: none; }

    #suggestion-list li:hover {
        background-color: var(--bg-light);
        color: var(--brand-primary);
    }

    #suggestion-list li .product-id {
        font-size: 12px;
        color: var(--text-sub);
        background: #f1f5f9;
        padding: 2px 6px;
        border-radius: 4px;
    }

    /* --- 第三行：分类导航 (QuickLinks) --- */
    .hairline {
        height: 1px;
        background: var(--border-color);
        margin: 0 -20px 15px; /* 全宽分隔线 */
        opacity: 0.6;
    }

    #QuickLinks {
        display: flex;
        justify-content: center;
        gap: 15px;
        flex-wrap: wrap;
        padding-bottom: 5px;
    }

    /* 隐藏旧的分隔符，改用间距 */
    #QuickLinks .sep { display: none; }

    #QuickLinks a {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 8px 16px;
        background-color: var(--bg-light);
        border: 1px solid transparent;
        border-radius: 50px;
        text-decoration: none;
        color: var(--text-main);
        font-size: 13px;
        font-weight: 600;
        transition: all 0.2s;
    }

    #QuickLinks a:hover {
        background-color: white;
        border-color: var(--brand-primary);
        color: var(--brand-primary);
        box-shadow: var(--shadow-sm);
        transform: translateY(-1px);
    }

    #QuickLinks img {
        height: 20px;
        width: auto;
        filter: grayscale(100%); /* 默认黑白 */
        opacity: 0.7;
        transition: all 0.2s;
    }
    #QuickLinks a:hover img {
        filter: none; /* 悬停恢复彩色 */
        opacity: 1;
    }

    /* 响应式适配 */
    @media (max-width: 768px) {
        .top-row { flex-direction: column; gap: 10px; }
        #MenuContent { flex-wrap: wrap; justify-content: center; }
        #SearchContent form { border-radius: 8px; }
        #SearchContent input[type="text"] { width: 100%; }
    }
</style>

<script>
    function logEvent(type, action, target, extraData) {
        try { console.debug('[事件记录]', type, action, target, extraData); } catch (e) {}
    }

    document.addEventListener('DOMContentLoaded', function() {
        var input = document.getElementById('keywordInput');
        var list = document.getElementById('suggestion-list');
        var searchContent = document.getElementById('SearchContent');

        if(input && list) {
            input.addEventListener('input', function() {
                var keyword = this.value;
                if (!keyword || keyword.trim() === "") {
                    list.style.display = 'none'; return;
                }
                var xhr = new XMLHttpRequest();
                var url = "${pageContext.request.contextPath}/autocomplete?keyword=" + encodeURIComponent(keyword);
                xhr.open("GET", url, true);
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        try {
                            var data = JSON.parse(xhr.responseText);
                            renderSuggestions(data);
                        } catch(e) { console.error(e); }
                    }
                };
                xhr.send();
            });

            function renderSuggestions(data) {
                list.innerHTML = "";
                if (data.length === 0) { list.style.display = 'none'; return; }

                for (var i = 0; i < data.length; i++) {
                    var item = data[i];
                    var li = document.createElement("li");

                    // 左侧显示名称
                    var nameSpan = document.createElement("span");
                    nameSpan.textContent = item.name;

                    // 右侧显示 ID
                    var idSpan = document.createElement("span");
                    idSpan.className = "product-id";
                    idSpan.textContent = item.id;

                    li.appendChild(nameSpan);
                    li.appendChild(idSpan);

                    // 闭包处理点击
                    (function(val) {
                        li.addEventListener('click', function() {
                            input.value = val; // 填入 ID
                            list.style.display = 'none';
                            // 可选：自动提交
                            // input.form.submit();
                        });
                    })(item.id);

                    list.appendChild(li);
                }
                list.style.display = 'block';
            }

            // 点击外部关闭列表
            document.addEventListener('click', function(e) {
                if (!searchContent.contains(e.target)) { list.style.display = 'none'; }
            });
        }
    });
</script>

<div id="Header">
    <div class="container">

        <!-- 第一行：Logo + 右侧菜单 -->
        <div class="top-row">
            <div id="LogoContent">
                <a href="mainForm" onclick="logEvent('LINK_CLICK','点击Logo返回主页')">
                    <img src="images/logo-topbar.gif" alt="MyPetStore Logo">
                </a>
            </div>

            <div id="MenuContent" aria-label="User navigation">
                <a href="orderForm" onclick="logEvent('LINK_CLICK','点击订单')">Order</a>
                <span class="sep"></span>
                <!-- 购物车 -->
                <a href="cartForm" onclick="logEvent('LINK_CLICK','点击购物车')" title="Shopping Cart">
                    <img name="img_cart" src="images/cart.gif" alt="Cart">
                    <span>Cart</span>
                </a>
                <span class="sep"></span>

                <!-- 登录/登出 -->
                <c:choose>
                    <c:when test="${empty sessionScope.loginAccount}">
                        <a href="signOnForm" onclick="logEvent('LINK_CLICK','点击登录')">Sign In</a>
                    </c:when>
                    <c:otherwise>
                        <a href="signOnForm" onclick="logEvent('LINK_CLICK','点击退出')">Sign Out</a>
                    </c:otherwise>
                </c:choose>

                <span class="sep"></span>
                <a href="updateAcount" onclick="logEvent('LINK_CLICK','点击我的账户')">My Account</a>
                <span class="sep"></span>
                <a href="eventView" onclick="logEvent('LINK_CLICK','点击事件查看')">Event Log</a>
                <span class="sep"></span>
                <a href="help.html" onclick="logEvent('LINK_CLICK','点击帮助')">Help</a>
            </div>
        </div>

        <!-- 第二行：搜索条 -->
        <div id="Search">
            <div id="SearchContent">
                <form action="${pageContext.request.contextPath}/search" method="post"
                      onsubmit="logEvent('FORM_SUBMIT','提交搜索表单')">

                    <input type="text" id="keywordInput" name="keyword"
                           placeholder="Search for pets, food, or toys..."
                           required autocomplete="off">

                    <!-- 自动补全列表 -->
                    <ul id="suggestion-list"></ul>

                    <input type="submit" value="Search"
                           onclick="logEvent('BUTTON_CLICK','点击搜索按钮')">
                </form>
            </div>
        </div>

        <!-- 分隔线 -->
        <div class="hairline" aria-hidden="true"></div>

        <!-- 第三行：分类导航 (QuickLinks) -->
        <div id="QuickLinks" role="navigation" aria-label="Product categories">
            <a href="categoryForm?categoryId=FISH" onclick="logEvent('LINK_CLICK','点击鱼类分类')">
                <img src="images/sm_fish.gif" alt="">
                <span class="label">Fish</span>
            </a>

            <a href="categoryForm?categoryId=DOGS" onclick="logEvent('LINK_CLICK','点击狗类分类')">
                <img src="images/sm_dogs.gif" alt="">
                <span class="label">Dogs</span>
            </a>

            <a href="categoryForm?categoryId=CATS" onclick="logEvent('LINK_CLICK','点击猫类分类')">
                <img src="images/sm_cats.gif" alt="">
                <span class="label">Cats</span>
            </a>

            <a href="categoryForm?categoryId=REPTILES" onclick="logEvent('LINK_CLICK','点击爬行类分类')">
                <img src="images/sm_reptiles.gif" alt="">
                <span class="label">Reptiles</span>
            </a>

            <a href="categoryForm?categoryId=BIRDS" onclick="logEvent('LINK_CLICK','点击鸟类分类')">
                <img src="images/sm_birds.gif" alt="">
                <span class="label">Birds</span>
            </a>
        </div>

    </div>
</div>