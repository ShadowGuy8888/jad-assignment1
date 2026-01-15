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
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/booking/update")
public class AdminUpdateBookingPage extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Access denied");
            return;
        }

        String bookingId = req.getParameter("id");
        if (bookingId == null || !bookingId.matches("\\d+")) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?error=Invalid booking ID");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();
            ps = conn.prepareStatement(
                "SELECT b.*, u.username, s.name AS service_name " +
                "FROM booking b " +
                "JOIN user u ON b.user_id = u.id " +
                "JOIN service s ON b.service_id = s.id " +
                "WHERE b.id = ?"
            );
            ps.setString(1, bookingId);
            rs = ps.executeQuery();

            if (!rs.next()) {
                res.sendRedirect(req.getContextPath() + "/admin/dashboard?error=Booking not found");
                return;
            }

            req.setAttribute("bookingId", rs.getString("id"));
            req.setAttribute("username", rs.getString("username"));
            req.setAttribute("serviceName", rs.getString("service_name"));
            req.setAttribute("bookingTimestamp", rs.getTimestamp("check_in_time"));
            req.setAttribute("duration", rs.getInt("duration_hours"));
            req.setAttribute("totalPrice", rs.getDouble("total_price"));
            req.setAttribute("status", rs.getString("status"));
            req.setAttribute("notes", rs.getString("notes"));

            req.getRequestDispatcher("/adminUpdateBooking.jsp").forward(req, res);

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?error=Database error");
            
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
