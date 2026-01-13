package csu.web.mypetstore.web.servlet;

import csu.web.mypetstore.domain.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;

public class UpdateCartServlet extends HttpServlet {

    private static final String CART_FORM = "/WEB-INF/jsp/cart/cart.jsp";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        HttpSession session = req.getSession();
        Account account = (Account) session.getAttribute("loginAccount");
        Cart cart = (Cart) session.getAttribute("cart");

        boolean isAjax = "XMLHttpRequest".equals(req.getHeader("X-Requested-With"));

        // 未登录
        if (account == null) {
            handleError(resp, isAjax, "请先登录才能更新购物车！", req);
            return;
        }

        // 初始化购物车
        if (cart == null) {
            cart = new Cart(account.getUsername());
            session.setAttribute("cart", cart);
        }

        List<Map<String, Object>> updates = new ArrayList<>();
        boolean hasChanges = false;

        // 遍历所有表单参数（itemId -> quantity）
        Enumeration<String> names = req.getParameterNames();
        while (names.hasMoreElements()) {
            String itemId = names.nextElement();
            try {
                int quantity = Integer.parseInt(req.getParameter(itemId));

                // 如果数量小于等于 0 或者非法（例如负数）
                if (quantity <= 0) {
                    // 如果数量不合法或为0，直接从购物车中删除该商品
                    Item removedItem = cart.removeItemById(itemId);
                    if (removedItem != null) {
                        hasChanges = true;
                        updates.add(Map.of(
                                "itemId", itemId,
                                "totalCost", 0.0 // 直接删除后不再计算费用
                        ));
                    }
                } else {
                    // 修改数量
                    CartItem item = cart.getCartItemById(itemId);
                    if (item != null && item.getQuantity() != quantity) {
                        cart.setQuantityByItemId(itemId, quantity);
                        hasChanges = true;
                        updates.add(Map.of(
                                "itemId", itemId,
                                "totalCost", item.getTotal()
                        ));
                    }
                }
            } catch (NumberFormatException ignore) {
                // 如果出现非法字符（无法转换为整数），也删除该商品
                cart.removeItemById(itemId);
                hasChanges = true;
                updates.add(Map.of(
                        "itemId", itemId,
                        "totalCost", 0.0 // 删除的商品，不需要显示费用
                ));
            }
        }

        if (isAjax) {
            sendJson(resp, true,
                    hasChanges ? "购物车已更新！" : "没有需要更新的内容",
                    updates, cart.getNumberOfItems(), cart.getSubTotal().doubleValue());
        } else {
            req.getRequestDispatcher(CART_FORM).forward(req, resp);
        }
    }


    private void handleError(HttpServletResponse resp, boolean isAjax, String message,
                             HttpServletRequest req) throws IOException, ServletException {
        if (isAjax) {
            sendJson(resp, false, message, null, 0, 0.0);
        } else {
            req.setAttribute("errorMessage", message);
            req.getRequestDispatcher(CART_FORM).forward(req, resp);
        }
    }

    private void sendJson(HttpServletResponse resp, boolean success, String message,
                          List<Map<String, Object>> updates, int count, double subTotal) throws IOException {
        StringBuilder json = new StringBuilder("{");
        json.append("\"success\":").append(success)
                .append(",\"message\":\"").append(message).append("\"")
                .append(",\"subTotal\":").append(String.format("%.2f", subTotal))
                .append(",\"updatedItems\":[");

        if (updates != null) {
            for (int i = 0; i < updates.size(); i++) {
                Map<String, Object> u = updates.get(i);
                json.append("{\"itemId\":\"").append(u.get("itemId"))
                        .append("\",\"totalCost\":").append(String.format("%.2f", u.get("totalCost"))).append("}");
                if (i < updates.size() - 1) json.append(",");
            }
        }

        json.append("]}");
        resp.getWriter().write(json.toString());
    }
}
