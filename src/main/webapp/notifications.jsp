<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="entities.Notification, java.util.List, java.text.SimpleDateFormat, java.util.Date" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications</title>
    <%@ include file="designScripts.jsp" %>
</head>

<body class="bg-light min-vh-100">
    <%@ include file="header.jsp" %>

    <main class="py-5">
        <div class="container">
            <div class="row align-items-center mb-4">
                <div class="col">
                    <h2 class="mb-0">Notifications</h2>
                    <p class="text-secondary mb-0">Stay updated with your bookings and account activity</p>
                </div>
                <div class="col-auto">
                    <% if (request.getAttribute("unreadCount") != null && (Integer)request.getAttribute("unreadCount") > 0) { %>
                        <a href="<%= request.getContextPath() %>/notifications?action=markAllRead" class="btn btn-outline-primary">
                            <i class="bi bi-check-all me-2"></i>Mark All as Read
                        </a>
                    <% } %>
                </div>
            </div>

            <%
                List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
                SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy 'at' hh:mm a");
                
                if (notifications == null || notifications.isEmpty()) {
            %>
                <!-- Empty State -->
                <div class="card border">
                    <div class="card-body text-center py-5">
                        <i class="bi bi-bell text-secondary mb-3" style="font-size: 4rem;"></i>
                        <h4 class="text-secondary">No Notifications</h4>
                        <p class="text-secondary mb-4">You're all caught up! Check back later for updates.</p>
                        <a href="<%= request.getContextPath() %>/services" class="btn btn-primary">
                            <i class="bi bi-plus-circle me-2"></i>Book a Service
                        </a>
                    </div>
                </div>
            <%
                } else {
                    for (Notification notification : notifications) {
                        String cardClass = notification.isRead() ? "border" : "border border-primary border-2";
                        String bgClass = notification.isRead() ? "" : "bg-light";
            %>
                <div class="card <%= cardClass %> <%= bgClass %> mb-3">
                    <div class="card-body">
                        <div class="row align-items-start">
                            <div class="col-auto">
                                <div class="d-flex align-items-center justify-content-center rounded-circle <%= notification.getBadgeClass() %> bg-opacity-10" style="width: 48px; height: 48px;">
                                    <i class="bi <%= notification.getIconClass() %> <%= notification.getBadgeClass().replace("bg-", "text-") %> fs-5"></i>
                                </div>
                            </div>
                            <div class="col">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <h6 class="mb-0 <%= !notification.isRead() ? "fw-bold" : "" %>">
                                        <%= notification.getTitle() %>
                                        <% if (!notification.isRead()) { %>
                                            <span class="badge bg-primary rounded-pill ms-2">New</span>
                                        <% } %>
                                    </h6>
                                    <div class="dropdown">
                                        <button class="btn btn-link text-secondary p-0" type="button" data-bs-toggle="dropdown">
                                            <i class="bi bi-three-dots-vertical"></i>
                                        </button>
                                        <ul class="dropdown-menu dropdown-menu-end">
                                            <% if (!notification.isRead()) { %>
                                                <li>
                                                    <a class="dropdown-item" href="<%= request.getContextPath() %>/notifications?action=markRead&id=<%= notification.getId() %>">
                                                        <i class="bi bi-check me-2"></i>Mark as Read
                                                    </a>
                                                </li>
                                            <% } %>
                                            <li>
                                                <a class="dropdown-item text-danger" href="<%= request.getContextPath() %>/notifications?action=delete&id=<%= notification.getId() %>" 
                                                   onclick="return confirm('Are you sure you want to delete this notification?')">
                                                    <i class="bi bi-trash me-2"></i>Delete
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                                <p class="mb-2 <%= !notification.isRead() ? "fw-medium" : "text-secondary" %>">
                                    <%= notification.getMessage() %>
                                </p>
                                <small class="text-secondary">
                                    <i class="bi bi-clock me-1"></i>
                                    <%= sdf.format(notification.getCreatedAt()) %>
                                </small>
                                
                                <% if (notification.getRelatedType() != null && notification.getRelatedId() != null) { %>
                                    <div class="mt-2">
                                        <% if (notification.getRelatedType() == Notification.RelatedType.BOOKING) { %>
                                            <a href="<%= request.getContextPath() %>/booking/details?id=<%= notification.getRelatedId() %>" class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-eye me-1"></i>View Booking
                                            </a>
                                        <% } else if (notification.getRelatedType() == Notification.RelatedType.PAYMENT) { %>
                                            <a href="<%= request.getContextPath() %>/myBookings" class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-receipt me-1"></i>View Details
                                            </a>
                                        <% } %>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
            <%
                    }
                }
            %>
        </div>
    </main>

    <%@ include file="footer.jsp" %>
    
</body>
</html>