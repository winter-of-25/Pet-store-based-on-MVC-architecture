package csu.web.mypetstore.domain;

import java.util.Date;

public class Event {
    private Long id;
    private String eventType;
    private String eventData;
    private String pageName;
    private String ipAddress;
    private Date createTime;
    private String sessionId;
    private Long userId;
    private String userName;

    // 事件类型常量
    public static final String PAGE_VIEW = "PAGE_VIEW";
    public static final String BUTTON_CLICK = "BUTTON_CLICK";
    public static final String FORM_SUBMIT = "FORM_SUBMIT";
    public static final String LINK_CLICK = "LINK_CLICK";
    public static final String PRODUCT_VIEW = "PRODUCT_VIEW";
    public static final String CATEGORY_VIEW = "CATEGORY_VIEW";
    public static final String ADD_TO_CART = "ADD_TO_CART";
    public static final String REMOVE_FROM_CART = "REMOVE_FROM_CART";
    public static final String USER_LOGIN = "USER_LOGIN";
    public static final String USER_LOGOUT = "USER_LOGOUT";
    public static final String USER_REGISTER = "USER_REGISTER";
    public static final String SEARCH = "SEARCH";
    public static final String CART_VIEW = "CART_VIEW";
    public static final String CHECKOUT_START = "CHECKOUT_START";

    // 无参构造方法
    public Event() {
        this.createTime = new Date();
    }

    // 全参构造方法
    public Event(String eventType, String eventData, String pageName,
                 String ipAddress, String sessionId, Long userId, String userName) {
        this();
        this.eventType = eventType;
        this.eventData = eventData;
        this.pageName = pageName;
        this.ipAddress = ipAddress;
        this.sessionId = sessionId;
        this.userId = userId;
        this.userName = userName;
    }

    // getter 和 setter 方法
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getEventType() { return eventType; }
    public void setEventType(String eventType) { this.eventType = eventType; }

    public String getEventData() { return eventData; }
    public void setEventData(String eventData) { this.eventData = eventData; }

    public String getPageName() { return pageName; }
    public void setPageName(String pageName) { this.pageName = pageName; }

    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }

    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }

    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    @Override
    public String toString() {
        return "Event{" +
                "id=" + id +
                ", eventType='" + eventType + '\'' +
                ", eventData='" + eventData + '\'' +
                ", pageName='" + pageName + '\'' +
                ", ipAddress='" + ipAddress + '\'' +
                ", createTime=" + createTime +
                ", sessionId='" + sessionId + '\'' +
                ", userId=" + userId +
                ", userName='" + userName + '\'' +
                '}';
    }
}