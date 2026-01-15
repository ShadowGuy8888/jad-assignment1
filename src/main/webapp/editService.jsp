<!-- Author: Lau Chun Yi -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    String serviceId = (String) request.getAttribute("serviceId");
    String name = (String) request.getAttribute("name");
    String description = (String) request.getAttribute("description");
    Integer categoryId = (Integer) request.getAttribute("categoryId");
    Integer hourlyRate = (Integer) request.getAttribute("hourlyRate");
    String imageUrl = (String) request.getAttribute("imageUrl");
    List<Integer> selectedQuals = (List<Integer>) request.getAttribute("selectedQuals");
    if (selectedQuals == null) selectedQuals = new ArrayList<>();
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Service - Admin</title>
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
                        <h5 class="mb-0"><i class="bi bi-pencil text-primary me-2"></i>Edit Service #<%= serviceId %></h5>
                    </div>
                    <div class="card-body p-4">
                        <% if (error != null) { %>
                        <div class="alert alert-danger"><%= error %></div>
                        <% } %>

                        <form action="<%= request.getContextPath() %>/EditServiceController" method="post">
                            <input type="hidden" name="serviceId" value="<%= serviceId %>">

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Service Name *</label>
                                <input type="text" class="form-control" name="name" value="<%= name %>" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Category *</label>
                                <select class="form-select" name="categoryId" required>
                                    <%
                                        List<Map<String, Object>> categories = (List<Map<String, Object>>) request.getAttribute("categories");
                                        if (categories != null) {
                                            for (Map<String, Object> row : categories) {
                                                int catId = (Integer) row.get("id");
                                    %>
                                    <option value="<%= catId %>" <%= catId == categoryId ? "selected" : "" %>><%= row.get("name") %></option>
                                    <%
                                            }
                                        }
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
                                        List<Map<String, Object>> qualifications = (List<Map<String, Object>>) request.getAttribute("qualifications");
                                        if (qualifications != null) {
                                            for (Map<String, Object> row : qualifications) {
                                                int qualId = (Integer) row.get("id");
                                                boolean isSelected = selectedQuals.contains(qualId);
                                    %>
                                    <div class="form-check mb-2">
                                        <input class="form-check-input" type="checkbox" name="qualifications" value="<%= qualId %>" id="qual_<%= qualId %>" <%= isSelected ? "checked" : "" %>>
                                        <label class="form-check-label" for="qual_<%= qualId %>"><%= row.get("name") %></label>
                                    </div>
                                    <%
                                            }
                                        }
                                    %>
                                </div>
                            </div>

                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary"><i class="bi bi-check-circle me-1"></i>Save Changes</button>
                                <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn btn-outline-secondary">Cancel</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        // This page should be accessed via /admin/service/edit servlet
    </script>
</body>
</html>
