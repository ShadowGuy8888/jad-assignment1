<!-- Author: Lau Chun Yi -->
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

    String serviceName = "", status = "", notes = "";
    int serviceId = 0, duration = 0;
    double hourlyRate = 0, totalPrice = 0;
    Date bookingDate = null;
    Time bookingTime = null;

    try {
        conn = DatabaseConnection.getConnection();
        ps = conn.prepareStatement(
            "SELECT b.*, s.name AS service_name, s.hourly_rate FROM booking b " +
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

        serviceId = rs.getInt("service_id");
        serviceName = rs.getString("service_name");
        hourlyRate = rs.getDouble("hourly_rate");
        status = rs.getString("status");
        bookingDate = rs.getDate("booking_date");
        bookingTime = rs.getTime("booking_time");
        duration = rs.getInt("duration_hours");
        totalPrice = rs.getDouble("total_price");
        notes = rs.getString("notes");

        // Check if can be edited
        if ("CANCELLED".equalsIgnoreCase(status) || "COMPLETED".equalsIgnoreCase(status) || "CONFIRMED".equalsIgnoreCase(status)) {
            response.sendRedirect("myBooking.jsp?error=This booking cannot be edited");
            return;
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }

    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Booking - Silver Care</title>
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
            <div class="row g-4">
                <!-- Left Column - Edit Form -->
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm">
                        <div class="card-header bg-white py-3">
                            <h4 class="mb-0 h5">Edit Booking #<%= bookingId %></h4>
                        </div>
                        <div class="card-body p-4">
                            <% if (error != null) { %>
                            <div class="alert alert-danger"><%= error %></div>
                            <% } %>

                            <form action="EditBookingServlet" method="post">
                                <input type="hidden" name="bookingId" value="<%= bookingId %>">
                                <input type="hidden" name="serviceId" value="<%= serviceId %>">
                                <input type="hidden" name="hourlyRate" value="<%= hourlyRate %>">

                                <!-- Service Info (Read Only) -->
                                <div class="mb-4">
                                    <label class="form-label fw-semibold small">Service</label>
                                    <input type="text" class="form-control bg-light" value="<%= serviceName %>" readonly>
                                    <small class="text-muted">Service cannot be changed. Please cancel and create a new booking to change service.</small>
                                </div>

                                <!-- Duration -->
                                <div class="mb-3">
                                    <label class="form-label fw-semibold small">Number of Hours *</label>
                                    <input type="number" class="form-control" name="duration" id="duration" min="1" value="<%= duration %>" required>
                                </div>

                                <!-- Date -->
                                <div class="mb-3">
                                    <label class="form-label fw-semibold small">Preferred Date *</label>
                                    <input type="date" class="form-control" name="date" id="date" value="<%= bookingDate %>" required>
                                </div>

                                <!-- Time -->
                                <div class="mb-3">
                                    <label class="form-label fw-semibold small">Preferred Time *</label>
                                    <input type="time" class="form-control" name="time" id="time" value="<%= bookingTime %>" required>
                                </div>

                                <!-- Notes -->
                                <div class="mb-4">
                                    <label class="form-label fw-semibold small">Special Requests (Optional)</label>
                                    <textarea class="form-control" name="notes" rows="4"><%= notes != null ? notes : "" %></textarea>
                                </div>

                                <!-- Buttons -->
                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-check-circle me-1"></i>Save Changes
                                    </button>
                                    <a href="bookingDetails.jsp?id=<%= bookingId %>" class="btn btn-outline-secondary">Cancel</a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Right Column - Price Summary -->
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm sticky-top" style="top:100px;">
                        <div class="card-header bg-white py-3">
                            <h5 class="mb-0 h6">Price Summary</h5>
                        </div>
                        <div class="card-body">
                            <div class="d-flex justify-content-between mb-2">
                                <span class="text-muted">Hourly Rate</span>
                                <span>$<%= String.format("%.2f", hourlyRate) %></span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span class="text-muted">Duration</span>
                                <span id="durationDisplay"><%= duration %> hour<%= duration > 1 ? "s" : "" %></span>
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between">
                                <span class="fw-semibold">Total</span>
                                <span class="fw-bold text-success fs-5" id="priceDisplay">$<%= String.format("%.2f", totalPrice) %></span>
                            </div>
                        </div>
                    </div>

                    <!-- Status Badge -->
                    <div class="card border-0 shadow-sm mt-3">
                        <div class="card-body">
                            <small class="text-muted d-block mb-1">Current Status</small>
                            <span class="badge <%= "CONFIRMED".equalsIgnoreCase(status) ? "bg-success" : "bg-warning text-dark" %> fs-6"><%= status %></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>

<%@ include file="footer.jsp" %>

<script>
    const hourlyRate = <%= hourlyRate %>;

    function updatePrice() {
        const hours = parseInt(document.getElementById("duration").value) || 1;
        const total = hours * hourlyRate;
        document.getElementById("priceDisplay").innerText = "$" + total.toFixed(2);
        document.getElementById("durationDisplay").innerText = hours + " hour" + (hours > 1 ? "s" : "");
    }

    document.getElementById("duration").addEventListener("input", updatePrice);
</script>
</body>
</html>