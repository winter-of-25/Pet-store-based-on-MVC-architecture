package csu.web.mypetstore.web.servlet;

import csu.web.mypetstore.domain.Item;
import csu.web.mypetstore.service.SearchService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class AutoCompleteServlet extends HttpServlet {

    private SearchService searchService;

    @Override
    public void init() throws ServletException {
        this.searchService = new SearchService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-cache");

        String keyword = req.getParameter("keyword");
        PrintWriter out = resp.getWriter();

        if (keyword == null || keyword.trim().equals("")) {
            out.write("[]");
            return;
        }

        String searchStr = keyword.trim();
        List<Item> listByKeyword = searchService.searchItems(searchStr);
        List<Item> listByProduct = searchService.searchItemsByProduct(searchStr);

        List<Item> finalStats = new ArrayList<>();
        Set<String> addedItemIds = new HashSet<>();

        if (listByKeyword != null) {
            for (Item item : listByKeyword) {
                String uniqueKey = item.getItemId();
                if (!addedItemIds.contains(uniqueKey)) {
                    finalStats.add(item);
                    addedItemIds.add(uniqueKey);
                }
            }
        }

        if (listByProduct != null) {
            for (Item item : listByProduct) {
                String uniqueKey = item.getItemId();
                if (!addedItemIds.contains(uniqueKey)) {
                    finalStats.add(item);
                    addedItemIds.add(uniqueKey);
                }
            }
        }

        StringBuilder json = new StringBuilder();
        json.append("[");

        if (!finalStats.isEmpty()) {
            int limit = Math.min(finalStats.size(), 8);

            for (int i = 0; i < limit; i++) {
                Item item = finalStats.get(i);

                // 确保数据不为空
                String itemId = (item.getItemId() != null) ? item.getItemId() : "";
                String attr = (item.getAttribute1() != null) ? item.getAttribute1() : "";

                // 构建显示名称：EST-6 - Male Adult
                String displayName = itemId;
                if (!attr.equals("") && !attr.equalsIgnoreCase("null")) {
                    displayName += " - " + attr;
                }

                // 构建搜索ID：EST-6 (这是重点，之后要填入输入框的值)
                String searchId = itemId;

                json.append("{");
                json.append("\"id\":\"").append(jsonEscape(searchId)).append("\",");
                json.append("\"name\":\"").append(jsonEscape(displayName)).append("\"");
                json.append("}");

                if (i < limit - 1) {
                    json.append(",");
                }
            }
        }
        json.append("]");
        out.write(json.toString());
        out.flush();
        out.close();
    }

    private String jsonEscape(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}