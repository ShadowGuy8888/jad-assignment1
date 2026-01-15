// Author: Lau Chun Yi
package com.jovanchunyi.servlets;

import java.io.IOException;
import java.sql.SQLException;

import daos.ServiceDAO;
import entities.Service;
import entities.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AddServiceController")
public class AddServiceController extends HttpServlet {

    private ServiceDAO serviceDAO;
    
    public AddServiceController() {
        this.serviceDAO = new ServiceDAO();
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

        try {
            String name = req.getParameter("name");
            String categoryId = req.getParameter("categoryId");
            int hourlyRate = Integer.parseInt(req.getParameter("hourlyRate"));
            String description = req.getParameter("description");
            String imageUrl = req.getParameter("imageUrl");
            
            Service service = new Service();
            service.setName(name);
            service.setCategoryId(Integer.parseInt(categoryId));
            service.setHourlyRate(hourlyRate);
            service.setDescription(description);
            service.setImageUrl(imageUrl != null && !imageUrl.isEmpty() ? imageUrl : "");
            
            boolean success = serviceDAO.create(service);
            
            if (success) {
                res.sendRedirect(req.getContextPath() + "/admin/dashboard?success=Service added successfully");
            } else {
                res.sendRedirect(req.getContextPath() + "/admin/service/add?error=Failed to add service");
            }

        } catch (IllegalArgumentException e) {
            res.sendRedirect(req.getContextPath() + "/admin/service/add?error=" + e.getMessage());
        } catch (SQLException e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/admin/service/add?error=Database error: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/admin/service/add?error=An error occurred while adding the service");
        }
    }
}
