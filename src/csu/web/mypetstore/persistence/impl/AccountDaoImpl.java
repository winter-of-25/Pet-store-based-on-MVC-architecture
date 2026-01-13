package csu.web.mypetstore.persistence.impl;

import csu.web.mypetstore.domain.Account;
import csu.web.mypetstore.persistence.AccountDao;
import csu.web.mypetstore.persistence.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AccountDaoImpl implements AccountDao {

    // 【修改点1】定义根据用户名查询的 SQL 语句 (去掉了密码验证条件)
    private static final String GET_ACCOUNT_BY_USERNAME = "SELECT " +
            "SIGNON.USERNAME," +
            "ACCOUNT.EMAIL,ACCOUNT.FIRSTNAME,ACCOUNT.LASTNAME,ACCOUNT.STATUS," +
            "ACCOUNT.ADDR1 AS address1,ACCOUNT.ADDR2 AS address2," +
            "ACCOUNT.CITY,ACCOUNT.STATE,ACCOUNT.ZIP,ACCOUNT.COUNTRY,ACCOUNT.PHONE," +
            "PROFILE.LANGPREF AS languagePreference,PROFILE.FAVCATEGORY AS favouriteCategoryId," +
            "PROFILE.MYLISTOPT AS listOption,PROFILE.BANNEROPT AS bannerOption," +
            "BANNERDATA.BANNERNAME " +
            "FROM ACCOUNT, PROFILE, SIGNON, BANNERDATA " +
            "WHERE ACCOUNT.USERID = ? " +  // 这里只匹配用户名
            "AND SIGNON.USERNAME = ACCOUNT.USERID " +
            "AND PROFILE.USERID = ACCOUNT.USERID " +
            "AND PROFILE.FAVCATEGORY = BANNERDATA.FAVCATEGORY";

    private static final String GET_ACCOUNT_BY_USERNAME_AND_PASSWORD = "SELECT " +
            "SIGNON.USERNAME," +
            "ACCOUNT.EMAIL,ACCOUNT.FIRSTNAME,ACCOUNT.LASTNAME,ACCOUNT.STATUS," +
            "ACCOUNT.ADDR1 AS address1,ACCOUNT.ADDR2 AS address2," +
            "ACCOUNT.CITY,ACCOUNT.STATE,ACCOUNT.ZIP,ACCOUNT.COUNTRY,ACCOUNT.PHONE," +
            "PROFILE.LANGPREF AS languagePreference,PROFILE.FAVCATEGORY AS favouriteCategoryId," +
            "PROFILE.MYLISTOPT AS listOption,PROFILE.BANNEROPT AS bannerOption," +
            "BANNERDATA.BANNERNAME " +
            "FROM ACCOUNT, PROFILE, SIGNON, BANNERDATA " +
            "WHERE ACCOUNT.USERID = ? AND SIGNON.PASSWORD = ? " +
            "AND SIGNON.USERNAME = ACCOUNT.USERID " +
            "AND PROFILE.USERID = ACCOUNT.USERID " +
            "AND PROFILE.FAVCATEGORY = BANNERDATA.FAVCATEGORY";


    private static final String INSERT_ACCOUNT = "petstore.insertAccount"; // 也可以按需改成SQL字符串
    private static final String INSERT_PROFILE = "petstore.insertProfile";
    private static final String INSERT_SIGNON = "petstore.insertSignon";
    private static final String UPDATE_ACCOUNT = "petstore.updateAccount";
    private static final String UPDATE_PROFILE = "petstore.updateProfile";
    private static final String UPDATE_SIGNON = "petstore.updateSignon";


    // 【修改点2】实现 getAccountByUsername 方法
    @Override
    public Account getAccountByUsername(String username) throws Exception {
        Account account = null;
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        try {
            connection = DBUtil.getConnection();
            preparedStatement = connection.prepareStatement(GET_ACCOUNT_BY_USERNAME);
            preparedStatement.setString(1, username);
            resultSet = preparedStatement.executeQuery();

            // 如果查到了记录，说明用户名已存在
            if(resultSet.next()) {
                account = this.resultSetToAccount(resultSet);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeResultSet(resultSet);
            DBUtil.closeStatement(preparedStatement);
            DBUtil.closeConnection(connection);
        }
        return account;
    }

    @Override
    public Account getAccountByUsernameAndPassword(Account account) throws Exception {
        Account account1 = null;
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        try {
            connection = DBUtil.getConnection();
            preparedStatement = connection.prepareStatement(GET_ACCOUNT_BY_USERNAME_AND_PASSWORD);
            preparedStatement.setString(1, account.getUsername());
            preparedStatement.setString(2, account.getPassword());
            resultSet = preparedStatement.executeQuery();
            if(resultSet.next()) {
                account1 = this.resultSetToAccount(resultSet);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeResultSet(resultSet);
            DBUtil.closeStatement(preparedStatement);
            DBUtil.closeConnection(connection);
        }
        return account1;
    }

    private Account resultSetToAccount(ResultSet resultSet) throws Exception{
        Account account = new Account();
        account.setUsername(resultSet.getString("username"));
        // account.setPassword(resultSet.getString("password")); // 密码通常不回显，或者查询中未包含
        account.setEmail(resultSet.getString("email"));
        account.setFirstName(resultSet.getString("firstName"));
        account.setLastName(resultSet.getString("lastName"));
        account.setStatus(resultSet.getString("status"));
        account.setAddress1(resultSet.getString("address1"));
        account.setAddress2(resultSet.getString("address2"));
        account.setCity(resultSet.getString("city"));
        account.setState(resultSet.getString("state"));
        account.setZip(resultSet.getString("zip"));
        account.setCountry(resultSet.getString("country"));
        account.setPhone(resultSet.getString("phone"));
        account.setFavouriteCategoryId(resultSet.getString("favouriteCategoryId"));
        account.setLanguagePreference(resultSet.getString("languagePreference"));
        account.setListOption(resultSet.getInt("listOption") == 1);
        account.setBannerOption(resultSet.getInt("bannerOption") == 1);
        account.setBannerName(resultSet.getString("bannerName"));
        return account;
    }


    @Override
    public void insertAccount(Account account) throws Exception {
        Connection connection = null;
        try {
            connection = DBUtil.getConnection();
            connection.setAutoCommit(false);

            // 1. 插入 SIGNON 表
            PreparedStatement signonStatement = connection.prepareStatement("INSERT INTO SIGNON (USERNAME, PASSWORD) VALUES (?, ?)");
            signonStatement.setString(1, account.getUsername());
            signonStatement.setString(2, account.getPassword());
            signonStatement.executeUpdate();
            DBUtil.closeStatement(signonStatement);

            // 2. 插入 ACCOUNT 表
            PreparedStatement accountStatement = connection.prepareStatement(
                    "INSERT INTO ACCOUNT (USERID, EMAIL, FIRSTNAME, LASTNAME, STATUS, ADDR1, ADDR2, CITY, STATE, ZIP, COUNTRY, PHONE) " +
                            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            accountStatement.setString(1, account.getUsername());
            accountStatement.setString(2, account.getEmail());
            accountStatement.setString(3, account.getFirstName());
            accountStatement.setString(4, account.getLastName());
            accountStatement.setString(5, account.getStatus());
            accountStatement.setString(6, account.getAddress1());
            accountStatement.setString(7, account.getAddress2());
            accountStatement.setString(8, account.getCity());
            accountStatement.setString(9, account.getState());
            accountStatement.setString(10, account.getZip());
            accountStatement.setString(11, account.getCountry());
            accountStatement.setString(12, account.getPhone());
            accountStatement.executeUpdate();
            DBUtil.closeStatement(accountStatement);

            // 3. 插入 PROFILE 表
            PreparedStatement profileStatement = connection.prepareStatement(
                    "INSERT INTO PROFILE (USERID, LANGPREF, FAVCATEGORY, MYLISTOPT, BANNEROPT) " +
                            "VALUES (?, ?, ?, ?, ?)");
            profileStatement.setString(1, account.getUsername());
            profileStatement.setString(2, account.getLanguagePreference());
            profileStatement.setString(3, account.getFavouriteCategoryId());
            profileStatement.setInt(4, account.isListOption() ? 1 : 0);
            profileStatement.setInt(5, account.isBannerOption() ? 1 : 0);
            profileStatement.executeUpdate();
            DBUtil.closeStatement(profileStatement);

            connection.commit();

        } catch (Exception e) {
            try {
                if (connection != null) connection.rollback();
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
            throw e; // 抛出异常让Servlet捕获
        } finally {
            try {
                if (connection != null) connection.setAutoCommit(true);
            } catch (Exception e) {
                e.printStackTrace();
            }
            DBUtil.closeConnection(connection);
        }
    }

    @Override
    public void insertProfile(Account account) {
        // 未实现，如不使用可保留空方法
    }

    @Override
    public void insertSignon(Account account) {
        // 未实现，如不使用可保留空方法
    }

    @Override
    public void updateAccount(Account account) throws Exception {
        Connection connection = null;
        try {
            connection = DBUtil.getConnection();
            connection.setAutoCommit(false);

            // 1. 更新 SIGNON 表
            PreparedStatement signonStatement = connection.prepareStatement("UPDATE SIGNON SET PASSWORD = ? WHERE USERNAME = ?");
            signonStatement.setString(1, account.getPassword());
            signonStatement.setString(2, account.getUsername());
            int signonRows = signonStatement.executeUpdate();
            DBUtil.closeStatement(signonStatement);

            if (signonRows == 0) {
                throw new Exception("未找到对应用户名的SIGNON记录: " + account.getUsername());
            }

            // 2. 更新 ACCOUNT 表
            PreparedStatement accountStatement = connection.prepareStatement(
                    "UPDATE ACCOUNT SET EMAIL = ?, FIRSTNAME = ?, LASTNAME = ?, STATUS = ?, ADDR1 = ?, ADDR2 = ?, CITY = ?, STATE = ?, ZIP = ?, COUNTRY = ?, PHONE = ? " +
                            "WHERE USERID = ?");
            accountStatement.setString(1, account.getEmail());
            accountStatement.setString(2, account.getFirstName());
            accountStatement.setString(3, account.getLastName());
            accountStatement.setString(4, account.getStatus());
            accountStatement.setString(5, account.getAddress1());
            accountStatement.setString(6, account.getAddress2());
            accountStatement.setString(7, account.getCity());
            accountStatement.setString(8, account.getState());
            accountStatement.setString(9, account.getZip());
            accountStatement.setString(10, account.getCountry());
            accountStatement.setString(11, account.getPhone());
            accountStatement.setString(12, account.getUsername());
            int accountRows = accountStatement.executeUpdate();
            DBUtil.closeStatement(accountStatement);

            if (accountRows == 0) {
                throw new Exception("未找到对应用户名的ACCOUNT记录: " + account.getUsername());
            }

            // 3. 更新 PROFILE 表
            PreparedStatement profileStatement = connection.prepareStatement(
                    "UPDATE PROFILE SET LANGPREF = ?, FAVCATEGORY = ?, MYLISTOPT = ?, BANNEROPT = ? " +
                            "WHERE USERID = ?");
            profileStatement.setString(1, account.getLanguagePreference());
            profileStatement.setString(2, account.getFavouriteCategoryId());
            profileStatement.setInt(3, account.isListOption() ? 1 : 0);
            profileStatement.setInt(4, account.isBannerOption() ? 1 : 0);
            profileStatement.setString(5, account.getUsername());
            int profileRows = profileStatement.executeUpdate();
            DBUtil.closeStatement(profileStatement);

            if (profileRows == 0) {
                throw new Exception("未找到对应用户名的PROFILE记录: " + account.getUsername());
            }

            connection.commit();

        } catch (Exception e) {
            try {
                if (connection != null) connection.rollback();
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
            throw e;
        } finally {
            try {
                if (connection != null) connection.setAutoCommit(true);
            } catch (Exception e) {
                e.printStackTrace();
            }
            DBUtil.closeConnection(connection);
        }
    }

    @Override
    public void updateProfile(Account account) {
        // 未实现
    }

    @Override
    public void updateSignon(Account account) {
        // 未实现
    }
}