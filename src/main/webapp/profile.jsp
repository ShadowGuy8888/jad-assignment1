<!-- Author: Lau Chun Yi -->
<%@ page import="java.util.*" %>
<%
    String username = (String) request.getAttribute("username");
    String email = (String) request.getAttribute("email");
    String phone = (String) request.getAttribute("phone");
    String createdAt = (String) request.getAttribute("createdAt");
    Integer totalBookings = (Integer) request.getAttribute("totalBookings");
    Integer upcomingCount = (Integer) request.getAttribute("upcomingCount");
    if (totalBookings == null) totalBookings = 0;
    if (upcomingCount == null) upcomingCount = 0;
    List<Map<String, Object>> upcomingBookings = (List<Map<String, Object>>) request.getAttribute("upcomingBookings");
    List<Map<String, Object>> recentActivities = (List<Map<String, Object>>) request.getAttribute("recentActivities");
    if (upcomingBookings == null) upcomingBookings = new ArrayList<>();
    if (recentActivities == null) recentActivities = new ArrayList<>();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Dashboard</title>
    <%@ include file="designScripts.jsp" %>
</head>
<body class="bg-light min-vh-100">
    <main>
        <%@ include file="header.jsp" %>
        
        <div class="container my-4">
            <div class="row g-4">
                <!-- Left Column -->
                <div class="col-lg-4">
                    <!-- Profile Card -->
                    <div class="card shadow-sm mb-4">
                        <div class="card-body text-center p-4">
                            <div class="bg-primary rounded-circle d-flex align-items-center justify-content-center mx-auto mb-3" style="width:80px;height:80px;">
                                <i class="bi bi-person-fill text-white fs-1"></i>
                            </div>
                            <h4 class="mb-1"><%= username %></h4>
                            <p class="text-secondary mb-3">Client Member</p>
                            
                            <div class="text-start mt-4">
                                <div class="mb-3">
                                    <small class="text-secondary d-block mb-1"><i class="bi bi-envelope me-2"></i>Email</small>
                                    <span><%= email != null ? email : "Not provided" %></span>
                                </div>
                                <div class="mb-3">
                                    <small class="text-secondary d-block mb-1"><i class="bi bi-telephone me-2"></i>Phone</small>
                                    <span><%= phone != null ? phone : "Not provided" %></span>
                                </div>
                                <div class="mb-3">
                                    <small class="text-secondary d-block mb-1"><i class="bi bi-calendar me-2"></i>Member Since</small>
                                    <span><%= createdAt != null ? createdAt : "N/A" %></span>
                                </div>
                            </div>
                            
                            <a href="<%= request.getContextPath() %>/profile/edit" class="btn btn-outline-primary w-100 mt-3">
                                <i class="bi bi-pencil me-2"></i>Edit Profile
                            </a>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="card shadow-sm">
                        <div class="card-header bg-white"><h5 class="mb-0">Quick Actions</h5></div>
                        <div class="card-body d-grid gap-2">
                            <a href="<%= request.getContextPath() %>/services" class="btn btn-primary"><i class="bi bi-calendar-plus me-2"></i>Book New Service</a>
                            <a href="<%= request.getContextPath() %>/myBookings" class="btn btn-outline-primary"><i class="bi bi-list-check me-2"></i>View All Bookings</a>
                            <a href="<%= request.getContextPath() %>/services" class="btn btn-outline-primary"><i class="bi bi-search me-2"></i>Browse Services</a>
                        </div>
                    </div>
                </div>

                <!-- Right Column -->
                <div class="col-lg-8">
                    <!-- Stats Cards -->
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <div class="card shadow-sm h-100">
                                <div class="card-body d-flex align-items-center">
                                    <div class="bg-primary bg-opacity-10 rounded p-3 me-3">
                                        <i class="bi bi-calendar-check text-primary fs-4"></i>
                                    </div>
                                    <div>
                                        <h3 class="mb-0"><%= totalBookings %></h3>
                                        <p class="text-secondary mb-0 small">Total Bookings</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card shadow-sm h-100">
                                <div class="card-body d-flex align-items-center">
                                    <div class="bg-success bg-opacity-10 rounded p-3 me-3">
                                        <i class="bi bi-clock-history text-success fs-4"></i>
                                    </div>
                                    <div>
                                        <h3 class="mb-0"><%= upcomingCount %></h3>
                                        <p class="text-secondary mb-0 small">Upcoming</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Upcoming Bookings -->
                    <div class="card shadow-sm mb-4">
                        <div class="card-header bg-white d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">Upcoming Bookings</h5>
                            <a href="<%= request.getContextPath() %>/myBookings" class="btn btn-sm btn-outline-primary">View All</a>
                        </div>
                        <div class="card-body">
                            <% if (upcomingBookings.isEmpty()) { %>
                                <p class="text-secondary mb-0">No upcoming bookings</p>
                            <% } else { for (Map<String, Object> b : upcomingBookings) {
                                String status = (String)b.get("status");
                                String badgeClass = "CONFIRMED".equals(status) ? "bg-success" : "bg-warning text-dark";
                            %>
                            <div class="bg-light p-3 rounded mb-3 border-start border-4 border-primary">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <div>
                                        <h6 class="mb-1"><%= b.get("service_name") %></h6>
                                        <span class="badge <%= badgeClass %>"><%= status %></span>
                                    </div>
                                    <small class="text-secondary">Booking #<%= b.get("id") %></small>
                                </div>
                                <div class="row mt-3">
                                    <div class="col-md-4"><small class="text-secondary d-block">Date</small><span><%= b.get("date") %></span></div>
                                    <div class="col-md-4"><small class="text-secondary d-block">Time</small><span><%= b.get("time") %></span></div>
                                    <div class="col-md-4"><small class="text-secondary d-block">Duration</small><span><%= b.get("duration") %> hours</span></div>
                                </div>
                                <a href="<%= request.getContextPath() %>/booking/details?id=<%= b.get("id") %>" class="btn btn-sm btn-primary mt-3"><i class="bi bi-eye me-1"></i>View Details</a>
                            </div>
                            <% } } %>
                        </div>
                    </div>

                    <!-- Recent Activity -->
                    <div class="card shadow-sm">
                        <div class="card-header bg-white"><h5 class="mb-0">Recent Activity</h5></div>
                        <div class="card-body">
                            <% if (recentActivities.isEmpty()) { %>
                                <p class="text-secondary mb-0">No recent updates</p>
                            <% } else { for (Map<String, Object> a : recentActivities) { %>
	                            <div class="bg-white p-3 rounded mb-2 border-start border-4 border-primary">
	                                <div class="d-flex justify-content-between align-items-start">
	                                    <div>
	                                        <h6 class="mb-1"><%= a.get("service_name") %> - <%= a.get("status") %></h6>
	                                        <small class="text-secondary">Booking #<%= a.get("id") %></small>
	                                    </div>
	                                    <small class="text-secondary"><%= a.get("updated") != null ? a.get("updated") : "" %></small>
	                                </div>
	                            </div>
                            <% } 
                            } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="footer.jsp" %>
    </main>
</body>
</html>
