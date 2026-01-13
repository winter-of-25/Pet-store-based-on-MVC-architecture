package csu.web.mypetstore.persistence;

import csu.web.mypetstore.domain.Event;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventDao {

    /**
     * 插入事件记录
     */
    public boolean insertEvent(Event event) {
        String sql = "INSERT INTO user_events (event_type, event_data, page_name, ip_address, session_id, user_id, user_name, create_time) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.execute("SET NAMES 'utf8mb4'");
            pstmt.execute("SET CHARACTER SET utf8mb4");
            pstmt.execute("SET character_set_connection = utf8mb4");

            pstmt.setString(1, event.getEventType());
            pstmt.setString(2, event.getEventData());
            pstmt.setString(3, event.getPageName());
            pstmt.setString(4, event.getIpAddress());
            pstmt.setString(5, event.getSessionId());

            // 处理可能为null的userId
            if (event.getUserId() != null) {
                pstmt.setLong(6, event.getUserId());
            } else {
                pstmt.setNull(6, Types.BIGINT);
            }

            pstmt.setString(7, event.getUserName());

            // 设置创建时间
            if (event.getCreateTime() != null) {
                pstmt.setTimestamp(8, new Timestamp(event.getCreateTime().getTime()));
            } else {
                pstmt.setTimestamp(8, new Timestamp(System.currentTimeMillis()));
            }

            int result = pstmt.executeUpdate();
            System.out.println("插入事件结果: " + (result > 0));
            return result > 0;

        } catch (Exception e) {
            System.err.println("插入事件时发生错误: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 根据事件类型查询事件
     */
    public List<Event> findEventsByType(String eventType) {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM user_events WHERE event_type = ? ORDER BY create_time DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, eventType);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                events.add(mapResultSetToEvent(rs));
            }

        } catch (Exception e) {
            System.err.println("查询事件时发生错误: " + e.getMessage());
            e.printStackTrace();
        }

        return events;
    }

    /**
     * 根据用户ID查询事件
     */
    public List<Event> findEventsByUserId(Long userId) {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM user_events WHERE user_id = ? ORDER BY create_time DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                events.add(mapResultSetToEvent(rs));
            }

        } catch (Exception e) {
            System.err.println("查询用户事件时发生错误: " + e.getMessage());
            e.printStackTrace();
        }

        return events;
    }

    /**
     * 根据会话ID查询事件
     */
    public List<Event> findEventsBySessionId(String sessionId) {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM user_events WHERE session_id = ? ORDER BY create_time DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, sessionId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                events.add(mapResultSetToEvent(rs));
            }

        } catch (Exception e) {
            System.err.println("查询会话事件时发生错误: " + e.getMessage());
            e.printStackTrace();
        }

        return events;
    }

    /**
     * 查询指定时间范围内的事件
     */
    public List<Event> findEventsByTimeRange(Date startTime, Date endTime) {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM user_events WHERE create_time BETWEEN ? AND ? ORDER BY create_time DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setTimestamp(1, new Timestamp(startTime.getTime()));
            pstmt.setTimestamp(2, new Timestamp(endTime.getTime()));
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                events.add(mapResultSetToEvent(rs));
            }

        } catch (Exception e) {
            System.err.println("查询时间范围事件时发生错误: " + e.getMessage());
            e.printStackTrace();
        }

        return events;
    }

    /**
     * 查询所有事件
     */
    public List<Event> findAllEvents() {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM user_events ORDER BY create_time DESC";

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                events.add(mapResultSetToEvent(rs));
            }

        } catch (Exception e) {
            System.err.println("查询所有事件时发生错误: " + e.getMessage());
            e.printStackTrace();
        }

        return events;
    }

    /**
     * 获取事件统计信息
     */
    public List<EventStats> getEventStatistics() {
        List<EventStats> stats = new ArrayList<>();
        String sql = "SELECT event_type, COUNT(*) as count, " +
                "MAX(create_time) as last_occurrence " +
                "FROM user_events GROUP BY event_type ORDER BY count DESC";

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                EventStats stat = new EventStats();
                stat.setEventType(rs.getString("event_type"));
                stat.setCount(rs.getInt("count"));
                stat.setLastOccurrence(rs.getTimestamp("last_occurrence"));
                stats.add(stat);
            }

        } catch (Exception e) {
            System.err.println("获取事件统计时发生错误: " + e.getMessage());
            e.printStackTrace();
        }

        return stats;
    }

    /**
     * 从ResultSet映射到Event对象
     */
    private Event mapResultSetToEvent(ResultSet rs) throws SQLException {
        Event event = new Event();
        event.setId(rs.getLong("id"));
        event.setEventType(rs.getString("event_type"));
        event.setEventData(rs.getString("event_data"));
        event.setPageName(rs.getString("page_name"));
        event.setIpAddress(rs.getString("ip_address"));
        event.setSessionId(rs.getString("session_id"));
        event.setUserId(rs.getLong("user_id"));
        if (rs.wasNull()) {
            event.setUserId(null);
        }
        event.setUserName(rs.getString("user_name"));
        event.setCreateTime(rs.getTimestamp("create_time"));
        return event;
    }

    /**
     * 测试数据库连接
     */
    public boolean testConnection() {
        try (Connection conn = DBUtil.getConnection()) {
            System.out.println("数据库连接成功!");
            return true;
        } catch (Exception e) {
            System.err.println("数据库连接失败: " + e.getMessage());
            return false;
        }
    }

    /**
     * 事件统计内部类
     */
    public static class EventStats {
        private String eventType;
        private int count;
        private Timestamp lastOccurrence;

        // getter和setter方法
        public String getEventType() { return eventType; }
        public void setEventType(String eventType) { this.eventType = eventType; }
        public int getCount() { return count; }
        public void setCount(int count) { this.count = count; }
        public Timestamp getLastOccurrence() { return lastOccurrence; }
        public void setLastOccurrence(Timestamp lastOccurrence) { this.lastOccurrence = lastOccurrence; }
    }

    public static void main(String[] args) {
        EventDao eventDAO = new EventDao();

        // 先测试数据库连接
        if (!eventDAO.testConnection()) {
            System.out.println("数据库连接失败，请检查配置");
            return;
        }

        // 创建一个完整的事件对象进行测试
        Event testEvent = new Event();
        testEvent.setEventType(Event.USER_LOGIN);
        testEvent.setEventData("用户登录测试");
        testEvent.setPageName("/signOn.jsp");
        testEvent.setIpAddress("127.0.0.1");
        testEvent.setSessionId("test_session_123");
        testEvent.setUserId(1L);
        testEvent.setUserName("testuser");

        System.out.println("测试事件创建时间: " + testEvent.getCreateTime());

        try {
            boolean success = eventDAO.insertEvent(testEvent);
            System.out.println("插入测试事件结果: " + success);

            // 测试查询功能
            List<Event> events = eventDAO.findEventsByType(Event.USER_LOGIN);
            System.out.println("查询到 " + events.size() + " 个登录事件");

            // 测试统计功能
            List<EventStats> stats = eventDAO.getEventStatistics();
            for (EventStats stat : stats) {
                System.out.println("事件类型: " + stat.getEventType() +
                        ", 次数: " + stat.getCount());
            }

        } catch (Exception e) {
            System.err.println("测试过程中发生错误: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public List<Event> findRecentEvents(int limit) {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM user_events ORDER BY create_time DESC LIMIT ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                events.add(mapResultSetToEvent(rs));
            }

        } catch (Exception e) {
            System.err.println("查询最近事件时发生错误: " + e.getMessage());
            e.printStackTrace();
        }

        return events;
    }

    /**
     * 查询日期范围内的事件
     */
    public List<Event> findEventsByDateRange(Date startDate, Date endDate) {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM user_events WHERE create_time BETWEEN ? AND ? ORDER BY create_time DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setTimestamp(1, new Timestamp(startDate.getTime()));
            pstmt.setTimestamp(2, new Timestamp(endDate.getTime()));
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                events.add(mapResultSetToEvent(rs));
            }

        } catch (Exception e) {
            System.err.println("查询日期范围事件时发生错误: " + e.getMessage());
            e.printStackTrace();
        }

        return events;
    }

    /**
     * 获取热门页面统计
     */
    public List<PageStats> getPopularPages(int limit) {
        List<PageStats> stats = new ArrayList<>();
        String sql = "SELECT page_name, COUNT(*) as visit_count, " +
                "MAX(create_time) as last_visit " +
                "FROM user_events WHERE page_name IS NOT NULL " +
                "GROUP BY page_name ORDER BY visit_count DESC LIMIT ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                PageStats stat = new PageStats();
                stat.setPageName(rs.getString("page_name"));
                stat.setVisitCount(rs.getInt("visit_count"));
                stat.setLastVisit(rs.getTimestamp("last_visit"));
                stats.add(stat);
            }

        } catch (Exception e) {
            System.err.println("获取热门页面统计时发生错误: " + e.getMessage());
            e.printStackTrace();
        }

        return stats;
    }

    /**
     * 获取活跃用户统计
     */
    public List<UserStats> getActiveUsers(int limit) {
        List<UserStats> stats = new ArrayList<>();
        String sql = "SELECT user_name, COUNT(*) as event_count, " +
                "MAX(create_time) as last_activity " +
                "FROM user_events WHERE user_name IS NOT NULL " +
                "GROUP BY user_name ORDER BY event_count DESC LIMIT ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                UserStats stat = new UserStats();
                stat.setUserName(rs.getString("user_name"));
                stat.setEventCount(rs.getInt("event_count"));
                stat.setLastActivity(rs.getTimestamp("last_activity"));
                stats.add(stat);
            }

        } catch (Exception e) {
            System.err.println("获取活跃用户统计时发生错误: " + e.getMessage());
            e.printStackTrace();
        }

        return stats;
    }

    /**
     * 页面统计内部类
     */
    public static class PageStats {
        private String pageName;
        private int visitCount;
        private Timestamp lastVisit;

        public String getPageName() { return pageName; }
        public void setPageName(String pageName) { this.pageName = pageName; }
        public int getVisitCount() { return visitCount; }
        public void setVisitCount(int visitCount) { this.visitCount = visitCount; }
        public Timestamp getLastVisit() { return lastVisit; }
        public void setLastVisit(Timestamp lastVisit) { this.lastVisit = lastVisit; }
    }

    /**
     * 用户统计内部类
     */
    public static class UserStats {
        private String userName;
        private int eventCount;
        private Timestamp lastActivity;

        public String getUserName() { return userName; }
        public void setUserName(String userName) { this.userName = userName; }
        public int getEventCount() { return eventCount; }
        public void setEventCount(int eventCount) { this.eventCount = eventCount; }
        public Timestamp getLastActivity() { return lastActivity; }
        public void setLastActivity(Timestamp lastActivity) { this.lastActivity = lastActivity; }
    }

}