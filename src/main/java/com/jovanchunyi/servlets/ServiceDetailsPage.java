package com.jovanchunyi.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.jovanchunyi.util.DatabaseConnection;

import entities.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/service/details")
public class ServiceDetailsPage extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
    	
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Please login to access this page");
            return;
        }

        String serviceId = req.getParameter("serviceId");
        if (serviceId == null || serviceId.trim().isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/services?error=Service ID not provided");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DatabaseConnection.getConnection();

            ps = conn.prepareStatement(
                "SELECT " +
                "    s.id, " +
                "    s.name AS service_name, " +
                "    s.description, " +
                "    s.hourly_rate, " +
                "    s.image_url, " +
                "    sc.name AS service_category_name " +
                "FROM service s " +
                "JOIN service_category sc ON s.category_id = sc.id " +
                "WHERE s.id = ? AND s.deleted_at IS NULL"
            );
            ps.setString(1, serviceId);
            rs = ps.executeQuery();
            if (!rs.next()) {
                res.sendRedirect(req.getContextPath() + "/services?error=Service not found");
                return;
            }

            req.setAttribute("serviceId", rs.getString("id"));
            req.setAttribute("serviceName", rs.getString("service_name"));
            req.setAttribute("description", rs.getString("description"));
            req.setAttribute("hourlyRate", rs.getDouble("hourly_rate"));
            req.setAttribute("imageUrl", rs.getString("image_url"));
            req.setAttribute("categoryName", rs.getString("service_category_name"));

            if (ps != null) ps.close();
            if (rs != null) rs.close();

            ps = conn.prepareStatement(
                "SELECT cq.name " +
                "FROM service_caregiver_qualification scq " +
                "JOIN caregiver_qualification cq ON scq.caregiver_qualification_id = cq.qualification_id " +
                "WHERE scq.service_id = ?"
            );
            ps.setString(1, serviceId);
            rs = ps.executeQuery();
            List<String> qualifications = new ArrayList<>();
            while (rs.next()) {
                qualifications.add(rs.getString("name"));
            }
            req.setAttribute("qualifications", qualifications);

            req.getRequestDispatcher("/serviceDetails.jsp").forward(req, res);

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/services?error=Database error");
            
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
