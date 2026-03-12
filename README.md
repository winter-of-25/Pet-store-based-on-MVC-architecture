# 🐾 JetStore - 在线宠物商城系统

<div align="center">

[![GitHub](https://img.shields.io/badge/GitHub-not--a--teenager--any--more%2Fjetstore-blue?logo=github&style=flat-square)](https://github.com/not-a-teenager-any-more/jetstore)
[![Language](https://img.shields.io/badge/Language-Java-orange?style=flat-square&logo=java)](https://github.com/not-a-teenager-any-more/jetstore)
[![Repository Size](https://img.shields.io/badge/Size-4.2%20MB-brightgreen?style=flat-square)](https://github.com/not-a-teenager-any-more/jetstore)
[![Last Commit](https://img.shields.io/badge/Last%20Commit-2026%2F01%2F13-blue?style=flat-square)](https://github.com/not-a-teenager-any-more/jetstore/commits/main)
[![Stars](https://img.shields.io/github/stars/not-a-teenager-any-more/jetstore?style=flat-square)](https://github.com/not-a-teenager-any-more/jetstore)
[![License](https://img.shields.io/badge/License-Unlicensed-red?style=flat-square)](https://github.com/not-a-teenager-any-more/jetstore)

**一个基于 Java 的完整在线宠物商城系统，提供现代化的Web界面和完善的电商功能**

[快速开始](#-快速开始) • [项目结构](#-项目结构) • [功能特性](#-功能特性) • [使用指南](#-使用指南) • [技术栈](#-技术栈) • [贡献](#-贡献)

</div>

---

## 📋 项目简介

**JetStore** 是一个功能完整的在线宠物商城系统，模仿真实的电商平台。该项目展示了从用户认证、商品浏览、购物车管理到订单处理的完整电商流程。项目采用前后端分离的架构，结合现代化的Web设计和优雅的用户界面。

### 🎯 核心目标

- 提供完整的宠物电商购物体验
- 展示Java Web应用开发的最佳实践
- 实现标准的MVC架构和数据库交互
- 提供易于扩展和维护的代码结构

---

## ✨ 功能特性

### 🛍️ 用户功能模块

#### 1. **用户认证与账户管理**
- ✅ 用户注册（Sign Up）- 创建新账户
- ✅ 用户登录（Sign In）- 账户认证
- ✅ 密码管理和账户信息维护
- ✅ 用户会话管理

#### 2. **商品浏览与搜索**
- ✅ **分层商品浏览**
  - 一级：商品分类（Categories）- 如狗、猫、鸟等
  - 二级：商品列表（Products）- 特定分类下的商品
  - 三级：商品详情（Items）- 具体商品信息和价格
- ✅ **全文搜索功能** - 按商品名称搜索
- ✅ **商品详情展示**
  - 商品名称、描述、价格
  - 库存状态
  - 高清商品图片和视觉展示

#### 3. **购物车管理**
- ✅ **添加商品** - 将商品加入购物车
- ✅ **移除商品** - 从购物车中删除商品
- ✅ **修改数量** - 调整商品购买数量
- ✅ **库存验证** - 显示库存状态和缺货提醒
- ✅ **购物车实时计算** - 自动更新价格和数量

#### 4. **订单处理流程**
- ✅ **结账流程（Checkout Process）**
  - 订单确认 - 查看购物车内容
  - 账户验证 - 需要登录才能下单
  - 支付信息 - 输入支付方式
  - 配送信息 - 收货地址和收货人信息
  - 账单信息 - 确认账单地址（可与配送地址不同）
- ✅ **订单管理** - 查看历史订单
- ✅ **订单确认** - 显示最终订单信息
- ✅ **邮件通知** - 订单确认邮件（可配置）

#### 5. **帮助与指南**
- ✅ 完整的用户使用指南
- ✅ 分类清晰的帮助文档
- ✅ 快速导航和平滑滚动
- ✅ 常见问题解答

### 🎨 界面特性

#### 首页特点
- 🌟 **现代毛玻璃效果** - Glassmorphism设计风格
- 🌟 **流畅动画** - 浮动元素和平滑过渡
- 🌟 **响应式设计** - 完美适配各种屏幕尺寸
- 🌟 **背景音乐控制** - 可视化音频播放器
- 🌟 **粒子系统** - 动态背景气泡效果
- 🌟 **触摸友好** - 移动设备优化

#### 设计元素
- 蓝白渐变色调，营造温馨感
- Font Awesome图标库支持
- Google Fonts（Poppins字体）
- 自定义动画和过渡效果
- 触摸和悬停交互反馈

---

## 📁 项目结构

```
jetstore/
│
├── 📄 jetstore1.iml                    # IntelliJ IDEA 项目模块配置文件
├── 📄 .gitignore                       # Git忽略文件配置
├── 📄 README.md                        # 项目说明文档
│
├── 📂 src/                             # Java源代码目录
│   ├── 📄 Main.java                    # 主程序入口（示例代码）
│   │
│   └── 📂 csu/                         # 应用核心包（中山大学CSU包）
│       └── 📂 web/                     # Web相关类包
│           ├── Servlet类              # 处理HTTP请求的servlet
│           ├── Bean类                 # 数据模型/实体类
│           ├── DAO类                  # 数据库访问对象（持久层）
│           ├── Service类              # 业务逻辑层
│           └── 工具类                 # 辅助工具函数
│
├── 📂 web/                             # Web资源目录
│   ├── 📄 index.html                   # 首页 - MyPetStore欢迎页面
│   │                                   # 特点：现代毛玻璃效果、动画粒子系统
│   │                                   # 功能：登录入口、音乐播放器、响应式设计
│   │
│   ├── 📄 help.html                    # 帮助与使用指南
│   │                                   # 特点：JPetStore Demo用户指南
│   │                                   # 内容：账户管理、购物流程、订单处理
│   │
│   ├── 📂 images/                      # 图片资源目录
│   │   ├── 商品分类图片
│   │   ├── 宠物图片
│   │   ├── 图标和装饰图
│   │   └── UI元素图片
│   │
│   ├── 📂 WEB-INF/                     # Web应用配置目录
│   │   ├── web.xml                     # Web应用部署描述符
│   │   └── lib/                        # 依赖JAR包目录
│   │
│   └── 📂 web/                         # 额外的Web资源
│       └── WEB-INF/                    # 备用配置目录
│
└── 📂 .idea/                           # IntelliJ IDEA IDE配置
    ├── .gitignore                      # IDE特定的忽略规则
    ├── workspace.xml                   # 工作区配置
    ├── 项目文件缓存
    └── IDE元数据
```

### 核心目录详解

#### `src/Main.java` - 应用入口
```java
// 简单的演示程序，展示基本的Java编程
public class Main {
    public static void main(String[] args) {
        System.out.printf("Hello and welcome!");
        for (int i = 1; i <= 5; i++) {
            System.out.println("i = " + i);
        }
    }
}
```

#### `src/csu/web/` - 核心应用代码
该包包含以下重要组件：

**数据模型层 (Bean/Entity)**
- `User` - 用户信息类（用户ID、用户名、密码、个人信息）
- `Product` - 商品类（商品ID、名称、价格、分类）
- `Category` - 分类类（分类ID、名称、描述）
- `CartItem` - 购物车项类（商品、数量、价格）
- `Order` - 订单类（订单ID、用户ID、订单日期、状态、项目列表）
- `OrderDetail` - 订单详情类

**数据访问层 (DAO)**
- `UserDAO` - 用户数据库操作
- `ProductDAO` - 商品数据库操作
- `CategoryDAO` - 分类数据库操作
- `OrderDAO` - 订单数据库操作

**业务逻辑层 (Service)**
- `UserService` - 用户业务逻辑
- `ProductService` - 商品业务逻辑
- `ShoppingCartService` - 购物车业务逻辑
- `OrderService` - 订单业务逻辑

**表现层 (Servlet/Controller)**
- `LoginServlet` - 登录处理
- `RegisterServlet` - 注册处理
- `ProductServlet` - 商品展示和搜索
- `CartServlet` - 购物车操作
- `OrderServlet` - 订单处理

#### `web/` - 前端资源

**HTML页面**
- `index.html` (13.4 KB) - 欢迎页面，包含：
  - 毛玻璃容器设计
  - 柔和波浪顶部装饰
  - 爪印图标动画
  - 登录入口按钮
  - 背景粒子系统
  - 音乐播放控制
  - 完整响应式设计

- `help.html` (15.5 KB) - 用户指南，包含：
  - JPetStore Demo 用户指南
  - 注册和登录说明
  - 商品浏览和搜索教程
  - 购物车使用指南
  - 订单流程详解
  - 常见问题解答
  - 快速导航菜单
  - "返回顶部"按钮

**资源文件夹**
- `images/` - 存放所有图片资源
- `WEB-INF/` - 应用配置和库文件
  - `web.xml` - 部署描述符（配置servlet映射、初始参数等）
  - `lib/` - 第三方JAR包

#### `.idea/` - IDE配置
- IntelliJ IDEA项目元数据
- 工作区和缓存文件
- 代码风格和检查配置
- 运行配置

---

## 🛠️ 技术栈

### 后端技术

| 技术 | 版本 | 用途 |
|------|------|------|
| **Java** | Java 8+ | 核心编程语言 |
| **JSP/Servlet** | Java EE | Web应用框架 |
| **MySQL** | 8.0.31+ | 数据库管理系统 |
| **MySQL Connector** | 8.0.31 | Java-MySQL驱动 |
| **JSP API** | Latest | JSP页面处理 |

### 前端技术

| 技术 | 用途 |
|------|------|
| **HTML5** | 页面结构 |
| **CSS3** | 样式设计（渐变、动画、Glassmorphism） |
| **JavaScript** | 交互逻辑和动态效果 |
| **Font Awesome 4.7** | 图标库 |
| **Google Fonts** | 字体库（Poppins） |
| **Particles.js 2.0** | 粒子系统库 |

### 开发工具

| 工具 | 版本 | 用途 |
|------|------|------|
| **IntelliJ IDEA** | Latest | Java IDE开发环境 |
| **Git** | Latest | 版本控制 |
| **Maven/Gradle** | Optional | 项目构建工具 |
| **Tomcat** | 9.0+ | Java Web应用服务器 |

---

## 🚀 快速开始

### 📋 前置要求

- **Java Development Kit (JDK)**: Java 8 或更高版本
  ```bash
  java -version
  ```
  
- **MySQL数据库**: 5.7 或更高版本
  ```bash
  mysql --version
  ```
  
- **Tomcat服务器**: 9.0 或更高版本
  
- **Git**: 用于版本控制
  ```bash
  git --version
  ```
  
- **IDE**: IntelliJ IDEA Community/Ultimate Edition

### 🔧 安装步骤

#### 1️⃣ 克隆仓库

```bash
# 使用HTTPS克隆
git clone https://github.com/not-a-teenager-any-more/jetstore.git

# 或使用SSH克隆
git clone git@github.com:not-a-teenager-any-more/jetstore.git

# 进入项目目录
cd jetstore
```

#### 2️⃣ 配置IntelliJ IDEA

```bash
# 在IntelliJ IDEA中打开项目
1. 打开 IntelliJ IDEA
2. 点击 "File" → "Open"
3. 选择 jetstore 项目目录
4. IDE自动识别项目为Java项目

# 导入模块
1. 右键点击项目根目录
2. 选择 "Add Framework Support"
3. 选择 "Web Application"
4. IDE自动导入 jetstore1.iml ���块配置
```

#### 3️⃣ 数据库配置

```bash
# 连接MySQL
mysql -u root -p

# 创建数据库
CREATE DATABASE jetstore_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# 使用数据库
USE jetstore_db;

# 创建用户表
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    zip VARCHAR(20),
    country VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

# 创建分类表
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    category_desc TEXT,
    image_url VARCHAR(255)
);

# 创建商品表
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category_id INT,
    product_desc TEXT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

# 创建商品项目表
CREATE TABLE items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2),
    quantity_in_stock INT,
    image_url VARCHAR(255),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

# 创建订单表
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    order_status VARCHAR(50),
    shipping_address VARCHAR(255),
    billing_address VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

# 创建订单详情表
CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    item_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);
```

#### 4️⃣ 配置数据库连接

在项目中创建数据库配置文件 `src/csu/web/db.properties`:

```properties
# MySQL数据库配置
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://localhost:3306/jetstore_db?useSSL=false&serverTimezone=UTC
db.username=root
db.password=your_password
db.pool.size=10
db.timeout=30
```

#### 5️⃣ 配置Servlet映射

编辑 `web/WEB-INF/web.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
         http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">

    <servlet>
        <servlet-name>loginServlet</servlet-name>
        <servlet-class>csu.web.LoginServlet</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>loginServlet</servlet-name>
        <url-pattern>/login</url-pattern>
    </servlet-mapping>

    <servlet>
        <servlet-name>productServlet</servlet-name>
        <servlet-class>csu.web.ProductServlet</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>productServlet</servlet-name>
        <url-pattern>/products</url-pattern>
    </servlet-mapping>

    <welcome-file-list>
        <welcome-file>index.html</welcome-file>
    </welcome-file-list>

</web-app>
```

#### 6️⃣ 编译与构建

```bash
# 使用IDE编译
在 IntelliJ IDEA 中：
1. 点击 "Build" → "Build Project"

# 或使用Maven（如果项目配置了Maven）
mvn clean compile

# 或使用Gradle（如果项目配置了Gradle）
gradle clean build
```

#### 7️⃣ 配置Tomcat服务器

```bash
在 IntelliJ IDEA 中配置Tomcat：
1. 点击 "Run" → "Edit Configurations"
2. 点击 "+" → "Tomcat Server" → "Local"
3. 配置Tomcat主页路径
4. 在 "Deployment" 选项卡中添加工件 (artifacts)
5. 选择 "jetstore:war exploded"
6. 设置应用上下文路径为 "/"
7. 点击 "Apply" 和 "OK"
```

#### 8️⃣ 运行应用

```bash
# 方法1：使用IDE运行
在 IntelliJ IDEA 中：
1. 点击绿色 "Run" 按钮
2. 或使用快捷键 Shift + F10

# 方法2：使用Tomcat命令行
cd $CATALINA_HOME
./bin/startup.sh          # Linux/Mac
./bin/startup.bat         # Windows

# 访问应用
打开浏览器，访问: http://localhost:8080
```

#### 9️⃣ 验证安装

```bash
# 检查首页加载
访问: http://localhost:8080/index.html
预期看到：MyPetStore欢迎页面，具有动画效果

# 检查帮助页面
访问: http://localhost:8080/web/help.html
预期看到：JPetStore Demo用户指南

# 检查Tomcat日志
查看Tomcat日志目录中的 catalina.out 文件
确保没有错误信息
```

---

## 📖 详细使用指南

### 🎯 用户工作流程

#### 场景1：新用户注册与首次购物

```
1. 访问首页 (index.html)
   ↓
2. 点击 "Enter Pet Store" 按钮
   ↓
3. 进入商城主页，浏览商品分类
   ↓
4. 点击分类（如"Dogs"）查看该分类的宠物
   ↓
5. 选择具体宠物商品查看详情和价格
   ↓
6. 点击 "Add to Cart" 添加到购物车
   ↓
7. 查看购物车（可修改数量或删除商品）
   ↓
8. 点击 "Proceed to Checkout" 进行结账
   ↓
9. 系统提示未登录，重定向到登录页面
   ↓
10. 点击 "New User" 进入注册页面
    - 输入用户名、密码、邮箱等信息
    - 填写收货地址和收货人信息
    - 点击 "Submit" 完成注册
    ↓
11. 返回结账流程，输入支付和配送信息
    ↓
12. 确认订单，显示订单详情
    ↓
13. 收到订单确认邮件（如已配置）
```

#### 场景2：已注册用户快速购物

```
1. 访问首页
   ↓
2. 点击右上角 "Sign-in" 链接
   ↓
3. 输入用户名和密码登录
   ↓
4. 浏览和搜索商品
   ↓
5. 添加商品到购物车
   ↓
6. 进行结账（系统已识别用户身份）
   ↓
7. 核实地址和支付信息
   ↓
8. 完成订单
```

#### 场景3：浏览和搜索商品

```
商品分层结构：
Category（分类）
  └─ Product（商品）
      └─ Item（商品项）
         ├─ 价格
         ├─ 库存
         └─ 描述

搜索流程：
1. 在导航栏搜索框输入商品名称
   ↓
2. 点击搜索或按Enter
   ↓
3. 系统返回匹配的商品列表
   ↓
4. 点击商品查看详情
```

### 📋 界面导航说明

#### 首页 (index.html)
- **欢迎文本**: "Welcome Home - Discover joy, love, and the perfect companion for your family"
- **主按钮**: "Enter Pet Store" - 进入商城
- **音乐控制**: 右下角圆形按钮，可播放背景音乐
- **背景效果**: 浮动爪印、心形和礼物图标
- **粒子系统**: 动态白色气泡浮动效果

#### 帮助页面 (help.html)
- **快速导航**: 包含11个主要功能链接
- **详细说明**: 每个功能都有专门的部分讲解
- **高亮信息框**: 重要信息用黄色背景突出显示
- **返回顶部按钮**: 固定在右下角，便于快速回到页面顶部

### 🔍 高级功能详解

#### 购物车的数量限制处理
```
当用户要求的商品数量超过库存时：
1. 购物车会在 "In Stock" 字段标记 "Backordered"
2. 用户仍可以提交订单
3. 系统会处理缺货项的订单状态
```

#### 账户安全
- 登录使用用户名和密码认证
- 密码在数据库中应使用加密存储（如BCrypt）
- 会话管理防止非授权访问
- 订单信息只有用户本人和管理员可查看

#### 邮件通知
- 注册成功后发送欢迎邮件
- 订单确认邮件包含订单详情和跟踪信息
- 配置文件中可启用/禁用邮件功能

---

## 🔐 安全与最佳实践

### 密码安全

```java
// 推荐使用BCrypt进行密码加密
import org.mindrot.jbcrypt.BCrypt;

// 存储密码时
String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt());

// 验证密码时
if (BCrypt.checkpw(plainPassword, hashedPassword)) {
    // 密码正确
}
```

### SQL注入防护

```java
// ❌ 不安全的做法
String query = "SELECT * FROM users WHERE username = '" + username + "'";

// ✅ 安全的做法（使用PreparedStatement）
String query = "SELECT * FROM users WHERE username = ?";
PreparedStatement pstmt = connection.prepareStatement(query);
pstmt.setString(1, username);
ResultSet rs = pstmt.executeQuery();
```

### 会话管理

```java
// 设置会话超时（30分钟）
session.setMaxInactiveInterval(30 * 60);

// 检查用户是否登录
User user = (User) session.getAttribute("currentUser");
if (user == null) {
    response.sendRedirect("/login");
}

// 注销时清除会话
session.invalidate();
```

---

## 🐛 常见问题与解决方案

### Q1: "无法连接到数据库"
**A:** 检查以下几点：
```bash
# 1. MySQL服务是否运行
# Windows
net start MySQL80

# Linux
sudo systemctl start mysql

# 2. 检查数据库连接参数
- 检查db.properties中的URL、用户名、密码
- 确保localhost:3306可访问
- 验证数据库是否已创建

# 3. 检查MySQL驱动
- 确保mysql-connector-j-8.0.31.jar在CLASSPATH中
- IDE中可能需要手动添加库
```

### Q2: "JSP编译错误"
**A:** 
```bash
# 1. 清除编译缓存
在IDE中：Build → Clean Project

# 2. 重新编译
Build → Build Project

# 3. 检查JSP语法
确保<%= %> 和<% %> 标签正确使用
```

### Q3: "图片或资源加载失败"
**A:**
```bash
# 1. 检查web.xml中的资源映射
# 确保静态资源目录已配置

# 2. 检查文件路径
相对路径应该相对于web根���录

# 3. 检查文件权限
文件应该有读权限
```

### Q4: "登录后自动注销"
**A:**
```bash
# 1. 增加会话超时时间
在web.xml中添加：
<session-config>
    <cookie-config>
        <secure>true</secure>
        <http-only>true</http-only>
    </cookie-config>
    <tracking-mode>COOKIE</tracking-mode>
</session-config>

# 2. 检查客户端Cookie设置
确保浏览器允许Cookie
```

### Q5: "购物车数据丢失"
**A:**
```bash
# 1. 检查会话存储
购物车应存储在HttpSession中

# 2. 添加持久化存储
可选：在数据库中保存购物车

# 3. 增加会话超时
确保超时时间足够长
```

---

## 📊 数据库架构

### ER图表

```
┌──────────────┐
│    users     │
├──────────────┤
│ user_id (PK) │
│ username     │
│ password     │
│ email        │
│ first_name   │
│ last_name    │
│ phone        │
│ address      │
│ city         │
│ state        │
│ zip          │
│ country      │
└──────────────┘
       │
       │ (1:N)
       │
┌──────────────────────┐
│      orders          │
├──────────────────────┤
│ order_id (PK)        │
│ user_id (FK)         │
│ order_date           │
│ order_status         │
│ shipping_address     │
│ billing_address      │
└──────────────────────┘
       │
       │ (1:N)
       │
┌─────────────────────┐
│   order_details     │
├─────────────────────┤
│ order_detail_id(PK) │
│ order_id (FK)       │
│ item_id (FK)        │
│ quantity            │
│ price               │
└─────────────────────┘
       │
       │ (N:1)
       │
┌──────────────────┐
│     items        │
├──────────────────┤
│ item_id (PK)     │
│ product_id (FK)  │
│ item_name        │
│ price            │
│ quantity_in_stock│
│ image_url        │
└──────────────────┘
       │
       │ (N:1)
       │
┌──────────────────┐
│    products      │
├──────────────────┤
│ product_id (PK)  │
│ product_name     │
│ category_id (FK) │
│ product_desc     │
└──────────────────┘
       │
       │ (N:1)
       │
┌──────────────────┐
│   categories     │
├──────────────────┤
│ category_id (PK) │
│ category_name    │
│ category_desc    │
│ image_url        │
└──────────────────┘
```

### 关键表字段说明

| 表名 | 关键字段 | 说明 |
|------|---------|------|
| users | user_id | 用户唯一标识 |
| users | username | 用户名，唯一 |
| categories | category_id | 商品分类唯一标识 |
| products | product_id | 商品唯一标识 |
| items | item_id | 商品项唯一标识 |
| orders | order_id | 订单唯一标识 |
| orders | order_status | 订单状态（pending, completed, cancelled） |
| order_details | order_detail_id | 订单详情唯一标识 |

---


---

## 🤝 贡献指南

我们欢迎来自社区的贡献！无论是报告错误、建议功能还是提交代码，都有帮助。

### 📝 贡献流程

#### 1. 报告问题 (Issues)
```bash
1. 前往 GitHub Issues 页面
2. 点击 "New Issue"
3. 选择问题类型（Bug、Feature Request 等）
4. 填写详细信息：
   - 问题描述
   - 复现步骤
   - 期望行为
   - 实际行为
   - 环境信息（Java版本、Tomcat版本等）
```

#### 2. 提交代码 (Pull Requests)

```bash
# Step 1: Fork 本仓库
在 GitHub 页面点击 "Fork"

# Step 2: Clone 你的 fork
git clone https://github.com/your-username/jetstore.git
cd jetstore

# Step 3: 创建特性分支
git checkout -b feature/amazing-feature
# 或修复分支
git checkout -b fix/bug-fix

# Step 4: 进行开发和提交
# 编辑文件...
git add .
git commit -m "feat: 添加令人惊叹的功能"
# 或
git commit -m "fix: 修复重要bug"

# 遵循提交信息规范：
# feat: 新功能
# fix: 修复bug
# docs: 文档更新
# style: 代码风格调整（空格、缩进等）
# refactor: 代码重构
# perf: 性能优化
# test: 添加或修改测试
# chore: 构建过程或依赖更新

# Step 5: 推送到远程
git push origin feature/amazing-feature

# Step 6: 创建 Pull Request
1. 前往 GitHub
2. 点击 "Compare & pull request"
3. 填写PR描述：
   - 做了什么改动
   - 为什么做这个改动
   - 测试了什么
4. 点击 "Create pull request"
```

### ✅ 代码审查标准

提交的代码应该：
- ✅ 遵循项目的代码风格
- ✅ 包含适当的注释和文档
- ✅ 通过所有单元测试
- ✅ 不破坏现有功能
- ✅ 对性能无负面影响
- ✅ 遵循安全最佳实践

### 📋 代码风格指南

```java
// Java命名约定
public class UserService {          // 类名：PascalCase
    private String username;        // 变量名：camelCase
    public static final int MAX_SIZE = 100;  // 常量：UPPER_SNAKE_CASE
    
    public void processUser() {     // 方法名：camelCase
        // 代码...
    }
}

// 缩进：使用4个空格
public void example() {
    if (condition) {
        doSomething();
    }
}

// 注释
/**
 * 用户登录方法
 * @param username 用户名
 * @param password 密码
 * @return 登录成功返回User对象，失败返回null
 */
public User login(String username, String password) {
    // 实现...
}
```

---

## 📄 许可证

本项目当前**无许可证**。这意味着所有权利保留。

如果您有许可证相关问题，请联系项目所有者。

---

## 👥 项目维护者

- **[not-a-teenager-any-more](https://github.com/not-a-teenager-any-more)** - 项目所有者和主要维护者

## 🙋 获取帮助

- **GitHub Issues**: [提交问题](https://github.com/not-a-teenager-any-more/jetstore/issues)
- **Wiki**: [项目Wiki](https://github.com/not-a-teenager-any-more/jetstore/wiki)
- **讨论**: [GitHub Discussions](https://github.com/not-a-teenager-any-more/jetstore/discussions)

---

## 📊 项目统计

| 统计项 | 数据 |
|--------|------|
| ⭐ 总Stars | 2 |
| 👥 Watchers | 2 |
| 🔄 Forks | 0 |
| 📋 Issues | 0 |
| 📦 大小 | 4.2 MB |
| 🔗 主要语言 | Java |
| 📅 创建时间 | 2025年12月（约58天前） |
| 📅 最后更新 | 2026年1月13日 |
| 👤 所有者 | not-a-teenager-any-more |

---

## 🎓 学习资源

### 相关教程和文档
- [Java Servlet Documentation](https://docs.oracle.com/cd/E17802_01/products/products/servlet/2.4/)
- [JSP Documentation](https://projects.eclipse.org/projects/ee4j.jsp)
- [MySQL Tutorial](https://dev.mysql.com/doc/refman/8.0/en/)
- [IntelliJ IDEA Help](https://www.jetbrains.com/help/idea/)
- [Tomcat Documentation](https://tomcat.apache.org/tomcat-10.0-doc/)

### 相关项目
- [JPetStore - MyBatis示例](https://github.com/mybatis/jpetstore-6)
- [Spring PetClinic](https://github.com/spring-projects/spring-petclinic)
- [Microservices Architecture](https://microservices.io/)

---

## 🔄 版本历史

### v1.0.0 (当前版本)
- ✅ 核��电商功能完成
- ✅ 用户认证系统
- ✅ 商品浏览和搜索
- ✅ 购物车管理
- ✅ 订单处理
- ✅ 现代化UI设计
- ✅ 响应式页面

### 未来计划 (v1.1.0+)
- 🔜 支付网关集成
- 🔜 订单追踪系统
- 🔜 用户评价和评论
- 🔜 推荐算法
- 🔜 库存管理系统
- 🔜 管理后台
- 🔜 移动端应用
- 🔜 多语言支持

---

## 📞 联系方式

- **GitHub Profile**: [@not-a-teenager-any-more](https://github.com/not-a-teenager-any-more)
- **Issue Tracker**: [GitHub Issues](https://github.com/not-a-teenager-any-more/jetstore/issues)
- **Repository**: [jetstore](https://github.com/not-a-teenager-any-more/jetstore)

---

<div align="center">

### 🌟 如果这个项目对你有帮助，请给个Star！⭐

**Made with ❤️ by [not-a-teenager-any-more](https://github.com/not-a-teenager-any-more)**

**[⬆ 返回顶部](#-jetstore---在线宠物商城系统)**

---

*最后更新: 2026年3月12日* | *文档版本: 1.0.0*

</div>
