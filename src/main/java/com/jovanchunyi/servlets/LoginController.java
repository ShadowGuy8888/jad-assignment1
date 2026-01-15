// Author: Jovan Yap Keat An
package com.jovanchunyi.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import daos.UserDAO;
import entities.User;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Date;

@WebServlet("/login")
public class LoginController extends HttpServlet {
	
    private UserDAO userDAO;
    
    public LoginController() {
        this.userDAO = new UserDAO();
    }
    
	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

        String usernameInput = req.getParameter("usernameInput");
        String passwordInput = req.getParameter("passwordInput");

        if (usernameInput == null || usernameInput.isEmpty() || passwordInput == null || passwordInput.isEmpty()) {
            req.setAttribute("error", "All fields are required!");
            req.getRequestDispatcher("login.jsp").forward(req, res);
            return;
        }
        
        try {
            User user = userDAO.findByUsername(usernameInput);
            if (user == null || user.getPassword() == null || !BCrypt.checkpw(passwordInput, user.getPassword())) {
                user = null;
            }
            
            if (user == null) {
                req.setAttribute("error", "Invalid username and password!");
                req.getRequestDispatcher("login.jsp").forward(req, res);
                return;
            }

            HttpSession session = req.getSession();
            user.setPassword(null);
            session.setAttribute("currentUser", user);
            session.setAttribute("loginTimestamp", new Date());

            if ("ADMIN".equals(user.getRole())) {
                res.sendRedirect(req.getContextPath() + "/admin/dashboard");

            } else if ("USER".equals(user.getRole()) || "USER".equals(user.getRole())) {
                res.sendRedirect(req.getContextPath() + "/index.jsp");

            } else res.sendRedirect("login.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Database error occurred. Please try again.");
            req.getRequestDispatcher("login.jsp").forward(req, res);
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Internal server error!");
            req.getRequestDispatcher("login.jsp").forward(req, res);
        }
	}
}
