package csu.web.mypetstore.service;

import csu.web.mypetstore.domain.Category;
import csu.web.mypetstore.domain.Item;
import csu.web.mypetstore.domain.Product;
import csu.web.mypetstore.persistence.CategoryDao;
import csu.web.mypetstore.persistence.ItemDao;
import csu.web.mypetstore.persistence.ProductDao;
import csu.web.mypetstore.persistence.impl.CategoryDaoImpl;
import csu.web.mypetstore.persistence.impl.ItemDaoImpl;
import csu.web.mypetstore.persistence.impl.ProductDaoImpl;

import java.util.List;

public class CatalogService {
    private CategoryDao categoryDao;
    private ItemDao itemDao;
    private ProductDao productDao;
    public CatalogService(){
        categoryDao = new CategoryDaoImpl();
        itemDao = new ItemDaoImpl();
        productDao = new ProductDaoImpl();
    }
    public List<Category> getCategoryList() throws Exception {
        return categoryDao.getCategoryList();
    }

    public Category getCategory(String categoryId) throws Exception {
        return categoryDao.getCategory(categoryId);
    }

    public Product getProduct(String productId) {
        return productDao.getProduct(productId);
    }

    public List<Product> getProductListByCategory(String categoryId) {
        return productDao.getProductListByCategory(categoryId);
    }

    public List<Product> searchProductList(String keyword) {
        return productDao.searchProductList("%" + keyword.toLowerCase() + "%");
    }

    public List<Item> getItemListByProduct(String productId) {
        return itemDao.getItemListByProduct(productId);
    }

    public Item getItem(String itemId) {
        return itemDao.getItem(itemId);
    }

    public boolean isItemInStock(String itemId) {
        return itemDao.getInventoryQuantity(itemId) > 0;
    }
}
