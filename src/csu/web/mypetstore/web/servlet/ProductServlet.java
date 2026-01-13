package csu.web.mypetstore.web.servlet;

import csu.web.mypetstore.domain.Product;
import csu.web.mypetstore.persistence.ProductDao;
import csu.web.mypetstore.persistence.impl.ProductDaoImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class ProductServlet extends HttpServlet {

    private ProductDao productDao;

    @Override
    public void init() throws ServletException {
        super.init();
        productDao = new ProductDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String productId = request.getParameter("productId");

        if (productId == null || productId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/error.jsp?message=Product ID is required");
            return;
        }

        try {
            Product product = productDao.getProduct(productId);

            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/error.jsp?message=Product not found: " + productId);
                return;
            }

            // 获取该产品的所有商品
            csu.web.mypetstore.persistence.ItemDao itemDao = new csu.web.mypetstore.persistence.impl.ItemDaoImpl();
            List<csu.web.mypetstore.domain.Item> itemList = itemDao.getItemListByProduct(productId);

            HttpSession session = request.getSession();
            session.setAttribute("product", product);
            session.setAttribute("itemList", itemList);

            request.getRequestDispatcher("/product.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp?message=Server error: " + e.getMessage());
        }
    }
}