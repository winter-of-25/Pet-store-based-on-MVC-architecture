package csu.web.mypetstore.web.servlet;

import csu.web.mypetstore.service.EventService;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebFilter("/*")
public class EventFilter implements Filter {
    private EventService eventService;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        eventService = new EventService();
        System.out.println("增强版事件监听过滤器已启动");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        // 设置请求和响应的字符编码为UTF-8
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String requestURI = httpRequest.getRequestURI();
        String method = httpRequest.getMethod();

        // 只处理需要记录的请求，排除静态资源
        if (shouldLogRequest(requestURI)) {

            // 记录页面访问事件（增强版）
            eventService.logPageView(httpRequest, requestURI);

            // 记录搜索事件（增强版）
            if (requestURI.contains("search") || httpRequest.getParameter("keyword") != null) {
                String keyword = httpRequest.getParameter("keyword");
                if (keyword != null && !keyword.trim().isEmpty()) {
                    String searchType = requestURI.contains("product") ? "商品搜索" : "全局搜索";
                    eventService.logSearch(httpRequest, keyword, searchType);
                }
            }

            // 记录登录事件
            if (requestURI.contains("signon") && "POST".equalsIgnoreCase(method)) {
                String username = httpRequest.getParameter("username");
                boolean success = httpRequest.getSession().getAttribute("loginAccount") != null;
                eventService.logUserLogin(httpRequest, username, success);
            }

            // 记录登出事件
            if (requestURI.contains("signoff")) {
                String username = (String) httpRequest.getSession().getAttribute("username");
                if (username == null) username = "未知用户";
                eventService.logUserLogout(httpRequest, username);
            }

            // 记录购物车操作
            if (requestURI.contains("cart") && "POST".equalsIgnoreCase(method)) {
                String action = httpRequest.getParameter("action");
                String itemId = httpRequest.getParameter("itemId");
                String quantityStr = httpRequest.getParameter("quantity");

                if ("addItemToCart".equals(action) && itemId != null) {
                    int quantity = 1;
                    try {
                        quantity = Integer.parseInt(quantityStr);
                    } catch (NumberFormatException e) {
                        // 使用默认数量
                    }
                    eventService.logCartAction(httpRequest, "add", itemId, quantity);
                } else if ("removeItemFromCart".equals(action) && itemId != null) {
                    eventService.logCartAction(httpRequest, "remove", itemId, 0);
                }
            }
        }

        chain.doFilter(request, response);
    }

    private boolean shouldLogRequest(String requestURI) {
        // 排除静态资源
        return !requestURI.endsWith(".css") &&
                !requestURI.endsWith(".js") &&
                !requestURI.endsWith(".gif") &&
                !requestURI.endsWith(".png") &&
                !requestURI.endsWith(".jpg") &&
                !requestURI.endsWith(".ico") &&
                !requestURI.contains("/eventLogger") &&
                !requestURI.contains("/CaptchaServlet");
    }

    @Override
    public void destroy() {
        System.out.println("事件监听过滤器已关闭");
    }
}