<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>
<script>
    // 兜底：如果外部未定义 logEvent，不要报错
    if (typeof window.logEvent !== 'function') {
        window.logEvent = function(type, msg){ try{ console.debug('[LOG]', type, msg || ''); }catch(e){} };
    }

    // 增强版我的列表产品点击记录
    function logMyListProductClick(productId, productName) {
        logEvent('PRODUCT_VIEW', '从我的列表点击产品', productName, {
            productId: productId,
            fromModule: 'myList',
            listType: 'favorites',
            user: '${sessionScope.loginAccount.username}' || '未登录用户',
            timestamp: new Date().toISOString()
        });
    }

    // 我的列表模块展示记录
    window.addEventListener('DOMContentLoaded', function() {
        var myList = document.getElementById('MyListPanel');
        if (myList) {
            var productCount = myList.querySelectorAll('.mylist-item').length;
            if (productCount > 0) {
                logEvent('MODULE_VIEW', '我的列表模块展示', 'Pet Favorites', {
                    productCount: productCount,
                    module: 'myList',
                    user: '${sessionScope.loginAccount.username}' || '未登录用户',
                    timestamp: new Date().toISOString()
                });
            }
        }
    });
</script>
<%
    // 确保响应使用UTF-8编码（不影响后端逻辑）
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
%>

<style>
    /* 仅作用于本段组件，避免影响全局样式 */
    #MyListPanel{
        --text:#0f172a; --muted:#6b7280;
        --card:rgba(255,255,255,.78); --card-border:rgba(15,23,42,.08);
        --accent:#6366f1; --accent2:#22d3ee; --ring:rgba(99,102,241,.22);
        color:var(--text);
        background:var(--card);
        border:1px solid var(--card-border);
        border-radius:18px;
        padding:16px 18px 12px;
        backdrop-filter:blur(12px);
    }
    @media (prefers-color-scheme: dark){
        #MyListPanel{
            --text:#e5e7eb; --muted:#9ca3af;
            --card:rgba(15,23,42,.72); --card-border:rgba(148,163,184,.25);
            --accent:#60a5fa; --accent2:#8b5cf6; --ring:rgba(96,165,250,.28);
        }
    }
    #MyListPanel .mylist-head{margin-bottom:10px}
    #MyListPanel .mylist-title{
        margin:0; font-size:18px; font-weight:800;
        background:linear-gradient(90deg,var(--text),var(--accent));
        -webkit-background-clip:text; background-clip:text; color:transparent;
    }
    #MyListPanel .mylist-sub{
        margin:4px 0 0; font-size:12px; color:var(--muted);
    }

    #MyListPanel .mylist-grid{
        list-style:none; margin:12px 0 0; padding:0;
        display:grid; gap:10px;
        grid-template-columns:repeat(auto-fill,minmax(220px,1fr));
    }
    #MyListPanel .mylist-item{margin:0}

    #MyListPanel .mylist-link{
        display:flex; align-items:center; gap:8px;
        padding:10px 12px; border-radius:12px;
        border:1px solid var(--card-border); background:rgba(255,255,255,.6);
        text-decoration:none; color:inherit;
        transition:box-shadow .2s, transform .08s ease;
    }
    @media (prefers-color-scheme: dark){
        #MyListPanel .mylist-link{ background:rgba(15,23,42,.6); }
    }
    #MyListPanel .mylist-link:hover{
        box-shadow:0 0 0 8px var(--ring); text-decoration:none; transform:translateY(-1px);
    }

    #MyListPanel .dot{
        width:8px; height:8px; border-radius:50%;
        background:linear-gradient(135deg,var(--accent),var(--accent2));
        box-shadow:0 0 0 4px var(--ring);
        flex:0 0 auto;
    }
    #MyListPanel .name{font-weight:600}
    #MyListPanel .pid{
        margin-left:auto; font-size:12px; color:var(--muted);
        font-variant-numeric:tabular-nums;
    }
</style>

<c:if test="${!empty sessionScope.myList}">
    <div id="MyListPanel" aria-label="Pet Favorites">
        <div class="mylist-head">
            <h4 class="mylist-title">Pet Favorites</h4>
            <p class="mylist-sub">Shop for more of your favorite pets here.</p>
        </div>

        <ul class="mylist-grid">
            <c:forEach var="product" items="${sessionScope.myList}">
                <li class="mylist-item">
                    <a class="mylist-link"
                       href="productForm?productId=${product.productId}"
                       onclick="logMyListProductClick('${product.productId}', '${product.name}')">
                        <span class="dot" aria-hidden="true"></span>
                        <span class="name">${product.name}</span>
                        <span class="pid">(${product.productId})</span>
                    </a>
                </li>
            </c:forEach>
        </ul>
    </div>
</c:if>
