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
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
        	Class.forName("com.mysql.cj.jdbc.Driver");
        	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/silvercare", "root", "password");
			ps = conn.prepareStatement("SELECT * FROM user WHERE username = ?");
        	
            ps.setString(1, username);
            rs = ps.executeQuery();

            if (rs.next()) {
                req.setAttribute("error", "Username already exists!");
                req.getRequestDispatcher("register.jsp").forward(req, res);
                return;
            }
            
            PreparedStatement ps1 = conn.prepareStatement("INSERT INTO user (username, password, email, first_name, last_name, phone, address, emergency_contact, blk_no, unit_no) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

            ps1.setString(1, username);
            ps1.setString(2, BCrypt.hashpw(password, BCrypt.gensalt(10))); // bcrypt hashing
            ps1.setString(3, email);
            ps1.setString(4, firstName);
            ps1.setString(5, lastName);
            ps1.setString(6, phone);
            ps1.setString(7, address);
            ps1.setString(8, emergencyPhone);
            ps1.setString(9, blkNo);
            ps1.setString(10, unitNo);
            ps1.executeUpdate();

            // Start session
            HttpSession session = req.getSession();
            session.setAttribute("username", username);
            session.setAttribute("loginTimestamp", new Date());

            res.sendRedirect("index.jsp");

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            req.setAttribute("error", "Database error occurred.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
        
        } finally {
        	try { if (rs != null) rs.close(); } catch (SQLException e) {}
        	try { if (ps != null) ps.close(); } catch (SQLException e) {}
        	try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
        
	}

}
