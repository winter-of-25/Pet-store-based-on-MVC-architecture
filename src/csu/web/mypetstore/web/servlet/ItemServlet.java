package csu.web.mypetstore.web.servlet;

import csu.web.mypetstore.domain.Item;
import csu.web.mypetstore.domain.Product;
import csu.web.mypetstore.persistence.ItemDao;
import csu.web.mypetstore.persistence.ProductDao;
import csu.web.mypetstore.persistence.impl.ItemDaoImpl;
import csu.web.mypetstore.persistence.impl.ProductDaoImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class ItemServlet extends HttpServlet {

    private ItemDao itemDao;
    private ProductDao productDao;

    @Override
    public void init() throws ServletException {
        super.init();
        // 初始化 DAO
        itemDao = new ItemDaoImpl();
        productDao = new ProductDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 设置字符编码
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        // 获取 itemId 参数
        String itemId = request.getParameter("itemId");

        if (itemId == null || itemId.trim().isEmpty()) {
            // 如果没有提供 itemId，重定向到错误页面
            response.sendRedirect(request.getContextPath() + "/error.jsp?message=Item ID is required");
            return;
        }

        try {
            // 从数据库获取商品信息
            Item item = itemDao.getItem(itemId);

            if (item == null) {
                // 商品不存在
                response.sendRedirect(request.getContextPath() + "/error.jsp?message=Item not found: " + itemId);
                return;
            }

            // 获取对应的产品信息（实际上在 ItemDao 中已经通过联表查询获取了 Product 信息）
            // 这里我们直接从 item 对象中获取 product 即可
            Product product = item.getProduct();

            if (product == null) {
                // 如果 product 为空，尝试通过 productId 获取
                product = productDao.getProduct(item.getProductId());
                if (product == null) {
                    response.sendRedirect(request.getContextPath() + "/error.jsp?message=Product not found for item: " + itemId);
                    return;
                }
                item.setProduct(product);
            }

            // 获取库存数量并设置到 item 对象中
            int quantity = itemDao.getInventoryQuantity(itemId);
            item.setQuantity(quantity);

            // 将数据设置到 session 中
            HttpSession session = request.getSession();
            session.setAttribute("item", item);
            session.setAttribute("product", product);

            // 记录访问日志
            System.out.println("Item viewed: " + itemId + " - " + product.getName() + " by IP: " + request.getRemoteAddr());

            // 转发到 item.jsp
            request.getRequestDispatcher("/WEB-INF/jsp/catalog/item.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp?message=Server error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}