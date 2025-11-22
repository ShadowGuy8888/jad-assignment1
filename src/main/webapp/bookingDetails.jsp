<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.jovanchunyi.util.DatabaseConnection" %>
<%
    // Access control
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp?error=Please login first");
        return;
    }

    String bookingIdParam = request.getParameter("id");
    if (bookingIdParam == null || !bookingIdParam.matches("\\d+")) {
        response.sendRedirect("myBookings.jsp?error=Invalid booking ID");
        return;
    }
    int bookingId = Integer.parseInt(bookingIdParam);

    // DB variables
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String serviceName = "", status = "", notes = "", categoryName = "";
    int duration = 0;
    double totalPrice = 0, hourlyRate = 0;
    Date bookingDate = null;
    Time bookingTime = null;

    try {
        conn = DatabaseConnection.getConnection();
        String sql = "SELECT b.*, s.name AS service_name, s.hourly_rate, c.name AS category_name " +
                     "FROM booking b " +
                     "JOIN service s ON b.service_id = s.id " +
                     "JOIN service_category c ON s.category_id = c.id " +
                     "WHERE b.id = ? AND b.user_id = ?";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, bookingId);
        ps.setString(2, userId);
        rs = ps.executeQuery();

        if (!rs.next()) {
            response.sendRedirect("myBookings.jsp?error=Booking not found");
            return;
        }

        serviceName = rs.getString("service_name");
        categoryName = rs.getString("category_name");
        hourlyRate = rs.getDouble("hourly_rate");
        duration = rs.getInt("duration_hours");
        totalPrice = rs.getDouble("total_price");
        bookingDate = rs.getDate("booking_date");
        bookingTime = rs.getTime("booking_time");
        status = rs.getString("status");
        notes = rs.getString("notes");
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if(rs != null) rs.close();
        if(ps != null) ps.close();
        if(conn != null) conn.close();
    }

    String statusClass = status != null ? status.toLowerCase() : "pending";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking Details - Silver Care</title>
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
<body>
<%@ include file="header.jsp" %>

<main>
    <section class="bg-light py-3 border-bottom">
        <div class="container">
            <a href="myBooking.jsp" class="btn btn-link text-decoration-none p-0 text-dark">
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
                            <span class="text-muted">Booking #<%= bookingId %></span>
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
                                    <p class="detail-label">Date</p>
                                    <p class="detail-value mb-0"><%= bookingDate %></p>
                                </div>
                                <div class="col-md-4">
                                    <p class="detail-label">Time</p>
                                    <p class="detail-value mb-0"><%= bookingTime %></p>
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
                            <% if (statusClass.equals("pending") || statusClass.equals("confirmed")) { %>
                            <a href="editBooking.jsp?id=<%= bookingId %>" class="btn btn-outline-primary">Edit Booking</a>
                            <a href="cancelBooking.jsp?id=<%= bookingId %>" class="btn btn-outline-danger">Cancel Booking</a>
                            <% } %>
                            <a href="myBooking.jsp" class="btn btn-secondary">Back to Bookings</a>
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
