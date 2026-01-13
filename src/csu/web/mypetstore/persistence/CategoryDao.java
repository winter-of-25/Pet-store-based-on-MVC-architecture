package csu.web.mypetstore.persistence;

import csu.web.mypetstore.domain.Category;

import java.util.List;

public interface CategoryDao {
    List<Category> getCategoryList() throws Exception;

    Category getCategory(String categoryId) throws Exception;
}
