package csu.web.mypetstore.web.servlet;
// SearchServlet.java


import csu.web.mypetstore.domain.Item;
import csu.web.mypetstore.service.SearchService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class SearchServlet extends HttpServlet {

    private SearchService searchService;

    @Override
    public void init() throws ServletException {
        searchService = new SearchService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String productId = request.getParameter("productId");

        List<Item> searchResults = null;

        if (keyword != null && !keyword.trim().isEmpty()) {
            // 关键词搜索
            searchResults = searchService.searchItems(keyword);
            request.setAttribute("searchType", "keyword");
            request.setAttribute("searchValue", keyword);
        } else if (productId != null && !productId.trim().isEmpty()) {
            // 产品ID搜索
            searchResults = searchService.searchItemsByProduct(productId);
            request.setAttribute("searchType", "product");
            request.setAttribute("searchValue", productId);
        }

        request.setAttribute("searchResults", searchResults);

        // 转发到搜索结果页面
        request.getRequestDispatcher("/WEB-INF/jsp/search/searchResults.jsp").forward(request, response);
    }
}