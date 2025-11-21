package com.jovan.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;
import java.util.Date;

import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    public RegisterServlet() {}

	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String username = req.getParameter("usernameInput");
        String password = req.getParameter("passwordInput");
        String confirmPassword = req.getParameter("confirmPasswordInput");
        String email = req.getParameter("emailInput");
        String firstName = req.getParameter("firstNameInput");
        String lastName = req.getParameter("lastNameInput");
        String phone = req.getParameter("phoneInput");
        String emergencyPhone = req.getParameter("emergencyPhoneInput");
        String address = req.getParameter("addressInput");
        String blkNo = req.getParameter("blockNoInput");
        String unitNo = req.getParameter("unitNoInput");

        if (username == null || username.isEmpty()
        	|| password == null || password.isEmpty()
        	|| !password.equals(confirmPassword)) {
            req.setAttribute("error", "Passwords do not match! All fields are required!");
            req.getRequestDispatcher("register.jsp").forward(req, res); // send error message to client
            return;
        }
        
        Connection conn = null;
        CallableStatement cs = null;

        try {
        	Class.forName("com.mysql.cj.jdbc.Driver");
        	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/silvercare", "root", "password");
			cs = conn.prepareCall("{ CALL register_user(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) }");
        	
		    cs.setString(1, username);
		    cs.setString(2, BCrypt.hashpw(password, BCrypt.gensalt(10)));
		    cs.setString(3, email);
		    cs.setString(4, firstName);
		    cs.setString(5, lastName);
		    cs.setString(6, phone);
		    cs.setString(7, address);
		    cs.setString(8, emergencyPhone);
		    cs.setString(9, blkNo);
		    cs.setString(10, unitNo);
		    
		    cs.registerOutParameter(11, Types.INTEGER); // p_id
		    cs.registerOutParameter(12, Types.VARCHAR); // p_role
		    cs.registerOutParameter(13, Types.BOOLEAN); // p_success
		    cs.registerOutParameter(14, Types.VARCHAR); // p_message
		    
		    cs.execute();
		    
		    String userId = cs.getString(11);
		    String userRole = cs.getString(12);
		    boolean success = cs.getBoolean(13);
		    String message = cs.getString(14);

		    if (success) {
	            // Start session
	            HttpSession session = req.getSession();
	            session.setAttribute("userId", userId);
	            session.setAttribute("username", username);
	            session.setAttribute("userRole", userRole);
	            session.setAttribute("loginTimestamp", new Date());
	            res.sendRedirect("index.jsp");
		    
		    } else { // error registering
		        req.setAttribute("error", message);
		        req.getRequestDispatcher("register.jsp").forward(req, res);
		    }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            req.setAttribute("error", "Database error occurred.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
        
        } finally {
        	try { if (cs != null) cs.close(); } catch (SQLException e) {}
        	try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
        
	}

}
