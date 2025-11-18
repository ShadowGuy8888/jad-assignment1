package com.jovan.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	
    public LoginServlet() {}
    
	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

        String usernameInput = req.getParameter("usernameInput");
        String passwordInput = req.getParameter("passwordInput");

        if (usernameInput == null || usernameInput.isEmpty() || passwordInput == null || passwordInput.isEmpty()) {
            req.setAttribute("error", "All fields are required!");
            req.getRequestDispatcher("login.jsp").forward(req, res);
            return;
        }
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/silvercare", "root", "password");

            ps = conn.prepareStatement("SELECT * FROM user WHERE username = ?;");
            ps.setString(1, usernameInput);
            rs = ps.executeQuery();

            if (!rs.next()) {
                req.setAttribute("error", "Invalid username and password!");
                req.getRequestDispatcher("login.jsp").forward(req, res);
                return;
            }

            String passwordHash = rs.getString("password");

            if (!BCrypt.checkpw(passwordInput, passwordHash)) {
                req.setAttribute("error", "Invalid username and password!");
                req.getRequestDispatcher("login.jsp").forward(req, res);
                return;
            }

            // On successful login
            HttpSession session = req.getSession();
            session.setAttribute("username", rs.getString("username"));

            res.sendRedirect("index.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Internal server error!");
            req.getRequestDispatcher("login.jsp").forward(req, res);
        
        } finally {
        	try { if (rs != null) rs.close(); } catch (SQLException e) {}
        	try { if (ps != null) ps.close(); } catch (SQLException e) {}
        	try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
        
	}

}
