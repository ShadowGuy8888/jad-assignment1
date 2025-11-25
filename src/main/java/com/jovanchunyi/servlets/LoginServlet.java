package com.jovanchunyi.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.jovanchunyi.util.DatabaseConnection;

import java.io.IOException;
import java.sql.*;
import java.util.Date;

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
            conn = DatabaseConnection.getConnection();
            
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

            session.setAttribute("userId", rs.getString("id"));
            session.setAttribute("username", usernameInput);
            session.setAttribute("userRole", rs.getString("role"));
            session.setAttribute("loginTimestamp", new Date());

            session.setAttribute("email", rs.getString("email"));
            session.setAttribute("phone", rs.getString("phone"));
            session.setAttribute("firstName", rs.getString("first_name"));
            session.setAttribute("lastName", rs.getString("last_name"));
            session.setAttribute("createdAt", rs.getString("created_at"));
            session.setAttribute("address", rs.getString("address"));
            session.setAttribute("blockNo", rs.getString("blk_no"));
            session.setAttribute("unitNo", rs.getString("unit_no"));
            session.setAttribute("emergencyContact", rs.getString("emergency_contact"));

            String role = rs.getString("role");
            session.setAttribute("role", role);

            if ("ADMIN".equals(role)) {
                res.sendRedirect("admin.jsp");
            } else if ("USER".equals(role)) {
                res.sendRedirect("index.jsp");
            } else {
                res.sendRedirect("login.jsp"); // fallback
            }


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
