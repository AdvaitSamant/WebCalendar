package com.todo.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbCon {
    private static final String URL = "jdbc:mysql://localhost:3306/todo_db?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "Deact_0960";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL Driver not found. Ensure MySQL Connector/J is included in your project.", e);
        } catch (SQLException e) {
            throw new SQLException("Failed to connect to database. Check credentials and server status.", e);
        }
    }
}
