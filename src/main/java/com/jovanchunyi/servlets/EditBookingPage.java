package com.jovanchunyi.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

import daos.BookingDAO;
import daos.ServiceDAO;
import entities.Booking;
import entities.Service;

/**
 * Servlet implementation class EditBookingPage
 */
@WebServlet("/booking/edit")
public class EditBookingPage extends HttpServlet {
	
	private final BookingDAO bookingDAO = new BookingDAO();
    private final ServiceDAO serviceDAO = new ServiceDAO();
	
	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession();
        entities.User currentUser = (entities.User) session.getAttribute("currentUser");

        if (currentUser == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Please login first");
            return;
        }

        try {
        	String bookingId = req.getParameter("id");
        	if (bookingId == null || !bookingId.matches("\\d+")) 
        		throw new Exception("Invalid booking ID.");
        	
        	String userId = String.valueOf(currentUser.getId());
        	Booking originalBooking = bookingDAO.findByIdAndUser(bookingId, userId);
        	if (originalBooking == null) 
        		throw new Exception("Booking not found.");
        	if (currentUser.getId() != originalBooking.getUserId()) 
        		throw new Exception("Access denied.");
        	if ("CANCELLED".equals(originalBooking.getStatus()) || 
        		"COMPLETED".equals(originalBooking.getStatus()) ||
        		"CONFIRMED".equals(originalBooking.getStatus())) {
        		throw new Exception("This booking cannot be edited");
        	}
        	
            Service service = serviceDAO.findById(String.valueOf(originalBooking.getServiceId()));
            double hourlyRate = 0.0;
            String serviceName = null;
            if (service != null) {
                hourlyRate = service.getHourlyRate();
                serviceName = service.getName();
            }
            
            Timestamp ts = originalBooking.getCheckInTime();
            LocalDateTime ldt = ts.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
            String dateStr = ldt.toLocalDate().format(DateTimeFormatter.ISO_LOCAL_DATE);
            String timeStr = ldt.toLocalTime().format(DateTimeFormatter.ofPattern("HH:mm"));
            
            req.setAttribute("bookingId", bookingId);
            req.setAttribute("serviceName", serviceName);
            req.setAttribute("hourlyRate", hourlyRate);
            req.setAttribute("checkInTime", ts);
            req.setAttribute("bookingDate", dateStr);
            req.setAttribute("bookingTime", timeStr);
            req.setAttribute("duration", originalBooking.getDurationHours());
            req.setAttribute("totalPrice", originalBooking.getTotalPrice());
            req.setAttribute("notes", originalBooking.getNotes());
            req.getRequestDispatcher("/editBooking.jsp").forward(req, res);

        } catch (Exception e) {
        	e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/myBookings?error=" + e.getMessage());
        }
	}

}
