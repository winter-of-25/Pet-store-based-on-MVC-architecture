package csu.web.mypetstore.persistence.impl;

import csu.web.mypetstore.domain.Product;
import csu.web.mypetstore.persistence.DBUtil;
import csu.web.mypetstore.persistence.ProductDao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductDaoImpl implements ProductDao {

    private static final String getProductListByCategoryString =
            "SELECT PRODUCTID, NAME,DESCN as description,CATEGORY as categoryId FROM PRODUCT WHERE CATEGORY = ?";

    private static final String getProductString =
            "SELECT PRODUCTID, NAME,DESCN as description,CATEGORY as categoryId FROM PRODUCT WHERE PRODUCTID = ?";

    private static final String searchProductListString =
            "SELECT PRODUCTID, NAME,DESCN as description,CATEGORY as categoryId FROM PRODUCT WHERE NAME LIKE ?";

    @Override
    public List<Product> getProductListByCategory(String categoryId) {
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(getProductListByCategoryString)) {
            preparedStatement.setString(1, categoryId);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                List<Product> productList = new ArrayList<>();
                while (resultSet.next()) {
                    Product product = new Product();
                    product.setProductId(resultSet.getString("productId"));
                    product.setName(resultSet.getString("name"));
                    product.setDescription(resultSet.getString("description"));
                    product.setCategoryId(resultSet.getString("categoryId"));
                    productList.add(product);
                }
                return productList;
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Product getProduct(String productId) {
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(getProductString)) {
            preparedStatement.setString(1, productId);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    Product product = new Product();
                    product.setProductId(resultSet.getString("productId"));
                    product.setName(resultSet.getString("name"));
                    product.setDescription(resultSet.getString("description"));
                    product.setCategoryId(resultSet.getString("categoryId"));
                    return product;
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    @Override
    public List<Product> searchProductList(String keywords) {
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(searchProductListString)) {
            preparedStatement.setString(1, "%" + keywords + "%");
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                List<Product> productList = new ArrayList<>();
                while (resultSet.next()) {
                    Product product = new Product();
                    product.setProductId(resultSet.getString("productId"));
                    product.setName(resultSet.getString("name"));
                    product.setDescription(resultSet.getString("description"));
                    product.setCategoryId(resultSet.getString("categoryId"));
                    productList.add(product);
                }
                return productList;
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
