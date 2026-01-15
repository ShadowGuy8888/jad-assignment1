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

@WebServlet("/EditClientController")
public class EditClientController extends HttpServlet {

    private UserDAO userDAO;
    
    public EditClientController() {
        this.userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Access denied");
            return;
        }

        String clientId = req.getParameter("clientId");
        String firstName = req.getParameter("firstName");
        String lastName = req.getParameter("lastName");
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");

        try {
            User user = new User();
            user.setId(Integer.parseInt(clientId));
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setUsername(username);
            user.setEmail(email);
            user.setPhone(phone);

            boolean success;
            if (password != null && !password.trim().isEmpty()) {
                success = userDAO.updateUserWithPassword(user, password);
            } else {
                success = userDAO.updateUser(user);
            }

            if (success) {
                res.sendRedirect(req.getContextPath() + "/admin/dashboard?success=Client updated successfully");
            } else {
                res.sendRedirect(req.getContextPath() + "/admin/editClient?id=" + clientId + "&error=Unable to update client");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/admin/editClient?id=" + clientId + "&error=Database error");
            
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/admin/editClient?id=" + clientId + "&error=An error occurred while updating the client");
        }
    }
}
