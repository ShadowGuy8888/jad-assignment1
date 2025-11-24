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

@WebServlet("/EditBookingServlet")
public class EditBookingServlet extends HttpServlet {

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

        // Get form parameters
        String bookingIdParam = request.getParameter("bookingId");
        if (bookingIdParam == null || !bookingIdParam.matches("\\d+")) {
            response.sendRedirect("myBookings.jsp?error=Invalid booking ID");
            return;
        }
        int bookingId = Integer.parseInt(bookingIdParam);

        int duration = Integer.parseInt(request.getParameter("duration"));
        String date = request.getParameter("date");
        String time = request.getParameter("time");
        String notes = request.getParameter("notes");
        double hourlyRate = Double.parseDouble(request.getParameter("hourlyRate"));

        // Calculate new total
        double totalPrice = duration * hourlyRate;

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Update booking (only if belongs to user and not cancelled/completed)
            String sql = "UPDATE booking SET booking_date = ?, booking_time = ?, duration_hours = ?, " +
                         "total_price = ?, notes = ?, updated_at = NOW() " +
                         "WHERE id = ? AND user_id = ? AND status IN ('PENDING', 'CONFIRMED')";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, date);
            ps.setString(2, time);
            ps.setInt(3, duration);
            ps.setDouble(4, totalPrice);
            ps.setString(5, notes);
            ps.setInt(6, bookingId);
            ps.setString(7, userId);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                response.sendRedirect("bookingDetails.jsp?id=" + bookingId + "&success=Booking updated successfully");
            } else {
                response.sendRedirect("editBooking.jsp?id=" + bookingId + "&error=Unable to update booking");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("editBooking.jsp?id=" + bookingId + "&error=Database error");
        }
    }
}