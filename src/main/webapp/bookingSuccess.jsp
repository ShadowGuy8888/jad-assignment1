<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.jovanchunyi.util.DatabaseConnection" %>
<%
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp?error=Please login first");
        return;
    }

    // Get the latest booking for this user
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
    String serviceName = "";
    String bookingDate = "";
    String bookingTime = "";
    int duration = 0;
    double totalPrice = 0;
    int bookingId = 0;

    try {
        conn = DatabaseConnection.getConnection();
        ps = conn.prepareStatement(
            "SELECT b.id, b.booking_date, b.booking_time, b.duration_hours, b.total_price, s.name AS service_name " +
            "FROM booking b JOIN service s ON b.service_id = s.id " +
            "WHERE b.user_id = ? ORDER BY b.id DESC LIMIT 1"
        );
        ps.setString(1, userId);
        rs = ps.executeQuery();
        
        if (rs.next()) {
            bookingId = rs.getInt("id");
            serviceName = rs.getString("service_name");
            bookingDate = rs.getString("booking_date");
            bookingTime = rs.getString("booking_time");
            duration = rs.getInt("duration_hours");
            totalPrice = rs.getDouble("total_price");
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
    <title>Booking Confirmed</title>
    <%@ include file="designScripts.jsp" %>
</head>
<body>
    <%@ include file="header.jsp" %>

    <main class="py-5">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-6">
                    <!-- Success Card -->
                    <div class="card border-0 shadow-sm text-center">
                        <div class="card-body p-5">
                            <!-- Success Icon -->
                            <div class="mb-4">
                                <div class="d-inline-flex align-items-center justify-content-center bg-success bg-opacity-10 rounded-circle" style="width: 80px; height: 80px;">
                                    <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#198754" stroke-width="2">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <path d="m9 12 2 2 4-4"></path>
                                    </svg>
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
                                    <span class="text-muted">Date:</span>
                                    <span class="fw-semibold"><%= bookingDate %></span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Time:</span>
                                    <span class="fw-semibold"><%= bookingTime %></span>
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
                                <a href="myBooking.jsp" class="btn btn-primary">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="me-1">
                                        <rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect>
                                        <line x1="16" x2="16" y1="2" y2="6"></line>
                                        <line x1="8" x2="8" y1="2" y2="6"></line>
                                        <line x1="3" x2="21" y1="10" y2="10"></line>
                                    </svg>
                                    View My Bookings
                                </a>
                                <a href="services.jsp" class="btn btn-outline-secondary">
                                    Continue Browsing
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Info Note -->
                    <div class="alert alert-info d-flex align-items-start gap-2 mt-4" role="alert">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="flex-shrink-0" style="margin-top: 2px;">
                            <circle cx="12" cy="12" r="10"></circle>
                            <path d="M12 16v-4"></path>
                            <path d="M12 8h.01"></path>
                        </svg>
                        <small>A confirmation email has been sent to your registered email address. Please check your inbox for more details.</small>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="footer.jsp" %>
</body>
</html>