<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="address-list">
    <h3>选择收货地址</h3>
    <div id="addressForm">
        收货人：<input type="text" name="receiverName" id="receiverName" placeholder="姓名">
        <br>
        电话：<input type="text" name="receiverPhone" id="receiverPhone" placeholder="电话">
        <br>
        地址：<input type="text" name="receiverAddress" id="receiverAddress" placeholder="地址">
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(function () {

        // 实时输入 -> 本地显示 + AJAX 保存
        let timer;
        $('#receiverName, #receiverPhone, #receiverAddress').on('input', function () {
            clearTimeout(timer);
            const field = $(this).attr('name');
            const value = $(this).val();
            timer = setTimeout(() => saveAddress(field, value), 400);

            $("#showName").text($("#receiverName").val());
            $("#showPhone").text($("#receiverPhone").val());
            $("#showAddress").text($("#receiverAddress").val());
        });

        function saveAddress(field, value) {
            $.ajax({
                url: '<%= request.getContextPath() %>/updateAddress',
                method: 'POST',
                data: { [field]: value },
                dataType: 'json',
                success: function (res) {
                    if (res.success) {
                        console.log("✅ 地址保存成功");

                        // 根据更新的字段修改提示消息
                        let updateMessage = '';
                        switch (field) {
                            case 'receiverName':
                                updateMessage = '已更新姓名';
                                break;
                            case 'receiverPhone':
                                updateMessage = '已更新电话';
                                break;
                            case 'receiverAddress':
                                updateMessage = '已更新地址';
                                break;
                        }

                        showMessage(updateMessage, 'success');  // 调用 showMessage 函数显示动态消息

                        // ✅ 成功后再同步一次（防止丢失）
                        $("#showName").text(res.name);
                        $("#showPhone").text(res.phone);
                        $("#showAddress").text(res.address);
                    }
                },
                error: function () {
                    console.error("❌ 地址更新失败");
                }
            });
        }

        // 防止表单提交刷新页面
        $('#addressForm').on('submit', function (e) {
            e.preventDefault();
        });
    });
</script>

