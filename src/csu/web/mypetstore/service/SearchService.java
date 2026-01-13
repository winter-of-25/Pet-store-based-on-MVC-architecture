package csu.web.mypetstore.service;

import csu.web.mypetstore.domain.Item;
import csu.web.mypetstore.persistence.ItemDao;
import csu.web.mypetstore.persistence.impl.ItemDaoImpl;

import java.util.List;

public class SearchService {

    private final ItemDao itemDao;

    public SearchService() {
        this.itemDao = new ItemDaoImpl();
    }

    public List<Item> searchItems(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return null;
        }
        // 调用 DAO 进行模糊查询
        return itemDao.searchItems(keyword.trim());
    }

    public List<Item> searchItemsByProduct(String productId) {
        if (productId == null || productId.trim().isEmpty()) {
            return null;
        }
        // 调用 DAO 根据产品ID查询 Item 列表
        return itemDao.getItemListByProduct(productId.trim());
    }
}