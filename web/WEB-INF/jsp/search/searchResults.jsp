<%-- searchResults.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
%>

<html>
<head>
    <title>Search Results - MyPetStore</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/petstore.css">

    <style>
        :root{
            --bg:#f6f7fb;--text:#0f172a;--muted:#6b7280;
            --card:rgba(255,255,255,.86);--card-border:rgba(15,23,42,.08);
            --accent:#6366f1;--accent2:#22d3ee;--ring:rgba(99,102,241,.22);
            --shadow:0 18px 40px rgba(15,23,42,.14);
        }
        @media (prefers-color-scheme: dark){
            :root{
                --bg:#020617;--text:#e5e7eb;--muted:#9ca3af;
                --card:rgba(15,23,42,.9);--card-border:rgba(148,163,184,.35);
                --accent:#60a5fa;--accent2:#8b5cf6;--ring:rgba(96,165,250,.28);
                --shadow:0 22px 48px rgba(0,0,0,.7);
            }
        }

        body{
            margin:0;
            color:var(--text);
            background:
                    radial-gradient(1200px 600px at -10% -10%, rgba(99,102,241,.16), transparent),
                    radial-gradient(900px 600px at 110% 8%, rgba(34,211,238,.16), transparent),
                    var(--bg);
            -webkit-font-smoothing:antialiased;
            -moz-osx-font-smoothing:grayscale;
            font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "PingFang SC","Microsoft YaHei", Arial;
        }

        .wrap{
            max-width:1120px;
            margin:32px auto 64px;
            padding:0 20px 32px;
        }

        #Content{
            background:var(--card);
            border-radius:22px;
            border:1px solid var(--card-border);
            box-shadow:var(--shadow);
            backdrop-filter:blur(16px);
            padding:20px 20px 24px;
        }

        .search-header{
            margin-bottom:14px;
            padding-bottom:12px;
            border-bottom:1px solid rgba(148,163,184,.25);
            display:flex;
            align-items:flex-end;
            justify-content:space-between;
            gap:10px;
            flex-wrap:wrap;
        }
        .search-header h2{
            margin:0;
            font-size:22px;
            font-weight:800;
            background:linear-gradient(90deg,var(--text),var(--accent));
            -webkit-background-clip:text;
            background-clip:text;
            color:transparent;
        }
        .search-pill{
            padding:4px 10px;
            border-radius:999px;
            font-size:12px;
            color:var(--muted);
            border:1px solid var(--card-border);
            background:rgba(15,23,42,.02);
        }

        .search-results{
            margin-top:8px;
            display:flex;
            flex-direction:column;
            gap:12px;
        }

        .item-card{
            border:1px solid var(--card-border);
            padding:14px 16px;
            border-radius:16px;
            display:flex;
            align-items:stretch;
            gap:14px;
            background:rgba(255,255,255,.65);
            box-shadow:0 10px 26px rgba(15,23,42,.08);
            transition:box-shadow .18s, transform .08s, background .18s;
            cursor: pointer;
        }
        @media (prefers-color-scheme: dark){
            .item-card{background:rgba(15,23,42,.72);}
        }
        .item-card:hover{
            transform:translateY(-2px);
            box-shadow:0 14px 34px rgba(15,23,42,.26);
            background:rgba(255,255,255,.85);
        }

        .item-image{
            width:80px;
            height:80px;
            margin-right:12px;
            background:transparent;
            display:flex;
            align-items:center;
            justify-content:center;
            overflow:hidden;
            flex-shrink:0;
        }
        .item-image img{
            max-width:100%;
            max-height:100%;
            object-fit:contain;
            display:block;
            border-radius:8px;
        }
        .item-image span{
            font-size:11px;
            color:var(--muted);
        }

        .item-info{
            flex:1;
            display:flex;
            flex-direction:column;
            gap:6px;
        }

        .item-name{
            font-size:18px;
            font-weight:700;
            margin:0;
        }
        .item-description{
            color:var(--muted);
            font-size:13px;
            line-height:1.5;
        }
        .item-price{
            color:#e74c3c;
            font-weight:700;
            font-size:16px;
        }
        @media (prefers-color-scheme: dark){
            .item-price{color:#f97373;}
        }
        .item-meta{
            font-size:12px;
            color:var(--muted);
        }

        .item-actions{
            margin-top:8px;
        }

        .item-actions .Button {
            display: inline-block;
            padding: 8px 16px;
            background: var(--accent);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s ease;
            border: none;
            cursor: pointer;
        }

        .item-actions .Button:hover {
            background: var(--accent2);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .item-actions .Button:active {
            transform: translateY(0);
        }

        .no-results{
            text-align:center;
            padding:40px 16px 32px;
            color:var(--muted);
        }
        .no-results h3{
            margin-top:0;
            margin-bottom:6px;
            font-size:18px;
        }

        .back-home{
            margin-top:20px;
            text-align:center;
        }

        .back-home .Button {
            display: inline-block;
            padding: 10px 20px;
            background: var(--accent);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.2s ease;
        }

        .back-home .Button:hover {
            background: var(--accent2);
        }

        @media (max-width:720px){
            .item-card{
                flex-direction:row;
                align-items:center;
            }
            .item-image{
                width:60px;
                height:60px;
            }
        }
    </style>

    <script>
        if (typeof window.logEvent !== 'function') {
            window.logEvent = function(type, msg){
                try{ console.debug('[LOG]', type, msg || ''); }catch(e){}
            };
        }

        function logResultClick(itemId){
            logEvent('SEARCH_RESULT_CLICK', '点击搜索结果: ' + itemId);
        }

        // 点击整个卡片也可以跳转
        function navigateToItem(itemId) {
            window.location.href = '${pageContext.request.contextPath}/item?itemId=' + itemId;
        }

        window.addEventListener('load', function(){
            var type  = '${searchType}';
            var value = '${searchValue}';
            logEvent('SEARCH_RESULTS_VIEW', '查看搜索结果: type=' + type + ', value=' + value);
        });
    </script>
</head>
<body>
<div id="Header">
    <jsp:include page="../common/top.jsp"/>
</div>

<div class="wrap">
    <div id="Content">
        <div class="search-header">
            <h2>
                <c:choose>
                    <c:when test="${searchType == 'keyword'}">
                        Search Results for: "${searchValue}"
                    </c:when>
                    <c:when test="${searchType == 'product'}">
                        Products in Category: "${searchValue}"
                    </c:when>
                    <c:otherwise>
                        Search Results
                    </c:otherwise>
                </c:choose>
            </h2>
            <span class="search-pill">
               Showing
               <c:choose>
                   <c:when test="${empty searchResults}">0</c:when>
                   <c:otherwise>${fn:length(searchResults)}</c:otherwise>
               </c:choose>
               result(s)
           </span>
        </div>

        <div class="search-results">
            <c:choose>
                <c:when test="${empty searchResults}">
                    <div class="no-results">
                        <h3>No items found</h3>
                        <p>Please try different search terms.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="item" items="${searchResults}">
                        <div class="item-card" onclick="navigateToItem('${item.itemId}')">
                            <div class="item-image">
                                <img src="${pageContext.request.contextPath}/images/${item.product.productId}.jpg"
                                     alt="${item.product.name}"
                                     onerror="this.style.display='none'">
                                <c:if test="${empty item.product.productId}">
                                    <span>No Image</span>
                                </c:if>
                            </div>
                            <div class="item-info">
                                <div class="item-name">${item.product.name}</div>
                                <div class="item-description">${item.product.description}</div>
                                <div class="item-price">
                                    Price:
                                    $<fmt:formatNumber value="${item.listPrice}" pattern="#,##0.00"/>
                                </div>
                                <div class="item-meta">
                                    <small>Item ID: ${item.itemId} | Status: ${item.status}</small>
                                </div>
                                <div class="item-actions">
                                    <a href="${pageContext.request.contextPath}/item?itemId=${item.itemId}"
                                       class="Button"
                                       onclick="event.stopPropagation(); logResultClick('${item.itemId}')">
                                        View Details
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="back-home">
            <a href="${pageContext.request.contextPath}/" class="Button">
                Back to Home
            </a>
        </div>
    </div>
</div>

<div id="Footer">
    <jsp:include page="../common/bottom.jsp"/>
</div>
</body>
</html>