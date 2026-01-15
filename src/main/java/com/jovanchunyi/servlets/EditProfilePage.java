package com.jovanchunyi.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.jovanchunyi.util.DatabaseConnection;

import entities.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/profile/edit")
public class EditProfilePage extends HttpServlet {

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
            ps = conn.prepareStatement("SELECT * FROM user WHERE id = ?");
            ps.setString(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                req.setAttribute("userId", userId);
                req.setAttribute("username", rs.getString("username"));
                req.setAttribute("email", rs.getString("email"));
                req.setAttribute("phone", rs.getString("phone"));
                req.setAttribute("createdAt", rs.getString("created_at"));
                req.setAttribute("firstName", rs.getString("first_name"));
                req.setAttribute("lastName", rs.getString("last_name"));
                req.setAttribute("address", rs.getString("address"));
                req.setAttribute("emergencyContact", rs.getString("emergency_contact"));
                req.setAttribute("blkNo", rs.getString("blk_no"));
                req.setAttribute("unitNo", rs.getString("unit_no"));
            }
            req.getRequestDispatcher("/editProfile.jsp").forward(req, res);

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/profile/edit?error=Database error");
            
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
