<!-- Author: Lau Chun Yi -->
<%@ page import="java.sql.*, java.util.*, com.jovanchunyi.util.DatabaseConnection" %>
<%
    String username = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("userRole");

    if (username == null) {
        response.sendRedirect("login.jsp?error=Please login to access this page");
        return;
    }

    if ("admin".equals(userRole)) {
        response.sendRedirect("admin.jsp");
        return;
    }

    String userId = (String) session.getAttribute("userId");

    // Variables to hold user info
    String email = "", phone = "", createdAt = "";

    if (userId != null && !userId.equals("0")) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "SELECT username, email, phone, created_at FROM user WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        username = rs.getString("username"); // optional, overrides session
                        email = rs.getString("email");
                        phone = rs.getString("phone");
                        createdAt = rs.getString("created_at"); // format as needed
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    List<Map<String, Object>> upcomingBookings = new ArrayList<>();
    List<Map<String, Object>> recentActivities = new ArrayList<>();
    int totalBookings = 0, upcomingCount = 0;

    if (userId != null && !"0".equals(userId)) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            // Total bookings count
            try (PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM booking WHERE user_id = ?")) {
                stmt.setString(1, userId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) totalBookings = rs.getInt(1);
            }

            // Upcoming count
            try (PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM booking WHERE user_id = ? AND status IN ('PENDING','CONFIRMED')")) {
                stmt.setString(1, userId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) upcomingCount = rs.getInt(1);
            }

            // Upcoming bookings
            String sqlUpcoming = "SELECT b.id, s.name AS service_name, b.booking_date, b.booking_time, b.duration_hours, b.status " +
                "FROM booking b JOIN service s ON b.service_id = s.id " +
                "WHERE b.user_id = ? AND b.status IN ('PENDING','CONFIRMED') " +
                "ORDER BY b.booking_date ASC, b.booking_time ASC LIMIT 2";
            try (PreparedStatement stmt = conn.prepareStatement(sqlUpcoming)) {
                stmt.setString(1, userId);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    Map<String, Object> b = new HashMap<>();
                    b.put("id", rs.getInt("id"));
                    b.put("service_name", rs.getString("service_name"));
                    b.put("date", rs.getDate("booking_date"));
                    b.put("time", rs.getTime("booking_time"));
                    b.put("duration", rs.getInt("duration_hours"));
                    b.put("status", rs.getString("status"));
                    upcomingBookings.add(b);
                }
            }

            // Recent activity
            String sqlActivity = "SELECT b.id, s.name AS service_name, b.status, b.updated_at " +
                "FROM booking b JOIN service s ON b.service_id = s.id " +
                "WHERE b.user_id = ? ORDER BY b.updated_at DESC LIMIT 5";
            try (PreparedStatement stmt = conn.prepareStatement(sqlActivity)) {
                stmt.setString(1, userId);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    Map<String, Object> a = new HashMap<>();
                    a.put("id", rs.getInt("id"));
                    a.put("service_name", rs.getString("service_name"));
                    a.put("status", rs.getString("status"));
                    a.put("updated", rs.getTimestamp("updated_at"));
                    recentActivities.add(a);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Dashboard - Silver Care</title>
    <%@ include file="designScripts.jsp" %>
</head>
<body class="bg-light min-vh-100">
    <main>
        <!-- Page Header -->
        <section class="bg-white border-bottom">
            <div class="container py-4">
                <div class="row align-items-center">
                    <div class="col">
                        <h2 class="mb-0">My Dashboard</h2>
                        <p class="text-secondary mb-0">Welcome back, <%= username %>!</p>
                    </div>
                    <div class="col-auto d-flex align-items-center gap-2">
                        <span class="badge bg-primary">Client Member</span>
                        <!-- Home Button -->
                        <a href="index.jsp" class="btn btn-outline-primary btn-sm">
                            <i class="bi bi-house-door me-1"></i> Home
                        </a>
                    </div>
                </div>
            </div>
        </section>
        
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
                            
                            <a href="editProfile.jsp" class="btn btn-outline-primary w-100 mt-3">
                                <i class="bi bi-pencil me-2"></i>Edit Profile
                            </a>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="card shadow-sm">
                        <div class="card-header bg-white"><h5 class="mb-0">Quick Actions</h5></div>
                        <div class="card-body d-grid gap-2">
                            <a href="services.jsp" class="btn btn-primary"><i class="bi bi-calendar-plus me-2"></i>Book New Service</a>
                            <a href="myBooking.jsp" class="btn btn-outline-primary"><i class="bi bi-list-check me-2"></i>View All Bookings</a>
                            <a href="services.jsp" class="btn btn-outline-primary"><i class="bi bi-search me-2"></i>Browse Services</a>
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
                            <a href="myBooking.jsp" class="btn btn-sm btn-outline-primary">View All</a>
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
                                <a href="bookingDetails.jsp?id=<%= b.get("id") %>" class="btn btn-sm btn-primary mt-3"><i class="bi bi-eye me-1"></i>View Details</a>
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