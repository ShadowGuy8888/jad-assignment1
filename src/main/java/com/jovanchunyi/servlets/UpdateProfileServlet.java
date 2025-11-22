package com.jovanchunyi.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;

import com.jovanchunyi.util.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
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
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String emergencyContact = request.getParameter("emergencyContact");
        String blkNo = request.getParameter("blkNo");
        String unitNo = request.getParameter("unitNo");

        // Validate required fields
        if (email == null || email.trim().isEmpty()) {
            response.sendRedirect("editProfile.jsp?error=Email is required");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DatabaseConnection.getConnection();

            // Update user profile
            String sql = "UPDATE user SET first_name = ?, last_name = ?, email = ?, " +
                        "phone = ?, address = ?, emergency_contact = ?, blk_no = ?, " +
                        "unit_no = ?, updated_at = ? WHERE id = ?";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, firstName);
            pstmt.setString(2, lastName);
            pstmt.setString(3, email);
            pstmt.setString(4, phone);
            pstmt.setString(5, address);
            pstmt.setString(6, emergencyContact);
            pstmt.setString(7, blkNo);
            pstmt.setString(8, unitNo);
            pstmt.setTimestamp(9, new Timestamp(System.currentTimeMillis()));
            pstmt.setString(10, userId);

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                // Update session attributes with new values
                session.setAttribute("firstName", firstName);
                session.setAttribute("lastName", lastName);
                session.setAttribute("email", email);
                session.setAttribute("phone", phone);
                session.setAttribute("address", address);
                session.setAttribute("emergencyContact", emergencyContact);
                session.setAttribute("blkNo", blkNo);
                session.setAttribute("unitNo", unitNo);

                response.sendRedirect("editProfile.jsp?success=Profile updated successfully!");
            } else {
                response.sendRedirect("editProfile.jsp?error=Failed to update profile. Please try again.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("editProfile.jsp?error=Database error: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}