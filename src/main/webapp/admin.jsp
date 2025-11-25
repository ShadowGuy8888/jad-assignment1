<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.*, com.jovanchunyi.util.DatabaseConnection" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("ADMIN")) {
        response.sendRedirect("login.jsp?error=Access denied");
        return;
    }
    String firstName = (String) session.getAttribute("firstName");
    String lastName = (String) session.getAttribute("lastName");
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    int totalServices = 0, totalClients = 0, activeBookings = 0;
    double totalRevenue = 0;
    try {
        conn = DatabaseConnection.getConnection();
        ps = conn.prepareStatement("SELECT COUNT(*) FROM service");
        rs = ps.executeQuery();
        if(rs.next()) totalServices = rs.getInt(1);
        rs.close(); ps.close();
        ps = conn.prepareStatement("SELECT COUNT(*) FROM user WHERE role='USER'");
        rs = ps.executeQuery();
        if(rs.next()) totalClients = rs.getInt(1);
        rs.close(); ps.close();
        ps = conn.prepareStatement("SELECT COUNT(*) FROM booking WHERE status IN ('PENDING','CONFIRMED')");
        rs = ps.executeQuery();
        if(rs.next()) activeBookings = rs.getInt(1);
        rs.close(); ps.close();
        ps = conn.prepareStatement("SELECT COALESCE(SUM(total_price),0) FROM booking WHERE status = 'COMPLETED'");
        rs = ps.executeQuery();
        if(rs.next()) totalRevenue = rs.getDouble(1);
        rs.close(); ps.close();
    } catch(Exception e) { e.printStackTrace(); }
    
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .stat-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.25rem; }
        .nav-pills .nav-link.active { background: linear-gradient(135deg, #6366f1, #8b5cf6); }
        .table th { font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.5px; }
        .avatar { width: 32px; height: 32px; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: white; font-weight: 600; font-size: 0.75rem; }
    </style>
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg bg-white border-bottom sticky-top">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="#"><i class="bi bi-heart-pulse text-primary me-2"></i>CareAdmin</a>
            <div class="d-flex align-items-center gap-3">
                <span class="text-muted d-none d-md-inline">Welcome, <%= firstName %> <%= lastName %></span>
                <a href="logout.jsp" class="btn btn-outline-danger btn-sm"><i class="bi bi-box-arrow-right me-1"></i>Logout</a>
            </div>
        </div>
    </nav>

    <div class="container-fluid py-4">
        <!-- Alert Messages -->
        <% if (success != null) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-2"></i><%= success %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>
        <% if (error != null) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-circle me-2"></i><%= error %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <div class="row">
            <div class="col-lg-2 mb-4">
                <div class="nav flex-column nav-pills">
                    <button class="nav-link active text-start mb-1" data-bs-toggle="pill" data-bs-target="#overview"><i class="bi bi-grid me-2"></i>Overview</button>
                    <button class="nav-link text-start mb-1" data-bs-toggle="pill" data-bs-target="#services"><i class="bi bi-box me-2"></i>Services</button>
                    <button class="nav-link text-start mb-1" data-bs-toggle="pill" data-bs-target="#clients"><i class="bi bi-people me-2"></i>Clients</button>
                    <button class="nav-link text-start" data-bs-toggle="pill" data-bs-target="#bookings"><i class="bi bi-calendar-check me-2"></i>Bookings</button>
                </div>
            </div>

            <div class="col-lg-10">
                <div class="tab-content">
                    <!-- Overview -->
                    <div class="tab-pane fade show active" id="overview">
                        <div class="row g-3 mb-4">
                            <div class="col-sm-6 col-xl-3">
                                <div class="card border-0 shadow-sm h-100">
                                    <div class="card-body d-flex justify-content-between align-items-center">
                                        <div><p class="text-muted small mb-1">Total Services</p><h3 class="mb-0"><%= totalServices %></h3></div>
                                        <div class="stat-icon bg-primary bg-opacity-10 text-primary"><i class="bi bi-box"></i></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6 col-xl-3">
                                <div class="card border-0 shadow-sm h-100">
                                    <div class="card-body d-flex justify-content-between align-items-center">
                                        <div><p class="text-muted small mb-1">Registered Clients</p><h3 class="mb-0"><%= totalClients %></h3></div>
                                        <div class="stat-icon bg-success bg-opacity-10 text-success"><i class="bi bi-people"></i></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6 col-xl-3">
                                <div class="card border-0 shadow-sm h-100">
                                    <div class="card-body d-flex justify-content-between align-items-center">
                                        <div><p class="text-muted small mb-1">Active Bookings</p><h3 class="mb-0"><%= activeBookings %></h3></div>
                                        <div class="stat-icon bg-warning bg-opacity-10 text-warning"><i class="bi bi-calendar-check"></i></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6 col-xl-3">
                                <div class="card border-0 shadow-sm h-100">
                                    <div class="card-body d-flex justify-content-between align-items-center">
                                        <div><p class="text-muted small mb-1">Revenue</p><h3 class="mb-0">$<%= String.format("%.2f", totalRevenue) %></h3></div>
                                        <div class="stat-icon bg-info bg-opacity-10 text-info"><i class="bi bi-currency-dollar"></i></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card border-0 shadow-sm">
                            <div class="card-header bg-white py-3"><h6 class="mb-0"><i class="bi bi-lightning text-warning me-2"></i>Quick Actions</h6></div>
                            <div class="card-body">
                                <button class="btn btn-outline-primary me-2" onclick="document.querySelector('[data-bs-target=\'#services\']').click()"><i class="bi bi-plus-circle me-1"></i>View Services</button>
                                <button class="btn btn-outline-success" onclick="document.querySelector('[data-bs-target=\'#clients\']').click()"><i class="bi bi-people me-1"></i>View Clients</button>
                            </div>
                        </div>
                    </div>

                    <!-- Services -->
                    <div class="tab-pane fade" id="services">
                        <div class="card border-0 shadow-sm">
                            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                                <h6 class="mb-0"><i class="bi bi-box text-primary me-2"></i>All Services</h6>
                                <a href="addService.jsp" class="btn btn-primary btn-sm"><i class="bi bi-plus me-1"></i>Add Service</a>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr><th>ID</th><th>Name</th><th>Description</th><th>Rate</th><th>Category</th><th>Actions</th></tr>
                                    </thead>
                                    <tbody>
                                    <%
                                        String[] colors = {"bg-primary","bg-success","bg-warning","bg-danger","bg-info"};
                                        int i = 0;
                                        try {
                                            ps = conn.prepareStatement("SELECT s.id, s.name, s.description, s.hourly_rate, c.name as category_name FROM service s JOIN service_category c ON s.category_id=c.id");
                                            rs = ps.executeQuery();
                                            while(rs.next()) { int sid = rs.getInt("id");
                                    %>
                                        <tr>
                                            <td>#<%= sid %></td>
                                            <td><div class="d-flex align-items-center gap-2"><div class="avatar <%= colors[i++ % 5] %>"><i class="bi bi-box"></i></div><%= rs.getString("name") %></div></td>
                                            <td class="text-muted"><%= rs.getString("description") %></td>
                                            <td><span class="badge bg-success">$<%= rs.getInt("hourly_rate") %>/hr</span></td>
                                            <td><span class="badge bg-secondary"><%= rs.getString("category_name") %></span></td>
                                            <td>
                                                <a href="editService.jsp?id=<%= sid %>" class="btn btn-sm btn-outline-primary me-1"><i class="bi bi-pencil"></i></a>
                                                <a href="DeleteServiceServlet?id=<%= sid %>" class="btn btn-sm btn-outline-danger" onclick="return confirm('Delete this service?')"><i class="bi bi-trash"></i></a>
                                            </td>
                                        </tr>
                                    <% } rs.close(); ps.close(); } catch(Exception e) { e.printStackTrace(); } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Clients -->
                    <div class="tab-pane fade" id="clients">
                        <div class="card border-0 shadow-sm">
                            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                                <h6 class="mb-0"><i class="bi bi-people text-success me-2"></i>All Clients</h6>
                                <span class="badge bg-success"><%= totalClients %> Total</span>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr><th>ID</th><th>User</th><th>Email</th><th>Phone</th><th>Actions</th></tr>
                                    </thead>
                                    <tbody>
                                    <%
                                        i = 0;
                                        try {
                                            ps = conn.prepareStatement("SELECT id, username, email, phone FROM user WHERE role='USER'");
                                            rs = ps.executeQuery();
                                            while(rs.next()) {
                                                int cid = rs.getInt("id");
                                                String uname = rs.getString("username");
                                                String init = uname != null && uname.length() > 0 ? uname.substring(0,1).toUpperCase() : "?";
                                    %>
                                        <tr>
                                            <td>#<%= cid %></td>
                                            <td><div class="d-flex align-items-center gap-2"><div class="avatar <%= colors[i++ % 5] %>"><%= init %></div><%= uname %></div></td>
                                            <td class="text-muted"><%= rs.getString("email") %></td>
                                            <td><%= rs.getString("phone") != null ? rs.getString("phone") : "N/A" %></td>
                                            <td>
                                                <a href="editClient.jsp?id=<%= cid %>" class="btn btn-sm btn-outline-primary me-1"><i class="bi bi-pencil"></i></a>
                                                <a href="DeleteClientServlet?id=<%= cid %>" class="btn btn-sm btn-outline-danger" onclick="return confirm('Delete this client?')"><i class="bi bi-trash"></i></a>
                                            </td>
                                        </tr>
                                    <% } } catch(Exception e) { e.printStackTrace(); } finally { if(rs!=null) rs.close(); if(ps!=null) ps.close(); } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Bookings -->
                    <div class="tab-pane fade" id="bookings">
                        <div class="card border-0 shadow-sm">
                            <div class="card-header bg-white py-3"><h6 class="mb-0"><i class="bi bi-calendar-check text-warning me-2"></i>All Bookings</h6></div>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr><th>ID</th><th>User</th><th>Service</th><th>Date</th><th>Time</th><th>Duration</th><th>Total</th><th>Status</th><th>Actions</th></tr>
                                    </thead>
                                    <tbody>
                                    <%
                                        try {
                                            ps = conn.prepareStatement(
                                                "SELECT b.id, u.username, s.name as service_name, b.booking_date, b.booking_time, b.duration_hours, b.total_price, b.status " +
                                                "FROM booking b JOIN user u ON b.user_id = u.id JOIN service s ON b.service_id = s.id ORDER BY b.booking_date DESC"
                                            );
                                            rs = ps.executeQuery();
                                            while(rs.next()) {
                                                int bid = rs.getInt("id");
                                                String status = rs.getString("status");
                                                String badgeClass = "CONFIRMED".equals(status) ? "bg-success" : "PENDING".equals(status) ? "bg-warning text-dark" : "CANCELLED".equals(status) ? "bg-danger" : "bg-info";
                                    %>
                                        <tr>
                                            <td>#<%= bid %></td>
                                            <td><%= rs.getString("username") %></td>
                                            <td><%= rs.getString("service_name") %></td>
                                            <td><%= rs.getDate("booking_date") %></td>
                                            <td><%= rs.getTime("booking_time") %></td>
                                            <td><%= rs.getInt("duration_hours") %> hr</td>
                                            <td>$<%= String.format("%.2f", rs.getDouble("total_price")) %></td>
                                            <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                                            <td>
                                                <a href="adminUpdateBooking.jsp?id=<%= bid %>" class="btn btn-sm btn-outline-primary"><i class="bi bi-pencil"></i></a>
                                            </td>
                                        </tr>
                                    <% } rs.close(); ps.close(); } catch(Exception e) { e.printStackTrace(); } finally { if(conn!=null) conn.close(); } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>