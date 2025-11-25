<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.jovanchunyi.util.DatabaseConnection" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("ADMIN")) {
        response.sendRedirect("login.jsp?error=Access denied");
        return;
    }

    String bookingId = request.getParameter("id");
    if (bookingId == null) {
        response.sendRedirect("admin.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String username = "", serviceName = "", status = "", notes = "";
    int duration = 0;
    double totalPrice = 0;
    Date bookingDate = null;
    Time bookingTime = null;

    try {
        conn = DatabaseConnection.getConnection();
        ps = conn.prepareStatement(
            "SELECT b.*, u.username, s.name AS service_name FROM booking b " +
            "JOIN user u ON b.user_id = u.id JOIN service s ON b.service_id = s.id WHERE b.id = ?"
        );
        ps.setInt(1, Integer.parseInt(bookingId));
        rs = ps.executeQuery();

        if (!rs.next()) {
            response.sendRedirect("admin.jsp?error=Booking not found");
            return;
        }

        username = rs.getString("username");
        serviceName = rs.getString("service_name");
        bookingDate = rs.getDate("booking_date");
        bookingTime = rs.getTime("booking_time");
        duration = rs.getInt("duration_hours");
        totalPrice = rs.getDouble("total_price");
        status = rs.getString("status");
        notes = rs.getString("notes");
        rs.close(); ps.close();
    } catch (Exception e) { e.printStackTrace(); }

    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Booking - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar bg-white border-bottom">
        <div class="container">
            <a class="navbar-brand fw-bold" href="admin.jsp"><i class="bi bi-arrow-left me-2"></i>Back to Dashboard</a>
        </div>
    </nav>

    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-6">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h5 class="mb-0"><i class="bi bi-calendar-check text-warning me-2"></i>Update Booking #<%= bookingId %></h5>
                    </div>
                    <div class="card-body p-4">
                        <% if (error != null) { %>
                        <div class="alert alert-danger"><%= error %></div>
                        <% } %>

                        <!-- Booking Info (Read Only) -->
                        <div class="bg-light rounded p-3 mb-4">
                            <div class="row">
                                <div class="col-6 mb-2"><small class="text-muted d-block">Client</small><span class="fw-semibold"><%= username %></span></div>
                                <div class="col-6 mb-2"><small class="text-muted d-block">Service</small><span class="fw-semibold"><%= serviceName %></span></div>
                                <div class="col-6 mb-2"><small class="text-muted d-block">Date</small><span><%= bookingDate %></span></div>
                                <div class="col-6 mb-2"><small class="text-muted d-block">Time</small><span><%= bookingTime %></span></div>
                                <div class="col-6"><small class="text-muted d-block">Duration</small><span><%= duration %> hours</span></div>
                                <div class="col-6"><small class="text-muted d-block">Total</small><span class="text-success fw-bold">$<%= String.format("%.2f", totalPrice) %></span></div>
                            </div>
                        </div>

                        <form action="AdminUpdateBookingServlet" method="post">
                            <input type="hidden" name="bookingId" value="<%= bookingId %>">

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Status *</label>
                                <select class="form-select" name="status" required>
                                    <option value="PENDING" <%= "PENDING".equals(status) ? "selected" : "" %>>Pending</option>
                                    <option value="CONFIRMED" <%= "CONFIRMED".equals(status) ? "selected" : "" %>>Confirmed</option>
                                    <option value="COMPLETED" <%= "COMPLETED".equals(status) ? "selected" : "" %>>Completed</option>
                                    <option value="CANCELLED" <%= "CANCELLED".equals(status) ? "selected" : "" %>>Cancelled</option>
                                </select>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold">Admin Notes</label>
                                <textarea class="form-control" name="notes" rows="3"><%= notes != null ? notes : "" %></textarea>
                            </div>

                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary"><i class="bi bi-check-circle me-1"></i>Update Booking</button>
                                <a href="admin.jsp" class="btn btn-outline-secondary">Cancel</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%
        if (conn != null) conn.close();
    %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>