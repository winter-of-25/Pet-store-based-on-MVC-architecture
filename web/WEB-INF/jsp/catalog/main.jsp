<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>
<%@ include file="../common/top.jsp"%>

<%
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
%>

<style>
    :root {
        --brand-primary: #3b82f6;
        --brand-dark: #1d4ed8;
        --brand-light: #eff6ff;
        --text-main: #0f172a;
        --text-sub: #64748b;
        --bg-page: #f8fafc;
        --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
        --radius-lg: 16px;
        --radius-md: 12px;
    }

    body {
        background-color: var(--bg-page);
        color: var(--text-main);
        font-family: 'Poppins', -apple-system, BlinkMacSystemFont, sans-serif;
    }

    .main-container {
        max-width: 1200px;
        margin: 30px auto 80px;
        padding: 0 20px;
    }

    /* 欢迎条 */
    .welcome-bar {
        background: white;
        padding: 12px 20px;
        border-radius: var(--radius-md);
        box-shadow: var(--card-shadow);
        margin-bottom: 24px;
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 14px;
        border-left: 4px solid var(--brand-primary);
    }

    /* --- 核心布局区域 (左导航 + 右轮播) --- */
    .hero-section {
        display: grid;
        grid-template-columns: 260px 1fr;
        gap: 24px;
        margin-bottom: 40px;
        height: 480px;
    }

    /* 左侧导航菜单 */
    .category-menu {
        background: white;
        border-radius: var(--radius-lg);
        box-shadow: var(--card-shadow);
        display: flex;
        flex-direction: column;
        overflow: hidden;
        height: 100%;
    }

    .menu-header {
        background: var(--brand-primary);
        color: white;
        padding: 18px 20px;
        font-weight: 600;
        font-size: 16px;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .menu-item {
        flex: 1;
        display: flex;
        align-items: center;
        padding: 0 20px;
        text-decoration: none;
        color: var(--text-main);
        transition: all 0.2s;
        border-left: 3px solid transparent;
        gap: 15px;
    }

    .menu-item:hover {
        background-color: var(--brand-light);
        border-left-color: var(--brand-primary);
        padding-left: 25px;
        color: var(--brand-primary);
    }

    .menu-icon { font-size: 18px; width: 24px; text-align: center; color: #94a3b8; }
    .menu-item:hover .menu-icon { color: var(--brand-primary); }
    .menu-text h4 { margin: 0; font-size: 14px; font-weight: 600; }
    .menu-text p { margin: 2px 0 0; font-size: 11px; color: var(--text-sub); }

    /* 右侧轮播图 */
    .carousel-container {
        background: white;
        border-radius: var(--radius-lg);
        box-shadow: var(--card-shadow);
        overflow: hidden;
        position: relative;
        height: 100%;
    }

    .slide {
        position: absolute; inset: 0;
        opacity: 0; transition: opacity 0.6s ease-in-out;
        z-index: 0;
    }
    .slide.active { opacity: 1; z-index: 1; }

    .slide img {
        width: 100%; height: 100%;
        object-fit: cover;
    }

    /* 轮播文字层 */
    .slide-content {
        position: absolute;
        bottom: 30px; left: 30px;
        background: rgba(255, 255, 255, 0.9);
        backdrop-filter: blur(8px);
        padding: 20px 30px;
        border-radius: var(--radius-md);
        max-width: 400px;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
    }
    .slide-title { font-size: 24px; font-weight: 700; color: var(--text-main); margin-bottom: 5px; }
    .slide-desc { font-size: 14px; color: var(--text-sub); }
    .btn-shop {
        display: inline-block;
        margin-top: 10px;
        padding: 8px 20px;
        background: var(--brand-primary);
        color: white;
        text-decoration: none;
        border-radius: 20px;
        font-size: 13px;
        font-weight: 600;
        transition: background 0.2s;
    }
    .btn-shop:hover { background: var(--brand-dark); }

    /* 轮播控制 */
    .carousel-arrow {
        position: absolute; top: 50%; transform: translateY(-50%);
        width: 40px; height: 40px;
        background: rgba(255,255,255,0.8); border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
        cursor: pointer; z-index: 2;
        transition: all 0.3s;
        color: var(--text-main);
    }
    .carousel-arrow:hover { background: white; color: var(--brand-primary); }
    .prev { left: 20px; }
    .next { right: 20px; }

    /* --- 1. 服务保障条 --- */
    .features-bar {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 20px;
        margin-bottom: 40px;
    }
    .feature-item {
        background: white;
        padding: 20px;
        border-radius: var(--radius-md);
        display: flex;
        align-items: center;
        gap: 15px;
        box-shadow: var(--card-shadow);
        border: 1px solid transparent;
        transition: all 0.2s;
    }
    .feature-item:hover {
        transform: translateY(-3px);
        border-color: var(--brand-light);
        box-shadow: 0 10px 20px rgba(0,0,0,0.05);
    }
    .f-icon { font-size: 24px; color: var(--brand-primary); width: 40px; text-align: center; }
    .f-text h5 { margin: 0; font-size: 15px; font-weight: 600; }
    .f-text p { margin: 2px 0 0; font-size: 12px; color: var(--text-sub); }

    /* --- 2. 热门推荐 --- */
    .section-title {
        font-size: 24px;
        font-weight: 700;
        margin-bottom: 24px;
        color: var(--text-main);
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .section-link { font-size: 14px; color: var(--brand-primary); text-decoration: none; font-weight: 600; }

    .product-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 24px;
    }

    /* 卡片样式：无图，使用图标 */
    .product-card {
        background: white;
        border-radius: var(--radius-lg);
        overflow: hidden;
        box-shadow: var(--card-shadow);
        transition: all 0.3s ease;
        text-decoration: none;
        color: inherit;
        display: flex;
        flex-direction: column;
        height: 240px;
        border: 1px solid transparent;
    }

    /* 视觉区域 */
    .p-visual {
        flex: 1;
        background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 60px;
        color: var(--brand-primary);
        transition: all 0.3s ease;
    }

    /* 信息区域 */
    .p-info {
        padding: 20px;
        background: white;
        text-align: center;
    }

    .p-cat {
        font-size: 11px;
        color: var(--text-sub);
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 1px;
        margin-bottom: 5px;
    }

    .p-title {
        margin: 0;
        font-size: 18px;
        font-weight: 700;
        color: var(--text-main);
    }

    /* 悬停特效 */
    .product-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 30px rgba(59, 130, 246, 0.15);
    }

    .product-card:hover .p-visual {
        background: var(--brand-primary);
        color: white;
        font-size: 70px;
    }

    @media (max-width: 900px) {
        .hero-section { grid-template-columns: 1fr; height: auto; }
        .category-menu { display: none; }
        .features-bar { grid-template-columns: repeat(2, 1fr); }
        .product-grid { grid-template-columns: repeat(2, 1fr); }
    }
</style>

<div class="main-container">

    <c:if test="${not empty sessionScope.loginAccount}">
        <div class="welcome-bar">
            <span>👋 Welcome back, <b>${sessionScope.loginAccount.username}</b>!</span>
        </div>
    </c:if>

    <section class="hero-section">
        <aside class="category-menu">
            <div class="menu-header">
                <i class="fa fa-list"></i> Categories
            </div>

            <a href="categoryForm?categoryId=FISH" class="menu-item">
                <i class="fa fa-tint menu-icon"></i> <div class="menu-text">
                <h4>Fish</h4>
                <p>Aquatic Life</p>
            </div>
            </a>
            <a href="categoryForm?categoryId=DOGS" class="menu-item">
                <i class="fa fa-heart menu-icon"></i> <div class="menu-text">
                <h4>Dogs</h4>
                <p>Loyal Friends</p>
            </div>
            </a>
            <a href="categoryForm?categoryId=CATS" class="menu-item">
                <i class="fa fa-star menu-icon"></i> <div class="menu-text">
                <h4>Cats</h4>
                <p>Cute & Fluffy</p>
            </div>
            </a>
            <a href="categoryForm?categoryId=REPTILES" class="menu-item">
                <i class="fa fa-leaf menu-icon"></i> <div class="menu-text">
                <h4>Reptiles</h4>
                <p>Exotic Pets</p>
            </div>
            </a>
            <a href="categoryForm?categoryId=BIRDS" class="menu-item">
                <i class="fa fa-paper-plane menu-icon"></i> <div class="menu-text">
                <h4>Birds</h4>
                <p>Fly High</p>
            </div>
            </a>
        </aside>

        <div class="carousel-container">
            <div class="slide active">
                <img src="${pageContext.request.contextPath}/images/mfish.png" alt="Fish">
                <div class="slide-content">
                    <div class="slide-title">Underwater Beauty</div>
                    <div class="slide-desc">Peaceful aquarium life.</div>
                    <a href="categoryForm?categoryId=FISH" class="btn-shop">Shop Fish &rarr;</a>
                </div>
            </div>
            <div class="slide">
                <img src="${pageContext.request.contextPath}/images/mdog.png" alt="Dogs">
                <div class="slide-content">
                    <div class="slide-title">Loyal Companions</div>
                    <div class="slide-desc">Puppies that bring joy.</div>
                    <a href="categoryForm?categoryId=DOGS" class="btn-shop">Shop Dogs &rarr;</a>
                </div>
            </div>
            <div class="slide">
                <img src="${pageContext.request.contextPath}/images/mcat.png" alt="Cats">
                <div class="slide-content">
                    <div class="slide-title">Feline Friends</div>
                    <div class="slide-desc">Cute kittens for you.</div>
                    <a href="categoryForm?categoryId=CATS" class="btn-shop">Shop Cats &rarr;</a>
                </div>
            </div>
            <div class="slide">
                <img src="${pageContext.request.contextPath}/images/mbird.png" alt="Birds">
                <div class="slide-content">
                    <div class="slide-title">Take Flight</div>
                    <div class="slide-desc">Colorful birds singing.</div>
                    <a href="categoryForm?categoryId=BIRDS" class="btn-shop">Shop Birds &rarr;</a>
                </div>
            </div>

            <div class="carousel-arrow prev" onclick="moveSlide(-1)">&#10094;</div>
            <div class="carousel-arrow next" onclick="moveSlide(1)">&#10095;</div>
        </div>
    </section>

    <section class="features-bar">
        <div class="feature-item">
            <i class="fa fa-truck f-icon"></i>
            <div class="f-text">
                <h5>Fast Delivery</h5>
                <p>Safe animal transport</p>
            </div>
        </div>
        <div class="feature-item">
            <i class="fa fa-heartbeat f-icon"></i>
            <div class="f-text">
                <h5>Health Check</h5>
                <p>Vet certified pets</p>
            </div>
        </div>
        <div class="feature-item">
            <i class="fa fa-comments f-icon"></i>
            <div class="f-text">
                <h5>24/7 Support</h5>
                <p>Expert pet advice</p>
            </div>
        </div>
        <div class="feature-item">
            <i class="fa fa-shield f-icon"></i>
            <div class="f-text">
                <h5>Secure Payment</h5>
                <p>100% safe checkout</p>
            </div>
        </div>
    </section>

    <section>
        <div class="section-title">
            Trending Categories
            <a href="#" class="section-link">View All <i class="fa fa-angle-right"></i></a>
        </div>
        <div class="product-grid">
            <a href="categoryForm?categoryId=DOGS" class="product-card">
                <div class="p-visual">
                    <i class="fa fa-heart"></i>
                </div>
                <div class="p-info">
                    <div class="p-cat">Category</div>
                    <div class="p-title">Dogs</div>
                </div>
            </a>

            <a href="categoryForm?categoryId=CATS" class="product-card">
                <div class="p-visual">
                    <i class="fa fa-star"></i>
                </div>
                <div class="p-info">
                    <div class="p-cat">Category</div>
                    <div class="p-title">Cats</div>
                </div>
            </a>

            <a href="categoryForm?categoryId=BIRDS" class="product-card">
                <div class="p-visual">
                    <i class="fa fa-paper-plane"></i>
                </div>
                <div class="p-info">
                    <div class="p-cat">Category</div>
                    <div class="p-title">Birds</div>
                </div>
            </a>

            <a href="categoryForm?categoryId=FISH" class="product-card">
                <div class="p-visual">
                    <i class="fa fa-tint"></i>
                </div>
                <div class="p-info">
                    <div class="p-cat">Category</div>
                    <div class="p-title">Fish</div>
                </div>
            </a>
        </div>
    </section>

</div>

<script>
    // 轮播逻辑
    let slideIndex = 0;
    const slides = document.querySelectorAll('.slide');
    let timer;

    function showSlides(n) {
        if (n >= slides.length) slideIndex = 0;
        if (n < 0) slideIndex = slides.length - 1;
        slides.forEach(slide => slide.classList.remove('active'));
        slides[slideIndex].classList.add('active');
    }

    function moveSlide(n) {
        slideIndex += n;
        showSlides(slideIndex);
        resetTimer();
    }

    function autoPlay() {
        slideIndex++;
        showSlides(slideIndex);
    }

    function resetTimer() {
        clearInterval(timer);
        timer = setInterval(autoPlay, 5000);
    }

    if(slides.length > 0) {
        timer = setInterval(autoPlay, 5000);
    }
</script>

<%@ include file="../common/bottom.jsp"%>