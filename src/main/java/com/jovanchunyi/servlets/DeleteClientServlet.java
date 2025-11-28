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

@WebServlet("/DeleteClientServlet")
public class DeleteClientServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");

        if (role == null || !"ADMIN".equals(role)) {
            response.sendRedirect("login.jsp?error=Access denied");
            return;
        }

        String clientId = request.getParameter("id");
        if (clientId == null || !clientId.matches("\\d+")) {
            response.sendRedirect("admin.jsp?error=Invalid client ID");
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Check if client has bookings
            PreparedStatement checkPs = conn.prepareStatement("SELECT COUNT(*) FROM booking WHERE user_id = ?");
            checkPs.setInt(1, Integer.parseInt(clientId));
            var rs = checkPs.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                response.sendRedirect("admin.jsp?error=Cannot delete client with existing bookings");
                return;
            }

            // Delete client
            String sql = "DELETE FROM user WHERE id = ? AND role = 'USER'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(clientId));

            int rows = ps.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("admin.jsp?success=Client deleted successfully");
            } else {
                response.sendRedirect("admin.jsp?error=Client not found");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("admin.jsp?error=Database error");
        }
    }
}