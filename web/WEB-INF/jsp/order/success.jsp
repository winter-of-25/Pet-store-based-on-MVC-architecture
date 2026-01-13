<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../common/top.jsp" %>

<style>
    :root {
        --bg: #f6f7fb;
        --text: #0f172a;
        --muted: #6b7280;
        --card: rgba(255, 255, 255, .78);
        --card-border: rgba(15, 23, 42, .08);
        --accent: #6366f1;
        --accent2: #22d3ee;
        --ring: rgba(99, 102, 241, .22);
        --ok: #10b981;
        --ok-weak: rgba(16, 185, 129, .12);
        --shadow: 0 18px 40px rgba(2, 6, 23, .12);
    }

    @media (prefers-color-scheme: dark) {
        :root {
            --bg: #0b1020;
            --text: #e5e7eb;
            --muted: #9ca3af;
            --card: rgba(13, 18, 36, .78);
            --card-border: rgba(148, 163, 184, .25);
            --accent: #60a5fa;
            --accent2: #8b5cf6;
            --ring: rgba(96, 165, 250, .28);
            --ok: #34d399;
            --ok-weak: rgba(52, 211, 153, .16);
            --shadow: 0 20px 45px rgba(0, 0, 0, .55);
        }
    }

    body {
        margin: 0;
        color: var(--text);
        background:
                radial-gradient(1200px 600px at -10% -10%, rgba(99, 102, 241, .18), transparent),
                radial-gradient(900px 600px at 110% 8%, rgba(34, 211, 238, .18), transparent),
                var(--bg);
        font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "PingFang SC", "Microsoft YaHei", Arial;
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
    }

    .wrap {
        max-width: 880px;
        margin: 48px auto 96px;
        padding: 0 24px
    }

    /* 卡片容器（沿用首页风格） */
    #Catalog {
        background: var(--card);
        border: 1px solid var(--card-border);
        border-radius: 22px;
        box-shadow: var(--shadow);
        backdrop-filter: blur(14px);
        padding: 28px 24px;
    }

    .success-head {
        display: flex;
        flex-direction: column;
        align-items: center;
        text-align: center;
        gap: 10px
    }

    .success-icon {
        width: 56px;
        height: 56px;
        border-radius: 999px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        background: var(--ok-weak);
        border: 1px solid rgba(16, 185, 129, .35);
    }

    .success-title {
        margin: 0;
        font-size: 24px;
        font-weight: 800;
        background: linear-gradient(90deg, var(--ok), var(--accent));
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
    }

    .success-sub {
        margin: 0;
        color: var(--muted);
        font-size: 13px
    }

    .countdown-box {
        margin: 18px 0 10px;
        text-align: center
    }

    .countdown-num {
        display: inline-block;
        min-width: 2ch;
        padding: 2px 8px;
        border-radius: 999px;
        background: rgba(15, 23, 42, .06);
        font-weight: 700;
    }

    @media (prefers-color-scheme: dark) {
        .countdown-num {
            background: rgba(255, 255, 255, .08)
        }
    }

    /* 进度条 */
    .bar-track {
        height: 8px;
        border-radius: 999px;
        background: rgba(15, 23, 42, .08);
        overflow: hidden
    }

    .bar-fill {
        height: 100%;
        width: 100%;
        border-radius: 999px;
        background: linear-gradient(90deg, var(--accent), var(--accent2));
        transition: width .35s ease;
    }

    @media (prefers-color-scheme: dark) {
        .bar-track {
            background: rgba(255, 255, 255, .12)
        }
    }

    /* 按钮（与全站一致） */
    .Button {
        appearance: none;
        border: 0;
        outline: 0;
        cursor: pointer;
        padding: 10px 16px;
        border-radius: 12px;
        background: linear-gradient(135deg, var(--accent), var(--accent2));
        color: #fff;
        font-weight: 700;
        font-size: 14px;
        text-decoration: none;
        display: inline-block;
        box-shadow: 0 8px 20px rgba(99, 102, 241, .25);
        transition: transform .08s ease, box-shadow .2s ease, filter .2s ease;
    }

    .Button:hover {
        transform: translateY(-1px);
        filter: brightness(1.05);
    }

    .Button:active {
        transform: translateY(0);
        box-shadow: 0 4px 12px rgba(99, 102, 241, .2);
    }

    .actions {
        margin-top: 18px;
        text-align: center
    }

    /* 防御性隐藏任何 For You/个性化 Banner */
    .for-you-banner,
    #ForYouBanner,
    .module-for-you,
    [data-module="foryou"],
    .for-you,
    .foryou,
    .for_you {
        display: none !important;
    }
</style>

<script>
    // 埋点兜底
    if (typeof window.logEvent !== 'function') {
        window.logEvent = function (type, msg) { try { console.debug('[LOG]', type, msg || ''); } catch (e) { } };
    }
</script>

<div class="wrap">
    <div id="Catalog">
        <div class="success-head" aria-live="polite">
                        <span class="success-icon" aria-hidden="true">
                            <!-- 简洁对勾图标 -->
                            <svg viewBox="0 0 24 24" width="26" height="26" fill="none" stroke="currentColor"
                                 style="color:var(--ok)">
                                <path d="M20 6L9 17l-5-5" stroke-width="2.5" stroke-linecap="round"
                                      stroke-linejoin="round" />
                            </svg>
                        </span>
            <h2 class="success-title">
                <c:out value="${successMessage}" />
            </h2>
            <p class="success-sub">感谢您的购买！订单已成功处理。</p>
        </div>

        <div class="countdown-box">
            <p>页面将在 <span id="countdown" class="countdown-num">5</span> 秒后自动跳转到首页…</p>
            <div class="bar-track" aria-hidden="true">
                <div id="barFill" class="bar-fill"></div>
            </div>
        </div>

        <div class="actions">
            <a href="mainForm" class="Button" onclick="logEvent('RETURN_HOME_CLICK','成功页-返回首页')">立即返回首页</a>
        </div>
    </div>
</div>

<script>
    // 倒计时与进度条
    (function () {
        var total = 5, remain = total;
        var num = document.getElementById('countdown');
        var bar = document.getElementById('barFill');

        function render() {
            num.textContent = remain;
            var pct = Math.max(0, Math.min(100, Math.round(remain / total * 100)));
            bar.style.width = pct + '%';
        }
        render();

        var timer = setInterval(function () {
            remain--;
            render();
            if (remain <= 0) {
                clearInterval(timer);
                window.location.href = 'mainForm';
            }
        }, 1000);

        // 进入页面埋点
        try { logEvent('ORDER_SUCCESS_VIEW', '展示成功页'); } catch (e) { }
    })();
</script>

<%@ include file="../common/bottom.jsp" %>