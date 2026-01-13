<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="../common/top.jsp" %>

<%
    String ctx = request.getContextPath();
%>

<style>
    /* 页面背景与布局 */
    body {
        background-color: #f8fafc; /* 浅灰背景 */
    }

    .checkout-container {
        max-width: 1000px;
        margin: 40px auto;
        padding: 0 20px;
        font-family: 'Poppins', -apple-system, sans-serif;
    }

    .page-title {
        text-align: center;
        margin-bottom: 30px;
        font-size: 28px;
        color: #1e293b;
        font-weight: 700;
    }

    /* --- 步骤条 (Stepper) 样式 --- */
    .stepper-wrapper {
        display: flex;
        justify-content: space-between;
        margin-bottom: 30px;
        position: relative;
    }

    .stepper-wrapper::before {
        content: '';
        position: absolute;
        top: 20px;
        left: 0;
        right: 0;
        height: 2px;
        background: #e2e8f0;
        z-index: 0;
        margin: 0 50px; /* 防止线头露出来 */
    }

    .step-item {
        position: relative;
        z-index: 1;
        text-align: center;
        width: 120px;
        cursor: pointer;
        transition: all 0.3s ease;
        opacity: 0.6;
    }

    .step-item.active {
        opacity: 1;
    }

    .step-item.active .step-circle {
        background: #3b82f6;
        color: white;
        border-color: #3b82f6;
        box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.2);
        transform: scale(1.1);
    }

    .step-circle {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: white;
        border: 2px solid #cbd5e1;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 10px;
        font-weight: bold;
        color: #64748b;
        transition: all 0.3s;
        font-size: 16px;
    }

    .step-label {
        font-size: 14px;
        font-weight: 600;
        color: #475569;
    }

    .step-item:hover .step-circle {
        border-color: #3b82f6;
        color: #3b82f6;
    }

    /* --- 内容卡片区域 --- */
    .content-card {
        background: white;
        border-radius: 16px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.05);
        padding: 40px;
        min-height: 400px;
        position: relative;
    }

    .tab-content {
        display: none;
        animation: fadeIn 0.4s ease-in-out;
    }

    .tab-content.active {
        display: block;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    /* Loading 状态 */
    #confirm-tab.loading {
        opacity: 0.5;
        pointer-events: none;
        position: relative;
    }

    /* --- 针对子页面 (address/payment) 的通用表单美化 --- */
    /* 即使子页面没有写class，这些样式也会生效 */
    .tab-content h3, .tab-content h4 {
        margin-top: 0;
        margin-bottom: 20px;
        color: #0f172a;
        font-size: 20px;
        border-bottom: 2px solid #f1f5f9;
        padding-bottom: 10px;
    }

    .tab-content table {
        width: 100%;
        border-collapse: collapse;
    }

    /* 输入框美化 */
    .tab-content input[type="text"],
    .tab-content input[type="tel"],
    .tab-content select,
    .tab-content textarea {
        width: 100%;
        padding: 10px 15px;
        margin: 5px 0 20px;
        display: inline-block;
        border: 1px solid #cbd5e1;
        border-radius: 8px;
        box-sizing: border-box;
        font-size: 14px;
        transition: border-color 0.2s;
    }

    .tab-content input:focus,
    .tab-content select:focus {
        outline: none;
        border-color: #3b82f6;
        box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
    }

    .tab-content label {
        font-weight: 500;
        color: #334155;
        font-size: 14px;
    }

    /* 按钮美化 */
    .tab-content button,
    .tab-content input[type="submit"] {
        background-color: #3b82f6;
        color: white;
        padding: 12px 24px;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-weight: 600;
        font-size: 14px;
        transition: background-color 0.2s;
        display: inline-block;
    }

    .tab-content button:hover,
    .tab-content input[type="submit"]:hover {
        background-color: #2563eb;
    }

    /* 购物车表格特别处理 (防止样式冲突) */
    #cart-tab table td {
        padding: 15px;
        border-bottom: 1px solid #f1f5f9;
    }
    #cart-tab table th {
        text-align: left;
        color: #64748b;
        font-weight: 600;
        padding-bottom: 10px;
    }

</style>

<div class="checkout-container">
    <h2 class="page-title">Checkout</h2>

    <div class="stepper-wrapper">
        <div class="step-item active" data-tab="cart-tab">
            <div class="step-circle">1</div>
            <div class="step-label">购物车</div>
        </div>
        <div class="step-item" data-tab="address-tab">
            <div class="step-circle">2</div>
            <div class="step-label">收货信息</div>
        </div>
        <div class="step-item" data-tab="payment-tab">
            <div class="step-circle">3</div>
            <div class="step-label">支付方式</div>
        </div>
        <div class="step-item" data-tab="confirm-tab">
            <div class="step-circle"><i class="fa fa-check"></i></div>
            <div class="step-label">确认订单</div>
        </div>
    </div>

    <div class="content-card">
        <div id="cart-tab" class="tab-content active">
            <%@ include file="../content/cartContent.jsp" %>
            <div style="text-align: right; margin-top: 20px;">
                <button onclick="switchStep('address-tab')">下一步：填写地址 &rarr;</button>
            </div>
        </div>

        <div id="address-tab" class="tab-content">
            <%@ include file="../content/addressContent.jsp" %>
            <div style="margin-top: 20px; display: flex; justify-content: space-between;">
                <button style="background:#94a3b8" onclick="switchStep('cart-tab')">&larr; 返回购物车</button>
                <button onclick="saveAddressAndNext()">保存并去支付 &rarr;</button>
            </div>
        </div>

        <div id="payment-tab" class="tab-content">
            <%@ include file="../content/paymentContent.jsp" %>
            <div style="margin-top: 20px; display: flex; justify-content: space-between;">
                <button style="background:#94a3b8" onclick="switchStep('address-tab')">&larr; 返回地址</button>
                <button onclick="savePaymentAndNext()">保存并预览订单 &rarr;</button>
            </div>
        </div>

        <div id="confirm-tab" class="tab-content">
            <%@ include file="newOrderContent.jsp" %>
        </div>
    </div>
</div>

<script>
    const steps = document.querySelectorAll('.step-item');
    const contents = document.querySelectorAll('.tab-content');

    // 切换 Tab 的核心函数
    function switchStep(targetId) {
        // 1. 处理 Tab 内容显示
        contents.forEach(c => c.classList.remove('active'));
        document.getElementById(targetId).classList.add('active');

        // 2. 处理步骤条高亮 (实现进度条效果: 当前及之前的步骤都高亮)
        let foundActive = false;

        // 我们需要找到目标 tab 在列表中的索引
        let targetIndex = -1;
        steps.forEach((step, index) => {
            if(step.dataset.tab === targetId) targetIndex = index;
        });

        // 循环设置样式
        steps.forEach((step, index) => {
            if (index <= targetIndex) {
                step.classList.add('active');
            } else {
                step.classList.remove('active');
            }
        });

        // 3. 特殊逻辑：确认订单页刷新
        if (targetId === 'confirm-tab') {
            loadConfirmTab();
        }
    }

    // 点击步骤条事件
    steps.forEach(step => {
        step.addEventListener('click', () => {
            switchStep(step.dataset.tab);
        });
    });

    // 加载确认页
    function loadConfirmTab() {
        const confirmTab = document.querySelector('#confirm-tab');
        confirmTab.classList.add('loading');

        fetch('<%=request.getContextPath()%>/loadConfirm', {
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        })
            .then(r => r.text())
            .then(html => {
                confirmTab.innerHTML = html;
            })
            .catch(err => console.error("加载订单详情失败", err))
            .finally(() => confirmTab.classList.remove('loading'));
    }

    // 封装的保存逻辑 - 结合了 UI 切换
    function saveAddressAndNext() {
        // 尝试获取表单，防止 ID 不对
        const form = document.getElementById('addressForm') || document.querySelector('#address-tab form');
        if(!form) {
            alert('未找到地址表单');
            switchStep('payment-tab'); // 即使没表单也跳过去演示
            return;
        }

        fetch('<%=ctx%>/saveAddress', {
            method: 'POST',
            body: new URLSearchParams(new FormData(form)),
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        })
            .then(r => r.json())
            .then(d => {
                if (d.success) {
                    // 成功后自动跳转下一步
                    switchStep('payment-tab');
                } else {
                    alert(d.message || '保存失败');
                }
            })
            .catch(err => {
                console.error(err);
                // 开发阶段容错，如果后端没通，允许跳转
                switchStep('payment-tab');
            });
    }

    function savePaymentAndNext() {
        const form = document.getElementById('paymentForm') || document.querySelector('#payment-tab form');
        if(!form) {
            switchStep('confirm-tab');
            return;
        }

        fetch('<%=ctx%>/savePayment', {
            method: 'POST',
            body: new URLSearchParams(new FormData(form)),
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        })
            .then(r => r.json())
            .then(d => {
                if (d.success) {
                    switchStep('confirm-tab');
                } else {
                    alert(d.message || '保存失败');
                }
            })
            .catch(err => {
                console.error(err);
                switchStep('confirm-tab');
            });
    }

</script>

<%@ include file="../common/bottom.jsp" %>