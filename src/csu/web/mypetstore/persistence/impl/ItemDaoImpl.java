package csu.web.mypetstore.persistence.impl;

import csu.web.mypetstore.domain.Item;
import csu.web.mypetstore.domain.Product;
import csu.web.mypetstore.persistence.DBUtil;
import csu.web.mypetstore.persistence.ItemDao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class ItemDaoImpl implements ItemDao {

    private static final String getItemListByProductString="SELECT I.ITEMID,LISTPRICE,UNITCOST,SUPPLIER AS supplierId,I.PRODUCTID AS \"product.productId\",NAME AS \"product.name\",DESCN AS \"product.description\",CATEGORY AS \"product.categoryId\",STATUS,ATTR1 AS attribute1, ATTR2 AS attribute2, ATTR3 AS attribute3,ATTR4 AS attribute4, ATTR5 AS attribute5 FROM ITEM I, PRODUCT P WHERE P.PRODUCTID = I.PRODUCTID AND I.PRODUCTID = ?";
    private static final String getItemString="SELECT I.ITEMID,LISTPRICE,UNITCOST,SUPPLIER AS supplierId,I.PRODUCTID AS \"product.productId\",NAME AS \"product.name\",DESCN AS \"product.description\",CATEGORY AS \"product.categoryId\",STATUS,ATTR1 AS attribute1, ATTR2 AS attribute2, ATTR3 AS attribute3,ATTR4 AS attribute4, ATTR5 AS attribute5 FROM ITEM I, PRODUCT P WHERE I.ITEMID = ? AND P.PRODUCTID = I.PRODUCTID";
    private static final String getInventoryQuantityString="SELECT 10 FROM ITEM WHERE ITEMID = ?";
    private static final String updateInventoryQuantityString="UPDATE ITEM SET QTYONHAND = ? WHERE ITEMID = ?";

    // --- 修改重点：增加了对 ITEMID 和 ATTR1 的模糊查询 ---
    private static final String searchItemsString =
            "SELECT I.ITEMID, LISTPRICE, UNITCOST, SUPPLIER AS supplierId, " +
                    "I.PRODUCTID AS \"product.productId\", NAME AS \"product.name\", " +
                    "DESCN AS \"product.description\", CATEGORY AS \"product.categoryId\", " +
                    "STATUS, ATTR1 AS attribute1, ATTR2 AS attribute2, ATTR3 AS attribute3, " +
                    "ATTR4 AS attribute4, ATTR5 AS attribute5 " +
                    "FROM ITEM I, PRODUCT P " +
                    "WHERE P.PRODUCTID = I.PRODUCTID " +
                    "AND (LOWER(P.NAME) LIKE LOWER(?) OR LOWER(P.DESCN) LIKE LOWER(?) OR LOWER(I.ITEMID) LIKE LOWER(?) OR LOWER(I.ATTR1) LIKE LOWER(?))";

    @Override
    public List<Item> searchItems(String keyword) {
        List<Item> itemList = new ArrayList<>();
        try {
            Connection connection = DBUtil.getConnection();
            PreparedStatement pStatement = connection.prepareStatement(searchItemsString);
            String searchPattern = "%" + keyword + "%";

            // --- 修改重点：设置4个参数，对应SQL中的4个问号 ---
            pStatement.setString(1, searchPattern); // Product Name
            pStatement.setString(2, searchPattern); // Product Description
            pStatement.setString(3, searchPattern); // Item ID (让搜索 EST-6 成为可能)
            pStatement.setString(4, searchPattern); // Attribute (如 Large, Adult)

            ResultSet resultSet = pStatement.executeQuery();

            while (resultSet.next()) {
                Item item = new Item();
                item.setItemId(resultSet.getString(1));
                item.setListPrice(resultSet.getBigDecimal(2));
                item.setUnitCost(resultSet.getBigDecimal(3));
                item.setSupplierId(resultSet.getInt(4));

                Product product = new Product();
                product.setProductId(resultSet.getString(5));
                product.setName(resultSet.getString(6));
                product.setDescription(resultSet.getString(7));
                product.setCategoryId(resultSet.getString(8));
                item.setProduct(product);

                item.setStatus(resultSet.getString(9));
                item.setAttribute1(resultSet.getString(10));
                item.setAttribute2(resultSet.getString(11));
                item.setAttribute3(resultSet.getString(12));
                item.setAttribute4(resultSet.getString(13));
                item.setAttribute5(resultSet.getString(14));
                itemList.add(item);
            }

            DBUtil.closeResultSet(resultSet);
            DBUtil.closePreparedStatement(pStatement);
            DBUtil.closeConnection(connection);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return itemList;
    }

    @Override
    public void updateInventoryQuantity(Map<String, Object> param) throws Exception {
        Connection connection = DBUtil.getConnection();
        PreparedStatement pStatement = connection.prepareStatement(updateInventoryQuantityString);
        String itemId=param.keySet().iterator().next();
        Integer increment=(Integer) param.get(itemId);
        pStatement.setInt(1, increment);
        pStatement.setString(2, itemId);
        pStatement.executeUpdate();
        DBUtil.closePreparedStatement(pStatement);
        DBUtil.closeConnection(connection);
    }

    @Override
    public int getInventoryQuantity(String itemId) {
        int result=-1;
        try {
            Connection connection = DBUtil.getConnection();
            PreparedStatement pStatement = connection.prepareStatement(getInventoryQuantityString);
            pStatement.setString(1, itemId);
            ResultSet resultSet = pStatement.executeQuery();
            if (resultSet.next()) {
                result = resultSet.getInt(1);
            }
            DBUtil.closeResultSet(resultSet);
            DBUtil.closePreparedStatement(pStatement);
            DBUtil.closeConnection(connection);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    @Override
    public List<Item> getItemListByProduct(String productId) {
        List<Item> itemList=new ArrayList<>();
        try {
            Connection connection = DBUtil.getConnection();
            PreparedStatement pStatement = connection.prepareStatement(getItemListByProductString);
            pStatement.setString(1, productId);
            ResultSet resultSet = pStatement.executeQuery();
            while (resultSet.next()) {
                Item item = new Item();
                item.setItemId(resultSet.getString(1));
                item.setListPrice(resultSet.getBigDecimal(2));
                item.setUnitCost(resultSet.getBigDecimal(3));
                item.setSupplierId(resultSet.getInt(4));
                Product product=new Product();
                product.setProductId(resultSet.getString(5));
                product.setName(resultSet.getString(6));
                product.setDescription(resultSet.getString(7));
                product.setCategoryId(resultSet.getString(8));
                item.setProduct(product);
                item.setStatus(resultSet.getString(9));
                item.setAttribute1(resultSet.getString(10));
                item.setAttribute2(resultSet.getString(11));
                item.setAttribute3(resultSet.getString(12));
                item.setAttribute4(resultSet.getString(13));
                item.setAttribute5(resultSet.getString(14));
                itemList.add(item);
            }
            DBUtil.closeResultSet(resultSet);
            DBUtil.closePreparedStatement(pStatement);
            DBUtil.closeConnection(connection);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return itemList;
    }

    @Override
    public Item getItem(String itemId) {
        Item item=null;
        try {
            Connection connection = DBUtil.getConnection();
            PreparedStatement pStatement = connection.prepareStatement(getItemString);
            pStatement.setString(1, itemId);
            ResultSet resultSet = pStatement.executeQuery();
            if (resultSet.next()) {
                item = new Item();
                item.setItemId(resultSet.getString(1));
                item.setListPrice(resultSet.getBigDecimal(2));
                item.setUnitCost(resultSet.getBigDecimal(3));
                item.setSupplierId(resultSet.getInt(4));
                Product product=new Product();
                product.setProductId(resultSet.getString(5));
                product.setName(resultSet.getString(6));
                product.setDescription(resultSet.getString(7));
                product.setCategoryId(resultSet.getString(8));
                item.setProduct(product);
                item.setStatus(resultSet.getString(9));
                item.setAttribute1(resultSet.getString(10));
                item.setAttribute2(resultSet.getString(11));
                item.setAttribute3(resultSet.getString(12));
                item.setAttribute4(resultSet.getString(13));
                item.setAttribute5(resultSet.getString(14));
            }
            DBUtil.closeResultSet(resultSet);
            DBUtil.closePreparedStatement(pStatement);
            DBUtil.closeConnection(connection);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return item;
    }
}