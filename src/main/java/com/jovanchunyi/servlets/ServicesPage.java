// Author: Lau Chun Yi
package com.jovanchunyi.servlets;

import java.io.IOException;
import java.util.List;

import daos.ServiceDAO;
import daos.ServiceCategoryDAO;
import entities.Service;
import entities.ServiceCategory;
import entities.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/services")
public class ServicesPage extends HttpServlet {
    
    private ServiceDAO serviceDAO;
    private ServiceCategoryDAO serviceCategoryDAO;
    
    public ServicesPage() {
        this.serviceDAO = new ServiceDAO();
        this.serviceCategoryDAO = new ServiceCategoryDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
    	
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Please login to access this page");
            return;
        }
        
        try {
            String selectedCategory = req.getParameter("categoryName");
            if (selectedCategory == null) selectedCategory = "all";
            
            List<ServiceCategory> categories = serviceCategoryDAO.findAll();
            List<Service> services = serviceDAO.findAll();
            
            if (!"all".equals(selectedCategory)) {
                Integer selectedId = null;
                for (ServiceCategory c : categories) {
                    if (c.getName().equals(selectedCategory)) {
                        selectedId = c.getId();
                        break;
                    }
                }
                if (selectedId != null) {
                    List<Service> filtered = new java.util.ArrayList<>();
                    for (Service s : services) {
                        if (s.getCategoryId() == selectedId) filtered.add(s);
                    }
                    services = filtered;
                }
            }
            
            req.setAttribute("categories", categories);
            req.setAttribute("services", services);
            req.setAttribute("selectedCategory", selectedCategory);
            
            req.getRequestDispatcher("/services.jsp").forward(req, res);
            
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/services?error=Database error");
        }
    }
}
