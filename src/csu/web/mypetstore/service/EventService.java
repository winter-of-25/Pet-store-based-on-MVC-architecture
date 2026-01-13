package csu.web.mypetstore.service;

import csu.web.mypetstore.domain.Event;
import csu.web.mypetstore.persistence.EventDao;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.List;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

public class EventService {
    private EventDao eventDao;

    public EventService() {
        this.eventDao = new EventDao();
    }

    /**
     * 记录通用事件（增强版）
     */
    public void logEvent(HttpServletRequest request, String eventType, String eventData) {
        try {
            Event event = createEnhancedEvent(request);
            event.setEventType(eventType);
            event.setEventData(eventData);
            event.setPageName(request.getRequestURI());

            eventDao.insertEvent(event);
            System.out.println("记录事件: " + eventType + " - " + eventData);
        } catch (Exception e) {
            System.err.println("记录事件失败: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * 记录详细事件（包含额外参数）
     */
    public void logDetailedEvent(HttpServletRequest request, String eventType,
                                 String action, String target, Map<String, Object> additionalInfo) {
        try {
            Event event = createEnhancedEvent(request);
            event.setEventType(eventType);

            // 构建详细的事件数据JSON
            StringBuilder eventData = new StringBuilder();
            eventData.append("{");
            eventData.append("\"action\": \"").append(escapeJson(action)).append("\"");
            eventData.append(", \"target\": \"").append(escapeJson(target)).append("\"");

            // 添加额外信息
            if (additionalInfo != null && !additionalInfo.isEmpty()) {
                for (Map.Entry<String, Object> entry : additionalInfo.entrySet()) {
                    eventData.append(", \"").append(escapeJson(entry.getKey())).append("\": ");
                    if (entry.getValue() instanceof String) {
                        eventData.append("\"").append(escapeJson(entry.getValue().toString())).append("\"");
                    } else {
                        eventData.append(entry.getValue());
                    }
                }
            }

            // 添加请求信息
            eventData.append(", \"requestMethod\": \"").append(request.getMethod()).append("\"");
            eventData.append(", \"userAgent\": \"").append(escapeJson(request.getHeader("User-Agent"))).append("\"");
            eventData.append(", \"referer\": \"").append(escapeJson(request.getHeader("Referer"))).append("\"");

            eventData.append("}");

            event.setEventData(eventData.toString());
            event.setPageName(request.getRequestURI());

            eventDao.insertEvent(event);
            System.out.println("记录详细事件: " + eventType + " - " + action + " - " + target);
        } catch (Exception e) {
            System.err.println("记录详细事件失败: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * 创建增强的事件对象（收集更多信息）
     */
    private Event createEnhancedEvent(HttpServletRequest request) {
        Event event = new Event();
        event.setIpAddress(getClientIpAddress(request));
        event.setSessionId(request.getSession().getId());

        // 增强用户信息收集
        Object userObj = request.getSession().getAttribute("loginAccount");
        if (userObj != null) {
            try {
                // 根据您的用户对象结构调整这里
                // 假设用户对象有getUserId()和getUsername()方法
                // 如果您的用户对象不同，请相应调整
                java.lang.reflect.Method getUserIdMethod = userObj.getClass().getMethod("getUserId");
                java.lang.reflect.Method getUsernameMethod = userObj.getClass().getMethod("getUsername");

                Long userId = (Long) getUserIdMethod.invoke(userObj);
                String username = (String) getUsernameMethod.invoke(userObj);

                event.setUserId(userId);
                event.setUserName(username);
            } catch (Exception e) {
                // 如果反射失败，尝试其他方式获取用户信息
                try {
                    // 尝试从session中直接获取用户信息
                    String username = (String) request.getSession().getAttribute("username");
                    Long userId = (Long) request.getSession().getAttribute("userId");

                    if (username != null) event.setUserName(username);
                    if (userId != null) event.setUserId(userId);
                } catch (Exception ex) {
                    System.err.println("获取用户信息失败: " + ex.getMessage());
                }
            }
        }

        return event;
    }

    /**
     * 记录页面访问事件（增强版）
     */
    public void logPageView(HttpServletRequest request, String pageName) {
        Map<String, Object> additionalInfo = new HashMap<>();
        additionalInfo.put("pageTitle", getPageTitle(pageName));
        additionalInfo.put("queryString", request.getQueryString());

        logDetailedEvent(request, Event.PAGE_VIEW, "访问页面", pageName, additionalInfo);
    }

    /**
     * 记录按钮点击事件（增强版）
     */
    public void logButtonClick(HttpServletRequest request, String buttonName, String context) {
        Map<String, Object> additionalInfo = new HashMap<>();
        additionalInfo.put("context", context);
        additionalInfo.put("buttonId", getButtonIdentifier(request));

        logDetailedEvent(request, Event.BUTTON_CLICK, "点击按钮", buttonName, additionalInfo);
    }

    /**
     * 记录链接点击事件（增强版）
     */
    public void logLinkClick(HttpServletRequest request, String linkName, String linkUrl) {
        Map<String, Object> additionalInfo = new HashMap<>();
        additionalInfo.put("linkUrl", linkUrl);
        additionalInfo.put("linkText", linkName);

        logDetailedEvent(request, Event.LINK_CLICK, "点击链接", linkName, additionalInfo);
    }

    /**
     * 记录表单提交事件（增强版）
     */
    public void logFormSubmit(HttpServletRequest request, String formName, String formAction) {
        Map<String, Object> additionalInfo = new HashMap<>();
        additionalInfo.put("formAction", formAction);
        additionalInfo.put("formMethod", request.getMethod());
        // 可以记录部分表单字段（注意不要记录敏感信息）
        additionalInfo.put("fieldCount", getFormFieldCount(request));

        logDetailedEvent(request, Event.FORM_SUBMIT, "提交表单", formName, additionalInfo);
    }

    /**
     * 记录搜索事件（增强版）
     */
    public void logSearch(HttpServletRequest request, String keyword, String searchType) {
        Map<String, Object> additionalInfo = new HashMap<>();
        additionalInfo.put("searchType", searchType);
        additionalInfo.put("resultCount", request.getAttribute("searchResultCount"));
        additionalInfo.put("searchParams", request.getQueryString());

        logDetailedEvent(request, Event.SEARCH, "执行搜索", keyword, additionalInfo);
    }

    /**
     * 记录用户登录事件
     */
    public void logUserLogin(HttpServletRequest request, String username, boolean success) {
        Map<String, Object> additionalInfo = new HashMap<>();
        additionalInfo.put("loginSuccess", success);
        additionalInfo.put("loginTime", new Date().toString());

        logDetailedEvent(request, Event.USER_LOGIN, "用户登录", username, additionalInfo);
    }

    /**
     * 记录用户登出事件
     */
    public void logUserLogout(HttpServletRequest request, String username) {
        Map<String, Object> additionalInfo = new HashMap<>();
        additionalInfo.put("logoutTime", new Date().toString());

        logDetailedEvent(request, Event.USER_LOGOUT, "用户登出", username, additionalInfo);
    }

    /**
     * 记录购物车操作
     */
    public void logCartAction(HttpServletRequest request, String action, String itemId, int quantity) {
        Map<String, Object> additionalInfo = new HashMap<>();
        additionalInfo.put("itemId", itemId);
        additionalInfo.put("quantity", quantity);
        additionalInfo.put("actionType", action);

        logDetailedEvent(request,
                action.equals("add") ? Event.ADD_TO_CART : Event.REMOVE_FROM_CART,
                "购物车操作", itemId, additionalInfo);
    }

    // 辅助方法
    private String getClientIpAddress(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    private String getPageTitle(String pageName) {
        // 根据页面路径返回对应的页面标题
        Map<String, String> pageTitles = new HashMap<>();
        pageTitles.put("/mainForm", "主页");
        pageTitles.put("/categoryForm", "商品分类");
        pageTitles.put("/productForm", "商品详情");
        pageTitles.put("/cartForm", "购物车");
        pageTitles.put("/signOnForm", "登录页面");
        // 添加更多页面映射...

        return pageTitles.getOrDefault(pageName, pageName);
    }

    private String getButtonIdentifier(HttpServletRequest request) {
        // 尝试从请求中获取按钮标识符
        String buttonId = request.getParameter("buttonId");
        if (buttonId != null) return buttonId;

        String buttonName = request.getParameter("buttonName");
        if (buttonName != null) return buttonName;

        return "unknown";
    }

    private int getFormFieldCount(HttpServletRequest request) {
        int count = 0;
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            paramNames.nextElement();
            count++;
        }
        return count;
    }

    // 原有的查询方法保持不变
    public List<Event> findEventsByType(String eventType) {
        return eventDao.findEventsByType(eventType);
    }

    public List<Event> findEventsByUserId(Long userId) {
        return eventDao.findEventsByUserId(userId);
    }

    public List<Event> findAllEvents() {
        return eventDao.findAllEvents();
    }

    public List<Event> findRecentEvents(int limit) {
        return eventDao.findRecentEvents(limit);
    }

    public List<Event> findEventsByDateRange(Date startDate, Date endDate) {
        return eventDao.findEventsByDateRange((java.sql.Date) startDate, (java.sql.Date) endDate);
    }

    public List<Event> findEventsBySession(String sessionId) {
        return eventDao.findEventsBySessionId(sessionId);
    }

    public List<EventDao.EventStats> getEventStatistics() {
        return eventDao.getEventStatistics();
    }

    public List<EventDao.EventStats> getEventTypeStatistics() {
        return eventDao.getEventStatistics();
    }

    public List<EventDao.PageStats> getPopularPages(int limit) {
        return eventDao.getPopularPages(limit);
    }

    public List<EventDao.UserStats> getActiveUsers(int limit) {
        return eventDao.getActiveUsers(limit);
    }
}