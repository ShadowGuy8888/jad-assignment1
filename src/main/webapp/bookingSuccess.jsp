<!-- Author: Jovan Yap Keat An -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Timestamp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking Confirmed</title>
    <%@ include file="designScripts.jsp" %>
</head>
<%
    String bookingId = (String) request.getAttribute("bookingId");
    Timestamp bookingTimestamp = (Timestamp) request.getAttribute("bookingTimestamp");
    Integer duration = (Integer) request.getAttribute("duration");
    Double totalPrice = (Double) request.getAttribute("totalPrice");
    String serviceName = (String) request.getAttribute("serviceName");
    if (duration == null) duration = 0;
    if (totalPrice == null) totalPrice = 0.0;
%>
<body>
    <%@ include file="header.jsp" %>
    
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-6">
                    <!-- Success Card -->
                    <div class="card border-0 shadow-sm text-center">
                        <div class="card-body p-5">
                            <!-- Success Icon -->
                            <div class="mb-4">
                                <div class="d-inline-flex align-items-center justify-content-center bg-success bg-opacity-10 rounded-circle" style="width: 80px; height: 80px;">
                                    <i class="bi bi-check-circle text-success" style="font-size: 2em;"></i>
                                </div>
                            </div>

                            <h2 class="mb-2">Booking Confirmed!</h2>
                            <p class="text-muted mb-4">Your booking has been successfully submitted. We'll contact you shortly to confirm the details.</p>

                            <!-- Booking Details -->
                            <div class="bg-light rounded p-4 text-start mb-4">
                                <h6 class="text-muted small text-uppercase mb-3">Booking Details</h6>
                                
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Booking ID:</span>
                                    <span class="fw-semibold">#<%= bookingId %></span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Service:</span>
                                    <span class="fw-semibold"><%= serviceName %></span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Check-In Time:</span>
                                    <span class="fw-semibold"><%= bookingTimestamp %></span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Duration:</span>
                                    <span class="fw-semibold"><%= duration %> hour<%= duration > 1 ? "s" : "" %></span>
                                </div>
                                <hr>
                                <div class="d-flex justify-content-between">
                                    <span class="fw-semibold">Total:</span>
                                    <span class="fw-bold text-success fs-5">$<%= String.format("%.2f", totalPrice) %></span>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="d-flex gap-2 justify-content-center">
                                <a href="<%= request.getContextPath() %>/myBookings" class="btn btn-primary">
                                    <i class="bi bi-calendar4"></i>
                                    View My Bookings
                                </a>
                                <a href="<%= request.getContextPath() %>/services" class="btn btn-outline-secondary">
                                    Continue Browsing
                                </a>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

    <%@ include file="footer.jsp" %>
</body>
</html>
