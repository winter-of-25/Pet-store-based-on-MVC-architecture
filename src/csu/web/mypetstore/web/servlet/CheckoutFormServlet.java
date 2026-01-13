package csu.web.mypetstore.web.servlet;

import csu.web.mypetstore.domain.Account;
import csu.web.mypetstore.domain.Cart;
import csu.web.mypetstore.persistence.impl.CartDaoImpl;
import csu.web.mypetstore.persistence.CartDao;



import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class CheckoutFormServlet extends HttpServlet {
    private static final String SUCCESS_PAGE = "/WEB-INF/jsp/order/success.jsp";
    private static final String MAIN_PAGE = "/mainForm";

    private CartDao cartDao = new CartDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置字符编码
        resp.setContentType("text/html;charset=UTF-8");
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        Account loginAccount = (Account) session.getAttribute("loginAccount");
        Cart cart = (Cart) session.getAttribute("cart");

        // 检查用户是否登录
        if (loginAccount == null) {
            // 用户未登录，跳转到登录页面
            resp.sendRedirect("signOnForm");
            return;
        }

        // 检查购物车是否为空
        if (cart == null || cart.getNumberOfItems() == 0) {
            req.setAttribute("errorMessage", "购物车为空，无法结算！");
            req.getRequestDispatcher("/WEB-INF/jsp/cart/cart.jsp").forward(req, resp);
            return;
        }

        try {
            // 模拟支付处理逻辑
            // 这里可以添加实际的支付处理代码，如调用支付接口

            // 保存订单到数据库（这里可以扩展订单功能）
            // saveOrderToDatabase(loginAccount, cart);

            // 清空数据库中的购物车
            cartDao.clearCart(loginAccount.getUsername());

            // 清空会话中的购物车
            session.removeAttribute("cart");

            // 设置支付成功消息
            req.setAttribute("successMessage", "支付成功！");
            req.setAttribute("orderTotal", cart.getSubTotal());
            req.setAttribute("userName", loginAccount.getUsername());

            // 显示成功页面
            req.getRequestDispatcher(SUCCESS_PAGE).forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            // 支付失败处理
            req.setAttribute("errorMessage", "支付失败，请重试！");
            req.getRequestDispatcher("/WEB-INF/jsp/order/newOrder.jsp").forward(req, resp);
        }
    }
}