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

@WebServlet("/DeleteServiceServlet")
public class DeleteServiceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");

        if (role == null || !"ADMIN".equals(role)) {
            response.sendRedirect("login.jsp?error=Access denied");
            return;
        }

        String serviceId = request.getParameter("id");
        if (serviceId == null || !serviceId.matches("\\d+")) {
            response.sendRedirect("admin.jsp?error=Invalid service ID");
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Check if service has bookings
            PreparedStatement checkPs = conn.prepareStatement("SELECT COUNT(*) FROM booking WHERE service_id = ?");
            checkPs.setInt(1, Integer.parseInt(serviceId));
            var rs = checkPs.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                response.sendRedirect("admin.jsp?error=Cannot delete service with existing bookings");
                return;
            }

            // Delete service
            String sql = "DELETE FROM service WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(serviceId));

            int rows = ps.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("admin.jsp?success=Service deleted successfully");
            } else {
                response.sendRedirect("admin.jsp?error=Service not found");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("admin.jsp?error=Database error");
        }
    }
}