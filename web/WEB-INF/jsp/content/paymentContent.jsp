<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="payment-list">
    <h3>选择支付方式</h3>
    <c:forEach var="method" items="${paymentMethods}">
        <div class="payment-item">
            <label>
                <input type="radio" name="paymentMethod" class="payment-option"
                       value="${method}"
                       <c:if test="${selectedPayment != null && selectedPayment == method}">checked</c:if> />
                    ${method}
            </label>
        </div>
    </c:forEach>
</div>

<script>
    function updatePayment() {
        var selectedPayment = $("input[name='paymentMethod']:checked").val();

        $.ajax({
            type: "POST",
            url: "updatePayment",
            data: { paymentMethod: selectedPayment },
            dataType: "json",
            success: function(response) {
                if (response.success) {
                    showMessage('已更改支付方式', 'success');
                    $("#orderSummary").html("<p>支付方式：" + selectedPayment + "</p>");
                } else {
                    alert(response.message);
                }
            },
            error: function() {
                alert("更新支付方式失败，请重试");
            }
        });
    }

    // 绑定事件
    $(document).on('change', "input[name='paymentMethod']", updatePayment);
</script>


<label><input type="radio" name="paymentMethod" value="支付宝" onchange="updatePayment()"> 支付宝</label>
<label><input type="radio" name="paymentMethod" value="微信支付" onchange="updatePayment()"> 微信支付</label>
<label><input type="radio" name="paymentMethod" value="银行卡" onchange="updatePayment()"> 银行卡</label>

