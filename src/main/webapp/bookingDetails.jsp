<!-- Author: Jovan Yap Keat An -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Timestamp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking Details</title>
    <%@ include file="designScripts.jsp" %>
    <style>
        .status-badge { padding: 0.35rem 0.85rem; border-radius: 50px; font-size: 0.875rem; font-weight: 500; }
        .status-pending { background-color: #fff3cd; color: #856404; }
        .status-confirmed { background-color: #d4edda; color: #155724; }
        .status-completed { background-color: #cce5ff; color: #004085; }
        .status-cancelled { background-color: #f8d7da; color: #721c24; }
        .detail-label { font-size: 0.85rem; color: #6c757d; margin-bottom: 0.25rem; }
        .detail-value { font-weight: 500; }
    </style>
</head>
<%
    String bookingIdParam = (String) request.getAttribute("bookingId");
    String serviceName = (String) request.getAttribute("serviceName");
    String categoryName = (String) request.getAttribute("categoryName");
    String hourlyRateStr = (String) request.getAttribute("hourlyRate");
    String durationStr = (String) request.getAttribute("durationHours");
    String totalPriceStr = (String) request.getAttribute("totalPrice");
    Timestamp bookingTimestamp = (Timestamp) request.getAttribute("checkInTime");
    String status = (String) request.getAttribute("status");
    String notes = (String) request.getAttribute("notes");
    int duration = 0;
    double hourlyRate = 0.0;
    double totalPrice = 0.0;
    try {
        if (durationStr != null) duration = Integer.parseInt(durationStr);
        if (hourlyRateStr != null) hourlyRate = Double.parseDouble(hourlyRateStr);
        if (totalPriceStr != null) totalPrice = Double.parseDouble(totalPriceStr);
    } catch (Exception ignored) {}
    String statusClass = status != null ? status.toLowerCase() : "pending";
%>
<body>
<%@ include file="header.jsp" %>
<main>
    <section class="bg-light py-3 border-bottom">
        <div class="container">
            <a href="<%= request.getContextPath() %>/myBookings" class="btn btn-link text-decoration-none p-0 text-dark">
                &larr; Back to My Bookings
            </a>
        </div>
    </section>

    <section class="py-5">
        <div class="container">
            <div class="row g-4">
                <!-- Left Column - Booking Details -->
                <div class="col-lg-8">
                    <div class="d-flex justify-content-between align-items-start mb-4">
                        <div>
                            <span class="badge bg-primary mb-2"><%= categoryName %></span>
                            <h1 class="h3 mb-2"><%= serviceName %></h1>
                            <span class="text-muted">Booking #<%= bookingIdParam %></span>
                        </div>
                        <span class="status-badge status-<%= statusClass %>"><%= status %></span>
                    </div>

                    <!-- Schedule Card -->
                    <div class="card border mb-4">
                        <div class="card-header bg-white">
                            <h5 class="mb-0 h6">Schedule Details</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-4">
                                    <p class="detail-label">Check-In Time</p>
                                    <p class="detail-value mb-0"><%= bookingTimestamp %></p>
                                </div>
                                <div class="col-md-4">
                                    <p class="detail-label">Duration</p>
                                    <p class="detail-value mb-0"><%= duration %> hour<%= duration>1?"s":"" %></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Notes Card -->
                    <div class="card border">
                        <div class="card-header bg-white">
                            <h5 class="mb-0 h6">Special Requests</h5>
                        </div>
                        <div class="card-body">
                            <p class="text-secondary mb-0"><%= (notes != null && !notes.isEmpty()) ? notes : "No special requests" %></p>
                        </div>
                    </div>
                </div>

                <!-- Right Column - Price Summary -->
                <div class="col-lg-4">
                    <div class="card border">
                        <div class="card-header bg-white">
                            <h5 class="mb-0 h6">Price Summary</h5>
                        </div>
                        <div class="card-body">
                            <div class="d-flex justify-content-between mb-2">
                                <span class="text-muted">Hourly Rate</span>
                                <span>$<%= String.format("%.2f", hourlyRate) %></span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span class="text-muted">Duration</span>
                                <span><%= duration %> hour<%= duration>1?"s":"" %></span>
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between">
                                <span class="fw-semibold">Total</span>
                                <span class="fw-bold text-success fs-5">$<%= String.format("%.2f", totalPrice) %></span>
                            </div>
                        </div>

                        <!-- Actions -->
                        <div class="card-body d-grid gap-2">
                            <% if (statusClass.equals("pending")) { %>
                            <a href="<%= request.getContextPath() %>/booking/edit?id=<%= bookingIdParam %>" class="btn btn-outline-primary">Edit Booking</a>
                            <form method="post" action="<%= request.getContextPath() %>/booking/details?id=<%= bookingIdParam %>">
                                <button type="submit" class="btn btn-outline-danger w-100">Remove from Cart</button>
                            </form>
                            <% } %>
                            <a href="<%= request.getContextPath() %>/myBookings" class="btn btn-secondary">Back to Bookings</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>

<%@ include file="footer.jsp" %>
</body>
</html>
