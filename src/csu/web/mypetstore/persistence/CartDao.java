package csu.web.mypetstore.persistence;

import csu.web.mypetstore.domain.CartItem;

import java.util.List;

public interface CartDao {
    // 获取用户购物车中的所有商品
    List<CartItem> getCartItemsByUserId(String userId);

    // 添加商品到购物车
    void addItemToCart(String userId, String itemId, int quantity);

    // 更新购物车中商品数量
    void updateCartItemQuantity(String userId, String itemId, int quantity);

    // 从购物车中移除商品
    void removeItemFromCart(String userId, String itemId);

    // 清空用户购物车
    void clearCart(String userId);

    // 检查购物车中是否包含某商品
    boolean containsItem(String userId, String itemId);

    // 获取购物车中商品数量
    int getCartItemCount(String userId);
}