package csu.web.mypetstore.persistence;

import java.sql.*;

public class DBUtil {
    private static final String DRIVER="com.mysql.cj.jdbc.Driver";
    private static final String URL="jdbc:mysql://localhost:3306/test?serverTimezone=Asia/Shanghai&useUnicode=true&characterEncoding=UTF-8&useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USERNAME="root";
    private static final String PASSWORD="123456789";

    public static Connection getConnection() throws Exception {
        Class.forName(DRIVER);
        Connection connection=null;
        connection = DriverManager.getConnection(URL,USERNAME,PASSWORD);
        return connection;

    }


    public static void closePreparedStatement(PreparedStatement preparedStatement) throws Exception {
        preparedStatement.close();
    }

    public static void closeConnection(Connection connection) throws Exception {
        connection.close();
    }

    public static void closeResultSet(ResultSet resultSet) throws Exception {
        resultSet.close();
    }

    public static void closeStatement(Statement statement) throws Exception {
        statement.close();
    }

}
