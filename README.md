# Pet Store Based on MVC Architecture

一个使用 Java Servlet、JSP 和 MySQL 实现的宠物商店 Web 应用。项目按领域模型、数据访问、业务服务和 Servlet 控制器组织，页面资源位于 `web/`。

## 已实现功能

- 账户注册、登录、退出及账户信息维护
- 宠物分类、商品和具体商品条目浏览
- 商品搜索与自动补全
- 购物车添加、移除和数量更新
- 订单创建与订单信息展示
- 验证码、用户名检查和页面访问事件记录

## 技术栈

- Java、Servlet 4.0、JSP
- JDBC、MySQL Connector/J
- MySQL
- HTML、CSS、JavaScript
- IntelliJ IDEA Web Facet
- Servlet 容器（例如 Tomcat 9）

## 目录结构

```text
.
├── src/csu/web/mypetstore/
│   ├── domain/          # 领域模型
│   ├── persistence/     # DAO 接口、实现与数据库连接
│   ├── service/         # 业务服务
│   └── web/servlet/     # Servlet 控制器
├── web/
│   ├── WEB-INF/jsp/     # JSP 页面
│   ├── WEB-INF/web.xml  # Servlet 映射
│   ├── images/          # 静态图片
│   └── index.html
└── jetstore1.iml        # IntelliJ IDEA 模块配置
```

## 快速开始

```bash
git clone https://github.com/winter-of-25/Pet-store-based-on-MVC-architecture.git
cd Pet-store-based-on-MVC-architecture
```

1. 修改 `src/csu/web/mypetstore/persistence/DBUtil.java` 中的数据库地址、数据库名、用户名和密码。
2. 准备与 DAO 查询相匹配的 MySQL 表和数据。
3. 使用 IntelliJ IDEA 打开项目，将 `src/` 设为源代码目录、`web/` 设为 Web 根目录。
4. 配置 JDK、Servlet/JSP API、MySQL Connector/J 和兼容 Servlet 4.0 的 Tomcat。
5. 部署后从配置的应用上下文访问首页。

## 注意事项

- 仓库未提供数据库初始化脚本。
- 项目未使用 Maven 或 Gradle，不能直接运行 `mvn` 或 `gradle` 构建。
- `DBUtil.java` 含本地连接配置，请勿提交真实生产凭据。
- 实际访问路径由 Servlet 容器的应用上下文决定。

## 许可证

仓库当前未提供许可证文件。除非版权所有者另行授权，否则默认保留所有权利。

## 联系方式

- GitHub: [winter-of-25](https://github.com/winter-of-25)
- Email: [A3762577373@outlook.com](mailto:A3762577373@outlook.com)
