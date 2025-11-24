package com.jovanchunyi.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.jovanchunyi.util.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/CancelBookingServlet")
public class CancelBookingServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp?error=Please login first");
            return;
        }

        String bookingIdParam = request.getParameter("bookingId");
        if (bookingIdParam == null || !bookingIdParam.matches("\\d+")) {
            response.sendRedirect("myBookings.jsp?error=Invalid booking ID");
            return;
        }
        int bookingId = Integer.parseInt(bookingIdParam);

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Update status to CANCELLED (only if belongs to user and not already cancelled/completed)
            String sql = "UPDATE booking SET status = 'CANCELLED', updated_at = NOW() " +
                         "WHERE id = ? AND user_id = ? AND status IN ('PENDING', 'CONFIRMED')";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ps.setString(2, userId);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                response.sendRedirect("myBookings.jsp?success=Booking cancelled successfully");
            } else {
                response.sendRedirect("myBookings.jsp?error=Unable to cancel booking");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("myBookings.jsp?error=Database error");
        }
    }
}