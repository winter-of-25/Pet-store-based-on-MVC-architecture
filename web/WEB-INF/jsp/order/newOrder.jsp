<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
        max-width: 900px;
        margin: 48px auto 96px;
        padding: 0 24px
    }

    /* 顶部欢迎区（与首页一致） */
    #Welcome {
        margin-bottom: 14px
    }

    #WelcomeContent {
        background: var(--card);
        border: 1px solid var(--card-border);
        border-radius: 16px;
        padding: 10px 14px;
        box-shadow: var(--shadow);
        backdrop-filter: blur(10px);
        font-size: 14px;
    }

    #WelcomeContent b,
    #WelcomeContent strong {
        font-weight: 800
    }

    #WelcomeContent .hello {
        display: inline-block;
        margin-left: 6px;
        padding: 2px 10px;
        border-radius: 999px;
        background: rgba(99, 102, 241, .12);
        color: var(--accent);
        font-size: 12px
    }

    /* 结算卡片 */
    #CheckoutContent {
        background: var(--card);
        border: 1px solid var(--card-border);
        border-radius: 22px;
        padding: 20px;
        box-shadow: var(--shadow);
        backdrop-filter: blur(14px);
    }

    #CheckoutContent h2 {
        margin: 0 0 12px;
        font-size: 20px;
        line-height: 1.3
    }

    .summary {
        display: grid;
        gap: 14px;
        margin: 10px 0 18px
    }

    .row {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        gap: 12px
    }

    .row .label {
        color: var(--muted)
    }

    .row .value {
        font-weight: 600
    }

    /* 地址分行样式（只用现有字段） */
    .addr {
        display: grid;
        gap: 8px
    }

    .addr-line {
        display: flex;
        align-items: center;
        gap: 8px;
        flex-wrap: wrap
    }

    .badge {
        display: inline-block;
        padding: 2px 8px;
        border-radius: 999px;
        background: rgba(15, 23, 42, .06);
        border: 1px solid var(--card-border);
        color: var(--muted);
        font-size: 12px;
        font-weight: 600;
    }

    @media (prefers-color-scheme: dark) {
        .badge {
            background: rgba(255, 255, 255, .08)
        }
    }

    .addr-text {
        font-weight: 700
    }

    /* 按钮：沿用主色+微动效 */
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

    /* 分隔符（与首页一致） */
    #Separator {
        height: 10px;
        color: transparent
    }

    /* 防御性隐藏任何外部注入的 For You/个性化 Banner（与首页一致） */
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
    // 与首页一致的埋点兜底
    if (typeof window.logEvent !== 'function') {
        window.logEvent = function (type, msg) { try { console.debug('[LOG]', type, msg || ''); } catch (e) { } };
    }

    // 增强版结算页面记录
    window.addEventListener('load', function() {
        var username = '${sessionScope.loginAccount.username}' || '未登录用户';
        var cartSize = '${sessionScope.cart.numberOfItems}' || 0;
        var subtotal = '${sessionScope.cart.subTotal}' || '0';

        logEvent('CHECKOUT_VIEW', '进入结算页面', 'newOrder.jsp', {
            user: username,
            cartSize: parseInt(cartSize),
            subtotal: subtotal,
            hasAddress: ${not empty sessionScope.loginAccount.address1},
            timestamp: new Date().toISOString()
        });
    });

    // 增强版结算提交记录
    function logCheckoutSubmit() {
        var username = '${sessionScope.loginAccount.username}' || '未登录用户';
        var cartSize = '${sessionScope.cart.numberOfItems}' || 0;
        var subtotal = '${sessionScope.cart.subTotal}' || '0';

        logEvent('CHECKOUT_SUBMIT', '提交结算订单', '确认订单信息', {
            user: username,
            cartSize: parseInt(cartSize),
            subtotal: subtotal,
            paymentMethod: '待选择',
            shippingAddress: {
                state: '${sessionScope.loginAccount.state}',
                city: '${sessionScope.loginAccount.city}',
                address1: '${sessionScope.loginAccount.address1}'
            },
            timestamp: new Date().toISOString()
        });
    }
</script>
<div class="wrap">
    <div id="Welcome">
        <div id="WelcomeContent">
            <c:if test="${not empty sessionScope.loginAccount}">
                <script>logEvent('USER_VIEW_CHECKOUT', '进入结算页: ${sessionScope.loginAccount.username}');</script>
                欢迎，<b>${sessionScope.loginAccount.username}</b>！
                <span class="hello">结算中心</span>
            </c:if>
        </div>
    </div>

    <div id="Checkout">
        <div id="CheckoutContent">
            <h2>请确认您的订单信息</h2>

            <div class="summary">
                <div class="row">
                    <div class="label">应付金额</div>
                    <div class="value">
                        <fmt:formatNumber value="${sessionScope.cart.subTotal}" pattern="￥#,##0.00" />
                    </div>
                </div>

                <!-- 收货地址：仅使用已存在的 state / city / address1，绝不新增字段 -->
                <c:if test="${not empty sessionScope.loginAccount.state
                     or not empty sessionScope.loginAccount.city
                     or not empty sessionScope.loginAccount.address1}">
                    <div class="row">
                        <div class="label">收货地址</div>
                        <div class="value addr">
                            <c:if test="${not empty sessionScope.loginAccount.state}">
                                <div class="addr-line"><span class="badge">省/州</span><span
                                        class="addr-text">${sessionScope.loginAccount.state}</span>
                                </div>
                            </c:if>
                            <c:if test="${not empty sessionScope.loginAccount.city}">
                                <div class="addr-line"><span class="badge">城市</span><span
                                        class="addr-text">${sessionScope.loginAccount.city}</span></div>
                            </c:if>
                            <c:if test="${not empty sessionScope.loginAccount.address1}">
                                <div class="addr-line"><span class="badge">街道/地址1</span><span
                                        class="addr-text">${sessionScope.loginAccount.address1}</span>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:if>
            </div>

            <form action="checkoutForm" method="get" onsubmit="logEvent('CHECKOUT_SUBMIT','提交结算')">
                <input type="submit" value="立即结算" class="Button">
            </form>
        </div>
    </div>

    <div id="Separator">&nbsp;</div>
</div>

<%@ include file="../common/bottom.jsp" %>