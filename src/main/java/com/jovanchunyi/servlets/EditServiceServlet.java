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

@WebServlet("/EditServiceServlet")
public class EditServiceServlet extends HttpServlet {

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

        int serviceId = Integer.parseInt(request.getParameter("serviceId"));
        String name = request.getParameter("name");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        int hourlyRate = Integer.parseInt(request.getParameter("hourlyRate"));
        String description = request.getParameter("description");
        String imageUrl = request.getParameter("imageUrl");
        String[] qualifications = request.getParameterValues("qualifications");

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // 1. Update service
            String sql = "UPDATE service SET name = ?, category_id = ?, hourly_rate = ?, description = ?, image_url = ? WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setInt(2, categoryId);
            ps.setInt(3, hourlyRate);
            ps.setString(4, description);
            ps.setString(5, imageUrl != null && !imageUrl.isEmpty() ? imageUrl : null);
            ps.setInt(6, serviceId);
            ps.executeUpdate();
            ps.close();

            // 2. Delete existing qualifications
            ps = conn.prepareStatement("DELETE FROM service_caregiver_qualification WHERE service_id = ?");
            ps.setInt(1, serviceId);
            ps.executeUpdate();
            ps.close();

            // 3. Insert new qualifications
            if (qualifications != null && qualifications.length > 0) {
                String qualSql = "INSERT INTO service_caregiver_qualification (caregiver_qualification_id, service_id) VALUES (?, ?)";
                ps = conn.prepareStatement(qualSql);
                
                for (String qualId : qualifications) {
                    ps.setInt(1, Integer.parseInt(qualId));
                    ps.setInt(2, serviceId);
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            conn.commit(); // Commit transaction
            response.sendRedirect("admin.jsp?success=Service updated successfully");

        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            response.sendRedirect("editService.jsp?id=" + serviceId + "&error=Database error");
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}