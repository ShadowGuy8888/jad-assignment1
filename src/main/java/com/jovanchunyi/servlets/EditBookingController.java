// Author: Lau Chun Yi
package com.jovanchunyi.servlets;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

import daos.BookingDAO;
import entities.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/booking/update")
public class EditBookingController extends HttpServlet {

	private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Please login first");
            return;
        }

        try {
        	// hidden input field
        	String bookingId = req.getParameter("bookingId");
        	
        	// user edit input fields
        	int duration = (int) Double.parseDouble(req.getParameter("duration"));
        	LocalDate date = LocalDate.parse(req.getParameter("date"));
        	LocalTime time = LocalTime.parse(req.getParameter("time"));
        	String notes = req.getParameter("notes");
        	
        	LocalDateTime checkInTime = LocalDateTime.of(date, time);

        	String serviceId = bookingDAO.getServiceIdByBookingId(bookingId);
        	if (serviceId == null) throw new Exception("Service not found for booking");
        	
        	double hourlyRate = bookingDAO.getServicePrice(serviceId);
        	double totalPrice = hourlyRate * duration;
        	
        	Timestamp ts = Timestamp.valueOf(checkInTime);
        	String userId = String.valueOf(currentUser.getId());
        	boolean updateSuccess = bookingDAO.updateBooking(ts, duration, totalPrice, notes, bookingId, userId);
        	if (updateSuccess) 
        		res.sendRedirect(req.getContextPath() + "/booking/details?id=" + bookingId + "&success=Booking updated successfully");
        	else
        		throw new Exception("Unable to update booking");

        } catch (SQLException e) {
        	e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/myBookings?error=Database error");
        } catch (Exception e) {
        	e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/myBookings?error=" + e.getMessage());
        }
    }
}
