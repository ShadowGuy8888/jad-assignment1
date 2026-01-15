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

@WebServlet("/admin/editClient")
public class EditClientPage extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

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
            User user = userDAO.findById(Integer.parseInt(clientId));
            if (user == null) {
                res.sendRedirect(req.getContextPath() + "/admin/dashboard?error=Client not found");
                return;
            }

            req.setAttribute("clientId", clientId);
            req.setAttribute("username", user.getUsername());
            req.setAttribute("email", user.getEmail());
            req.setAttribute("phone", user.getPhone());
            req.setAttribute("firstName", user.getFirstName());
            req.setAttribute("lastName", user.getLastName());

            req.getRequestDispatcher("/editClient.jsp").forward(req, res);

        } catch (SQLException e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?error=Database error");

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?error=An error occurred while loading client");
        }
    }
}

