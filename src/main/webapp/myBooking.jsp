	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ page import="java.util.*" %>
	<!DOCTYPE html>
	<html lang="en">
		<head>
		    <meta charset="UTF-8">
		    <meta name="viewport" content="width=device-width, initial-scale=1.0">
		    <title>My Bookings</title>
		    <%@ include file="designScripts.jsp" %>
		</head>
		<body class="bg-light min-vh-100">
 			<%@ include file="header.jsp" %>
 
 			<main>
		        <div class="container py-4">
		            <div class="row align-items-center">
		                <div class="col">
		                    <h2 class="mb-0">My Bookings</h2>
		                    <p class="text-secondary mb-0">View and manage your service bookings</p>
		                </div>
		                <div class="col-auto">
		                    <button class="btn btn-primary" onclick="location.href='<%= request.getContextPath() %>/services?categoryName=all'">
		                        <i class="bi bi-plus-circle me-2"></i>New Booking
		                    </button>
		                </div>
		            </div>
		        </div>
     
		        <div class="container my-4">
		            <div class="row g-4">
		                <div class="col-lg-8">
		                	<!-- BOOKING CARDS -->
<%
    List<Map<String, Object>> bookings = (List<Map<String, Object>>) request.getAttribute("bookings");
    if (bookings == null) bookings = new ArrayList<>();
    boolean hasBookings = !bookings.isEmpty();
    for (Map<String, Object> row : bookings) {
        String bookingId = String.valueOf(row.get("id"));
        String serviceName = (String) row.get("serviceName");
        java.sql.Timestamp bookingTimestamp = (java.sql.Timestamp) row.get("bookingTimestamp");
        int duration = (Integer) row.get("duration");
        double totalPrice = (Double) row.get("totalPrice");
        String statusClass = (String) row.get("statusClass");
        String notes = (String) row.get("notes");
%>
		                    <div class="card shadow-sm mb-3 booking-card">
		                        <div class="card-body p-4">
		                            <div class="row">
		                            	<!-- Nested grid -->
		                                <div class="col-md-8">
		                                    <div class="d-flex justify-content-between align-items-start mb-3">
		                                        <div>
		                                            <h5 class="mb-1"><%= serviceName %></h5>
		                                            <span class="badge bg-warning text-dark"><%= statusClass %></span>
		                                        </div>
		                                        <span class="text-secondary">Booking #<%= bookingId %></span>
		                                    </div>
		                                    <div class="row mb-3">
		                                        <div class="col-md-4 mb-2">
		                                            <small class="text-secondary d-block">Check-In Time</small>
		                                            <span class="fw-semibold"><%= bookingTimestamp %></span>
		                                        </div>
		                                        <div class="col-md-4 mb-2">
		                                            <small class="text-secondary d-block">Duration</small>
		                                            <span class="fw-semibold"><%= duration %> hours</span>
		                                        </div>
		                                        <div class="col-md-4 mb-2">
		                                            <small class="text-secondary d-block">Price</small>
		                                            <span class="fw-semibold text-success">$<%= String.format("%.2f", totalPrice) %></span>
		                                        </div>
		                                    </div>
		                                    <div>
		                                        <small class="text-secondary d-block mb-1">Notes</small>
		                                        <p class="mb-0 text-secondary small fst-italic"><%= notes != null ? notes : "-" %></p>
		                                    </div>
		                                </div>
		                                <div class="col-md-4 border-start">
		                                    <div class="d-grid gap-2">
		                                        <button class="btn btn-outline-primary btn-sm" onclick="location.href='<%= request.getContextPath() %>/booking/details?id=<%= bookingId %>'">
		                                            <i class="bi bi-eye me-1"></i>View Details
		                                        </button>
		                                    </div>
		                                </div>
		                            </div>
		                        </div>
		                    </div>
<%
    }
    if (!hasBookings) {
%>
					        <div class="empty-state">
					            <i class="bi bi-calendar-x"></i>
					            <p>No bookings found. <a href="<%= request.getContextPath() %>/services">Book a service now</a></p>
					        </div>
<%
    }
%>
		                </div>
<%
					if (hasBookings) {
%>
		                <div class="col-lg-4">
		                    <div class="card shadow-sm sticky-top" style="top: 100px;">
		                        <div class="card-header bg-white border-bottom">
		                            <h5 class="mb-0">Order Summary</h5>
		                        </div>
		                        <div class="card-body">
		                            <div class="d-flex justify-content-between mb-2">
		                                <span class="text-secondary">Subtotal</span>
		                                <span class="fw-semibold" id="subtotal">$<%= String.format("%.2f", (Double) request.getAttribute("subtotal")) %></span>
		                            </div>
		                            <div class="d-flex justify-content-between mb-2">
		                                <span class="text-secondary">GST (9%)</span>
		                                <span class="fw-semibold" id="gst">$<%= String.format("%.2f", (Double) request.getAttribute("gst")) %></span>
		                            </div>
		                            <hr>
		                            <div class="d-flex justify-content-between mb-3">
		                                <span class="fw-bold">Total</span>
		                                <span class="fw-bold text-primary fs-4" id="total">$<%= String.format("%.2f", (Double) request.getAttribute("total")) %></span>
		                            </div>
		                            <div class="d-grid gap-2">
		                                <button class="btn btn-primary btn-lg" onclick="location.href = '<%= request.getContextPath() %>/checkout'">
		                                    <i class="bi bi-credit-card me-2"></i>Proceed to Checkout
		                                </button>
		                                <button class="btn btn-outline-secondary" onclick="location.href = '<%= request.getContextPath() %>/services?categoryName=all'">
		                                    <i class="bi bi-arrow-left me-2"></i>Continue Browsing
		                                </button>
		                            </div>
		                        </div>
		                    </div>
		                </div>
<%
					}
%>
		            </div>
		        </div>
 			</main>
 
		    <%@ include file="footer.jsp" %>

		</body>
	</html>
