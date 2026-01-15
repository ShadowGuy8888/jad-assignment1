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

@WebServlet("/booking/cancel")
public class CancelBookingPage extends HttpServlet {

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
        if (bookingId == null || !bookingId.matches("\\d+")) {
            res.sendRedirect(req.getContextPath() + "/myBookings?error=Invalid booking ID");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();
            ps = conn.prepareStatement(
                "SELECT b.*, s.name AS service_name " +
                "FROM booking b " +
                "JOIN service s ON b.service_id = s.id " +
                "WHERE b.id = ? AND b.user_id = ?"
            );
            ps.setString(1, bookingId);
            ps.setString(2, String.valueOf(currentUser.getId()));
            rs = ps.executeQuery();

            if (!rs.next()) {
                res.sendRedirect(req.getContextPath() + "/myBookings?error=Booking not found");
                return;
            }

            String status = rs.getString("status");
            if ("CANCELLED".equalsIgnoreCase(status) || "COMPLETED".equalsIgnoreCase(status)) {
                res.sendRedirect(req.getContextPath() + "/myBookings?error=This booking cannot be cancelled");
                return;
            }

            req.setAttribute("bookingId", rs.getString("id"));
            req.setAttribute("serviceName", rs.getString("service_name"));
            req.setAttribute("bookingTimestamp", rs.getTimestamp("check_in_time"));
            req.setAttribute("duration", rs.getInt("duration_hours"));
            req.setAttribute("totalPrice", rs.getDouble("total_price"));

            req.getRequestDispatcher("/cancelBooking.jsp").forward(req, res);

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
}
