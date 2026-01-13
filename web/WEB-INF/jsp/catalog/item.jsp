<%@ include file="../common/top.jsp"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>

<%
    // 确保响应使用UTF-8编码
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
%>

<style>
    :root{
        --bg:#f6f7fb;--text:#0f172a;--muted:#6b7280;
        --card:rgba(255,255,255,.78);--card-border:rgba(15,23,42,.08);
        --accent:#6366f1;--accent2:#22d3ee;--ring:rgba(99,102,241,.22);
        --shadow:0 18px 40px rgba(2,6,23,.12);
        --danger:#ef4444;
    }
    @media (prefers-color-scheme: dark){
        :root{
            --bg:#0b1020;--text:#e5e7eb;--muted:#9ca3af;
            --card:rgba(13,18,36,.78);--card-border:rgba(148,163,184,.25);
            --accent:#60a5fa;--accent2:#8b5cf6;--ring:rgba(96,165,250,.28);
            --shadow:0 20px 45px rgba(0,0,0,.55);
        }
    }

    body{
        margin:0;
        background:
                radial-gradient(1200px 600px at -10% -10%, rgba(99,102,241,.18), transparent),
                radial-gradient(900px 600px at 110% 8%, rgba(34,211,238,.18), transparent),
                var(--bg);
        color:var(--text);
        font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "PingFang SC","Microsoft YaHei", Arial;
        -webkit-font-smoothing:antialiased;
        -moz-osx-font-smoothing:grayscale;
    }

    .wrap{
        max-width:980px;
        margin:48px auto 96px;
        padding:0 24px;
    }

    /* 返回上一层 —— 保留原有 href 和 onclick */
    #BackLink{
        margin-bottom:14px;
    }
    #BackLink a{
        display:inline-flex;
        align-items:center;
        gap:6px;
        padding:8px 14px;
        border-radius:999px;
        border:1px solid var(--card-border);
        background:rgba(15,23,42,.02);
        color:var(--accent);
        text-decoration:none;
        backdrop-filter:blur(10px);
        font-size:13px;
    }
    #BackLink a::before{content:"←";font-size:12px}
    #BackLink a:hover{
        box-shadow:0 0 0 8px var(--ring);
        text-decoration:none;
    }

    /* 主卡片 —— 保留 id=Catalog */
    #Catalog{
        background:var(--card);
        border:1px solid var(--card-border);
        border-radius:22px;
        box-shadow:var(--shadow);
        backdrop-filter:blur(14px);
        padding:22px 22px 18px;
    }

    /* 我们仍然用 table，但让它像信息卡片 */
    #Catalog table{
        width:100%;
        border-collapse:separate;
        border-spacing:0 10px;
    }
    #Catalog table tr td{
        background:rgba(255,255,255,.4);
        border-radius:14px;
        padding:14px 14px;
    }
    @media (prefers-color-scheme: dark){
        #Catalog table tr td{background:rgba(15,23,42,.45);}
    }

    /* 描述块 */
    .desc{
        background:transparent !important;
        padding-bottom:4px !important;
    }
    .desc p{
        margin:0;
        color:var(--muted);
        position: relative;
        cursor: pointer;
    }

    /* item 标题组合 */
    .item-title{
        font-size:20px;
        font-weight:800;
        line-height:1.4;
    }
    .item-id{
        display:inline-block;
        padding:3px 10px;
        border-radius:999px;
        background:rgba(99,102,241,.12);
        color:var(--accent);
        font-size:12px;
        margin-bottom:4px;
    }

    /* 库存区 */
    .stock-ok{
        color:#166534;
        background:rgba(22,101,52,.08);
        border-radius:999px;
        padding:5px 14px;
        display:inline-block;
        font-size:13px;
    }
    .stock-bad{
        color:var(--danger);
        background:rgba(239,68,68,.08);
        border-radius:999px;
        padding:5px 14px;
        display:inline-block;
        font-size:13px;
    }

    /* 价格 */
    .price{
        font-size:24px;
        font-weight:700;
        color:var(--text);
    }

    /* 按钮 —— 不改为 form，保持你的链接 onclick 行为 */
    .Button,
    .btn{
        display:inline-flex;
        align-items:center;
        justify-content:center;
        gap:6px;
        padding:10px 18px;
        border-radius:14px;
        border:1px solid transparent;
        background:linear-gradient(135deg,var(--accent),var(--accent2));
        color:#fff;
        font-weight:600;
        text-decoration:none;
        cursor:pointer;
    }
    .Button:hover,
    .btn:hover{box-shadow:0 0 0 8px var(--ring);text-decoration:none}

    @media (max-width:720px){
        #Catalog{padding:16px 16px 12px}
        #Catalog table{border-spacing:0 8px}
        .item-title{font-size:18px}
    }

    /* 商品信息提示框样式 */
    .product-tooltip {
        position: absolute;
        top: -10px;
        left: 50%;
        transform: translateX(-50%);
        background: var(--card);
        border: 1px solid var(--card-border);
        border-radius: 14px;
        box-shadow: var(--shadow);
        backdrop-filter: blur(14px);
        padding: 14px;
        z-index: 1000;
        width: 400px; /* 增加提示框宽度 */
        display: none;
        opacity: 0;
        transition: opacity 0.3s ease;
    }

    .product-tooltip.show {
        display: block;
        opacity: 1;
    }

    .product-tooltip img {
        width: 100%; /* 图片占满提示框宽度 */
        height: auto;
        border-radius: 8px;
        margin-bottom: 10px;
        object-fit: cover; /* 确保图片填充容器 */
    }

    .tooltip-content {
        color: var(--text);
    }

    .tooltip-content h4 {
        margin: 0 0 8px 0;
        font-size: 16px;
        font-weight: 600;
    }

    .tooltip-content p {
        margin: 0;
        font-size: 14px;
        color: var(--muted);
    }
</style>


<script>
    // 兜底，避免外面没定义 logEvent
    if (typeof window.logEvent !== 'function') {
        window.logEvent = function(type, msg){ try{ console.debug('[LOG]', type, msg || ''); }catch(e){} };
    }

    // 页面加载时记录商品详情浏览
    window.addEventListener('load', function() {
        var itemId = '${sessionScope.item.itemId}' || '未知商品';
        var productName = '${sessionScope.product.name}' || '未知产品';
        var price = '${sessionScope.item.listPrice}' || '0';
        var quantity = '${sessionScope.item.quantity}' || '0';

        logEvent('PRODUCT_VIEW', '浏览商品详情', productName, {
            itemId: itemId,
            productId: '${sessionScope.product.productId}',
            price: price,
            stock: parseInt(quantity) || 0,
            inStock: parseInt(quantity) > 0,
            user: '${sessionScope.loginAccount.username}' || '未登录用户',
            timestamp: new Date().toISOString()
        });
    });

    // 增强版添加到购物车记录
    function logAddToCartFromItem() {
        var itemId = '${sessionScope.item.itemId}' || '未知商品';
        var itemDesc = '${sessionScope.item.attribute1} ${sessionScope.item.attribute2}' || '未知商品';
        var price = '${sessionScope.item.listPrice}' || '0';
        var quantity = '${sessionScope.item.quantity}' || '0';

        logEvent('ADD_TO_CART', '从详情页添加商品到购物车', itemDesc, {
            itemId: itemId,
            productId: '${sessionScope.product.productId}',
            price: price,
            stock: parseInt(quantity) || 0,
            fromPage: 'item_detail',
            user: '${sessionScope.loginAccount.username}' || '未登录用户',
            timestamp: new Date().toISOString()
        });

        alert('商品已添加到购物车！');
    }

    // 商品信息提示框功能
    document.addEventListener('DOMContentLoaded', function() {
        // 创建提示框元素
        var tooltip = document.createElement('div');
        tooltip.className = 'product-tooltip';
        document.body.appendChild(tooltip);

        var hoverTimer;
        var descElement = document.querySelector('.desc p');

        // 鼠标悬停事件
        descElement.addEventListener('mouseenter', function(e) {
            // 清除之前的定时器
            if (hoverTimer) {
                clearTimeout(hoverTimer);
            }

            // 设置一秒后显示提示框
            hoverTimer = setTimeout(function() {
                // 使用XHR获取商品信息
                var xhr = new XMLHttpRequest();
                xhr.open('GET', 'productForm?productId=${sessionScope.product.productId}', true);

                xhr.onload = function() {
                    if (xhr.status === 200) {
                        // 创建临时div来解析响应
                        var tempDiv = document.createElement('div');
                        tempDiv.innerHTML = xhr.responseText;

                        // 提取商品信息（这里假设可以从响应中提取，实际可能需要调整）
                        var productName = '${sessionScope.product.name}';
                        var productId = '${sessionScope.product.productId}';
                        var description = '${sessionScope.product.description}';
                        var price = '${sessionScope.item.listPrice}';

                        // 构建提示框内容
                        var imgUrl = description; // 假设描述中直接是图片URL
                        tooltip.innerHTML = `

                            <div class="tooltip-content">
                                <h4>${sessionScope.product.name}</h4>
                                <p>产品ID: ${sessionScope.item.itemId}</p>
                                <p>价格: $${sessionScope.item.listPrice}</p>
                            </div>
                        `;

                        // 定位提示框
                        var rect = e.target.getBoundingClientRect();
                        tooltip.style.top = (rect.top - tooltip.offsetHeight - 10) + 'px';
                        tooltip.style.left = (rect.left + rect.width / 2 - tooltip.offsetWidth / 2) + 'px';

                        // 显示提示框
                        tooltip.classList.add('show');
                    }
                };

                xhr.send();
            }, 1000); // 一秒延迟
        });

        // 鼠标离开事件
        descElement.addEventListener('mouseleave', function() {
            // 清除定时器
            if (hoverTimer) {
                clearTimeout(hoverTimer);
                hoverTimer = null;
            }

            // 隐藏提示框
            tooltip.classList.remove('show');
        });
    });
</script>

<div class="wrap">
    <div id="BackLink">
        <a href="productForm?productId=${sessionScope.product.productId}"
           onclick="logEvent('LINK_CLICK', '返回产品: ${sessionScope.product.productId}')">
            Return to ${sessionScope.product.productId}
        </a>
    </div>

    <div id="Catalog">
        <table>
            <!-- 描述 -->
            <tr>
                <td class="desc">
                    <p>${sessionScope.product.description}</p>
                </td>
            </tr>

            <!-- Item ID -->
            <tr>
                <td>
                    <span class="item-id">${sessionScope.item.itemId}</span>
                </td>
            </tr>

            <!-- 大标题：属性 + 名称 -->
            <tr>
                <td>
                    <div class="item-title">
                        ${sessionScope.item.attribute1}
                        ${sessionScope.item.attribute2}
                        ${sessionScope.item.attribute3}
                        ${sessionScope.item.attribute4}
                        ${sessionScope.item.attribute5}
                        ${sessionScope.product.name}
                    </div>
                </td>
            </tr>

            <!-- 产品名称 -->
            <tr>
                <td>
                    <span style="color:var(--muted)">${sessionScope.product.name}</span>
                </td>
            </tr>

            <!-- 库存 -->
            <tr>
                <td>
                    <c:if test="${sessionScope.item.quantity <= 0}">
                        <span class="stock-bad">Back ordered.</span>
                    </c:if>
                    <c:if test="${sessionScope.item.quantity > 0}">
                        <span class="stock-ok">${sessionScope.item.quantity} in stock.</span>
                    </c:if>
                </td>
            </tr>

            <!-- 价格 -->
            <tr>
                <td>
                 <span class="price">
                     <fmt:formatNumber value="${sessionScope.item.listPrice}"
                                       pattern="$#,##0.00" />
                 </span>
                </td>
            </tr>

            <!-- 加入购物车 -->
            <tr>
                <td>
                    <!-- 保持原有 js 行为，不改后端 -->
                    <a href="addItemToCart?workingItemId=${sessionScope.item.itemId}" class="Button" onclick="logAddToCartFromItem()">
                        Add to Cart
                    </a>
                </td>
            </tr>
        </table>
    </div>
</div>

<%@ include file="../common/bottom.jsp"%>