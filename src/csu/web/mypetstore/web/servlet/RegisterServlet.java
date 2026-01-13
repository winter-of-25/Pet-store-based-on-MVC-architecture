package csu.web.mypetstore.web.servlet;

import csu.web.mypetstore.domain.Account;
import csu.web.mypetstore.domain.Product;
import csu.web.mypetstore.service.AccountService;
import csu.web.mypetstore.service.CatalogService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import csu.web.mypetstore.service.CatalogService;



public class RegisterServlet extends HttpServlet {

    private static final String Register_FORM = "/WEB-INF/jsp/account/register.jsp";
    private static final String SIGN_ON_FORM = "/WEB-INF/jsp/account/signOn.jsp";
    private static final long CAPTCHA_EXPIRE_TIME = 5 * 60 * 1000; // 5分钟
    private String username;
    private String password;
    private String loginMsg;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.username = req.getParameter("username");
        this.password = req.getParameter("password");
        this.loginMsg = req.getParameter("loginMsg");

        String captchaInput = req.getParameter("captcha");
        HttpSession session = req.getSession();
        AccountService accountService=new AccountService();
        Account loginAccount = null;
        try {
            loginAccount = accountService.getAccount(this.username,this.password);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        if(loginAccount==null) {


            // 校验输入准确性
            if (!validate()) {
                req.setAttribute("loginMsg", this.loginMsg);
                req.getRequestDispatcher(Register_FORM).forward(req, resp);
            } else {
                try {
                    // 创建Account对象并设置所有属性
                    Account account = new Account();

                    // 设置登录信息
                    account.setUsername(this.username);
                    account.setPassword(this.password);

                    // 设置个人信息
                    account.setEmail(req.getParameter("email"));
                    account.setFirstName(req.getParameter("firstName"));
                    account.setLastName(req.getParameter("lastName"));
                    account.setStatus(req.getParameter("status"));
                    account.setPhone(req.getParameter("phone"));

                    // 设置地址信息
                    account.setAddress1(req.getParameter("address1"));
                    account.setAddress2(req.getParameter("address2"));
                    account.setCity(req.getParameter("city"));
                    account.setState(req.getParameter("state"));
                    account.setZip(req.getParameter("zip"));
                    account.setCountry(req.getParameter("country"));

                    // 设置偏好设置
                    account.setFavouriteCategoryId(req.getParameter("favouriteCategoryId"));
                    account.setLanguagePreference(req.getParameter("languagePreference"));

                    // 处理复选框字段
                    String listOption = req.getParameter("listOption");
                    account.setListOption("true".equals(listOption));

                    String bannerOption = req.getParameter("bannerOption");
                    account.setBannerOption("true".equals(bannerOption));

                    account.setBannerName(req.getParameter("bannerName"));

                    String captchaResult = verifyCaptcha(captchaInput, session);
                    if (!"success".equals(captchaResult)) {
                        this.loginMsg = captchaResult;
                        req.setAttribute("loginMsg", this.loginMsg);
                        req.getRequestDispatcher(SIGN_ON_FORM).forward(req, resp);
                    }
                    // 调用服务层插入账户
                    accountService.insertAccount(account);

                    loginMsg = "注册成功，欢迎登录";
                    req.setAttribute("loginMsg", this.loginMsg);
                    req.getRequestDispatcher(SIGN_ON_FORM).forward(req, resp);

                } catch (Exception e) {
                    e.printStackTrace();
                    loginMsg = "注册失败，请重试";
                    req.setAttribute("loginMsg", this.loginMsg);
                    req.getRequestDispatcher(Register_FORM).forward(req, resp);
                }
            }
        }
        else{
            this.loginMsg="该用户已存在";
            req.setAttribute("loginMsg", this.loginMsg);
            req.getRequestDispatcher(Register_FORM).forward(req, resp);
        }
    }

    private boolean validate(){
        if(this.username == null || this.username.isEmpty()){
            this.loginMsg = "用户名不能为空";
            return false;
        }
        if(this.password == null || this.password.isEmpty()){
            this.loginMsg = "密码不能为空";
            return false;
        }
        return true;
    }
    private String verifyCaptcha(String userInput, HttpSession session) {
        if (userInput == null || userInput.trim().isEmpty()) {
            return "验证码不能为空";
        }

        String storedCode = (String) session.getAttribute("captchaCode");
        Long captchaTime = (Long) session.getAttribute("captchaTime");

        // 清除已使用的验证码
        session.removeAttribute("captchaCode");
        session.removeAttribute("captchaTime");

        if (storedCode == null) {
            return "验证码已失效，请刷新";
        }

        if (captchaTime == null || System.currentTimeMillis() - captchaTime > CAPTCHA_EXPIRE_TIME) {
            return "验证码已过期，请刷新";
        }

        if (!storedCode.equalsIgnoreCase(userInput.trim())) {
            return "验证码错误";
        }

        return "success";
    }
}