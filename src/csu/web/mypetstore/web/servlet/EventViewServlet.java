package csu.web.mypetstore.web.servlet;

import csu.web.mypetstore.domain.Event;
import csu.web.mypetstore.persistence.EventDao;
import csu.web.mypetstore.service.EventService;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/eventView")
public class EventViewServlet extends HttpServlet {
    private EventService eventService;
    private static final String ERROR_FORM = "/WEB-INF/jsp/statics/error.jsp";
    private static final String EVENTVIEW_FORM = "/WEB-INF/jsp/statics/eventView.jsp";

    private static final String EVENTSTATS_FORM = "/WEB-INF/jsp/statics/eventStats.jsp";


    @Override
    public void init() throws ServletException {
        eventService = new EventService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    showEventList(request, response);
                    break;
                case "stats":
                    showStatistics(request, response);
                    break;
                case "byType":
                    showEventsByType(request, response);
                    break;
                case "byUser":
                    showEventsByUser(request, response);
                    break;
                default:
                    showEventList(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "加载事件数据时发生错误: " + e.getMessage());
            request.getRequestDispatcher(ERROR_FORM).forward(request, response);
        }
    }

    /**
     * 显示事件列表
     */
    private void showEventList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String typeFilter = request.getParameter("typeFilter");
        String limitStr = request.getParameter("limit");
        int limit = 50; // 默认显示50条

        if (limitStr != null && !limitStr.isEmpty()) {
            try {
                limit = Integer.parseInt(limitStr);
            } catch (NumberFormatException e) {
                // 使用默认值
            }
        }

        List<Event> events;
        if (typeFilter != null && !typeFilter.isEmpty()) {
            events = eventService.findEventsByType(typeFilter);
        } else {
            events = eventService.findRecentEvents(limit);
        }

        request.setAttribute("events", events);
        request.setAttribute("eventTypes", getEventTypes());
        request.getRequestDispatcher(EVENTVIEW_FORM).forward(request, response);
    }

    /**
     * 显示统计信息
     */
    private void showStatistics(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<EventDao.EventStats> eventStats = eventService.getEventStatistics();
        List<EventDao.PageStats> pageStats = eventService.getPopularPages(10);
        List<EventDao.UserStats> userStats = eventService.getActiveUsers(10);

        request.setAttribute("eventStats", eventStats);
        request.setAttribute("pageStats", pageStats);
        request.setAttribute("userStats", userStats);
        request.getRequestDispatcher(EVENTSTATS_FORM).forward(request, response);
    }

    /**
     * 按类型显示事件
     */
    private void showEventsByType(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String eventType = request.getParameter("eventType");
        if (eventType != null && !eventType.isEmpty()) {
            List<Event> events = eventService.findEventsByType(eventType);
            request.setAttribute("events", events);
            request.setAttribute("currentEventType", eventType);
        }

        request.setAttribute("eventTypes", getEventTypes());
        request.getRequestDispatcher(EVENTVIEW_FORM).forward(request, response);
    }

    /**
     * 按用户显示事件
     */
    private void showEventsByUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userIdStr = request.getParameter("userId");
        if (userIdStr != null && !userIdStr.isEmpty()) {
            try {
                Long userId = Long.parseLong(userIdStr);
                List<Event> events = eventService.findEventsByUserId(userId);
                request.setAttribute("events", events);
                request.setAttribute("currentUserId", userId);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "无效的用户ID");
            }
        }

        request.getRequestDispatcher(EVENTVIEW_FORM).forward(request, response);
    }

    /**
     * 获取所有事件类型
     */
    private String[] getEventTypes() {
        return new String[]{
                Event.PAGE_VIEW,
                Event.BUTTON_CLICK,
                Event.FORM_SUBMIT,
                Event.LINK_CLICK,
                Event.PRODUCT_VIEW,
                Event.CATEGORY_VIEW,
                Event.ADD_TO_CART,
                Event.REMOVE_FROM_CART,
                Event.USER_LOGIN,
                Event.USER_LOGOUT,
                Event.USER_REGISTER,
                Event.SEARCH,
                Event.CART_VIEW,
                Event.CHECKOUT_START
        };
    }
}