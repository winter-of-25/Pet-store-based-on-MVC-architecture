<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ include file="../common/top.jsp"%>

<%
    // 确保响应使用UTF-8编码（不影响后端逻辑）
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
            --danger:#f87171;
        }
    }

    /* 页面背景仅轻微增强，不影响全局 */
    body{
        background:
                radial-gradient(1200px 600px at -10% -10%, rgba(99,102,241,.14), transparent),
                radial-gradient(900px 600px at 110% 8%, rgba(34,211,238,.14), transparent),
                var(--bg);
        color:var(--text);
        -webkit-font-smoothing:antialiased;
        -moz-osx-font-smoothing:grayscale;
    }

    .wrap{max-width:960px;margin:48px auto 96px;padding:0 24px}

    /* 错误卡片区域（保留后端变量输出，仅美化展示） */
    #ErrorPage{
        background:var(--card);
        border:1px solid var(--card-border);
        border-radius:22px;
        box-shadow:var(--shadow);
        backdrop-filter:blur(14px);
        padding:22px 22px 18px;
    }

    .err-head{
        display:flex;align-items:center;gap:12px;margin-bottom:6px
    }
    .err-icon{
        width:40px;height:40px;border-radius:12px;
        display:inline-flex;align-items:center;justify-content:center;
        background:rgba(239,68,68,.12);
    }
    .err-title{
        font-size:22px;font-weight:800;line-height:1.2;
        background:linear-gradient(90deg,var(--danger),var(--accent));
        -webkit-background-clip:text;background-clip:text;color:transparent;
    }
    .err-sub{color:var(--muted);font-size:13px;margin:2px 0 12px}

    .err-msg{
        white-space:pre-wrap; /* 保留换行 */
        padding:14px 16px;border-radius:16px;
        background:rgba(2,6,23,.04);
        border:1px solid var(--card-border);
        font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
        font-size:13px; line-height:1.55;
    }
    @media (prefers-color-scheme: dark){
        .err-msg{ background:rgba(255,255,255,.04) }
    }

    .actions{display:flex;flex-wrap:wrap;gap:10px;margin-top:14px}
    .btn{
        display:inline-flex;align-items:center;gap:8px;
        padding:10px 14px;border-radius:12px;border:1px solid transparent;
        background:linear-gradient(135deg,var(--accent),var(--accent2));
        color:#fff;font-weight:600;text-decoration:none;cursor:pointer;
    }
    .btn:hover{box-shadow:0 0 0 8px var(--ring)}
    .btn-ghost{
        background:rgba(255,255,255,.7); color:inherit; border:1px solid var(--card-border);
    }
    @media (prefers-color-scheme: dark){ .btn-ghost{ background:rgba(15,23,42,.6) } }
</style>


<script>
    // 兜底：若外层未注入 logEvent，避免报错
    if (typeof window.logEvent !== 'function') {
        window.logEvent = function(type, msg){ try{ console.debug('[LOG]', type, msg || ''); }catch(e){} };
    }

    // 进入页面即记录错误页浏览
    window.addEventListener('load', function() {
        var errorMsg = '${sessionScope.errorMsg}' || '未知错误';
        var currentUrl = window.location.href;
        var referrer = document.referrer;

        logEvent('ERROR_PAGE', '访问错误页面', errorMsg.substring(0, 100), {
            errorMessage: errorMsg,
            currentUrl: currentUrl,
            referrer: referrer,
            user: '${sessionScope.loginAccount.username}' || '未登录用户',
            timestamp: new Date().toISOString()
        });
    });

    // 增强版按钮动作记录
    function goBack(){
        logEvent('ERROR_ACTION', '点击返回上一页', '错误页面操作', {
            action: 'go_back',
            fromPage: 'error',
            user: '${sessionScope.loginAccount.username}' || '未登录用户',
            timestamp: new Date().toISOString()
        });
        history.back();
    }

    function reloadPage(){
        logEvent('ERROR_ACTION', '点击刷新页面', '错误页面操作', {
            action: 'reload',
            fromPage: 'error',
            user: '${sessionScope.loginAccount.username}' || '未登录用户',
            timestamp: new Date().toISOString()
        });
        location.reload();
    }

    async function copyError(){
        try{
            var txt = document.getElementById('errorMsgText')?.innerText || '';
            await navigator.clipboard.writeText(txt);
            logEvent('ERROR_ACTION', '复制错误信息', '错误页面操作', {
                action: 'copy_error',
                errorLength: txt.length,
                user: '${sessionScope.loginAccount.username}' || '未登录用户',
                timestamp: new Date().toISOString()
            });
            alert('错误信息已复制到剪贴板');
        }catch(e){
            alert('复制失败，请手动选择文本复制。');
        }
    }

    // 当错误卡片出现在视口时上报一次
    document.addEventListener('DOMContentLoaded', function(){
        var target = document.getElementById('ErrorPage');
        if ('IntersectionObserver' in window && target){
            var io = new IntersectionObserver(function(es){
                es.forEach(function(e){
                    if (e.isIntersecting){
                        logEvent('ERROR_VISIBLE', '错误信息对用户可见', '错误页面展示', {
                            visibility: 'visible',
                            user: '${sessionScope.loginAccount.username}' || '未登录用户',
                            timestamp: new Date().toISOString()
                        });
                        io.unobserve(e.target);
                    }
                });
            });
            io.observe(target);
        }
    });
</script>

<div class="wrap">
    <section id="ErrorPage" role="alert" aria-live="polite" aria-label="Error message">
        <div class="err-head">
     <span class="err-icon" aria-hidden="true">
       <!-- 简洁的感叹号图标 -->
       <svg width="22" height="22" viewBox="0 0 24 24" fill="none" aria-hidden="true">
         <path d="M12 8v5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
         <circle cx="12" cy="17" r="1.4" fill="currentColor"/>
         <path d="M12 3a9 9 0 1 1 0 18 9 9 0 0 1 0-18Z" stroke="currentColor" stroke-width="1.5" opacity=".6"/>
       </svg>
     </span>
            <div>
                <div class="err-title">抱歉，页面出错了</div>
                <div class="err-sub">请查看下面的错误详情，您可以返回上一页或刷新重试。</div>
            </div>
        </div>

        <!-- 用原有 JSTL 输出错误内容（不修改后端变量/逻辑） -->
        <div id="errorMsgText" class="err-msg">
            <c:out value="${sessionScope.errorMsg}"></c:out>
        </div>

        <div class="actions">
            <button type="button" class="btn-ghost btn" onclick="goBack()">返回上一页</button>
            <button type="button" class="btn-ghost btn" onclick="reloadPage()">刷新页面</button>
            <button type="button" class="btn" onclick="copyError()">复制错误信息</button>
        </div>
    </section>
</div>

<%@ include file="../common/bottom.jsp"%>
