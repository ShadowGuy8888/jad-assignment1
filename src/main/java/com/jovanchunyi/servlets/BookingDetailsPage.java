// Author: Lau Chun Yi
package com.jovanchunyi.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.jovanchunyi.util.DatabaseConnection;

import daos.BookingDAO;
import entities.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/booking/details")
public class BookingDetailsPage extends HttpServlet {
    
    private final BookingDAO bookingDAO = new BookingDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
    	
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Please login first");
            return;
        }
        
        String bookingId = req.getParameter("id");
        if (bookingId == null || bookingId.trim().isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/myBookings?error=Booking ID not provided");
            return;
        }
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DatabaseConnection.getConnection();
            
            ps = conn.prepareStatement(
                "SELECT b.*, s.name AS service_name, s.hourly_rate, sc.name AS category_name, u.first_name, u.last_name, u.email, u.phone " +
                "FROM booking b " +
                "JOIN service s ON b.service_id = s.id " +
                "JOIN service_category sc ON s.category_id = sc.id " +
                "JOIN user u ON b.user_id = u.id " +
                "WHERE b.id = ?"
            );
            ps.setString(1, bookingId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                req.setAttribute("bookingId", rs.getString("id"));
                req.setAttribute("serviceName", rs.getString("service_name"));
                req.setAttribute("categoryName", rs.getString("category_name"));
                req.setAttribute("hourlyRate", String.valueOf(rs.getDouble("hourly_rate")));
                req.setAttribute("checkInTime", rs.getTimestamp("check_in_time"));
                req.setAttribute("durationHours", rs.getString("duration_hours"));
                req.setAttribute("totalPrice", String.valueOf(rs.getDouble("total_price")));
                req.setAttribute("status", rs.getString("status"));
                req.setAttribute("notes", rs.getString("notes"));
                req.setAttribute("createdAt", rs.getTimestamp("created_at"));
                req.setAttribute("updatedAt", rs.getTimestamp("updated_at"));
                
                req.setAttribute("userFirstName", rs.getString("first_name"));
                req.setAttribute("userLastName", rs.getString("last_name"));
                req.setAttribute("userEmail", rs.getString("email"));
                req.setAttribute("userPhone", rs.getString("phone"));
                
                req.getRequestDispatcher("/bookingDetails.jsp").forward(req, res);
            } else {
                res.sendRedirect(req.getContextPath() + "/myBookings?error=Booking not found");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "myBookings?error=Database error");
            
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Please login first");
            return;
        }

        String bookingId = req.getParameter("id");
        if (bookingId == null || bookingId.trim().isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/myBookings?error=Booking ID not provided");
            return;
        }

        String userId = String.valueOf(currentUser.getId());

        try {
            boolean deleted = bookingDAO.deletePendingBooking(bookingId, userId);
            if (deleted) {
                res.sendRedirect(req.getContextPath() + "/myBookings?success=Booking removed from cart");
            } else {
                res.sendRedirect(req.getContextPath() + "/myBookings?error=Unable to remove booking from cart");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/myBookings?error=Database error while removing booking");
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/myBookings?error=An error occurred while removing booking");
        }
    }
}
