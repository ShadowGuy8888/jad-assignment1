package com.jovanchunyi.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;   // <-- add this import

import com.jovanchunyi.util.DatabaseConnection;

@WebServlet("/ChangePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Check if user is logged in
        if (session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp?error=Please login to access this page");
            return;
        }

        // Get form parameters
        String userId = request.getParameter("userId");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate inputs
        if (currentPassword == null || currentPassword.isEmpty() ||
            newPassword == null || newPassword.isEmpty() ||
            confirmPassword == null || confirmPassword.isEmpty()) {
            response.sendRedirect("editProfile.jsp?error=All password fields are required");
            return;
        }

        // Check if new passwords match
        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("editProfile.jsp?error=New passwords do not match");
            return;
        }

        // Check minimum password length
        if (newPassword.length() < 8) {
            response.sendRedirect("editProfile.jsp?error=Password must be at least 8 characters long");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();

            // First, verify current password
            String verifySql = "SELECT password FROM user WHERE id = ?";
            pstmt = conn.prepareStatement(verifySql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");

                // Correct comparison for hashed passwords
                if (!BCrypt.checkpw(currentPassword, storedPassword)) {
                    response.sendRedirect("editProfile.jsp?error=Current password is incorrect");
                    return;
                }
            } else {
                response.sendRedirect("editProfile.jsp?error=User not found");
                return;
            }

            // Close previous statement
            pstmt.close();

            // Hash new password
            String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

            // Update password
            String updateSql = "UPDATE user SET password = ?, updated_at = ? WHERE id = ?";
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setString(1, hashedNewPassword); 
            pstmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            pstmt.setString(3, userId);

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                response.sendRedirect("editProfile.jsp?success=Password changed successfully!");
            } else {
                response.sendRedirect("editProfile.jsp?error=Failed to change password. Please try again.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("editProfile.jsp?error=Database error: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
