<!-- Author: Jovan Yap Keat An -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.jovanchunyi.util.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Bookings - Silver Care</title>
    <%@ include file="designScripts.jsp" %>
    <style>
        body { min-height: 100vh; background-color: #f8f9fa; }
        .booking-card { border-left: 4px solid #667eea; transition: all 0.3s ease; }
        .booking-card:hover { transform: translateX(5px); box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .status-badge { padding: 0.35rem 0.85rem; border-radius: 50px; font-size: 0.875rem; font-weight: 500; }
        .status-pending { background-color: #fff3cd; color: #856404; }
        .status-confirmed { background-color: #d4edda; color: #155724; }
        .status-completed { background-color: #cce5ff; color: #004085; }
        .status-cancelled { background-color: #f8d7da; color: #721c24; }
        .filter-btn { cursor: pointer; transition: all 0.3s ease; }
        .filter-btn.active { background-color: #667eea !important; color: white !important; }
        .empty-state { padding: 4rem 2rem; text-align: center; }
        .empty-state i { font-size: 4rem; color: #dee2e6; margin-bottom: 1rem; }
    </style>
</head>
<%
    if (session.getAttribute("userRole") == null) {
        response.sendRedirect("login.jsp?error=Please login to access this page");
        return;
    }

    // Fetch bookings for this user
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;   
%>
<body>
<main>
	<%@ include file="header.jsp" %>
    <div class="container py-4">
        <div class="row align-items-center">
            <div class="col">
                <h2 class="mb-0">My Bookings</h2>
                <p class="text-secondary mb-0">View and manage your service bookings</p>
            </div>
            <div class="col-auto">
                <button class="btn btn-primary" onclick="location.href='services.jsp'">
                    <i class="bi bi-plus-circle me-2"></i>New Booking
                </button>
            </div>
        </div>
    </div>

    <div class="container my-4">
        <!-- Filter Tabs -->
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <div class="btn-group w-100" role="group">
                    <button type="button" class="btn btn-outline-primary filter-btn active" onclick="filterBookings('all')">All Bookings</button>
                    <button type="button" class="btn btn-outline-primary filter-btn" onclick="filterBookings('upcoming')">Upcoming</button>
                    <button type="button" class="btn btn-outline-primary filter-btn" onclick="filterBookings('completed')">Completed</button>
                    <button type="button" class="btn btn-outline-primary filter-btn" onclick="filterBookings('cancelled')">Cancelled</button>
                </div>
            </div>
        </div>

        <!-- Booking Cards -->
        <%
			String fetchBookingsSql = "SELECT b.*, s.name AS service_name, s.hourly_rate "
			                + "FROM booking b "
			                + "JOIN service s ON b.service_id = s.id "
			                + "WHERE b.user_id = ? "
			                + "ORDER BY b.booking_date DESC, b.booking_time DESC";
			
			try {
				conn = DatabaseConnection.getConnection();
				ps = conn.prepareStatement(fetchBookingsSql);
				ps.setString(1, (String) session.getAttribute("userId"));
				rs = ps.executeQuery();
	            boolean hasBookings = false;
	            while (rs.next()) {
	                hasBookings = true;
	                String bookingId = rs.getString("id");
	                String serviceName = rs.getString("service_name");
	                Date bookingDate = rs.getDate("booking_date");
	                Time bookingTime = rs.getTime("booking_time");
	                String duration = rs.getString("duration_hours");
	                double totalPrice = rs.getDouble("total_price");
	                String status = rs.getString("status");
	                String notes = rs.getString("notes");
	                
	                // Determine if upcoming (today or later) or completed/cancelled
	                String statusClass = status.toLowerCase();
        %>
        <div class="card booking-card shadow-sm mb-3" data-status="<%= statusClass %>">
            <div class="card-body p-4">
                <div class="row">
                    <div class="col-md-8">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <div>
                                <h5 class="mb-1"><%= serviceName %></h5>
                                <span class="status-badge status-<%= statusClass %>"><%= status %></span>
                            </div>
                            <span class="text-secondary">Booking #<%= bookingId %></span>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-4 mb-2">
                                <small class="text-secondary d-block">Date</small>
                                <span class="fw-semibold"><%= bookingDate %></span>
                            </div>
                            <div class="col-md-4 mb-2">
                                <small class="text-secondary d-block">Time</small>
                                <span class="fw-semibold"><%= bookingTime %></span>
                            </div>
                            <div class="col-md-4 mb-2">
                                <small class="text-secondary d-block">Duration</small>
                                <span class="fw-semibold"><%= duration %> hours</span>
                            </div>
                        </div>
                        <div class="mb-3">
                            <small class="text-secondary d-block mb-1">Care Recipient</small>
                            <span><%= username %></span>
                        </div>
                        <div>
                            <small class="text-secondary d-block mb-1">Notes</small>
                            <p class="mb-0"><%= notes != null ? notes : "-" %></p>
                        </div>
                    </div>
                    <div class="col-md-4 border-start">
                        <div class="d-grid gap-2">
                            <button class="btn btn-outline-primary btn-sm" onclick="location.href='bookingDetails.jsp?id=<%= bookingId %>'">
                                <i class="bi bi-eye me-1"></i>View Details
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
			<% 
			    } 
	            if(!hasBookings) { 
	        %> 
			        <div class="empty-state">
			            <i class="bi bi-calendar-x"></i>
			            <p>No bookings found. <a href="services.jsp">Book a service now</a></p>
			        </div>
		<%
			    }
	            
		    } catch (Exception e) {
				e.printStackTrace();
				
		    } finally {
	           if(rs != null) rs.close();
	           if(ps != null) ps.close();
	           if(conn != null) conn.close();
		    } 
		%>
    </div>
</main>

<script>
    function filterBookings(filter) {
        document.querySelectorAll('.filter-btn').forEach(btn => btn.classList.remove('active'));
        event.target.classList.add('active');

        document.querySelectorAll('.booking-card').forEach(card => {
            let status = card.getAttribute('data-status');
            if(filter === 'all') {
                card.style.display = 'block';
            } else if(filter === 'upcoming') {
                card.style.display = (status === 'pending' || status === 'confirmed') ? 'block' : 'none';
            } else if(filter === 'completed') {
                card.style.display = (status === 'completed') ? 'block' : 'none';
            } else if(filter === 'cancelled') {
                card.style.display = (status === 'cancelled') ? 'block' : 'none';
            }
        });
    }
</script>
<%@ include file="footer.jsp" %>
</body>
</html>
