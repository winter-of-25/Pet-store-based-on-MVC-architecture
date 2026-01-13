package csu.web.mypetstore.web.servlet;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;

public class UpdateAddressServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession();

        // 当前 session 中的已有值
        String name = (String) session.getAttribute("name");
        String phone = (String) session.getAttribute("phone");
        String address = (String) session.getAttribute("address");

        // 检查更新的字段
        String newName = request.getParameter("receiverName");
        String newPhone = request.getParameter("receiverPhone");
        String newAddress = request.getParameter("receiverAddress");

        if (newName != null) name = newName;
        if (newPhone != null) phone = newPhone;
        if (newAddress != null) address = newAddress;

        // 更新 Session
        session.setAttribute("name", name);
        session.setAttribute("phone", phone);
        session.setAttribute("address", address);

        // 返回 JSON
        String json = String.format(
                "{\"success\":true,\"message\":\"地址已更新\",\"name\":\"%s\",\"phone\":\"%s\",\"address\":\"%s\"}",
                escapeJson(name), escapeJson(phone), escapeJson(address)
        );
        response.getWriter().write(json);

        System.out.println("[UpdateAddressServlet] session 已更新: name=" + name + ", phone=" + phone + ", address=" + address);
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}
