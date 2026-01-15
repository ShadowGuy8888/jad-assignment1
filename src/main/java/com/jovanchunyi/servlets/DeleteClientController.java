// Author: Lau Chun Yi
package com.jovanchunyi.servlets;

import java.io.IOException;
import java.sql.SQLException;

import daos.UserDAO;
import entities.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/DeleteClientController")
public class DeleteClientController extends HttpServlet {
    private UserDAO userDAO;
    
    public DeleteClientController() {
        this.userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Access denied");
            return;
        }

        String clientId = req.getParameter("id");
        if (clientId == null || !clientId.matches("\\d+")) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?error=Invalid client ID");
            return;
        }

        try {
            boolean success = userDAO.deleteUser(clientId);
            
            if (success) {
                res.sendRedirect(req.getContextPath() + "/admin/dashboard?success=Client deleted successfully");
            } else {
                res.sendRedirect(req.getContextPath() + "/admin/dashboard?error=Cannot delete client with existing bookings");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?error=Database error");
            
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?error=An error occurred while deleting the client");
        }
    }
}
