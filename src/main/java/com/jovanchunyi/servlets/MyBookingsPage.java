package com.jovanchunyi.servlets;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import daos.BookingDAO;
import entities.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/myBookings")
public class MyBookingsPage extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();

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
            String userId = String.valueOf(currentUser.getId());
            List<Map<String, Object>> bookings = bookingDAO.getPendingBookingsByUser(userId);
            double subtotal = 0.0;
            for (Map<String, Object> row : bookings) {
                Object tp = row.get("totalPrice");
                if (tp instanceof Number) subtotal += ((Number) tp).doubleValue();
            }
            double gst = subtotal * 0.09;
            double total = subtotal + gst;

            req.setAttribute("bookings", bookings);
            req.setAttribute("subtotal", subtotal);
            req.setAttribute("gst", gst);
            req.setAttribute("total", total);
            req.getRequestDispatcher("/myBooking.jsp").forward(req, res);
            
        } catch (SQLException e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/myBookings?error=Database error: " + java.net.URLEncoder.encode(e.getMessage(), java.nio.charset.StandardCharsets.UTF_8));
            
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/myBookings?error=An error occurred while loading bookings: " + java.net.URLEncoder.encode(e.getMessage() != null ? e.getMessage() : e.toString(), java.nio.charset.StandardCharsets.UTF_8));
        }
    }
}
