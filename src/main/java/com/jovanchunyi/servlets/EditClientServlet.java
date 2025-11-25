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

@WebServlet("/EditClientServlet")
public class EditClientServlet extends HttpServlet {

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

        int clientId = Integer.parseInt(request.getParameter("clientId"));
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql;
            PreparedStatement ps;

            // Check if password needs to be updated
            if (password != null && !password.trim().isEmpty()) {
                sql = "UPDATE user SET first_name = ?, last_name = ?, username = ?, email = ?, phone = ?, password = ? WHERE id = ? AND role = 'USER'";
                ps = conn.prepareStatement(sql);
                ps.setString(1, firstName);
                ps.setString(2, lastName);
                ps.setString(3, username);
                ps.setString(4, email);
                ps.setString(5, phone);
                ps.setString(6, password); // In production, hash this password!
                ps.setInt(7, clientId);
            } else {
                sql = "UPDATE user SET first_name = ?, last_name = ?, username = ?, email = ?, phone = ? WHERE id = ? AND role = 'USER'";
                ps = conn.prepareStatement(sql);
                ps.setString(1, firstName);
                ps.setString(2, lastName);
                ps.setString(3, username);
                ps.setString(4, email);
                ps.setString(5, phone);
                ps.setInt(6, clientId);
            }

            ps.executeUpdate();
            response.sendRedirect("admin.jsp?success=Client updated successfully");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("editClient.jsp?id=" + clientId + "&error=Database error");
        }
    }
}