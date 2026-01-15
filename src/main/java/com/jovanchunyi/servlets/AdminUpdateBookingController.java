// Author: Lau Chun Yi
package com.jovanchunyi.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.jovanchunyi.util.DatabaseConnection;

import entities.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/booking/edit")
public class AdminUpdateBookingController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Access denied");
            return;
        }
        
        String bookingId = req.getParameter("id");
        if (bookingId == null) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DatabaseConnection.getConnection();
            
            String sql = "SELECT b.*, u.username, s.name AS service_name " +
                        "FROM booking b " +
                        "JOIN user u ON b.user_id = u.id " +
                        "JOIN service s ON b.service_id = s.id " +
                        "WHERE b.id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(bookingId));
            rs = ps.executeQuery();
            
            if (rs.next()) {
                req.setAttribute("bookingId", bookingId);
                req.setAttribute("username", rs.getString("username"));
                req.setAttribute("serviceName", rs.getString("service_name"));
                req.setAttribute("status", rs.getString("status"));
                req.setAttribute("notes", rs.getString("notes"));
                req.setAttribute("duration", rs.getInt("duration_hours"));
                req.setAttribute("totalPrice", rs.getDouble("total_price"));
                req.setAttribute("bookingTimestamp", rs.getTimestamp("check_in_time"));
                
                req.getRequestDispatcher("/adminUpdateBooking.jsp").forward(req, res);
            } else {
                res.sendRedirect(req.getContextPath() + "/admin/dashboard?error=Booking not found");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?error=" + e.getMessage());
            
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
}
