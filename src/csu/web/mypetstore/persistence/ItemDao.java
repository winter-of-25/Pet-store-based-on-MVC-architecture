package csu.web.mypetstore.persistence;

import csu.web.mypetstore.domain.Item;

import java.util.List;
import java.util.Map;

public interface ItemDao {
    void updateInventoryQuantity(Map<String, Object> param) throws Exception;

    int getInventoryQuantity(String itemId);

    List<Item> getItemListByProduct(String productId);

    Item getItem(String itemId);
    List<Item> searchItems(String keyword);
}
