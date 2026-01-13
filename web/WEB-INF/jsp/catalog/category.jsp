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
    }
    @media (prefers-color-scheme: dark){
        :root{--bg:#0b1020;--text:#e5e7eb;--muted:#9ca3af;
            --card:rgba(13,18,36,.78);--card-border:rgba(148,163,184,.25);
            --accent:#60a5fa;--accent2:#8b5cf6;--ring:rgba(96,165,250,.28);
            --shadow:0 20px 45px rgba(0,0,0,.55);}
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

    /* 返回主菜单按钮化，但保留原有结构与href */
    #BackLink{margin-bottom:14px}
    #BackLink a{
        display:inline-flex;align-items:center;gap:6px;
        padding:8px 14px;border-radius:999px;border:1px solid var(--card-border);
        background:rgba(15,23,42,.02);text-decoration:none;color:var(--accent);
        backdrop-filter:blur(10px);font-size:13px;
    }
    #BackLink a::before{content:"←";font-size:12px}
    #BackLink a:hover{box-shadow:0 0 0 8px var(--ring);text-decoration:none}

    /* 主卡片容器：保留 #Catalog id，仅增强样式 */
    #Catalog{
        background:var(--card);border:1px solid var(--card-border);
        border-radius:22px;box-shadow:var(--shadow);backdrop-filter:blur(14px);
        padding:22px;
    }
    #Catalog h2{
        margin:0 0 10px;font-size:26px;font-weight:800;
        background:linear-gradient(90deg,var(--text),var(--accent));
        -webkit-background-clip:text;background-clip:text;color:transparent
    }
    #Catalog .sub{margin:2px 0 16px;color:var(--muted);font-size:13px}

    /* 表格美化 */
    .table-wrap{overflow:auto;border:1px solid var(--card-border);border-radius:16px;background:rgba(255,255,255,.55)}
    table.prod-table{width:100%;min-width:520px;border-collapse:separate;border-spacing:0}
    .prod-table thead th,.prod-table tbody td{padding:12px 14px;text-align:left}
    .prod-table thead th{
        position:sticky;top:0;z-index:1;background:rgba(255,255,255,.75);
        font-size:12px;letter-spacing:.2px;color:var(--muted);border-bottom:1px solid var(--card-border)
    }
    @media (prefers-color-scheme: dark){
        .table-wrap{background:rgba(15,23,42,.55)}
        .prod-table thead th{background:rgba(15,23,42,.75)}
    }
    .prod-table tbody tr{transition:background .2s}
    .prod-table tbody tr:nth-child(odd){background:rgba(2,6,23,.03)}
    .prod-table tbody tr:hover{background:rgba(99,102,241,.06)}
    .prod-table tbody td:first-child{border-top-left-radius:12px;border-bottom-left-radius:12px}
    .prod-table tbody td:last-child{border-top-right-radius:12px;border-bottom-right-radius:12px}

    /* 产品链接按钮化（不改href/参数） */
    .prod-link{
        display:inline-flex;align-items:center;gap:8px;
        padding:8px 12px;border-radius:12px;border:1px solid var(--card-border);
        background:rgba(255,255,255,.85);text-decoration:none;color:inherit;
    }
    .prod-link:hover{box-shadow:0 0 0 8px var(--ring);text-decoration:none}
</style>


<script>
    // 兜底：如果外层未定义 logEvent，不报错
    if (typeof window.logEvent !== 'function') {
        window.logEvent = function(type, msg){ try{ console.debug('[LOG]', type, msg || ''); }catch(e){} };
    }

    // 页面加载时记录分类浏览
    window.addEventListener('load', function() {
        var categoryName = '${sessionScope.category.name}' || '未知分类';
        var categoryId = '${sessionScope.category.categoryId}' || '未知ID';
        var productCount = '${sessionScope.productList.size()}' || 0;

        logEvent('CATEGORY_VIEW', '浏览分类页面', categoryName, {
            categoryId: categoryId,
            productCount: parseInt(productCount),
            user: '${sessionScope.loginAccount.username}' || '未登录用户',
            timestamp: new Date().toISOString()
        });
    });

    // 增强版产品点击记录
    function logProductClick(productId, productName) {
        var categoryName = '${sessionScope.category.name}' || '未知分类';

        logEvent('PRODUCT_VIEW', '点击产品', productName, {
            productId: productId,
            category: categoryName,
            categoryId: '${sessionScope.category.categoryId}',
            fromPage: 'category',
            user: '${sessionScope.loginAccount.username}' || '未登录用户',
            timestamp: new Date().toISOString()
        });
    }
</script>


<div class="wrap">
    <div id="BackLink">
        <a href="mainForm" onclick="logEvent('LINK_CLICK', '返回主菜单')">Return to Main Menu</a>
    </div>

    <div id="Catalog">
        <h2>${sessionScope.category.name}</h2>
        <p class="sub">Browse products in this category.</p>

        <div class="table-wrap">
            <table class="prod-table">
                <thead>
                <tr>
                    <th>Product ID</th>
                    <th>Name</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="product" items="${sessionScope.productList}">
                    <tr>
                        <td>
                            <a class="prod-link"
                               href="productForm?productId=${product.productId}"
                               onclick="logProductClick('${product.productId}', '${product.name}')">
                                    ${product.productId}
                            </a>
                        </td>
                        <td>${product.name}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="../common/bottom.jsp"%>
