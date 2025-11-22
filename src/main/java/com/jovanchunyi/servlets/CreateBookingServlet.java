package com.jovanchunyi.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.jovanchunyi.util.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/CreateBookingServlet")
public class CreateBookingServlet extends HttpServlet {
	
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

        String serviceId = request.getParameter("service_id");
        String hours = request.getParameter("duration");
        String date = request.getParameter("date");
        String time = request.getParameter("time");
        String notes = request.getParameter("requests");
        double pricePerHour = getServicePrice(serviceId);
        double total = Integer.parseInt(hours) * pricePerHour;

        try (Connection conn = DatabaseConnection.getConnection()) {

            String sql = "INSERT INTO booking (user_id, service_id, booking_date, booking_time, duration_hours, total_price, notes) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, userId);
            ps.setString(2, serviceId);
            ps.setString(3, date);
            ps.setString(4, time);
            ps.setString(5, hours);
            ps.setDouble(6, total);
            ps.setString(7, notes);

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("serviceDetails.jsp?error=Database error");
            return;
        }

        response.sendRedirect("bookingSuccess.jsp");
    }

    // --- NEW METHOD ---
    private double getServicePrice(String serviceId) {
        double price = 0.0;

        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT hourly_rate FROM service WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, serviceId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                price = rs.getDouble("hourly_rate");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return price;
    }
}
