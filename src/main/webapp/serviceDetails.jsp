<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
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
    </style>
</head>
<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/silvercare", "root", "password");
	
	String serviceId = request.getParameter("serviceId");
	PreparedStatement ps = conn.prepareStatement(
        "SELECT " +
        "    s.id, " +
        "    s.name service_name, " +
        "    s.description, " +
        "    s.hourly_rate, " +
        "    s.image_url, " +
        "    sc.name service_category_name, " +
        "    GROUP_CONCAT(cq.name SEPARATOR \"||\") qualifications " +
        "FROM service s " +
        "JOIN service_category sc ON s.category_id = sc.id " +
        "LEFT JOIN service_caregiver_qualification scq ON s.id = scq.service_id " +
        "LEFT JOIN caregiver_qualification cq ON scq.caregiver_qualification_id = cq.qualification_id " +
        "WHERE s.id = ?;"
	);
	ps.setString(1, serviceId);
	ResultSet rs = ps.executeQuery();
%>
<body>
	<%@ include file="header.jsp" %>

    <main>
        <!-- Breadcrumb Section -->
        <section class="bg-light py-3 border-bottom">
            <div class="container">
                <button onclick="location.href = 'services.jsp'" class="btn btn-link text-decoration-none p-0 text-dark">
                    <i class="bi bi-arrow-left"></i>
                    Back to Services
                </button>
            </div>
        </section>

	<%
		if (rs.next()) {
	%>
	        <!-- Service Detail Section -->
	        <section class="py-5">
	            <div class="container">
	                <div class="row g-4">
	                    <!-- Left Column - Service Details -->
	                    <div class="col-lg-8">
	                        <!-- Service Header -->
	                        <div class="mb-4">
	                            <span class="badge bg-primary mb-2"><%= rs.getString("service_category_name") %></span>
	                            <h1 class="mb-3"><%= rs.getString("service_name") %></h1>
	                            <div class="d-flex flex-wrap gap-4 text-secondary">
	                                <div class="d-flex align-items-center gap-2">
	                                    <i class="fa-solid fa-dollar-sign text-success"></i>
	                                    <span class="text-success fw-semibold"><%= rs.getString("hourly_rate") %> per hour</span>
	                                </div>
	                                <div class="d-flex align-items-center gap-2">
	                                    <i class="bi bi-clock"></i>
	                                    <span>Flexible scheduling</span>
	                                </div>
	                            </div>
	                        </div>
	
	                        <!-- Service Description Card -->
	                        <div class="card border mb-4">
	                            <div class="card-header bg-white">
	                                <h4 class="mb-0 h5">Service Description</h4>
	                            </div>
	                            <div class="card-body">
	                                <p class="text-secondary mb-0"><%= rs.getString("description") %></p>
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
                                    	for (String qualification : rs.getString("qualifications").split("\\|\\|")) {
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
	                                <form>
	                                    <div class="mb-3">
	                                        <label for="quantity" class="form-label fw-semibold small">Number of Sessions/Hours</label>
	                                        <input type="number" class="form-control" id="quantity" min="1" value="1">
	                                    </div>
	
	                                    <div class="mb-3">
	                                        <label for="date" class="form-label fw-semibold small">Preferred Date *</label>
	                                        <div class="position-relative">
	                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#9CA3AF" stroke-width="2" class="position-absolute top-50 translate-middle-y ms-3" style="pointer-events: none;">
	                                                <path d="M8 2v4"></path>
	                                                <path d="M16 2v4"></path>
	                                                <rect width="18" height="18" x="3" y="4" rx="2"></rect>
	                                                <path d="M3 10h18"></path>
	                                            </svg>
	                                            <input type="date" class="form-control ps-5" id="date" min="2025-11-13">
	                                        </div>
	                                    </div>
	
	                                    <div class="mb-3">
	                                        <label for="time" class="form-label fw-semibold small">Preferred Time</label>
	                                        <input type="time" class="form-control" id="time">
	                                    </div>
	
	                                    <div class="mb-3">
	                                        <label for="caregiver" class="form-label fw-semibold small">Caregiver Preference (Optional)</label>
	                                        <input type="text" class="form-control" id="caregiver" placeholder="Request specific caregiver">
	                                    </div>
	
	                                    <div class="mb-3">
	                                        <label for="requests" class="form-label fw-semibold small">Special Requests or Care Needs</label>
	                                        <textarea class="form-control" id="requests" rows="4" placeholder="Describe any specific needs or requests..."></textarea>
	                                    </div>
	
	                                    <div class="border-top pt-3">
	                                        <div class="d-flex justify-content-between align-items-center mb-3">
	                                            <span>Total:</span>
	                                            <span class="fs-3 text-success fw-semibold">$35.00</span>
	                                        </div>
	                                        <button type="submit" class="btn btn-primary w-100 d-flex align-items-center justify-content-center gap-2">
	                                            <i class="bi bi-cart2"></i>
	                                            Add to Booking Cart
	                                        </button>
	                                    </div>
	                                </form>
	                            </div>
	                        </div>
	                    </div>
	                </div>
	            </div>
	        </section>
    <%
		} else {
    %>
    		<h1 class="text-danger">Service not found.</h1>
    <%
		}
    %>

        <!-- Important Information Section -->
        <section class="py-5 bg-light">
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
        </section>
    </main>
    
    <%@ include file="footer.jsp" %>
</body>
</html>