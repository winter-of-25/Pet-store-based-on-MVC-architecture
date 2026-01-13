package csu.web.mypetstore.web.servlet;

import csu.web.mypetstore.service.EventService;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/eventLogger")
public class EventLoggerServlet extends HttpServlet {
    private EventService eventService;

    @Override
    public void init() throws ServletException {
        eventService = new EventService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain; charset=UTF-8");

        String eventType = request.getParameter("eventType");
        String eventData = request.getParameter("eventData");

        try {
            if (eventType != null && eventData != null) {
                // 如果是JSON格式的数据，直接记录
                if (eventData.trim().startsWith("{")) {
                    eventService.logEvent(request, eventType, eventData);
                } else {
                    // 旧格式的字符串数据
                    eventService.logEvent(request, eventType, eventData);
                }
                response.getWriter().write("事件记录成功");
            } else {
                response.getWriter().write("参数缺失");
            }
        } catch (Exception e) {
            response.getWriter().write("事件记录失败: " + e.getMessage());
        }
    }
}