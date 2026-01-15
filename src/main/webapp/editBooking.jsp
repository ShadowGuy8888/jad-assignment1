<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Booking</title>
    <%@ include file="designScripts.jsp" %>
</head>
<%
    String bookingId = (String) request.getAttribute("bookingId");
    String serviceName = (String) request.getAttribute("serviceName");
    Double hourlyRate = (Double) request.getAttribute("hourlyRate");
    String bookingDate = (String) request.getAttribute("bookingDate");
    String bookingTime = (String) request.getAttribute("bookingTime");
    Integer duration = (Integer) request.getAttribute("duration");
    Double totalPrice = (Double) request.getAttribute("totalPrice");
    String notes = (String) request.getAttribute("notes");
%>
<body>
	<%@ include file="header.jsp" %>
	
	<main>
	    <section class="bg-light py-3 border-bottom">
	        <div class="container">
	            <a href="<%= request.getContextPath() %>/booking/details?id=<%= bookingId %>" class="btn btn-link text-decoration-none p-0 text-dark">
	                &larr; Back to Booking Details
	            </a>
	        </div>
	    </section>
	
	    <section class="py-5">
	        <div class="container">
	            <div class="row g-4">
	                <div class="col-lg-8">
	                    <div class="card border-0 shadow-sm">
	                        <div class="card-header bg-white py-3">
	                            <h4 class="mb-0 h5">Edit Booking #<%= bookingId %></h4>
	                        </div>
	                        <div class="card-body p-4">
	                            <form action="<%= request.getContextPath() %>/booking/update" method="POST">
	                                <input type="hidden" name="bookingId" value="<%= bookingId %>">

	                                <div class="mb-4">
	                                    <label class="form-label fw-semibold small">Service</label>
	                                    <input type="text" class="form-control bg-light" value="<%= serviceName %>" readonly>
	                                    <small class="text-muted">Service cannot be changed. Please cancel and create a new booking to change service.</small>
	                                </div>

	                                <div class="mb-3">
	                                    <label class="form-label fw-semibold small">Number of Hours *</label>
	                                    <input type="number" class="form-control" name="duration" id="duration" min="1" value="<%= duration %>" required>
	                                </div>

	                                <div class="mb-3">
	                                    <label class="form-label fw-semibold small">Preferred Date *</label>
	                                    <input type="date" class="form-control" name="date" id="date" value="<%= bookingDate %>" required>
	                                </div>

	                                <div class="mb-3">
	                                    <label class="form-label fw-semibold small">Preferred Time *</label>
	                                    <input type="time" class="form-control" name="time" id="time" value="<%= bookingTime %>" required>
	                                </div>

	                                <div class="mb-4">
	                                    <label class="form-label fw-semibold small">Special Requests (Optional)</label>
	                                    <textarea class="form-control" name="notes" rows="4"><%= notes != null ? notes : "-" %></textarea>
	                                </div>

	                                <div class="d-flex gap-2">
	                                    <button type="submit" class="btn btn-primary">
	                                        <i class="bi bi-check-circle me-1"></i>Save Changes
	                                    </button>
	                                    <a href="<%= request.getContextPath() %>/booking/details?id=<%= bookingId %>" class="btn btn-outline-secondary">Cancel</a>
	                                </div>
	                            </form>
	                        </div>
	                    </div>
	                </div>

	                <div class="col-lg-4">
	                    <div class="card border-0 shadow-sm sticky-top" style="top:100px;">
	                        <div class="card-header bg-white py-3">
	                            <h5 class="mb-0 h6">Price Summary</h5>
	                        </div>
	                        <div class="card-body">
	                            <div class="d-flex justify-content-between mb-2">
	                                <span class="text-muted">Hourly Rate</span>
	                                <span>$<%= String.format("%.2f", hourlyRate) %></span>
	                            </div>
	                            <div class="d-flex justify-content-between mb-2">
	                                <span class="text-muted">Duration</span>
	                                <span id="durationDisplay"><%= duration %> hour<%= duration > 1 ? "s" : "" %></span>
	                            </div>
	                            <hr>
	                            <div class="d-flex justify-content-between">
	                                <span class="fw-semibold">Total</span>
	                                <span class="fw-bold text-success fs-5" id="priceDisplay">$<%= String.format("%.2f", totalPrice) %></span>
	                            </div>
	                        </div>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </section>
	</main>
	
	<%@ include file="footer.jsp" %>
	
	<script>
	    const hourlyRate = <%= hourlyRate %>;
	
	    function updatePrice() {
	        const hours = parseInt(document.getElementById("duration").value) || 1;
	        const total = hours * hourlyRate;
	        document.getElementById("priceDisplay").innerText = "$" + total.toFixed(2);
	        document.getElementById("durationDisplay").innerText = hours + " hour" + (hours > 1 ? "s" : "");
	    }
	
	    document.getElementById("duration").addEventListener("input", updatePrice);
	</script>
</body>
</html>
