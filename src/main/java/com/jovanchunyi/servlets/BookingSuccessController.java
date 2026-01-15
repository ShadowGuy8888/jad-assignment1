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

@WebServlet("/booking/success")
public class BookingSuccessController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Please login first");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();
            ps = conn.prepareStatement(
                "SELECT b.id, b.check_in_time, b.duration_hours, b.total_price, s.name AS service_name " +
                "FROM booking b JOIN service s ON b.service_id = s.id " +
                "WHERE b.user_id = ? ORDER BY b.id DESC LIMIT 1"
            );
            ps.setString(1, String.valueOf(currentUser.getId()));
            rs = ps.executeQuery();

            if (rs.next()) {
                req.setAttribute("bookingId", rs.getString("id"));
                req.setAttribute("bookingTimestamp", rs.getTimestamp("check_in_time"));
                req.setAttribute("duration", rs.getInt("duration_hours"));
                req.setAttribute("totalPrice", rs.getDouble("total_price"));
                req.setAttribute("serviceName", rs.getString("service_name"));
            }

            req.getRequestDispatcher("/bookingSuccess.jsp").forward(req, res);

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/myBookings?error=Database error");
            
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
