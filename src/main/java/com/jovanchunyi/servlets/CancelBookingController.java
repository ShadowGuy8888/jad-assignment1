// Author: Lau Chun Yi
package com.jovanchunyi.servlets;

import java.io.IOException;
import java.sql.SQLException;

import daos.BookingDAO;
import entities.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/CancelBookingController")
public class CancelBookingController extends HttpServlet {
    private BookingDAO bookingDAO;
    
    public CancelBookingController() {
        this.bookingDAO = new BookingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Please login first");
            return;
        }

        String bookingId = req.getParameter("bookingId");
        if (bookingId == null || !bookingId.matches("\\d+")) {
            res.sendRedirect(req.getContextPath() + "/myBookings?error=Invalid booking ID");
            return;
        }

        try {
            String userId = String.valueOf(currentUser.getId());
            boolean success = bookingDAO.cancelBooking(bookingId, userId);
            
            if (success) {
                res.sendRedirect(req.getContextPath() + "/myBookings?success=Booking cancelled successfully");
            } else {
                res.sendRedirect(req.getContextPath() + "/myBookings?error=Unable to cancel booking");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/myBookings?error=Database error");
            
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/myBookings?error=An error occurred while cancelling the booking");
        }
    }
}
