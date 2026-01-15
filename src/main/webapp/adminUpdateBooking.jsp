<!-- Author: Lau Chun Yi -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Timestamp" %>
<%
    String bookingId = (String) request.getAttribute("bookingId");
    String username = (String) request.getAttribute("username");
    String serviceName = (String) request.getAttribute("serviceName");
    Timestamp bookingTimestamp = (Timestamp) request.getAttribute("bookingTimestamp");
    Integer duration = (Integer) request.getAttribute("duration");
    Double totalPrice = (Double) request.getAttribute("totalPrice");
    String status = (String) request.getAttribute("status");
    String notes = (String) request.getAttribute("notes");

    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Booking - Admin</title>
    <%@ include file="designScripts.jsp" %>
</head>
<body class="bg-light">
    <nav class="navbar bg-white border-bottom">
        <div class="container">
            <a class="navbar-brand fw-bold" href="<%= request.getContextPath() %>/admin/dashboard"><i class="bi bi-arrow-left me-2"></i>Back to Dashboard</a>
        </div>
    </nav>

    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-6">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h5 class="mb-0"><i class="bi bi-calendar-check text-warning me-2"></i>Update Booking #<%= bookingId %></h5>
                    </div>
                    <div class="card-body p-4">
                        <% if (error != null) { %>
                        <div class="alert alert-danger"><%= error %></div>
                        <% } %>

                        <!-- Booking Info (Read Only) -->
                        <div class="bg-light rounded p-3 mb-4">
                            <div class="row">
                                <div class="col-6 mb-2"><small class="text-muted d-block">Client</small><span class="fw-semibold"><%= username %></span></div>
                                <div class="col-6 mb-2"><small class="text-muted d-block">Service</small><span class="fw-semibold"><%= serviceName %></span></div>
                                <div class="col-6 mb-2"><small class="text-muted d-block">Check-In Time</small><span><%= bookingTimestamp %></span></div>
                                <div class="col-6"><small class="text-muted d-block">Duration</small><span><%= duration %> hours</span></div>
                                <div class="col-6"><small class="text-muted d-block">Total</small><span class="text-success fw-bold">$<%= String.format("%.2f", totalPrice) %></span></div>
                            </div>
                        </div>

                        <form action="<%= request.getContextPath() %>/admin/booking/edit" method="post">
                            <input type="hidden" name="bookingId" value="<%= bookingId %>">

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Status *</label>
                                <select class="form-select" name="status" required>
                                    <option value="PENDING" <%= "PENDING".equals(status) ? "selected" : "" %>>Pending</option>
                                    <option value="CONFIRMED" <%= "CONFIRMED".equals(status) ? "selected" : "" %>>Confirmed</option>
                                    <option value="COMPLETED" <%= "COMPLETED".equals(status) ? "selected" : "" %>>Completed</option>
                                    <option value="CANCELLED" <%= "CANCELLED".equals(status) ? "selected" : "" %>>Cancelled</option>
                                </select>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold">Admin Notes</label>
                                <textarea class="form-control" name="notes" rows="3"><%= notes != null ? notes : "" %></textarea>
                            </div>

                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary"><i class="bi bi-check-circle me-1"></i>Update Booking</button>
                                <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn btn-outline-secondary">Cancel</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        // Accessed via /admin/booking/update servlet
    </script>
</body>
</html>
