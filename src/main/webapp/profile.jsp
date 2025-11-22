<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Access control - redirect to login if not logged in
    String username = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("userRole");
    
    if (username == null) {
        response.sendRedirect("login.jsp?error=Please login to access this page");
        return;
    }
    
    // If user is admin, redirect to admin dashboard
    if ("admin".equals(userRole)) {
        response.sendRedirect("adminDashboard.jsp");
        return;
    }
    
    // Get user information from session
    String email = (String) session.getAttribute("email");
    String phone = (String) session.getAttribute("phone");
    String createdAt = (String) session.getAttribute("createdAt");
%>

<%@ page import="java.sql.*, java.util.*, com.jovanchunyi.util.DatabaseConnection" %>

<%
    int userId = (session.getAttribute("userId") != null) 
                    ? (int) session.getAttribute("userId") 
                    : -1;

    List<Map<String, Object>> upcomingBookings = new ArrayList<>();
    List<Map<String, Object>> recentActivities = new ArrayList<>();

    if (userId != -1) {
        try (Connection conn = DatabaseConnection.getConnection()) {

            // ==========================
            // 1️⃣ UPCOMING BOOKINGS
            // ==========================
            String sqlUpcoming =
                "SELECT b.id, s.name AS service_name, b.booking_date, b.booking_time, " +
                "b.duration_hours, b.status " +
                "FROM booking b " +
                "JOIN service s ON b.service_id = s.id " +
                "WHERE b.user_id = ? AND b.status IN ('PENDING','CONFIRMED') " +
                "ORDER BY b.booking_date ASC, b.booking_time ASC " +
                "LIMIT 2";

            try (PreparedStatement stmt = conn.prepareStatement(sqlUpcoming)) {
                stmt.setInt(1, userId);
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

            // ==========================
            // 2️⃣ RECENT ACTIVITY
            // ==========================
            String sqlActivity =
                "SELECT b.id, s.name AS service_name, b.status, b.updated_at " +
                "FROM booking b " +
                "JOIN service s ON b.service_id = s.id " +
                "WHERE b.user_id = ? " +
                "ORDER BY b.updated_at DESC " +
                "LIMIT 5";

            try (PreparedStatement stmt = conn.prepareStatement(sqlActivity)) {
                stmt.setInt(1, userId);
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

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Dashboard - Silver Care</title>
    <%@ include file="designScripts.jsp" %>
    <style>
        body {
            min-height: 100vh;
            background-color: #f8f9fa;
        }
        .profile-avatar {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            color: white;
            margin: 0 auto;
        }
        .stat-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }
        .activity-item {
            border-left: 3px solid #667eea;
            padding-left: 1rem;
            margin-bottom: 1rem;
            background: white;
            padding: 1rem;
            border-radius: 0.5rem;
        }
        .quick-action-card {
            cursor: pointer;
            transition: all 0.3s ease;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .quick-action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        .booking-card {
            border-left: 4px solid #667eea;
            transition: transform 0.3s ease;
        }
        .booking-card:hover {
            transform: translateX(5px);
        }
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 50px;
            font-size: 0.875rem;
            font-weight: 500;
        }
        .status-confirmed {
            background-color: #d4edda;
            color: #155724;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        .status-completed {
            background-color: #cce5ff;
            color: #004085;
        }
    </style>
</head>
<body>
    <main>
        <!-- Page Header -->
        <section class="bg-white border-bottom">
            <div class="container py-4">
                <div class="row align-items-center">
                    <div class="col">
                        <h2 class="mb-0">My Dashboard</h2>
                        <p class="text-secondary mb-0">Welcome back, <%= username %>!</p>
                    </div>
                    <div class="col-auto">
                        <span class="badge bg-primary">Client Member</span>
                    </div>
                </div>
            </div>
        </section>

        <div class="container my-4">
            <div class="row g-4">
                <!-- Left Column - Profile & Quick Actions -->
                <div class="col-lg-4">
                    <!-- Profile Card -->
                    <div class="card shadow-sm mb-4">
                        <div class="card-body text-center p-4">
                            <div class="profile-avatar mb-3">
                                <i class="bi bi-person-fill"></i>
                            </div>
                            <h4 class="mb-1"><%= username %></h4>
                            <p class="text-secondary mb-3">Client Member</p>
                            
                            <div class="text-start mt-4">
                                <div class="mb-3">
                                    <small class="text-secondary d-block mb-1">
                                        <i class="bi bi-envelope me-2"></i>Email
                                    </small>
                                    <span><%= email != null ? email : "Not provided" %></span>
                                </div>
                                <div class="mb-3">
                                    <small class="text-secondary d-block mb-1">
                                        <i class="bi bi-telephone me-2"></i>Phone
                                    </small>
                                    <span><%= phone != null ? phone : "Not provided" %></span>
                                </div>
                                <div class="mb-3">
                                    <small class="text-secondary d-block mb-1">
                                        <i class="bi bi-calendar me-2"></i>Member Since
                                    </small>
                                    <span><%=createdAt != null ? createdAt : "Not sure" %></span>
                                </div>
                            </div>
                            
                            <button class="btn btn-outline-primary w-100 mt-3" onclick="location.href='editProfile.jsp'">
                                <i class="bi bi-pencil me-2"></i>Edit Profile
                            </button>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="card shadow-sm">
                        <div class="card-header bg-white">
                            <h5 class="mb-0">Quick Actions</h5>
                        </div>
                        <div class="card-body p-3">
                            <div class="d-grid gap-2">
                                <button class="btn btn-primary" onclick="location.href='services.jsp'">
                                    <i class="bi bi-calendar-plus me-2"></i>Book New Service
                                </button>
                                <button class="btn btn-outline-primary" onclick="location.href='myBookings.jsp'">
                                    <i class="bi bi-list-check me-2"></i>View All Bookings
                                </button>
                                <button class="btn btn-outline-primary" onclick="location.href='services.jsp'">
                                    <i class="bi bi-search me-2"></i>Browse Services
                                </button>
                                <button class="btn btn-outline-primary" onclick="alert('Support feature coming soon!')">
                                    <i class="bi bi-headset me-2"></i>Contact Support
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Column - Dashboard Content -->
                <div class="col-lg-8">
                    <!-- Statistics Cards -->
                    <div class="row g-3 mb-4">
                        <div class="col-md-4">
                            <div class="card stat-card shadow-sm">
                                <div class="card-body">
                                    <div class="d-flex align-items-center">
                                        <div class="flex-shrink-0">
                                            <div class="bg-primary bg-opacity-10 rounded p-3">
                                                <i class="bi bi-calendar-check text-primary" style="font-size: 1.5rem;"></i>
                                            </div>
                                        </div>
                                        <div class="flex-grow-1 ms-3">
                                            <h3 class="mb-0">8</h3>
                                            <p class="text-secondary mb-0 small">Total Bookings</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card stat-card shadow-sm">
                                <div class="card-body">
                                    <div class="d-flex align-items-center">
                                        <div class="flex-shrink-0">
                                            <div class="bg-success bg-opacity-10 rounded p-3">
                                                <i class="bi bi-clock-history text-success" style="font-size: 1.5rem;"></i>
                                            </div>
                                        </div>
                                        <div class="flex-grow-1 ms-3">
                                            <h3 class="mb-0">2</h3>
                                            <p class="text-secondary mb-0 small">Upcoming</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card stat-card shadow-sm">
                                <div class="card-body">
                                    <div class="d-flex align-items-center">
                                        <div class="flex-shrink-0">
                                            <div class="bg-warning bg-opacity-10 rounded p-3">
                                                <i class="bi bi-star-fill text-warning" style="font-size: 1.5rem;"></i>
                                            </div>
                                        </div>
                                        <div class="flex-grow-1 ms-3">
                                            <h3 class="mb-0">4.9</h3>
                                            <p class="text-secondary mb-0 small">Avg Rating</p>
                                        </div>
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
    <%
        if (upcomingBookings.isEmpty()) {
    %>
        <p class="text-secondary">No upcoming bookings</p>
    <%
        } else {
            for (Map<String, Object> b : upcomingBookings) {
                String status = (String)b.get("status");
                String badgeClass =
                    "CONFIRMED".equals(status) ? "status-confirmed" :
                    "PENDING".equals(status) ? "status-pending" :
                    "status-completed";
    %>

        <div class="booking-card bg-light p-3 rounded mb-3">
            <div class="d-flex justify-content-between align-items-start mb-2">
                <div>
                    <h6 class="mb-1"><%= b.get("service_name") %></h6>
                    <span class="status-badge <%= badgeClass %>"><%= status %></span>
                </div>
                <div class="text-end">
                    <small class="text-secondary d-block">Booking #<%= b.get("id") %></small>
                </div>
            </div>

            <div class="row mt-3">
                <div class="col-md-4">
                    <small class="text-secondary d-block">Date</small>
                    <span><%= b.get("date") %></span>
                </div>
                <div class="col-md-4">
                    <small class="text-secondary d-block">Time</small>
                    <span><%= b.get("time") %></span>
                </div>
                <div class="col-md-4">
                    <small class="text-secondary d-block">Duration</small>
                    <span><%= b.get("duration") %> hours</span>
                </div>
            </div>

            <div class="mt-3">
                <button class="btn btn-sm btn-primary me-2"
                    onclick="location.href='bookingDetails.jsp?id=<%= b.get("id") %>'">
                    <i class="bi bi-eye me-1"></i>View Details
                </button>
            </div>
        </div>

    <%      } // end for
        } // end else
    %>
</div>
                        
                    </div>

                    <!-- Recent Activity -->
                    <div class="card shadow-sm">
                        <div class="card-header bg-white">
                            <h5 class="mb-0">Recent Activity</h5>
                        </div>
                        <div class="card-body">
    <%
        if (recentActivities.isEmpty()) {
    %>
        <p class="text-secondary">No recent updates</p>
    <%
        } else {
            for (Map<String, Object> a : recentActivities) {
    %>

        <div class="activity-item">
            <div class="d-flex justify-content-between align-items-start">
                <div>
                    <h6 class="mb-1"><%= a.get("service_name") %> - <%= a.get("status") %></h6>
                    <p class="text-secondary mb-0 small">Booking #<%= a.get("id") %></p>
                </div>
                <small class="text-secondary"><%= a.get("updated") != null ? a.get("updated") : "" %></small>
            </div>
        </div>

    <%      } // end for
        } // end else
    %>
</div>

                    </div>
                </div>
            </div>
        </div>

        <%@ include file="footer.jsp" %>
    </main>

    <script>
        // Auto-hide success messages after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                alert.style.transition = 'opacity 0.5s';
                alert.style.opacity = '0';
                setTimeout(() => alert.remove(), 500);
            });
        }, 5000);
    </script>
</body>
</html>