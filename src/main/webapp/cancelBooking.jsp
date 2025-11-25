<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.jovanchunyi.util.DatabaseConnection" %>
<%
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp?error=Please login first");
        return;
    }

    String bookingIdParam = request.getParameter("id");
    if (bookingIdParam == null || !bookingIdParam.matches("\\d+")) {
        response.sendRedirect("myBooking.jsp?error=Invalid booking ID");
        return;
    }
    int bookingId = Integer.parseInt(bookingIdParam);

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String serviceName = "", status = "";
    Date bookingDate = null;
    Time bookingTime = null;
    int duration = 0;
    double totalPrice = 0;

    try {
        conn = DatabaseConnection.getConnection();
        ps = conn.prepareStatement(
            "SELECT b.*, s.name AS service_name FROM booking b " +
            "JOIN service s ON b.service_id = s.id " +
            "WHERE b.id = ? AND b.user_id = ?"
        );
        ps.setInt(1, bookingId);
        ps.setString(2, userId);
        rs = ps.executeQuery();

        if (!rs.next()) {
            response.sendRedirect("myBooking.jsp?error=Booking not found");
            return;
        }

        serviceName = rs.getString("service_name");
        status = rs.getString("status");
        bookingDate = rs.getDate("booking_date");
        bookingTime = rs.getTime("booking_time");
        duration = rs.getInt("duration_hours");
        totalPrice = rs.getDouble("total_price");

        // Check if already cancelled or completed
        if ("CANCELLED".equalsIgnoreCase(status) || "COMPLETED".equalsIgnoreCase(status)) {
            response.sendRedirect("myBookings.jsp?error=This booking cannot be cancelled");
            return;
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
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
            <a href="bookingDetails.jsp?id=<%= bookingId %>" class="btn btn-link text-decoration-none p-0 text-dark">
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
                                    <span class="fw-semibold">#<%= bookingId %></span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Service:</span>
                                    <span class="fw-semibold"><%= serviceName %></span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Date:</span>
                                    <span class="fw-semibold"><%= bookingDate %></span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Time:</span>
                                    <span class="fw-semibold"><%= bookingTime %></span>
                                </div>
                                <hr>
                                <div class="d-flex justify-content-between">
                                    <span class="fw-semibold">Total:</span>
                                    <span class="fw-bold text-danger fs-5">$<%= String.format("%.2f", totalPrice) %></span>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <form action="CancelBookingServlet" method="post">
                                <input type="hidden" name="bookingId" value="<%= bookingId %>">
                                <div class="d-flex gap-2 justify-content-center">
                                    <a href="bookingDetails.jsp?id=<%= bookingId %>" class="btn btn-outline-secondary">Keep Booking</a>
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