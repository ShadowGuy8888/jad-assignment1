// Author: Lau Chun Yi
package com.jovanchunyi.servlets;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;

import daos.UserDAO;
import entities.User;

@WebServlet("/ChangePasswordController")
public class ChangePasswordController extends HttpServlet {
    private UserDAO userDAO;
    
    public ChangePasswordController() {
        this.userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Please login to access this page");
            return;
        }

        String currentPassword = req.getParameter("currentPassword");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        if (currentPassword == null || currentPassword.isEmpty() ||
            newPassword == null || newPassword.isEmpty() ||
            confirmPassword == null || confirmPassword.isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/profile/edit?error=All password fields are required");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            res.sendRedirect(req.getContextPath() + "/profile/edit?error=New passwords do not match");
            return;
        }

        try {
            String userId = String.valueOf(currentUser.getId());
            boolean success = userDAO.changePassword(userId, currentPassword, newPassword);

            if (success) {
                res.sendRedirect(req.getContextPath() + "/profile/edit?success=Password changed successfully!");
            } else {
                res.sendRedirect(req.getContextPath() + "/profile/edit?error=Current password is incorrect");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/profile/edit?error=Database error: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            res.sendRedirect(req.getContextPath() + "/profile/edit?error=" + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/profile/edit?error=An error occurred while changing the password");
        }
    }
}
