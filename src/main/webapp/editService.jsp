<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.jovanchunyi.util.DatabaseConnection" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("ADMIN")) {
        response.sendRedirect("login.jsp?error=Access denied");
        return;
    }

    String serviceId = request.getParameter("id");
    if (serviceId == null) {
        response.sendRedirect("admin.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String name = "", description = "", imageUrl = "";
    int categoryId = 0, hourlyRate = 0;
    List<Integer> selectedQuals = new ArrayList<>();

    try {
        conn = DatabaseConnection.getConnection();
        
        // Get service details
        ps = conn.prepareStatement("SELECT * FROM service WHERE id = ?");
        ps.setInt(1, Integer.parseInt(serviceId));
        rs = ps.executeQuery();

        if (!rs.next()) {
            response.sendRedirect("admin.jsp?error=Service not found");
            return;
        }

        name = rs.getString("name");
        description = rs.getString("description");
        categoryId = rs.getInt("category_id");
        hourlyRate = rs.getInt("hourly_rate");
        imageUrl = rs.getString("image_url");
        rs.close(); ps.close();

        // Get existing qualifications for this service
        ps = conn.prepareStatement("SELECT caregiver_qualification_id FROM service_caregiver_qualification WHERE service_id = ?");
        ps.setInt(1, Integer.parseInt(serviceId));
        rs = ps.executeQuery();
        while (rs.next()) {
            selectedQuals.add(rs.getInt("caregiver_qualification_id"));
        }
        rs.close(); ps.close();
    } catch (Exception e) { e.printStackTrace(); }

    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Service - Admin</title>
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
                        <h5 class="mb-0"><i class="bi bi-pencil text-primary me-2"></i>Edit Service #<%= serviceId %></h5>
                    </div>
                    <div class="card-body p-4">
                        <% if (error != null) { %>
                        <div class="alert alert-danger"><%= error %></div>
                        <% } %>

                        <form action="EditServiceServlet" method="post">
                            <input type="hidden" name="serviceId" value="<%= serviceId %>">

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Service Name *</label>
                                <input type="text" class="form-control" name="name" value="<%= name %>" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Category *</label>
                                <select class="form-select" name="categoryId" required>
                                    <%
                                        try {
                                            ps = conn.prepareStatement("SELECT id, name FROM service_category ORDER BY name");
                                            rs = ps.executeQuery();
                                            while (rs.next()) {
                                                int catId = rs.getInt("id");
                                    %>
                                    <option value="<%= catId %>" <%= catId == categoryId ? "selected" : "" %>><%= rs.getString("name") %></option>
                                    <%
                                            }
                                            rs.close(); ps.close();
                                        } catch (Exception e) { e.printStackTrace(); }
                                    %>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Hourly Rate ($) *</label>
                                <input type="number" class="form-control" name="hourlyRate" value="<%= hourlyRate %>" min="1" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Description *</label>
                                <textarea class="form-control" name="description" rows="4" required><%= description %></textarea>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Image URL (Optional)</label>
                                <input type="text" class="form-control" name="imageUrl" value="<%= imageUrl != null ? imageUrl : "" %>">
                            </div>

                            <!-- Caregiver Qualifications -->
                            <div class="mb-4">
                                <label class="form-label fw-semibold">Caregiver Qualifications *</label>
                                <small class="text-muted d-block mb-2">Select required qualifications for this service</small>
                                <div class="border rounded p-3" style="max-height: 200px; overflow-y: auto;">
                                    <%
                                        try {
                                            ps = conn.prepareStatement("SELECT qualification_id, name FROM caregiver_qualification ORDER BY name");
                                            rs = ps.executeQuery();
                                            while (rs.next()) {
                                                int qualId = rs.getInt("qualification_id");
                                                boolean isSelected = selectedQuals.contains(qualId);
                                    %>
                                    <div class="form-check mb-2">
                                        <input class="form-check-input" type="checkbox" name="qualifications" value="<%= qualId %>" id="qual_<%= qualId %>" <%= isSelected ? "checked" : "" %>>
                                        <label class="form-check-label" for="qual_<%= qualId %>"><%= rs.getString("name") %></label>
                                    </div>
                                    <%
                                            }
                                            rs.close(); ps.close();
                                        } catch (Exception e) { e.printStackTrace(); }
                                    %>
                                </div>
                            </div>

                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary"><i class="bi bi-check-circle me-1"></i>Save Changes</button>
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