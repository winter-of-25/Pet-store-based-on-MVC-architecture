package csu.web.mypetstore.web.servlet;

import csu.web.mypetstore.domain.Account;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;

public class UpdatePaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        HttpSession session = req.getSession();
        Account account = (Account) session.getAttribute("loginAccount");

        boolean isAjax = "XMLHttpRequest".equals(req.getHeader("X-Requested-With"));

        if (account == null) {
            sendJson(resp, false, "请先登录才能选择支付方式！");
            return;
        }

        String payment = req.getParameter("paymentMethod");
        if (payment != null && !payment.isEmpty()) {
            session.setAttribute("paymentMethod", payment);
            sendJson(resp, true, "支付方式已更新为：" + payment);
        } else {
            sendJson(resp, false, "未选择任何支付方式！");
        }
    }

    private void sendJson(HttpServletResponse resp, boolean success, String message) throws IOException {
        String json = String.format("{\"success\":%b,\"message\":\"%s\"}", success, message);
        resp.getWriter().write(json);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}
