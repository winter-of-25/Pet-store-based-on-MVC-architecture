package csu.web.mypetstore.web.servlet;

import csu.web.mypetstore.domain.Account;
import csu.web.mypetstore.domain.Cart;
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

public class SignOnServlet extends HttpServlet {

    private static final String SIGN_ON_FORM = "/WEB-INF/jsp/account/signOn.jsp";

    private String username;
    private String password;
    private String loginMsg;
    private static final long CAPTCHA_EXPIRE_TIME = 5 * 60 * 1000; // 5分钟
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            this.username=req.getParameter("username");
            this.password=req.getParameter("password");
        String captchaInput = req.getParameter("captcha");

        HttpSession session = req.getSession();

        if(!validate()){
            req.setAttribute("loginMsg",this.loginMsg);
            req.getRequestDispatcher(SIGN_ON_FORM).forward(req, resp);
        }else{
            AccountService accountService=new AccountService();
            Account loginAccount = null;
            try {
                loginAccount = accountService.getAccount(this.username,this.password);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
            if(loginAccount==null){
                this.loginMsg="用户名与密码不匹配!";
                req.setAttribute("loginMsg",this.loginMsg);
                req.getRequestDispatcher(SIGN_ON_FORM).forward(req, resp);
            }else{
                String captchaResult = verifyCaptcha(captchaInput, session);
                if (!"success".equals(captchaResult)) {
                    this.loginMsg = captchaResult;
                    req.setAttribute("loginMsg",this.loginMsg);
                    req.getRequestDispatcher(SIGN_ON_FORM).forward(req, resp);
                }
                loginAccount.setPassword(null);
                     session=req.getSession();
                    session.setAttribute("loginAccount",loginAccount);

                Cart cart = new Cart(loginAccount.getUsername());
                session.setAttribute("cart", cart);

                    if(loginAccount.isListOption()){
                        CatalogService catalogService=new CatalogService();
                        List<Product> mylist = catalogService.getProductListByCategory(loginAccount.getFavouriteCategoryId());
                        session.setAttribute("myList",mylist);
                    }

                    resp.sendRedirect("mainForm");
            }
        }
}

    private boolean validate(){
        if(this.username==null || this.username.isEmpty()){
            this.loginMsg="用户名不能为空";
            return false;
        }
        if(this.password==null || this.password.isEmpty()){
            this.loginMsg="密码不能为空";
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

        if (!storedCode.equalsIgnoreCase(userInput)) {
            return "验证码错误";
        }

        return "success";
    }
}
