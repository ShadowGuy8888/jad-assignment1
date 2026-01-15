<!-- Author: Lau Chun Yi -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.ArrayList, entities.User, entities.Service, entities.Booking" %>
<%
    // Get data from request attributes set by the servlet
    Integer totalServices = (Integer) request.getAttribute("totalServices");
    Integer totalClients = (Integer) request.getAttribute("totalClients");
    Integer activeBookings = (Integer) request.getAttribute("activeBookings");
    Double totalRevenue = (Double) request.getAttribute("totalRevenue");
    List<Service> services = (List<Service>) request.getAttribute("services");
    List<User> clients = (List<User>) request.getAttribute("clients");
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    
    // Default values if attributes are null
    if (totalServices == null) totalServices = 0;
    if (totalClients == null) totalClients = 0;
    if (activeBookings == null) activeBookings = 0;
    if (totalRevenue == null) totalRevenue = 0.0;
    if (services == null) services = new ArrayList<>();
    if (clients == null) clients = new ArrayList<>();
    if (bookings == null) bookings = new ArrayList<>();
    
	String success = request.getParameter("success");
	String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Admin</title>
    <%@ include file="designScripts.jsp" %>
    <style>
        .stat-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.25rem; }
        .nav-pills .nav-link.active { background: linear-gradient(135deg, #6366f1, #8b5cf6); }
        .table th { font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.5px; }
        .avatar { width: 32px; height: 32px; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: white; font-weight: 600; font-size: 0.75rem; }
    </style>
</head>
<body class="bg-light">
    <%@ include file="adminHeader.jsp" %>

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
                                <a href="<%= request.getContextPath() %>/admin/service/add" class="btn btn-primary btn-sm"><i class="bi bi-plus me-1"></i>Add Service</a>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr><th>ID</th><th>Name</th><th>Description</th><th>Rate</th><th>Category</th><th>Actions</th></tr>
                                    </thead>
                                    <tbody>
									<%
										String[] colors = {"bg-primary", "bg-success", "bg-warning", "bg-danger", "bg-info"};
										int i = 0;
										for (Service service : services) {
											int sid = service.getId();
									%>
											<tr>
											    <td>#<%= sid %></td>
											    <td>
											        <div class="d-flex align-items-center gap-2">
											            <div class="avatar <%= colors[i++ % 5] %>">
											                <i class="bi bi-box"></i>
											            </div>
											            <%= service.getName() %>
											        </div>
											    </td>
											    <td class="text-muted"><%= service.getDescription() != null ? service.getDescription() : "" %></td>
											    <td><span class="badge bg-success">$<%= service.getHourlyRate() %>/hr</span></td>
											    <td><span class="badge bg-secondary">Category</span></td>
											    <td>
											        <a href="<%= request.getContextPath() %>/admin/service/edit?id=<%= sid %>" class="btn btn-sm btn-outline-primary me-1">
											            <i class="bi bi-pencil"></i>
											        </a>
											        <a href="<%= request.getContextPath() %>/DeleteServiceController?id=<%= sid %>" class="btn btn-sm btn-outline-danger" 
											           onclick="return confirm('Delete this service?')">
											            <i class="bi bi-trash"></i>
											        </a>
											    </td>
											</tr>
									<% 
										}
									%>
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
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr><th>ID</th><th>Name</th><th>Username</th><th>Email</th><th>Phone</th><th>Actions</th></tr>
                                    </thead>
                                    <tbody>
									<%
										for (User client : clients) {
									%>
											<tr>
											    <td>#<%= client.getId() %></td>
											    <td><%= client.getFirstName() %> <%= client.getLastName() %></td>
											    <td><%= client.getUsername() %></td>
											    <td><%= client.getEmail() %></td>
											    <td><%= client.getPhone() != null ? client.getPhone() : "" %></td>
											    <td>
											        <a href="<%= request.getContextPath() %>/admin/editClient?id=<%= client.getId() %>" class="btn btn-sm btn-outline-primary me-1">
											            <i class="bi bi-pencil"></i>
											        </a>
											        <a href="<%= request.getContextPath() %>/DeleteClientController?id=<%= client.getId() %>" class="btn btn-sm btn-outline-danger" 
											           onclick="return confirm('Delete this client?')">
											            <i class="bi bi-trash"></i>
											        </a>
											    </td>
											</tr>
									<% 
										}
									%>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Bookings -->
                    <div class="tab-pane fade" id="bookings">
                        <div class="card border-0 shadow-sm">
                            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                                <h6 class="mb-0"><i class="bi bi-calendar-check text-warning me-2"></i>All Bookings</h6>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr><th>ID</th><th>Service</th><th>Date & Time</th><th>Duration</th><th>Total Price</th><th>Status</th><th>Actions</th></tr>
                                    </thead>
                                    <tbody>
									<%
										for (Booking booking : bookings) {
									%>
											<tr>
											    <td>#<%= booking.getId() %></td>
											    <td>Service Name</td>
											    <td><%= booking.getCheckInTime() %></td>
											    <td><%= booking.getDurationHours() %> hours</td>
											    <td>$<%= String.format("%.2f", booking.getTotalPrice()) %></td>
											    <td><span class="badge bg-secondary"><%= booking.getStatus() %></span></td>
											    <td>
											        <a href="<%= request.getContextPath() %>/admin/booking/update?id=<%= booking.getId() %>" class="btn btn-sm btn-outline-primary me-1">
											            <i class="bi bi-pencil"></i>
											        </a>
											    </td>
											</tr>
									<% 
										}
									%>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
