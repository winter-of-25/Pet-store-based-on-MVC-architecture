<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../common/top.jsp"%>

<%
    // 确保响应使用UTF-8编码（不影响后端逻辑）
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
%>

<style>
    :root{
        --bg:#f6f7fb;--text:#0f172a;--muted:#6b7280;
        --card:rgba(255,255,255,.86);--card-border:rgba(15,23,42,.1);
        --accent:#6366f1;--accent2:#22d3ee;--ring:rgba(99,102,241,.22);
        --shadow:0 18px 40px rgba(15,23,42,.12);
        --blue:#2563eb;--green:#16a34a;--red:#dc2626;--amber:#d97706;
    }
    @media (prefers-color-scheme: dark){
        :root{
            --bg:#0b1020;--text:#e5e7eb;--muted:#9ca3af;
            --card:rgba(13,18,36,.9);--card-border:rgba(148,163,184,.28);
            --accent:#60a5fa;--accent2:#8b5cf6;--ring:rgba(96,165,250,.28);
            --shadow:0 22px 48px rgba(0,0,0,.6);
        }
    }

    body{
        background:
                radial-gradient(1200px 600px at -10% -10%, rgba(99,102,241,.14), transparent),
                radial-gradient(900px 600px at 110% 8%, rgba(34,211,238,.14), transparent),
                var(--bg);
        color:var(--text);
        -webkit-font-smoothing:antialiased; -moz-osx-font-smoothing:grayscale;
        font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "PingFang SC","Microsoft YaHei", Arial;
    }

    /* 包裹容器（保持 #Catalog，不影响后端） */
    #Catalog{
        max-width:1120px; margin:32px auto 64px; padding:0 20px;
    }

    /* 返回按钮 */
    .back-link{
        display:inline-flex;align-items:center;gap:8px;
        padding:8px 14px;border-radius:999px;border:1px solid var(--card-border);
        background:rgba(255,255,255,.7);color:var(--text);text-decoration:none;
    }
    .back-link:hover{ box-shadow:0 0 0 8px var(--ring); text-decoration:none }
    .back-link::before{ content:"←"; }

    /* 标题与副标题 */
    #Catalog h2{
        margin:12px 0 4px;font-size:26px;font-weight:800;
        background:linear-gradient(90deg,var(--text),var(--accent));
        -webkit-background-clip:text;background-clip:text;color:transparent;
    }
    .sub{ color:var(--muted); font-size:13px; margin-bottom:16px }

    /* 统计卡网格 */
    .stats-container{
        display:grid;grid-template-columns:repeat(auto-fit,minmax(320px,1fr));
        gap:16px; margin:16px 0;
    }
    .stats-card{
        background:var(--card); border:1px solid var(--card-border);
        border-radius:20px; box-shadow:var(--shadow); backdrop-filter:blur(12px);
        padding:16px;
    }
    .stats-card h3{
        margin:0 0 10px; padding-bottom:8px; border-bottom:1px solid var(--card-border);
        font-size:16px; font-weight:800;
    }

    /* 表格美化 */
    .stats-table{ width:100%; border-collapse:separate; border-spacing:0; }
    .stats-table thead th, .stats-table tbody td{ padding:10px 12px; text-align:left; }
    .stats-table thead th{
        position:sticky; top:0; z-index:1; background:rgba(255,255,255,.75);
        border-bottom:1px solid var(--card-border); font-size:12px; color:var(--muted);
    }
    @media (prefers-color-scheme: dark){
        .stats-table thead th{ background:rgba(15,23,42,.75); }
    }
    .stats-table tbody tr:nth-child(odd){ background:rgba(2,6,23,.03); }
    .num{ text-align:center; font-variant-numeric:tabular-nums; }
    .mono{ font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono","Courier New", monospace; }

    /* 行内进度条（根据 data-count 自动算宽度） */
    .meter{ height:6px; border-radius:999px; background:rgba(2,6,23,.06); overflow:hidden; }
    @media (prefers-color-scheme: dark){ .meter{ background:rgba(255,255,255,.06); } }
    .meter .bar{ height:100%; width:0%; border-radius:999px; background:linear-gradient(90deg,var(--accent),var(--accent2)); }

    /* 汇总卡片中的“数字徽章” */
    .kpi{
        text-align:center; border:1px solid var(--card-border); border-radius:16px; padding:12px;
        background:rgba(255,255,255,.55);
    }
    @media (prefers-color-scheme: dark){ .kpi{ background:rgba(15,23,42,.55); } }
    .kpi .val{ font-size:26px; font-weight:800; line-height:1; }
    .kpi .lab{ color:var(--muted); font-size:12px; margin-top:6px; }

    /* 工具栏按钮 */
    .toolbar{ display:flex; gap:8px; flex-wrap:wrap; margin:10px 0 2px }
    .btn{
        display:inline-flex; align-items:center; gap:6px;
        padding:8px 12px; border-radius:12px; border:1px solid var(--card-border);
        background:rgba(255,255,255,.7); color:inherit; cursor:pointer; text-decoration:none;
    }
    .btn:hover{ box-shadow:0 0 0 8px var(--ring); }
    .btn.primary{ border-color:transparent; color:#fff; background:linear-gradient(135deg,var(--accent),var(--accent2)); }
</style>

<script>
    // 兜底：若外部未注入 logEvent，不抛错
    if (typeof window.logEvent !== 'function') {
        window.logEvent = function(t, m){ try{ console.debug('[LOG]', t, m || ''); }catch(e){} };
    }

    function goBack(){
        logEvent('NAV','返回事件列表');
        window.location.href = 'eventView?action=list';
    }

    // 根据 data-count 计算并渲染条形比例
    function renderMeters(sectionSelector){
        var rows = document.querySelectorAll(sectionSelector + ' [data-count]');
        if (!rows.length) return;
        var max = 0;
        rows.forEach(function(el){
            var v = Number(el.getAttribute('data-count')) || 0;
            if (v > max) max = v;
        });
        rows.forEach(function(el){
            var v = Number(el.getAttribute('data-count')) || 0;
            var p = max > 0 ? (v / max) * 100 : 0;
            var bar = el.querySelector('.meter .bar');
            if (bar){ bar.style.width = p.toFixed(2) + '%'; }
        });
    }

    // 简易 CSV 导出（仅前端，保留后端不变）
    function exportTableCSV(tableId, filename){
        var table = document.getElementById(tableId);
        if (!table) return;
        var rows = Array.from(table.querySelectorAll('tr'));
        var csv = rows.map(function(tr){
            return Array.from(tr.querySelectorAll('th,td')).map(function(td){
                var text = (td.innerText || '').replace(/\n+/g,' ').trim();
                // 基础转义
                if (/[",\n]/.test(text)){ text = '"' + text.replace(/"/g,'""') + '"'; }
                return text;
            }).join(',');
        }).join('\n');
        var blob = new Blob([csv], {type:'text/csv;charset=utf-8;'});
        var a = document.createElement('a');
        a.href = URL.createObjectURL(blob);
        a.download = filename || ('export-' + Date.now() + '.csv');
        document.body.appendChild(a); a.click(); a.remove();
    }

    window.addEventListener('DOMContentLoaded', function(){
        // 曝光上报
        logEvent('STATS_VIEW','用户行为统计页面打开');

        // 渲染各表的进度条
        renderMeters('#eventTypeSection');
        renderMeters('#hotPagesSection');
        renderMeters('#activeUsersSection');
    });
</script>

<div id="Catalog" aria-label="Analytics dashboard">
    <a href="javascript:void(0)" onclick="goBack()" class="back-link">返回事件列表</a>

    <h2>用户行为统计</h2>
    <p class="sub">下方为事件类型、热门页面与活跃用户数据概览。可导出为 CSV 以便分析。</p>

    <div class="stats-container">
        <!-- 事件类型统计 -->
        <section class="stats-card" id="eventTypeSection" aria-label="Event types">
            <h3>事件类型统计</h3>
            <div class="toolbar">
                <button class="btn" onclick="exportTableCSV('tblEvents','event-types.csv')">导出 CSV</button>
            </div>
            <table class="stats-table" id="tblEvents">
                <thead>
                <tr>
                    <th>事件类型</th>
                    <th class="num">发生次数</th>
                    <th>最后发生时间</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="stat" items="${eventStats}">
                    <tr data-count="${stat.count}">
                        <td class="mono">${stat.eventType}</td>
                        <td class="num">
                            <span class="mono">${stat.count}</span>
                            <div class="meter" aria-hidden="true"><div class="bar"></div></div>
                        </td>
                        <td>
                            <fmt:formatDate value="${stat.lastOccurrence}" pattern="MM-dd HH:mm"/>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </section>

        <!-- 热门页面统计 -->
        <section class="stats-card" id="hotPagesSection" aria-label="Hot pages">
            <h3>热门页面访问</h3>
            <div class="toolbar">
                <button class="btn" onclick="exportTableCSV('tblPages','hot-pages.csv')">导出 CSV</button>
            </div>
            <table class="stats-table" id="tblPages">
                <thead>
                <tr>
                    <th>页面名称</th>
                    <th class="num">访问次数</th>
                    <th>最后访问</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="pageStat" items="${pageStats}">
                    <tr data-count="${pageStat.visitCount}">
                        <td style="max-width: 280px; word-wrap: break-word;">
                                ${pageStat.pageName}
                        </td>
                        <td class="num">
                            <span class="mono">${pageStat.visitCount}</span>
                            <div class="meter" aria-hidden="true"><div class="bar"></div></div>
                        </td>
                        <td>
                            <fmt:formatDate value="${pageStat.lastVisit}" pattern="MM-dd HH:mm"/>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </section>

        <!-- 活跃用户统计 -->
        <section class="stats-card" id="activeUsersSection" aria-label="Active users">
            <h3>活跃用户</h3>
            <div class="toolbar">
                <button class="btn" onclick="exportTableCSV('tblUsers','active-users.csv')">导出 CSV</button>
            </div>
            <table class="stats-table" id="tblUsers">
                <thead>
                <tr>
                    <th>用户名</th>
                    <th class="num">事件数量</th>
                    <th>最后活动</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="userStat" items="${userStats}">
                    <tr data-count="${userStat.eventCount}">
                        <td class="mono">${userStat.userName}</td>
                        <td class="num">
                            <span class="mono">${userStat.eventCount}</span>
                            <div class="meter" aria-hidden="true"><div class="bar"></div></div>
                        </td>
                        <td>
                            <fmt:formatDate value="${userStat.lastActivity}" pattern="MM-dd HH:mm"/>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </section>
    </div>

    <!-- 汇总信息 -->
    <section class="stats-card" aria-label="System summary">
        <h3>系统汇总</h3>
        <div class="toolbar">
            <button class="btn primary" onclick="exportTableCSV('tblEvents','event-types.csv');exportTableCSV('tblPages','hot-pages.csv');exportTableCSV('tblUsers','active-users.csv');">
                一键导出全部
            </button>
        </div>

        <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:12px;margin-top:8px">
            <div class="kpi">
                <div class="val" style="color:var(--blue)">
                    <c:set var="totalEvents" value="0"/>
                    <c:forEach var="stat" items="${eventStats}">
                        <c:set var="totalEvents" value="${totalEvents + stat.count}"/>
                    </c:forEach>
                    ${totalEvents}
                </div>
                <div class="lab">总事件数</div>
            </div>
            <div class="kpi">
                <div class="val" style="color:var(--green)">${eventStats.size()}</div>
                <div class="lab">事件类型数</div>
            </div>
            <div class="kpi">
                <div class="val" style="color:var(--red)">${pageStats.size()}</div>
                <div class="lab">被访问页面数</div>
            </div>
            <div class="kpi">
                <div class="val" style="color:var(--amber)">${userStats.size()}</div>
                <div class="lab">活跃用户数</div>
            </div>
        </div>
    </section>
</div>

<%@ include file="../common/bottom.jsp"%>
