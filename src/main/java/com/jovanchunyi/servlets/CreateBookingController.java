package com.jovanchunyi.servlets;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

import daos.BookingDAO;
import entities.Booking;
import entities.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/booking/create")
public class CreateBookingController extends HttpServlet {

    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Please login first");
            return;
        }

        try {
            // Parse form input
            String userId = String.valueOf(currentUser.getId());
            String serviceId = (String) req.getParameter("serviceId");
            int duration = Integer.parseInt(req.getParameter("duration"));
            String notes = req.getParameter("notes");

            LocalDate datePart = LocalDate.parse(req.getParameter("date"));
            LocalTime timePart = LocalTime.parse(req.getParameter("time"));
            Timestamp checkInTime = Timestamp.valueOf(LocalDateTime.of(datePart, timePart));

            // Create Booking entity
            Booking booking = new Booking();
            booking.setUserId(currentUser.getId());
            booking.setServiceId(Integer.parseInt(serviceId));
            booking.setDurationHours(duration);
            booking.setCheckInTime(checkInTime);
            booking.setNotes(!"".equals(notes) ? notes : null);

            double hourlyRate = bookingDAO.getServicePrice(serviceId);
            booking.setTotalPrice(hourlyRate * duration);
            
            boolean created = bookingDAO.createBooking(booking);
            if (created) {
                res.sendRedirect(req.getContextPath() + "/booking/success");
            } else {
                res.sendRedirect(req.getContextPath() + "/service/details?serviceId=" + serviceId + "&error=Could not create booking");
            }

        } catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/service/details?serviceId=" + req.getParameter("serviceId") + "&error=Invalid form input");
            
        } catch (SQLException e) {
            res.sendRedirect(req.getContextPath() + "/service/details?serviceId=" + req.getParameter("serviceId") + "&error=Database error");
        }
    }
}
