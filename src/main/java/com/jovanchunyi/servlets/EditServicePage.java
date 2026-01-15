package com.jovanchunyi.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.jovanchunyi.util.DatabaseConnection;

import entities.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/service/edit")
public class EditServicePage extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Access denied");
            return;
        }

        String serviceId = req.getParameter("id");
        if (serviceId == null || !serviceId.matches("\\d+")) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?error=Invalid service ID");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();

            ps = conn.prepareStatement("SELECT * FROM service WHERE id = ?");
            ps.setString(1, serviceId);
            rs = ps.executeQuery();
            if (!rs.next()) {
                res.sendRedirect(req.getContextPath() + "/admin/dashboard?error=Service not found");
                return;
            }

            req.setAttribute("serviceId", rs.getString("id"));
            req.setAttribute("name", rs.getString("name"));
            req.setAttribute("description", rs.getString("description"));
            req.setAttribute("categoryId", rs.getInt("category_id"));
            req.setAttribute("hourlyRate", rs.getInt("hourly_rate"));
            req.setAttribute("imageUrl", rs.getString("image_url"));
            rs.close(); ps.close();

            List<Map<String, Object>> categories = new ArrayList<>();
            ps = conn.prepareStatement("SELECT id, name FROM service_category ORDER BY name");
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("id", rs.getInt("id"));
                row.put("name", rs.getString("name"));
                categories.add(row);
            }
            rs.close(); ps.close();

            List<Map<String, Object>> qualifications = new ArrayList<>();
            ps = conn.prepareStatement("SELECT qualification_id, name FROM caregiver_qualification ORDER BY name");
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("id", rs.getInt("qualification_id"));
                row.put("name", rs.getString("name"));
                qualifications.add(row);
            }
            rs.close(); ps.close();

            List<Integer> selectedQuals = new ArrayList<>();
            ps = conn.prepareStatement("SELECT caregiver_qualification_id FROM service_caregiver_qualification WHERE service_id = ?");
            ps.setString(1, serviceId);
            rs = ps.executeQuery();
            while (rs.next()) {
                selectedQuals.add(rs.getInt("caregiver_qualification_id"));
            }

            req.setAttribute("categories", categories);
            req.setAttribute("qualifications", qualifications);
            req.setAttribute("selectedQuals", selectedQuals);
            req.getRequestDispatcher("/editService.jsp").forward(req, res);

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
