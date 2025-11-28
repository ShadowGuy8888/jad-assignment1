<!-- Author: Lau Chun Yi -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.jovanchunyi.util.DatabaseConnection" %>
<%
    String role = (String) session.getAttribute("userRole");
    if (role == null || !"ADMIN".equals(role)) {
        response.sendRedirect("login.jsp?error=Access denied");
        return;
    }

    String clientId = request.getParameter("id");
    if (clientId == null) {
        response.sendRedirect("admin.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String username = "", email = "", phone = "", firstName = "", lastName = "";

    try {
        conn = DatabaseConnection.getConnection();
        ps = conn.prepareStatement("SELECT * FROM user WHERE id = ? AND role = 'USER'");
        ps.setInt(1, Integer.parseInt(clientId));
        rs = ps.executeQuery();

        if (!rs.next()) {
            response.sendRedirect("admin.jsp?error=Client not found");
            return;
        }

        username = rs.getString("username");
        email = rs.getString("email");
        phone = rs.getString("phone");
        firstName = rs.getString("first_name");
        lastName = rs.getString("last_name");
        rs.close(); ps.close();
    } catch (Exception e) { e.printStackTrace(); }

    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Client - Admin</title>
    <%@ include file="designScripts.jsp" %>
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
                        <h5 class="mb-0"><i class="bi bi-person-gear text-success me-2"></i>Edit Client #<%= clientId %></h5>
                    </div>
                    <div class="card-body p-4">
                        <% if (error != null) { %>
                        <div class="alert alert-danger"><%= error %></div>
                        <% } %>

                        <form action="EditClientServlet" method="post">
                            <input type="hidden" name="clientId" value="<%= clientId %>">

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">First Name</label>
                                    <input type="text" class="form-control" name="firstName" value="<%= firstName != null ? firstName : "" %>">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Last Name</label>
                                    <input type="text" class="form-control" name="lastName" value="<%= lastName != null ? lastName : "" %>">
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Username *</label>
                                <input type="text" class="form-control" name="username" value="<%= username %>" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Email</label>
                                <input type="email" class="form-control" name="email" value="<%= email %>">
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Phone</label>
                                <input type="text" class="form-control" name="phone" value="<%= phone != null ? phone : "" %>">
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold">New Password</label>
                                <input type="password" class="form-control" name="password" placeholder="Leave blank to keep current">
                                <small class="text-muted">Only fill this if you want to change the password</small>
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