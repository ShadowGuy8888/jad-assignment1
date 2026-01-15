<!-- Author: Jovan Yap Keat An -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Service Details</title>
	<%@ include file="designScripts.jsp" %>
    <style>
        .sticky-booking {
            position: sticky;
            top: 100px;
        }
        .service-image {
            object-fit: cover;
            border-radius: 0.5rem;
        }
    </style>
</head>
<body>
	<%@ include file="header.jsp" %>

    <div class="container">
        <button onclick="location.href = '<%= request.getContextPath() %>/services'" class="btn btn-link text-decoration-none text-dark my-3 p-0">
            <i class="bi bi-arrow-left"></i>
            Back to Services
        </button>
    </div>

<%
    String serviceId = (String) request.getAttribute("serviceId");
    String serviceName = (String) request.getAttribute("serviceName");
    String description = (String) request.getAttribute("description");
    Double hourlyRate = (Double) request.getAttribute("hourlyRate");
    String imageUrl = (String) request.getAttribute("imageUrl");
    String categoryName = (String) request.getAttribute("categoryName");
    List<String> qualifications = (List<String>) request.getAttribute("qualifications");
    if (qualifications == null) qualifications = java.util.Collections.emptyList();
%>
        <div class="container mb-5">
            <div class="row g-4">
                <!-- Left Column - Service Details -->
                <div class="col-lg-8">
                    <!-- Service Header -->
                    <div class="mb-4">
                        <span class="badge bg-primary mb-2"><%= categoryName %></span>
                        <h1 class="mb-3"><%= serviceName %></h1>
                        <div class="d-flex flex-wrap gap-4 text-secondary">
                            <div class="d-flex align-items-center gap-2">
                                <i class="fa-solid fa-dollar-sign text-success"></i>
                                <span class="text-success fw-semibold"><%= hourlyRate %> per hour</span>
                            </div>
                            <div class="d-flex align-items-center gap-2">
                                <i class="bi bi-clock"></i>
                                <span>Flexible scheduling</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Image -->
                    <div class="mb-4">
                            <img src="<%= imageUrl %>" 
                             alt="serviceId<%= serviceId %>_img" 
                             class="service-image img-fluid w-50" />
                    </div>
	
                    <!-- Service Description Card -->
                    <div class="card border mb-4">
                        <div class="card-header bg-white">
                            <h4 class="mb-0 h5">Service Description</h4>
                        </div>
                        <div class="card-body">
                            <p class="text-secondary mb-0"><%= description %></p>
                        </div>
                    </div>
	
                    <!-- Qualifications Card -->
                    <div class="card border">
                        <div class="card-header bg-white">
                            <h4 class="mb-0 h5 d-flex align-items-center gap-2">
                                <i class="fa-solid fa-medal"></i>
                                Caregiver Qualifications
                            </h4>
                        </div>
                        <div class="card-body">
                            <ul class="list-unstyled mb-0">
<%
                                for (String qualification : qualifications) {
%>
		                              <li class="d-flex align-items-start gap-2 mb-3">
		                         			<i class="bi bi-check2-circle text-success"></i>
		                                  <span><%= qualification %></span>
		                              </li>
<%
                                }
%>
	                           	</ul>
	                       	</div>
	                   	</div>
	               	</div>
	
					<!-- Right Column - Booking Form -->
					<div class="col-lg-4">
					    <div class="card border sticky-booking">
					        <div class="card-header bg-white">
					            <h4 class="mb-0 h5">Book This Service</h4>
					        </div>
					        <div class="card-body">
					            <form action="<%= request.getContextPath() %>/booking/create" method="POST">
<%
                                    String safeServiceId = (serviceId != null) ? serviceId : "0";
%>
					                <input type="hidden" name="serviceId" value="<%= safeServiceId %>">
					
					                <div class="mb-3">
					                    <label class="form-label fw-semibold small">Number of Hours *</label>
					                    <input type="number" class="form-control" name="duration" id="duration" min="1" value="1" required>
					                </div>

					                <div class="mb-3">
					                    <label class="form-label fw-semibold small">Preferred Date *</label>
					                    <input type="date" class="form-control" name="date" id="date" required>
					                </div>

					                <div class="mb-3">
					                    <label class="form-label fw-semibold small">Preferred Time *</label>
					                    <input type="time" class="form-control" name="time" id="time" required>
					                </div>

					                <div class="mb-3">
					                    <label class="form-label fw-semibold small">Special Requests (Optional)</label>
					                    <textarea class="form-control" name="notes" id="notes" rows="4"></textarea>
					                </div>

					                <div class="border-top pt-3">
					                    <div class="d-flex justify-content-between align-items-center mb-3">
					                        <span>Total:</span>
					                        <span class="fs-3 text-success fw-semibold" id="priceDisplay" data-hourly-rate="<%= String.format("%.2f", hourlyRate) %>">$<%= String.format("%.2f", hourlyRate) %></span>
					                    </div>
					                </div>
					                
				                    <input type="submit" class="btn btn-primary w-100 d-flex align-items-center justify-content-center gap-2" value="Add to Booking Cart">
					            </form>
					
					            <%-- JS for dynamically updating total price --%>
					            <script>
					                const pricePerHour = parseFloat(document.getElementById("priceDisplay").getAttribute("data-hourly-rate"));
					
					                function updateTotal() {
					                    const hoursInput = document.getElementById("duration");
					                    let hours = parseInt(hoursInput.value);
					                    if (isNaN(hours) || hours < 1) hours = 1;

					                    const total = hours * pricePerHour;
					
					                    document.getElementById("priceDisplay").innerText = "$" + total.toFixed(2);
					                }
					                document.getElementById("duration").addEventListener("input", updateTotal);
					                
					                // Initialize total on page load
					                updateTotal();
					            </script>
					        </div>
					    </div>
					</div>
	            </div>
	        </div>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <h2 class="text-center mb-5">Important Information</h2>
                <div class="row g-4">
                    <div class="col-md-4">
                        <div class="card border h-100">
                            <div class="card-body text-center">
                                <h5 class="mb-2">Flexible Scheduling</h5>
                                <p class="text-secondary small mb-0">Schedule changes accepted up to 24 hours before appointment</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card border h-100">
                            <div class="card-body text-center">
                                <h5 class="mb-2">Quality Guaranteed</h5>
                                <p class="text-secondary small mb-0">All caregivers are certified, insured, and background checked</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card border h-100">
                            <div class="card-body text-center">
                                <h5 class="mb-2">Family Updates</h5>
                                <p class="text-secondary small mb-0">Regular updates and communication with family members</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <%@ include file="footer.jsp" %>
</body>
</html>
