package com.jovanchunyi.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
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

@WebServlet("/profile")
public class ProfilePage extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Please login to access this page");
            return;
        }

        String userId = String.valueOf(currentUser.getId());
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();

            ps = conn.prepareStatement("SELECT username, email, phone, created_at FROM user WHERE id = ?");
            ps.setString(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                req.setAttribute("username", rs.getString("username"));
                req.setAttribute("email", rs.getString("email"));
                req.setAttribute("phone", rs.getString("phone"));
                req.setAttribute("createdAt", rs.getString("created_at"));
            }
            rs.close(); ps.close();

            int totalBookings = 0;
            ps = conn.prepareStatement("SELECT COUNT(*) FROM booking WHERE user_id = ?");
            ps.setString(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) totalBookings = rs.getInt(1);
            rs.close(); ps.close();
            req.setAttribute("totalBookings", totalBookings);

            int upcomingCount = 0;
            ps = conn.prepareStatement("SELECT COUNT(*) FROM booking WHERE user_id = ? AND status IN ('PENDING','CONFIRMED')");
            ps.setString(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) upcomingCount = rs.getInt(1);
            rs.close(); ps.close();
            req.setAttribute("upcomingCount", upcomingCount);

            List<Map<String, Object>> upcomingBookings = new ArrayList<>();
            ps = conn.prepareStatement(
                "SELECT b.id, s.name AS service_name, b.check_in_time, b.duration_hours, b.status " +
                "FROM booking b JOIN service s ON b.service_id = s.id " +
                "WHERE b.user_id = ? AND b.status IN ('PENDING','CONFIRMED') " +
                "ORDER BY b.check_in_time ASC LIMIT 2"
            );
            ps.setString(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> b = new HashMap<>();
                Timestamp ts = rs.getTimestamp("check_in_time");
                b.put("id", rs.getInt("id"));
                b.put("service_name", rs.getString("service_name"));
                b.put("date", ts != null ? ts.toLocalDateTime().toLocalDate() : null);
                b.put("time", ts != null ? ts.toLocalDateTime().toLocalTime() : null);
                b.put("duration", rs.getInt("duration_hours"));
                b.put("status", rs.getString("status"));
                upcomingBookings.add(b);
            }
            rs.close(); ps.close();
            req.setAttribute("upcomingBookings", upcomingBookings);

            List<Map<String, Object>> recentActivities = new ArrayList<>();
            ps = conn.prepareStatement(
                "SELECT b.id, s.name AS service_name, b.status, b.updated_at " +
                "FROM booking b JOIN service s ON b.service_id = s.id " +
                "WHERE b.user_id = ? ORDER BY b.updated_at DESC LIMIT 5"
            );
            ps.setString(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> a = new HashMap<>();
                a.put("id", rs.getInt("id"));
                a.put("service_name", rs.getString("service_name"));
                a.put("status", rs.getString("status"));
                a.put("updated", rs.getTimestamp("updated_at"));
                recentActivities.add(a);
            }
            req.setAttribute("recentActivities", recentActivities);

            req.getRequestDispatcher("/profile.jsp").forward(req, res);

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/index.jsp?error=Database error");
            
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
