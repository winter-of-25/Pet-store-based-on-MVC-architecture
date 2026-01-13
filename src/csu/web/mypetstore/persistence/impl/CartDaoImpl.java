package csu.web.mypetstore.persistence.impl;

import csu.web.mypetstore.domain.CartItem;
import csu.web.mypetstore.domain.Item;
import csu.web.mypetstore.persistence.CartDao;
import csu.web.mypetstore.persistence.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class CartDaoImpl implements CartDao{
    private static final String GET_CART_ITEMS_BY_USER_ID =
            "SELECT c.item_id, c.quantity, i.productid, i.listprice, i.unitcost, i.supplier, i.status, " +
                    "i.attr1 AS attribute1, i.attr2 AS attribute2, i.attr3 AS attribute3, " +
                    "i.attr4 AS attribute4, i.attr5 AS attribute5 " +
                    "FROM cart c JOIN item i ON c.item_id = i.itemid WHERE c.user_id = ?";

    private static final String ADD_ITEM_TO_CART =
            "INSERT INTO cart (user_id, item_id, quantity) VALUES (?, ?, ?) " +
                    "ON DUPLICATE KEY UPDATE quantity = quantity + ?";

    private static final String UPDATE_CART_ITEM_QUANTITY =
            "UPDATE cart SET quantity = ? WHERE user_id = ? AND item_id = ?";

    private static final String REMOVE_ITEM_FROM_CART =
            "DELETE FROM cart WHERE user_id = ? AND item_id = ?";

    private static final String CLEAR_CART =
            "DELETE FROM cart WHERE user_id = ?";

    private static final String CONTAINS_ITEM =
            "SELECT COUNT(*) FROM cart WHERE user_id = ? AND item_id = ?";

    private static final String GET_CART_ITEM_COUNT =
            "SELECT COUNT(*) FROM cart WHERE user_id = ?";

    @Override
    public List<CartItem> getCartItemsByUserId(String userId) {
        List<CartItem> cartItems = new ArrayList<>();
        try {
            Connection connection = DBUtil.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(GET_CART_ITEMS_BY_USER_ID);
            preparedStatement.setString(1, userId);
            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                CartItem cartItem = new CartItem();
                Item item = new Item();

                // 设置Item属性
                item.setItemId(resultSet.getString("item_id"));
                item.setProductId(resultSet.getString("productid"));
                item.setListPrice(resultSet.getBigDecimal("listprice"));
                item.setUnitCost(resultSet.getBigDecimal("unitcost"));
                item.setSupplierId(resultSet.getInt("supplier"));
                item.setStatus(resultSet.getString("status"));
                item.setAttribute1(resultSet.getString("attribute1"));
                item.setAttribute2(resultSet.getString("attribute2"));
                item.setAttribute3(resultSet.getString("attribute3"));
                item.setAttribute4(resultSet.getString("attribute4"));
                item.setAttribute5(resultSet.getString("attribute5"));
//                item.setName(resultSet.getString("name"));
//                item.setImage(resultSet.getString("image"));

                cartItem.setItem(item);
                cartItem.setQuantity(resultSet.getInt("quantity"));
                cartItem.setInStock(true); // 可以根据库存状态设置

                cartItems.add(cartItem);
            }
            DBUtil.closeResultSet(resultSet);
            DBUtil.closePreparedStatement(preparedStatement);
            DBUtil.closeConnection(connection);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cartItems;
    }

    @Override
    public void addItemToCart(String userId, String itemId, int quantity) {
        try {
            Connection connection = DBUtil.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(ADD_ITEM_TO_CART);
            preparedStatement.setString(1, userId);
            preparedStatement.setString(2, itemId);
            preparedStatement.setInt(3, quantity);
            preparedStatement.setInt(4, quantity);
            preparedStatement.executeUpdate();
            DBUtil.closePreparedStatement(preparedStatement);
            DBUtil.closeConnection(connection);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateCartItemQuantity(String userId, String itemId, int quantity) {
        try {
            Connection connection = DBUtil.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_CART_ITEM_QUANTITY);
            preparedStatement.setInt(1, quantity);
            preparedStatement.setString(2, userId);
            preparedStatement.setString(3, itemId);
            preparedStatement.executeUpdate();
            DBUtil.closePreparedStatement(preparedStatement);
            DBUtil.closeConnection(connection);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void removeItemFromCart(String userId, String itemId) {
        try {
            Connection connection = DBUtil.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(REMOVE_ITEM_FROM_CART);
            preparedStatement.setString(1, userId);
            preparedStatement.setString(2, itemId);
            preparedStatement.executeUpdate();
            DBUtil.closePreparedStatement(preparedStatement);
            DBUtil.closeConnection(connection);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void clearCart(String userId) {
        try {
            Connection connection = DBUtil.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(CLEAR_CART);
            preparedStatement.setString(1, userId);
            preparedStatement.executeUpdate();
            DBUtil.closePreparedStatement(preparedStatement);
            DBUtil.closeConnection(connection);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public boolean containsItem(String userId, String itemId) {
        try {
            Connection connection = DBUtil.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(CONTAINS_ITEM);
            preparedStatement.setString(1, userId);
            preparedStatement.setString(2, itemId);
            ResultSet resultSet = preparedStatement.executeQuery();
            boolean contains = false;
            if (resultSet.next()) {
                contains = resultSet.getInt(1) > 0;
            }
            DBUtil.closeResultSet(resultSet);
            DBUtil.closePreparedStatement(preparedStatement);
            DBUtil.closeConnection(connection);
            return contains;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int getCartItemCount(String userId) {
        try {
            Connection connection = DBUtil.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(GET_CART_ITEM_COUNT);
            preparedStatement.setString(1, userId);
            ResultSet resultSet = preparedStatement.executeQuery();
            int count = 0;
            if (resultSet.next()) {
                count = resultSet.getInt(1);
            }
            DBUtil.closeResultSet(resultSet);
            DBUtil.closePreparedStatement(preparedStatement);
            DBUtil.closeConnection(connection);
            return count;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}
