package csu.web.mypetstore.web.servlet;

import csu.web.mypetstore.domain.Account;
import csu.web.mypetstore.service.AccountService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

// 使用注解配置路径，或者你在 web.xml 中配置也可以
@WebServlet("/usernameCheck")
public class UsernameCheckServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. 设置响应格式，防止中文乱码
        resp.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        // 2. 获取参数
        String username = req.getParameter("username");

        // 3. 简单判空
        if (username == null || username.trim().isEmpty()) {
            out.print("EMPTY");
            return;
        }

        // 4. 调用 Service 查询
        AccountService service = new AccountService();
        Account account = null; // 调用我们在第一步新增的方法
        try {
            account = service.getAccount(username);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        // 5. 返回结果
        if (account != null) {
            // 如果查到了对象，说明用户名已存在
            out.print("EXIST");
        } else {
            // 没查到，说明可用
            out.print("OK");
        }
    }
}