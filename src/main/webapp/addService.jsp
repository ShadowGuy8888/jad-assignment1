<!-- Author: Lau Chun Yi -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Service - Admin</title>
    <%@ include file="designScripts.jsp" %>
</head>
<body class="bg-light">
    <nav class="navbar bg-white border-bottom">
        <div class="container">
            <a class="navbar-brand fw-bold" href="<%= request.getContextPath() %>/admin/dashboard"><i class="bi bi-arrow-left me-2"></i>Back to Dashboard</a>
        </div>
    </nav>

    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-6">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h5 class="mb-0"><i class="bi bi-plus-circle text-primary me-2"></i>Add New Service</h5>
                    </div>
                    <div class="card-body p-4">
                        <% if (error != null) { %>
                        <div class="alert alert-danger"><%= error %></div>
                        <% } %>
                        <% if (success != null) { %>
                        <div class="alert alert-success"><%= success %></div>
                        <% } %>

                        <form action="<%= request.getContextPath() %>/AddServiceController" method="POST">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Service Name *</label>
                                <input type="text" class="form-control" name="name" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Category *</label>
                                <select class="form-select" name="categoryId" required>
                                    <option value="">Select Category</option>
                                    <%
                                        List<Map<String, Object>> categories = (List<Map<String, Object>>) request.getAttribute("categories");
                                        if (categories != null) {
                                            for (Map<String, Object> row : categories) {
                                    %>
                                                <option value="<%= row.get("id") %>"><%= row.get("name") %></option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Hourly Rate ($) *</label>
                                <input type="number" class="form-control" name="hourlyRate" min="1" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Description *</label>
                                <textarea class="form-control" name="description" rows="4" required></textarea>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Image URL (Optional)</label>
                                <input type="text" class="form-control" name="imageUrl" placeholder="https://example.com/image.jpg">
                            </div>

                            <!-- Caregiver Qualifications -->
                            <div class="mb-4">
                                <label class="form-label fw-semibold">Caregiver Qualifications *</label>
                                <small class="text-muted d-block mb-2">Select required qualifications for this service</small>
                                <div class="border rounded p-3" style="max-height: 200px; overflow-y: auto;">
                                    <%
                                        List<Map<String, Object>> qualifications = (List<Map<String, Object>>) request.getAttribute("qualifications");
                                        if (qualifications != null) {
                                            for (Map<String, Object> row : qualifications) {
                                    %>
                                                <div class="form-check mb-2">
                                                    <input class="form-check-input" type="checkbox" name="qualifications" value="<%= row.get("id") %>" id="qual_<%= row.get("id") %>">
                                                    <label class="form-check-label" for="qual_<%= row.get("id") %>"><%= row.get("name") %></label>
                                                </div>
                                    <%
                                            }
                                        }
                                    %>
                                </div>
                            </div>

                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary"><i class="bi bi-check-circle me-1"></i>Add Service</button>
                                <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn btn-outline-secondary">Cancel</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        // This page should be accessed via /admin/service/add servlet
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
