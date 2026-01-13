
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>
<%
    // 确保响应使用UTF-8编码
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
%>

<style>
    :root {
        --bg:#f6f7fb;
        --text:#0f172a;
        --muted:#6b7280;
        --card:rgba(255,255,255,.78);
        --card-border:rgba(15,23,42,.08);
        --accent:#6366f1;
        --accent2:#22d3ee;
        --ring:rgba(99,102,241,.22);
        --shadow:0 18px 40px rgba(2,6,23,.12);
        --danger:#ef4444;
    }
    @media (prefers-color-scheme: dark){
        :root{
            --bg:#020617;
            --text:#e5e7eb;
            --muted:#9ca3af;
            --card:rgba(15,23,42,.82);
            --card-border:rgba(148,163,184,.25);
            --accent:#60a5fa;
            --accent2:#8b5cf6;
            --ring:rgba(96,165,250,.28);
            --shadow:0 20px 45px rgba(0,0,0,.6);
        }
    }

    body{
        margin:0;
        color:var(--text);
        background:
                radial-gradient(1200px 600px at -10% -10%, rgba(99,102,241,.24), transparent),
                radial-gradient(900px 600px at 110% 10%, rgba(34,211,238,.22), transparent),
                var(--bg);
        font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "PingFang SC","Microsoft YaHei", Arial;
        -webkit-font-smoothing:antialiased;
        -moz-osx-font-smoothing:grayscale;
    }

    .page-wrap{
        max-width:1100px;
        margin:48px auto 96px;
        padding:0 24px;
    }

    /* 返回主菜单链接按钮化 */
    .back-link{
        display:inline-flex;
        align-items:center;
        gap:6px;
        padding:8px 14px;
        border-radius:999px;
        border:1px solid var(--card-border);
        background:rgba(15,23,42,.02);
        font-size:13px;
        color:var(--accent);
        text-decoration:none;
        margin-bottom:14px;
        backdrop-filter:blur(10px);
    }
    .back-link::before{
        content:"←";
        font-size:12px;
    }
    .back-link:hover{
        box-shadow:0 0 0 8px var(--ring);
        text-decoration:none;
    }

    /* 主容器、卡片样式 */
    #Catalog{
        display:flex;
        flex-direction:column;
        gap:18px;
    }
    #Cart{
        background:var(--card);
        border-radius:22px;
        border:1px solid var(--card-border);
        box-shadow:var(--shadow);
        backdrop-filter:blur(14px);
        padding:22px 22px 26px;
    }

    #Cart h2{
        margin:0 0 4px;
        font-size:26px;
        font-weight:800;
        background:linear-gradient(90deg,var(--text),var(--accent));
        -webkit-background-clip:text;
        background-clip:text;
        color:transparent;
    }
    #Cart .sub-title{
        margin:2px 0 16px;
        font-size:13px;
        color:var(--muted);
    }

    /* 表格整体 */
    #Cart table{
        width:100%;
        border-collapse:separate;
        border-spacing:0 8px;
        font-size:14px;
    }
    #Cart table tr:first-child th{
        font-size:11px;
        text-transform:uppercase;
        letter-spacing:.08em;
        color:var(--muted);
        padding:4px 10px 6px;
        background:transparent;
        border:none;
    }
    #Cart table tr:not(:first-child){
        background:rgba(255,255,255,.7);
    }
    @media(prefers-color-scheme: dark){
        #Cart table tr:not(:first-child){
            background:rgba(15,23,42,.92);
        }
    }

    #Cart table td{
        padding:12px 10px;
        vertical-align:middle;
    }
    #Cart table tr td:first-child{
        border-top-left-radius:14px;
        border-bottom-left-radius:14px;
    }
    #Cart table tr td:last-child{
        border-top-right-radius:14px;
        border-bottom-right-radius:14px;
    }

    /* 空购物车行 */
    #Cart table tr.empty-row td{
        text-align:center;
        color:var(--muted);
        font-weight:600;
    }

    /* 数量输入框（不改 name，仍是 text） */
    #Cart input[type="text"]{
        padding:8px 10px;
        border-radius:10px;
        border:1px solid var(--card-border);
        background:rgba(255,255,255,.9);
        outline:none;
        width:78px;
        font-size:13px;
    }
    #Cart input[type="text"]:focus{
        border-color:var(--accent);
        box-shadow:0 0 0 8px var(--ring);
    }

    /* 金额右对齐 */
    #Cart td:nth-child(6),
    #Cart td:nth-child(7){
        text-align:right;
        font-variant-numeric:tabular-nums;
    }

    /* “In Stock?” 居中一点 */
    #Cart td:nth-child(4){
        text-align:center;
        white-space:nowrap;
    }

    /* Remove 按钮、结算按钮、更新按钮 */
    .Button,
    .btn{
        display:inline-flex;
        align-items:center;
        justify-content:center;
        gap:6px;
        border-radius:999px;
        padding:8px 14px;
        border:1px solid var(--card-border);
        background:rgba(255,255,255,.9);
        font-size:13px;
        cursor:pointer;
        text-decoration:none;
        color:var(--text);
        white-space:nowrap;
    }
    .Button:hover,
    .btn:hover{
        box-shadow:0 0 0 7px var(--ring);
        text-decoration:none;
    }

    .btn-primary{
        background:linear-gradient(135deg,var(--accent),var(--accent2));
        border-color:transparent;
        color:#fff;
        font-weight:600;
    }

    .btn-danger{
        background:linear-gradient(135deg,#ef4444,#f97316);
        border-color:transparent;
        color:#fff;
        font-weight:600;
    }

    /* 小计行（使用原来的最后一行） */
    #Cart table tr.subtotal-row td{
        background:transparent;
        padding-top:16px;
        border:none;
        font-size:15px;
    }
    #Cart table tr.subtotal-row td:first-child{
        border-radius:0;
    }
    #Cart table tr.subtotal-row td:last-child{
        border-radius:0;
    }
    #Cart table tr.subtotal-row td{
        text-align:right;
    }
    #Cart table tr.subtotal-row input[type="submit"]{
        margin-left:12px;
    }

    /* Proceed to Checkout 区域 */
    #Cart .checkout-wrap{
        margin-top:12px;
        text-align:right;
    }

    /* MyList 区域稍微缩进一点 */
    #MyList{
        margin-top:10px;
        padding:12px 16px 4px;
        border-radius:16px;
        border:1px dashed var(--card-border);
        background:rgba(15,23,42,.02);
    }

    #Separator{
        height:12px;
        color:transparent;
    }

    @media(max-width:768px){
        #Cart{
            padding:18px 14px 20px;
        }
        #Cart h2{
            font-size:22px;
        }
        #Cart table{
            display:block;
            overflow-x:auto;
        }
        #Cart table tr.subtotal-row td{
            font-size:14px;
        }
    }
</style>

<script>

    // 更新购物车显示
    function updateCartDisplay(data) {
        // 更新每行商品价格
        if (data.updatedItems && data.updatedItems.length > 0) {
            data.updatedItems.forEach(item => {
                const input = document.querySelector('input[name="' + item.itemId + '"]');
                if (input) {
                    const row = input.closest('tr');
                    if (row && row.cells.length >= 7) {
                        // 更新单品总价
                        row.cells[6].textContent = '$' + parseFloat(item.totalCost).toFixed(2);
                    }
                }
            });
        }

        // 更新小计
        if (data.subTotal) {
            const subtotalCell = document.querySelector('tr.subtotal-row td:first-child');
            if (subtotalCell) {
                subtotalCell.innerHTML =
                    'Sub Total: $' + parseFloat(data.subTotal).toFixed(2) +
                    ' <input type="submit" value="Update Cart" class="btn btn-primary" ' +
                    'onclick="logEvent(\'BUTTON_CLICK\', \'点击更新购物车\')">';
            }
        }
    }



    // 显示消息函数
    function showMessage(message, type) {
        // 移除现有消息
        var existingMessage = document.getElementById('ajax-message');
        if (existingMessage) {
            existingMessage.remove();
        }

        // 创建新消息
        var messageDiv = document.createElement('div');
        messageDiv.id = 'ajax-message';
        messageDiv.style.cssText = `
            position: fixed;
            top: 26.5%;
            right: 45%;
            padding: 12px 20px;
            border-radius: 8px;
            color: white;
            font-weight: 600;
            z-index: 1000;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            transition: all 0.3s ease;
        `;

        if (type === 'success') {
            messageDiv.style.backgroundColor = '#10b981';
        } else {
            messageDiv.style.backgroundColor = '#ef4444';
        }

        messageDiv.textContent = message;
        document.body.appendChild(messageDiv);

        // 3秒后自动消失
        setTimeout(() => {
            if (messageDiv.parentNode) {
                messageDiv.style.opacity = '0';
                setTimeout(() => messageDiv.remove(), 300);
            }
        }, 3000);
    }

    // 页面加载时记录购物车浏览
    window.addEventListener('load', function() {
        var cartSize = '${sessionScope.cart.numberOfItems}';
        var subtotal = '${sessionScope.cart.subTotal}';
        var username = '${sessionScope.loginAccount.username}' || '未登录用户';

        logEvent('CART_VIEW', '查看购物车', 'cart.jsp', {
            cartSize: parseInt(cartSize) || 0,
            subtotal: subtotal,
            user: username,
            timestamp: new Date().toISOString()
        });

        // 实时更新购物车（输入框失焦或按下 Enter）
        document.querySelectorAll('#Cart input[type="text"][name]').forEach(input => {
            input.addEventListener('change', handleQuantityChange);
            input.addEventListener('keyup', function (e) {
                if (e.key === 'Enter') handleQuantityChange.call(this);
            });
        });

        function handleQuantityChange() {
            const itemId = this.name;
            const newQuantity = this.value.trim();

            // 检查是否是合法的正整数
            const isValidNumber = /^[1-9]\d*$/.test(newQuantity);

            // 构造请求参数
            const params = new URLSearchParams();
            params.append(itemId, newQuantity);

            // 判断是否需要删除商品
            const shouldRemove = !isValidNumber || parseInt(newQuantity) <= 0;

            fetch('updateCart', {
                method: 'POST',
                body: params,
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                }
            })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        // 更新界面显示
                        updateCartDisplay(data);

                        if (shouldRemove) {
                            // 删除该商品所在的行
                            const input = document.querySelector('input[name="' + itemId + '"]');
                            if (input) {
                                const row = input.closest('tr');
                                if (row) row.remove();
                            }

                            showMessage('已移除无效商品', 'success');
                        } else {
                            showMessage('已更新数量', 'success');
                        }

                        // 如果购物车为空，刷新页面显示空提示
                        if (parseInt(data.updatedItems?.length || 0) === 0 &&
                            document.querySelectorAll('table tr').length <= 2) {
                            location.reload();
                        }

                    } else {
                        showMessage('更新失败: ' + data.message, 'error');
                    }
                })
                .catch(() => showMessage('网络错误', 'error'));
        }


    });

    // 增强版移除商品记录
    function logRemoveItem(itemId, itemName) {
        var cartSize = '${sessionScope.cart.numberOfItems}';

        logEvent('REMOVE_FROM_CART', '从购物车移除商品', itemName, {
            itemId: itemId,
            cartSizeBefore: parseInt(cartSize) || 0,
            user: '${sessionScope.loginAccount.username}' || '未登录用户',
            timestamp: new Date().toISOString()
        });

        return confirm('确定要从购物车中移除这个商品吗？');
    }

    // 增强版结算记录
    function logCheckout() {
        var cartSize = '${sessionScope.cart.numberOfItems}';
        var subtotal = '${sessionScope.cart.subTotal}';

        logEvent('CHECKOUT_START', '开始结算流程', '购物车页面', {
            cartSize: parseInt(cartSize) || 0,
            subtotal: subtotal,
            user: '${sessionScope.loginAccount.username}' || '未登录用户',
            timestamp: new Date().toISOString()
        });
    }

    // 商品点击记录
    function logItemClick(itemId, itemName) {
        logEvent('PRODUCT_VIEW', '点击商品详情', itemName, {
            itemId: itemId,
            fromPage: 'cart',
            user: '${sessionScope.loginAccount.username}' || '未登录用户'
        });
    }
</script>


<div class="page-wrap">
    <a href="mainForm" class="back-link" onclick="logEvent('LINK_CLICK', '返回主菜单')">
        Return to Main Menu
    </a>

    <div id="Catalog">
        <div id="Cart">
            <h2>Shopping Cart</h2>
            <p class="sub-title">
                Review the items in your cart and update quantities before checkout.
            </p>

            <form action="updateCart" method="post">
                <table>
                    <tr>
                        <th><b>Item ID</b></th>
                        <th><b>Product ID</b></th>
                        <th><b>Description</b></th>
                        <th><b>In Stock?</b></th>
                        <th><b>Quantity</b></th>
                        <th><b>List Price</b></th>
                        <th><b>Total Cost</b></th>
                        <th>&nbsp;</th>
                    </tr>

                    <c:if test="${sessionScope.cart.numberOfItems == 0}">
                        <tr class="empty-row">
                            <td colspan="8"><b>Your cart is empty.</b></td>
                        </tr>
                    </c:if>

                    <c:forEach var="cartItem" items="${sessionScope.cart.cartItems}">
                        <tr>
                            <td>
                                <a href="itemForm?itemId=${cartItem.item.itemId}"
                                   onclick="logEvent('LINK_CLICK', '查看商品详情: ${cartItem.item.itemId}')">
                                        ${cartItem.item.itemId}
                                </a>
                            </td>
                            <td>${cartItem.item.product.productId}</td>
                            <td>
                                    ${cartItem.item.attribute1} ${cartItem.item.attribute2}
                                    ${cartItem.item.attribute3} ${cartItem.item.attribute4}
                                    ${cartItem.item.attribute5} ${cartItem.item.product.name}
                            </td>
                            <td>${cartItem.inStock}</td>
                            <td>
                                <input type="text"
                                       name="${cartItem.item.itemId}"
                                       value="${cartItem.quantity}"
                                       oninput="this.value=this.value.replace(/[^0-9]/g,'')"
                                       min="0" />

                            </td>
                            <td>
                                <fmt:formatNumber value="${cartItem.item.listPrice}"
                                                  pattern="$#,##0.00" />
                            </td>
                            <td>
                                <fmt:formatNumber value="${cartItem.total}"
                                                  pattern="$#,##0.00" />
                            </td>
                            <td>
                                <a href="removeCartItem?workingItemId=${cartItem.item.itemId}"
                                   class="Button btn-danger"
                                   onclick="return logRemoveItem('${cartItem.item.itemId}', '${cartItem.item.attribute1} ${cartItem.item.attribute2}')">
                                    Remove
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <tr class="subtotal-row">
                        <td colspan="7">
                            Sub Total:
                            <fmt:formatNumber value="${sessionScope.cart.subTotal}" pattern="$#,##0.00" />
                            <input type="submit" value="Update Cart"
                                   class="btn btn-primary"
                                   onclick="logEvent('BUTTON_CLICK', '点击更新购物车')">
                        </td>
                        <td>&nbsp;</td>
                    </tr>
                </table>
            </form>

            <c:if test="${sessionScope.cart.numberOfItems > 0}">
                <div class="checkout-wrap">
                    <a href="newOrderForm" class="Button btn-primary" onclick="logCheckout()">
                        Proceed to Checkout
                    </a>
                </div>
            </c:if>
        </div>

        <div id="MyList">
            <c:if test="${sessionScope.loginAccount != null}">
                <c:if test="${!empty sessionScope.loginAccount.listOption}">
                    <%@ include file="../cart/includeMyList.jsp"%>
                </c:if>
            </c:if>
        </div>

        <div id="Separator">&nbsp;</div>
    </div>
</div>
