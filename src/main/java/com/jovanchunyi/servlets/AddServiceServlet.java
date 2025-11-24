package com.jovanchunyi.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.jovanchunyi.util.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AddServiceServlet")
public class AddServiceServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (role == null || !role.equals("ADMIN")) {
            response.sendRedirect("login.jsp?error=Access denied");
            return;
        }

        String name = request.getParameter("name");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        int hourlyRate = Integer.parseInt(request.getParameter("hourlyRate"));
        String description = request.getParameter("description");
        String imageUrl = request.getParameter("imageUrl");
        String[] qualifications = request.getParameterValues("qualifications");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // 1. Insert service
            String sql = "INSERT INTO service (name, category_id, hourly_rate, description, image_url) VALUES (?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, name);
            ps.setInt(2, categoryId);
            ps.setInt(3, hourlyRate);
            ps.setString(4, description);
            ps.setString(5, imageUrl != null && !imageUrl.isEmpty() ? imageUrl : null);
            ps.executeUpdate();

            // Get the generated service ID
            rs = ps.getGeneratedKeys();
            int serviceId = 0;
            if (rs.next()) {
                serviceId = rs.getInt(1);
            }
            rs.close();
            ps.close();

            // 2. Insert qualifications
            if (qualifications != null && qualifications.length > 0 && serviceId > 0) {
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
            response.sendRedirect("admin.jsp?success=Service added successfully");

        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            response.sendRedirect("addService.jsp?error=Database error: " + e.getMessage());
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