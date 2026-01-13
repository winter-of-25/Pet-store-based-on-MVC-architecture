<%@ include file="../common/top.jsp"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>
<%
    // 确保响应使用UTF-8编码（不影响后端）
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
%>

<style>
    :root{
        --bg:#f6f7fb;--text:#0f172a;--muted:#6b7280;
        --card:rgba(255,255,255,.78);--card-border:rgba(15,23,42,.08);
        --accent:#6366f1;--accent2:#22d3ee;--ring:rgba(99,102,241,.22);
        --shadow:0 18px 40px rgba(2,6,23,.12);
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
        margin:0;color:var(--text);
        background:
                radial-gradient(1200px 600px at -10% -10%, rgba(99,102,241,.18), transparent),
                radial-gradient(900px 600px at 110% 8%, rgba(34,211,238,.18), transparent),
                var(--bg);
        font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "PingFang SC","Microsoft YaHei", Arial;
        -webkit-font-smoothing:antialiased; -moz-osx-font-smoothing:grayscale;
    }

    .wrap{max-width:1080px;margin:48px auto 96px;padding:0 24px}

    /* 返回链接按钮化：保持原 href 与 onclick */
    #BackLink{margin-bottom:14px}
    #BackLink a{
        display:inline-flex;align-items:center;gap:6px;
        padding:8px 14px;border-radius:999px;border:1px solid var(--card-border);
        background:rgba(15,23,42,.02);text-decoration:none;color:var(--accent);
        backdrop-filter:blur(10px);font-size:13px;
    }
    #BackLink a::before{content:"←";font-size:12px}
    #BackLink a:hover{box-shadow:0 0 0 8px var(--ring);text-decoration:none}

    /* 主卡片容器：保留 #Catalog，不改变后端 */
    #Catalog{
        background:var(--card);border:1px solid var(--card-border);
        border-radius:22px;box-shadow:var(--shadow);backdrop-filter:blur(14px);
        padding:22px;
    }
    #Catalog h2{
        margin:0 0 8px;font-size:26px;font-weight:800;
        background:linear-gradient(90deg,var(--text),var(--accent));
        -webkit-background-clip:text;background-clip:text;color:transparent;
    }
    #Catalog .sub{margin:2px 0 16px;color:var(--muted);font-size:13px}

    /* 表格美化与响应 */
    .table-wrap{overflow:auto;border:1px solid var(--card-border);border-radius:16px;background:rgba(255,255,255,.55)}
    @media (prefers-color-scheme: dark){ .table-wrap{background:rgba(15,23,42,.55)} }

    table.item-table{width:100%;min-width:720px;border-collapse:separate;border-spacing:0}
    .item-table thead th,.item-table tbody td{padding:12px 14px;text-align:left}
    .item-table thead th{
        position:sticky;top:0;z-index:1;background:rgba(255,255,255,.75);
        font-size:12px;letter-spacing:.2px;color:var(--muted);border-bottom:1px solid var(--card-border)
    }
    @media (prefers-color-scheme: dark){
        .item-table thead th{background:rgba(15,23,42,.75)}
    }
    .item-table tbody tr{transition:background .2s}
    .item-table tbody tr:nth-child(odd){background:rgba(2,6,23,.03)}
    .item-table tbody tr:hover{background:rgba(99,102,241,.06)}
    .item-table tbody td:first-child{border-top-left-radius:12px;border-bottom-left-radius:12px}
    .item-table tbody td:last-child{border-top-right-radius:12px;border-bottom-right-radius:12px}

    /* 数字列右对齐 */
    .num{ text-align:right; font-variant-numeric: tabular-nums; }
    .center{ text-align:center; }

    /* 链接与按钮（不改变 class="Button" 行为） */
    .id-link{
        display:inline-flex;align-items:center;gap:8px;
        padding:8px 12px;border-radius:12px;border:1px solid var(--card-border);
        background:rgba(255,255,255,.85);text-decoration:none;color:inherit;
    }
    .id-link:hover{box-shadow:0 0 0 8px var(--ring);text-decoration:none}

    .Button{
        display:inline-flex;align-items:center;justify-content:center;gap:6px;
        padding:8px 14px;border-radius:12px;border:1px solid transparent;
        background:linear-gradient(135deg,var(--accent),var(--accent2));
        color:#fff;font-weight:600;text-decoration:none;cursor:pointer;
    }
    .Button:hover{box-shadow:0 0 0 8px var(--ring);text-decoration:none}
</style>

<script>
    // 兜底：若外层未注入 logEvent，不报错
    if (typeof window.logEvent !== 'function') {
        window.logEvent = function(type, msg){ try{ console.debug('[LOG]', type, msg || ''); }catch(e){} };
    }

    // 页面加载时记录产品浏览
    window.addEventListener('load', function() {
        var productName = '${sessionScope.product.name}' || '未知产品';
        var productId = '${sessionScope.product.productId}' || '未知ID';
        var categoryName = '${sessionScope.category.name}' || '未知分类';
        var itemCount = '${sessionScope.itemList.size()}' || 0;

        logEvent('PRODUCT_VIEW', '浏览产品页面', productName, {
            productId: productId,
            category: categoryName,
            categoryId: '${sessionScope.category.categoryId}',
            itemCount: parseInt(itemCount),
            user: '${sessionScope.loginAccount.username}' || '未登录用户',
            timestamp: new Date().toISOString()
        });
    });

    // 增强版商品点击记录
    function logItemClick(itemId) {
        var productName = '${sessionScope.product.name}' || '未知产品';

        logEvent('LINK_CLICK', '点击商品详情', itemId, {
            productId: '${sessionScope.product.productId}',
            productName: productName,
            fromPage: 'product_list',
            user: '${sessionScope.loginAccount.username}' || '未登录用户',
            timestamp: new Date().toISOString()
        });
    }

    // 增强版添加到购物车记录
    function logAddToCart(itemId, itemDesc) {
        var productName = '${sessionScope.product.name}' || '未知产品';

        logEvent('ADD_TO_CART', '添加商品到购物车', itemDesc, {
            itemId: itemId,
            productId: '${sessionScope.product.productId}',
            productName: productName,
            fromPage: 'product_list',
            user: '${sessionScope.loginAccount.username}' || '未登录用户',
            timestamp: new Date().toISOString()
        });

        alert('商品已添加到购物车！');
    }
</script>
<div class="wrap">
    <div id="BackLink">
        <a href="categoryForm?categoryId=${sessionScope.category.categoryId}"
           onclick="logEvent('LINK_CLICK', '返回分类: ${sessionScope.category.name}')">
            Return to&nbsp;${sessionScope.category.name}
        </a>
    </div>

    <div id="Catalog">
        <h2>${sessionScope.product.name}</h2>
        <p class="sub">Choose an item below and add it to your cart.</p>

        <div class="table-wrap">
            <table class="item-table">
                <thead>
                <tr>
                    <th>Item ID</th>
                    <th>Product ID</th>
                    <th>Description</th>
                    <th class="num">List Price</th>
                    <th class="center">&nbsp;</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${sessionScope.itemList}">
                    <tr>
                        <td>
                            <a class="id-link"
                               href="itemForm?itemId=${item.itemId}"
                               onclick="logItemClick('${item.itemId}')">
                                    ${item.itemId}
                            </a>
                        </td>
                        <td>${item.product.productId}</td>
                        <td>
                                ${item.attribute1} ${item.attribute2} ${item.attribute3}
                                ${item.attribute4} ${item.attribute5} ${sessionScope.product.name}
                        </td>
                        <td class="num">
                            <fmt:formatNumber value="${item.listPrice}" pattern="$#,##0.00" />
                        </td>
                        <td class="center">

                            <a href="addItemToCart?workingItemId=${item.itemId}" class="Button"
                               onclick="logAddToCart('${item.itemId}', '${item.attribute1} ${item.attribute2}')">
                                Add to Cart
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="../common/bottom.jsp"%>
