// Author: Lau Chun Yi
package com.jovanchunyi.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {

    public static Connection getConnection() throws SQLException {
		Connection conn = null;
		
		try {
		    String url = "jdbc:mysql://localhost:3306/silvercare";
		    String username = "root";
		    String password = "password";
		    
		    Class.forName("com.mysql.cj.jdbc.Driver");
		    conn = DriverManager.getConnection(url, username, password);
	    
		} catch (ClassNotFoundException e) {
			throw new SQLException("Database driver not found", e);
		}
		
		return conn;
    }

}