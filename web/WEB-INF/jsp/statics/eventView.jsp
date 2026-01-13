<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../common/top.jsp"%>

<%
    // 确保响应使用UTF-8编码（仅前端增强，不影响后端逻辑）
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
%>

<style>
    :root{
        --bg:#f6f7fb;--text:#0f172a;--muted:#6b7280;
        --card:rgba(255,255,255,.9);--card-border:rgba(15,23,42,.12);
        --accent:#6366f1;--accent2:#22d3ee;--ring:rgba(99,102,241,.22);
        --shadow:0 18px 40px rgba(15,23,42,.12);
        --ok:#16a34a;--warn:#dc2626;--amber:#d97706;
        --blue:#2563eb;--violet:#7c3aed;--teal:#0d9488;
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

    /* 页面容器（保持既有 #Catalog，不影响后端） */
    #Catalog{ max-width:1200px; margin:32px auto 64px; padding:0 20px; }

    /* 过滤区卡片 */
    .filter-section{
        background:var(--card);
        padding:16px;
        border-radius:20px;
        border:1px solid var(--card-border);
        box-shadow:var(--shadow);
        backdrop-filter:blur(12px);
        margin-bottom:16px;
    }
    .filter-section h2{ margin:0 0 8px; font-size:24px; font-weight:800; }
    .filters{ display:flex; gap:10px; align-items:center; flex-wrap:wrap; }
    .filters label{ font-size:13px; color:var(--muted); margin-right:6px }
    .filters select, .filters input[type="text"]{
        padding:8px 10px; border-radius:10px; border:1px solid var(--card-border);
        background:rgba(255,255,255,.65); color:inherit; outline:none;
    }
    @media (prefers-color-scheme: dark){
        .filters select, .filters input[type="text"]{ background:rgba(15,23,42,.65) }
    }
    .btn{
        display:inline-flex; align-items:center; gap:6px;
        padding:8px 14px; border-radius:12px; border:1px solid var(--card-border);
        background:rgba(255,255,255,.7); color:inherit; cursor:pointer; text-decoration:none;
    }
    .btn:hover{ box-shadow:0 0 0 8px var(--ring); }
    .btn.primary{ border-color:transparent; color:#fff; background:linear-gradient(135deg,var(--accent),var(--accent2)); }
    .muted{ color:var(--muted); font-size:12px }

    /* 表格容器与工具栏 */
    .table-card{
        background:var(--card);
        border:1px solid var(--card-border);
        border-radius:20px;
        box-shadow:var(--shadow);
        backdrop-filter:blur(10px);
        padding:12px;
        overflow:hidden;
    }
    .table-toolbar{
        display:flex; gap:8px; flex-wrap:wrap; align-items:center;
        padding:6px 6px 10px; border-bottom:1px dashed var(--card-border);
    }
    .table-toolbar .sep{ width:1px; height:28px; background:var(--card-border); }

    /* 表格本体 */
    .table-wrap{ overflow:auto; }
    .event-table{
        width:100%; border-collapse:separate; border-spacing:0; font-size:14px; min-width:980px;
    }
    .event-table thead th, .event-table tbody td{ padding:10px 12px; text-align:left; }
    .event-table thead th{
        position:sticky; top:0; z-index:1; background:rgba(255,255,255,.86);
        backdrop-filter:blur(8px); border-bottom:1px solid var(--card-border);
        font-size:12px; color:var(--muted);
    }
    @media (prefers-color-scheme: dark){
        .event-table thead th{ background:rgba(15,23,42,.86); }
    }
    .event-table tbody tr:nth-child(odd){ background:rgba(2,6,23,.03); }
    .event-table tbody tr:hover{ background:rgba(148,163,184,.12); }
    .mono{ font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono","Courier New", monospace; }
    .nowrap{ white-space:nowrap; }
    .clip{ max-width: 360px; word-wrap: break-word; }

    /* 事件类型色条（沿用原有 class，不改后端） */
    .event-table tbody tr[class^="event-type-"]{ border-left:4px solid transparent; }
    .event-type-PAGE_VIEW{ border-left-color: var(--blue) !important; }
    .event-type-BUTTON_CLICK{ border-left-color: #22c55e !important; }
    .event-type-FORM_SUBMIT{ border-left-color: #ef4444 !important; }
    .event-type-LINK_CLICK{ border-left-color: #f59e0b !important; }
    .event-type-PRODUCT_VIEW{ border-left-color: #6f42c1 !important; }
    .event-type-CATEGORY_VIEW{ border-left-color: #e83e8c !important; }
    .event-type-ADD_TO_CART{ border-left-color: #fd7e14 !important; }
    .event-type-REMOVE_FROM_CART{ border-left-color: #20c997 !important; }
    .event-type-USER_LOGIN{ border-left-color: #6610f2 !important; }
    .event-type-USER_LOGOUT{ border-left-color: #6c757d !important; }

    /* 事件数据可折叠 */
    .event-data{ max-height:3.6em; overflow:hidden; position:relative; }
    .event-data.expanded{ max-height:none; }
    .cell-actions{ display:flex; gap:6px; margin-top:6px; }

    /* 空状态 */
    .empty{
        text-align:center; padding:48px 16px; color:var(--muted);
        background:var(--card); border:1px dashed var(--card-border); border-radius:16px;
    }
</style>

<script>
    // 兜底：如果外层未定义 logEvent，避免报错
    if (typeof window.logEvent !== 'function') {
        window.logEvent = function(type, msg){ try{ console.debug('[LOG]', type, msg || ''); }catch(e){} };
    }

    function applyFilter() {
        var typeFilter = document.getElementById('typeFilter').value;
        var limit = document.getElementById('limit').value;
        var url = 'eventView?action=list';
        if (typeFilter) url += '&typeFilter=' + encodeURIComponent(typeFilter);
        if (limit && limit !== '50') url += '&limit=' + limit;
        window.location.href = url;
    }
    function clearFilter() { window.location.href = 'eventView?action=list'; }
    function showStatistics() { window.location.href = 'eventView?action=stats'; }

    // 前端关键词筛选（不替代后端筛选）
    function clientFilter() {
        var kw = (document.getElementById('clientKw').value || '').toLowerCase();
        var rows = document.querySelectorAll('#eventTable tbody tr');
        rows.forEach(function(r){
            var t = r.innerText.toLowerCase();
            r.style.display = kw ? (t.indexOf(kw) >= 0 ? '' : 'none') : '';
        });
    }

    // CSV 导出
    function exportTableCSV(tableId, filename){
        var table = document.getElementById(tableId);
        if (!table) return;
        var rows = Array.from(table.querySelectorAll('tr'));
        var csv = rows.map(function(tr){
            return Array.from(tr.querySelectorAll('th,td')).map(function(td){
                var text = (td.innerText || '').replace(/\s+\n/g,' ').replace(/\n+/g,' ').trim();
                if (/[",\n]/.test(text)){ text = '"' + text.replace(/"/g,'""') + '"'; }
                return text;
            }).join(',');
        }).join('\n');
        var blob = new Blob([csv], {type:'text/csv;charset=utf-8;'});
        var a = document.createElement('a');
        a.href = URL.createObjectURL(blob);
        a.download = filename || ('events-' + Date.now() + '.csv');
        document.body.appendChild(a); a.click(); a.remove();
        logEvent('EXPORT_CSV', '导出事件列表CSV');
    }

    // 展开/收起所有事件数据
    function expandAll(expand){
        document.querySelectorAll('.event-data').forEach(function(el){
            if (expand) el.classList.add('expanded'); else el.classList.remove('expanded');
        });
    }

    // 单行展开
    function toggleRow(btn){
        var cell = btn.closest('td');
        var block = cell.querySelector('.event-data');
        if (!block) return;
        block.classList.toggle('expanded');
        btn.innerText = block.classList.contains('expanded') ? '收起' : '展开';
    }

    // 尝试格式化/还原 JSON（逐行）
    function formatJSON(btn){
        var cell = btn.closest('td');
        var block = cell.querySelector('.event-data');
        if (!block) return;
        if (!block.dataset.original){
            block.dataset.original = block.innerText;
        }
        var text = block.innerText.trim();
        try{
            var obj = JSON.parse(text);
            block.innerText = JSON.stringify(obj, null, 2);
            block.classList.add('expanded');
            btn.innerText = '还原';
        }catch(e){
            // 若不是标准 JSON，再尝试去除首尾引号或单引号
            try{
                var t2 = text.replace(/^[“"]|[”"]$/g,'').replace(/^'|'$/g,'');
                var obj2 = JSON.parse(t2);
                block.innerText = JSON.stringify(obj2, null, 2);
                block.classList.add('expanded');
                btn.innerText = '还原';
            }catch(e2){
                // 无法解析则还原
                block.innerText = block.dataset.original || text;
                btn.innerText = '格式化';
                alert('该事件数据不是有效的 JSON，已保持原样。');
            }
        }
    }

    // 复制文本
    async function copyText(text, tip){
        try{
            await navigator.clipboard.writeText(text);
            if (tip !== false) alert('已复制到剪贴板');
        }catch(e){
            alert('复制失败，请手动选择复制');
        }
    }

    // 顶部曝光上报
    window.addEventListener('load', function(){
        logEvent('EVENT_LIST_VIEW','事件列表页面打开');
    });
</script>

<div id="Catalog">
    <div class="filter-section">
        <h2>用户行为事件记录</h2>

        <div class="filters">
            <div>
                <label for="typeFilter">事件类型</label>
                <select id="typeFilter" name="typeFilter">
                    <option value="">所有类型</option>
                    <c:forEach var="eventType" items="${eventTypes}">
                        <option value="${eventType}" <c:if test="${param.typeFilter == eventType}">selected</c:if>>${eventType}</option>
                    </c:forEach>
                </select>
            </div>

            <div>
                <label for="limit">显示条数</label>
                <select id="limit" name="limit">
                    <option value="20"  <c:if test="${param.limit == '20'}">selected</c:if>>20</option>
                    <option value="50"  <c:if test="${param.limit == '50' || empty param.limit}">selected</c:if>>50</option>
                    <option value="100" <c:if test="${param.limit == '100'}">selected</c:if>>100</option>
                    <option value="200" <c:if test="${param.limit == '200'}">selected</c:if>>200</option>
                </select>
            </div>

            <input id="clientKw" type="text" placeholder="前端关键字筛选（不影响后端）" oninput="clientFilter()"/>

            <button class="btn primary" onclick="applyFilter()">筛选</button>
            <button class="btn" onclick="clearFilter()">清除筛选</button>
            <button class="btn" onclick="showStatistics()">查看统计</button>
        </div>

        <div style="margin-top:8px">
     <span class="muted">
       共 ${events.size()} 条记录
       <c:if test="${not empty param.typeFilter}">
           · 筛选类型: <span class="mono">${param.typeFilter}</span>
       </c:if>
     </span>
        </div>
    </div>

    <c:if test="${not empty events}">
        <div class="table-card">
            <div class="table-toolbar">
                <button class="btn" onclick="exportTableCSV('eventTable','events.csv')">导出 CSV</button>
                <div class="sep"></div>
                <button class="btn" onclick="expandAll(true)">展开全部</button>
                <button class="btn" onclick="expandAll(false)">收起全部</button>
            </div>

            <div class="table-wrap">
                <table class="event-table" id="eventTable" aria-label="Event list table">
                    <thead>
                    <tr>
                        <th class="nowrap">ID</th>
                        <th class="nowrap">事件类型</th>
                        <th style="min-width:320px">事件数据</th>
                        <th class="nowrap">页面</th>
                        <th class="nowrap">用户</th>
                        <th class="nowrap">IP地址</th>
                        <th class="nowrap">会话ID</th>
                        <th class="nowrap">发生时间</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="event" items="${events}">
                        <tr class="event-type-${event.eventType}">
                            <td class="mono nowrap">${event.id}</td>
                            <td><strong>${event.eventType}</strong></td>

                            <td>
                                <div class="event-data mono" title="点击“展开/格式化”查看更多">
                                        ${event.eventData}
                                </div>
                                <div class="cell-actions">
                                    <button class="btn" onclick="toggleRow(this)">展开</button>
                                    <button class="btn" onclick="formatJSON(this)">格式化</button>
                                    <button class="btn" onclick="copyText(this.closest('td').querySelector('.event-data').innerText)">复制</button>
                                </div>
                            </td>

                            <td class="clip">${event.pageName}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty event.userName}">
                                        ${event.userName}
                                        <c:if test="${not empty event.userId}"> (ID: ${event.userId})</c:if>
                                    </c:when>
                                    <c:otherwise><span class="muted">未登录用户</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="nowrap">
                                    ${event.ipAddress}
                                <button class="btn" style="margin-left:6px" onclick="copyText('${event.ipAddress}', true)">复制</button>
                            </td>
                            <td class="mono" style="font-size:12px;">
                                    ${event.sessionId}
                                <button class="btn" style="margin-left:6px" onclick="copyText('${event.sessionId}', true)">复制</button>
                            </td>
                            <td class="nowrap">
                                <fmt:formatDate value="${event.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </c:if>

    <c:if test="${empty events}">
        <div class="empty">
            <h3 style="margin:0 0 6px">暂无事件记录</h3>
            <p style="margin:0">没有找到匹配的事件记录，请尝试调整筛选条件。</p>
        </div>
    </c:if>
</div>

<%@ include file="../common/bottom.jsp"%>
