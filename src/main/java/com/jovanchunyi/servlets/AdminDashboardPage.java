// Author: Lau Chun Yi
package com.jovanchunyi.servlets;

import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

import daos.UserDAO;
import daos.ServiceDAO;
import daos.BookingDAO;
import entities.User;
import entities.Service;
import entities.Booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/dashboard")
public class AdminDashboardPage extends HttpServlet {
    
    private UserDAO userDAO;
    private ServiceDAO serviceDAO;
    private BookingDAO bookingDAO;
    
    public AdminDashboardPage() {
        this.userDAO = new UserDAO();
        this.serviceDAO = new ServiceDAO();
        this.bookingDAO = new BookingDAO();
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
        
        try {
            int totalServices = serviceDAO.getActiveServiceCount();
            int totalClients = userDAO.getUserCountByRole("USER");
            int activeBookings = bookingDAO.getActiveBookingCount();
            double totalRevenue = bookingDAO.getTotalRevenue();
            
            List<Service> services = serviceDAO.getAllServicesExcludingDeleted();
            List<User> clients = userDAO.getUsersByRole("USER");
            List<Booking> bookings = bookingDAO.getAllBookings();
            
            req.setAttribute("totalServices", totalServices);
            req.setAttribute("totalClients", totalClients);
            req.setAttribute("activeBookings", activeBookings);
            req.setAttribute("totalRevenue", totalRevenue);
            req.setAttribute("services", services);
            req.setAttribute("clients", clients);
            req.setAttribute("bookings", bookings);
            req.setAttribute("username", currentUser.getUsername());
            
            req.getRequestDispatcher("/adminDashboard.jsp").forward(req, res);
            
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Database error");
        }
    }
}
