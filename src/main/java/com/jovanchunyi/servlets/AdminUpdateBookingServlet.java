// Author: Lau Chun Yi
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

@WebServlet("/AdminUpdateBookingServlet")
public class AdminUpdateBookingServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");

        if (role == null || !"ADMIN".equals(role)) {
            response.sendRedirect("login.jsp?error=Access denied");
            return;
        }

        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        String status = request.getParameter("status");
        String notes = request.getParameter("notes");

        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "UPDATE booking SET status = ?, notes = ?, updated_at = NOW() WHERE id = ?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, notes);
            ps.setInt(3, bookingId);

            ps.executeUpdate();
            response.sendRedirect("admin.jsp?success=Booking updated successfully");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("adminUpdateBooking.jsp?id=" + bookingId + "&error=Database error");
        }
    }
}