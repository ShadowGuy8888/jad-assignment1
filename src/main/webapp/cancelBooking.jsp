<!-- Author: Lau Chun Yi -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Timestamp" %>
<%
    String bookingIdParam = (String) request.getAttribute("bookingId");
    String serviceName = (String) request.getAttribute("serviceName");
    Timestamp bookingTimestamp = (Timestamp) request.getAttribute("bookingTimestamp");
    Integer duration = (Integer) request.getAttribute("duration");
    Double totalPrice = (Double) request.getAttribute("totalPrice");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cancel Booking - Silver Care</title>
    <%@ include file="designScripts.jsp" %>
</head>
<body>
<%@ include file="header.jsp" %>

<main>
    <section class="bg-light py-3 border-bottom">
        <div class="container">
            <a href="<%= request.getContextPath() %>/booking/details?id=<%= bookingIdParam %>" class="btn btn-link text-decoration-none p-0 text-dark">
                &larr; Back to Booking Details
            </a>
        </div>
    </section>

    <section class="py-5">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-6">
                    <div class="card border-0 shadow-sm">
                        <div class="card-body p-4 text-center">
                            <!-- Warning Icon -->
                            <div class="bg-danger bg-opacity-10 rounded-circle d-inline-flex align-items-center justify-content-center mb-4" style="width:80px;height:80px;">
                                <i class="bi bi-exclamation-triangle text-danger fs-1"></i>
                            </div>

                            <h3 class="mb-2">Cancel Booking?</h3>
                            <p class="text-muted mb-4">Are you sure you want to cancel this booking? This action cannot be undone.</p>

                            <!-- Booking Summary -->
                            <div class="bg-light rounded p-3 text-start mb-4">
                                <h6 class="text-muted small text-uppercase mb-3">Booking Summary</h6>
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Booking ID:</span>
                                    <span class="fw-semibold">#<%= bookingIdParam %></span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Service:</span>
                                    <span class="fw-semibold"><%= serviceName %></span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Check-In Time:</span>
                                    <span class="fw-semibold"><%= bookingTimestamp %></span>
                                </div>
                                <hr>
                                <div class="d-flex justify-content-between">
                                    <span class="fw-semibold">Total:</span>
                                    <span class="fw-bold text-danger fs-5">$<%= String.format("%.2f", totalPrice) %></span>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <form action="<%= request.getContextPath() %>/CancelBookingController" method="POST">
                                <input type="hidden" name="bookingId" value="<%= bookingIdParam %>">
                                <div class="d-flex gap-2 justify-content-center">
                                    <a href="<%= request.getContextPath() %>/booking/details?id=<%= bookingIdParam %>" class="btn btn-outline-secondary">Keep Booking</a>
                                    <button type="submit" class="btn btn-danger">
                                        <i class="bi bi-x-circle me-1"></i>Yes, Cancel Booking
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Info Note -->
                    <div class="alert alert-warning d-flex align-items-start gap-2 mt-4">
                        <i class="bi bi-info-circle flex-shrink-0 mt-1"></i>
                        <small>Cancellations made less than 24 hours before the scheduled time may be subject to a cancellation fee. Please review our cancellation policy for more details.</small>
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>

<%@ include file="footer.jsp" %>
</body>
</html>
