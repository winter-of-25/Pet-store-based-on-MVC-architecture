package csu.web.mypetstore.domain;

import csu.web.mypetstore.persistence.CartDao;
import csu.web.mypetstore.persistence.impl.CartDaoImpl;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.*;

public class Cart implements Serializable {
    private static final long serialVersionUID = 8329559983943337176L;

    private final Map<String, CartItem> itemMap = Collections.synchronizedMap(new HashMap<>());
    private final List<CartItem> itemList = new ArrayList<>();
    private final CartDao cartDao = new CartDaoImpl();

    private String userId;
    private boolean loadedFromDatabase = false;

    public Cart() {}

    public Cart(String userId) {
        this.userId = userId;
        loadFromDatabase();
    }

    public String getUserId() { return userId; }

    public void setUserId(String userId) {
        this.userId = userId;
        if (!loadedFromDatabase) loadFromDatabase();
    }

    /** 从数据库加载购物车数据 */
    private void loadFromDatabase() {
        if (userId == null || loadedFromDatabase) return;

        List<CartItem> dbItems = cartDao.getCartItemsByUserId(userId);
        itemMap.clear();
        itemList.clear();
        for (CartItem cartItem : dbItems) {
            itemMap.put(cartItem.getItem().getItemId(), cartItem);
            itemList.add(cartItem);
        }
        loadedFromDatabase = true;
    }

    /** 获取购物车所有商品 */
    public List<CartItem> getCartItems() { return itemList; }

    /** 获取购物车商品数量 */
    public int getNumberOfItems() { return itemList.size(); }

    /** 判断是否包含指定商品 */
    public boolean containsItemId(String itemId) { return itemMap.containsKey(itemId); }

    /** 添加商品 */
    public void addItem(Item item, boolean isInStock) {
        CartItem cartItem = itemMap.get(item.getItemId());
        if (cartItem == null) {
            cartItem = new CartItem();
            cartItem.setItem(item);
            cartItem.setQuantity(1);
            cartItem.setInStock(isInStock);
            itemMap.put(item.getItemId(), cartItem);
            itemList.add(cartItem);
            if (userId != null) cartDao.addItemToCart(userId, item.getItemId(), 1);
        } else {
            cartItem.incrementQuantity();
            if (userId != null) cartDao.updateCartItemQuantity(userId, item.getItemId(), cartItem.getQuantity());
        }
    }

    /** 根据ID移除商品 */
    public Item removeItemById(String itemId) {
        CartItem removed = itemMap.remove(itemId);
        if (removed != null) {
            itemList.remove(removed);
            if (userId != null) cartDao.removeItemFromCart(userId, itemId);
            return removed.getItem();
        }
        return null;
    }

    /** 修改数量 */
    public void setQuantityByItemId(String itemId, int quantity) {
        CartItem item = itemMap.get(itemId);
        if (item != null && quantity >= 0) {
            item.setQuantity(quantity);
            if (userId != null) cartDao.updateCartItemQuantity(userId, itemId, quantity);
        }
    }

    /** 获取购物车小计 */
    public BigDecimal getSubTotal() {
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem cartItem : itemList) {
            Item item = cartItem.getItem();
            if (item != null && item.getListPrice() != null) {
                total = total.add(item.getListPrice().multiply(BigDecimal.valueOf(cartItem.getQuantity())));
            }
        }
        return total;
    }

    /** 清空购物车 */
    public void clear() {
        itemMap.clear();
        itemList.clear();
        loadedFromDatabase = false;
        if (userId != null) cartDao.clearCart(userId);
    }

    /** 根据 itemId 获取 CartItem */
    public CartItem getCartItemById(String itemId) { return itemMap.get(itemId); }

    public void incrementQuantityByItemId(String itemId) {
        CartItem item = itemMap.get(itemId);
        if (item != null) {
            setQuantityByItemId(itemId, item.getQuantity() + 1);
        }
    }

}
