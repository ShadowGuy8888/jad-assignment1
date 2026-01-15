<!-- Author: Jovan Yap Keat An -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register</title>
<%@ include file="designScripts.jsp" %>
</head>
<% if (session.getAttribute("currentUser") != null) response.sendRedirect("logout.jsp"); %>
<body>
	<%@ include file="header.jsp" %>
	
    <main class="d-flex justify-content-center align-items-center py-5">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-12 col-md-10 col-lg-8">
                    <div class="text-center mb-4">
                        <div class="d-inline-flex align-items-center justify-content-center rounded-circle bg-primary bg-opacity-10 mb-3" style="width: 80px; height: 80px;">
                            <i class="fa-solid fa-user-plus text-primary fa-2x"></i>
                        </div>
                        <h1 class="display-6 fw-bold mb-2">Create Your Account</h1>
                        <p class="text-secondary">Register to access our care services and manage your bookings</p>
                    </div>

                    <div class="card border-0 shadow-sm">
                        <div class="card-body p-md-5">
                            <h2 class="h4 fw-bold mb-2">Register</h2>
                            <p class="text-secondary mb-4">Fill in your details to create an account</p>
                            
                            <form action="<%= request.getContextPath() %>/register" method="POST">
                                <!-- Required Fields Section -->
                                <div class="mb-4">
                                    <h6 class="text-uppercase small text-secondary fw-bold mb-3">Required Information</h6>
                                    <% 
                                    	String errMsg = (String) request.getAttribute("error");
                                    	if (errMsg != null) {
                                    %>
                                    		<small class="text-danger"><%= errMsg %></small>
                                    <%
                                    	} 
                                    %>
                                    
                                    <div class="mb-3">
                                        <label for="usernameInput" class="form-label">Username *</label>
                                        <input type="text" class="form-control" id="usernameInput" name="usernameInput" placeholder="anyUsername" required>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="passwordInput" class="form-label">Password *</label>
                                        <input type="password" class="form-control" id="passwordInput" name="passwordInput" placeholder="anyPassword" required>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="confirmPasswordInput" class="form-label">Confirm Password *</label>
                                        <input type="password" class="form-control" id="confirmPasswordInput" name="confirmPasswordInput" placeholder="yourPassword" required>
                                    </div>
                                </div>

                                <!-- Optional Fields Section -->
                                <div class="mb-4">
                                    <h6 class="text-uppercase small text-secondary fw-bold mb-3">Additional Information (Optional)</h6>
                                    
                                    <div class="mb-3">
                                        <label for="emailInput" class="form-label">Email Address</label>
                                        <input type="email" class="form-control" id="emailInput" name="emailInput" placeholder="your@email.com">
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="firstNameInput" class="form-label">First Name</label>
                                            <input type="text" class="form-control" id="firstNameInput" name="firstNameInput" placeholder="John">
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="lastNameInput" class="form-label">Last Name</label>
                                            <input type="text" class="form-control" id="lastNameInput" name="lastNameInput" placeholder="Doe">
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="phoneInput" class="form-label">Phone Number</label>
                                        <input type="tel" class="form-control" id="phoneInput" name="phoneInput">
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="emergencyPhoneInput" class="form-label">Emergency Contact Phone</label>
                                        <input type="tel" class="form-control" id="emergencyPhoneInput" name="emergencyPhoneInput">
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="addressInput" class="form-label">Address</label>
                                        <input type="text" class="form-control" id="addressInput" name="addressInput">
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="blockNoInput" class="form-label">Block Number</label>
                                            <input type="text" class="form-control" id="blockNoInput" name="blockNoInput">
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="unitNoInput" class="form-label">Unit Number</label>
                                            <input type="text" class="form-control" id="unitNoInput" name="unitNoInput">
                                        </div>
                                    </div>
                                </div>
                                
                                <button type="submit" class="btn btn-dark w-100 py-2">Create Account</button>
                            </form>
                            
                            <p class="text-center text-secondary mt-4 mb-4">
                                Already have an account? <a href="register.jsp" class="text-primary text-decoration-none fw-medium">Login here</a>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
	
	<%@ include file="footer.jsp" %>
</body>
</html>
