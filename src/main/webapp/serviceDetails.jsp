<!-- Author: Jovan Yap Keat An -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.jovanchunyi.util.DatabaseConnection" %>
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
<%
	String serviceId = request.getParameter("serviceId");

	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;

	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DatabaseConnection.getConnection();
		ps = conn.prepareStatement("SELECT * FROM service WHERE id = ?;");
		ps.setString(1, serviceId);
		rs = ps.executeQuery();
		if (!rs.next()) { // serviceId doesn't exist
			response.sendRedirect("services.jsp?error=serviceId not found");
			return;
		}
		
		ps = conn.prepareStatement(
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
		rs = ps.executeQuery();
%>
<body>
	<%@ include file="header.jsp" %>

    <div class="container">
        <button onclick="location.href = 'services.jsp'" class="btn btn-link text-decoration-none text-dark my-3 p-0">
            <i class="bi bi-arrow-left"></i>
            Back to Services
        </button>
    </div>

<%
		if (rs.next()) {
%>
	        <div class="container mb-5">
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
	                    
	                    <!-- Image -->
	                    <div class="mb-4">
                            <img src="<%= rs.getString("image_url") %>" 
                             alt="serviceId<%= rs.getString("id") %>_img" 
                             class="service-image img-fluid w-50" />
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
					            <form action="CreateBookingServlet" method="post">
					                <%-- Hidden fields --%>
<%
					                    String sessionUserId = (String) session.getAttribute("userId");
					                    String safeUserId = (sessionUserId != null) ? sessionUserId.toString() : "0";
					                    String safeServiceId = (serviceId != null) ? serviceId : "0";
%>
					                <input type="hidden" name="userId" value="<%= safeUserId %>">
					                <input type="hidden" name="serviceId" value="<%= safeServiceId %>">
					
					                <%-- Duration / Hours --%>
					                <div class="mb-3">
					                    <label class="form-label fw-semibold small">Number of Hours *</label>
					                    <input type="number" class="form-control" name="duration" id="duration" min="1" value="1" required>
					                </div>
					
					                <%-- Date --%>
					                <div class="mb-3">
					                    <label class="form-label fw-semibold small">Preferred Date *</label>
					                    <input type="date" class="form-control" name="date" id="date" required>
					                </div>
					
					                <%-- Time --%>
					                <div class="mb-3">
					                    <label class="form-label fw-semibold small">Preferred Time *</label>
					                    <input type="time" class="form-control" name="time" id="time" required>
					                </div>
					
					                <%-- Notes --%>
					                <div class="mb-3">
					                    <label class="form-label fw-semibold small">Special Requests (Optional)</label>
					                    <textarea class="form-control" name="requests" id="requests" rows="4"></textarea>
					                </div>
					
					                <%-- Total price shown to user --%>
					                <div class="border-top pt-3">
					                    <div class="d-flex justify-content-between align-items-center mb-3">
					                        <span>Total:</span>
					                        <span class="fs-3 text-success fw-semibold" id="priceDisplay">$<%= rs.getString("hourly_rate") %>.00</span>
					                    </div>
					
					                    <button type="submit" class="btn btn-primary w-100 d-flex align-items-center justify-content-center gap-2">
					                        Add to Booking Cart
					                    </button>
					                </div>
					            </form>
					
					            <%-- JS for dynamically updating total price --%>
					            <script>
					                const pricePerHour = <%= rs.getString("hourly_rate") %>; // hourly_rate from DB
					
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
<%
		}
	
	} catch (Exception e) {
		e.printStackTrace();
		
	} finally {
		if (rs != null) rs.close();
		if (ps != null) ps.close();
		if (conn != null) conn.close();
	}
%>

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