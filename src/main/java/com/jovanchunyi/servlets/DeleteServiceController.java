// Author: Lau Chun Yi
package com.jovanchunyi.servlets;

import java.io.IOException;
import java.sql.SQLException;

import daos.ServiceDAO;
import entities.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/DeleteServiceController")
public class DeleteServiceController extends HttpServlet {

    private ServiceDAO serviceDAO;
    
    public DeleteServiceController() {
        this.serviceDAO = new ServiceDAO();
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

        String serviceId = req.getParameter("id");
        if (serviceId == null || !serviceId.matches("\\d+")) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?error=Invalid service ID");
            return;
        }

        try {
            boolean success = serviceDAO.delete(serviceId);
            
            if (success) {
                res.sendRedirect(req.getContextPath() + "/admin/dashboard?success=Service deleted successfully");
            } else {
                res.sendRedirect(req.getContextPath() + "/admin/dashboard?error=Cannot delete service with existing bookings");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?error=Database error");
            
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?error=An error occurred while deleting the service");
        }
    }
}
