<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Access control - redirect to login if not logged in
    String username = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("userRole");
    
    if (username == null) {
        response.sendRedirect("login.jsp?error=Please login to access this page");
        return;
    }
    
    // Get user information from session
    Integer userId = (Integer) session.getAttribute("userId");
    String email = (String) session.getAttribute("email");
    String phone = (String) session.getAttribute("phone");
    String firstName = (String) session.getAttribute("firstName");
    String lastName = (String) session.getAttribute("lastName");
    String address = (String) session.getAttribute("address");
    String emergencyContact = (String) session.getAttribute("emergencyContact");
    String blkNo = (String) session.getAttribute("blockNo");
    String unitNo = (String) session.getAttribute("unitNo");
    
    // Get success/error messages
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile - Silver Care</title>
    <%@ include file="designScripts.jsp" %>
</head>
<body class="bg-light">
    <main>
        <!-- Page Header -->
        <section class="bg-white border-bottom">
            <div class="container py-4">
                <div class="row align-items-center">
                    <div class="col">
                        <h2 class="mb-0">Edit Profile</h2>
                        <p class="text-secondary mb-0">Update your personal information</p>
                    </div>
                    <div class="col-auto">
                        <a href="index.jsp" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left me-2"></i>Back to Dashboard
                        </a>
                    </div>
                </div>
            </div>
        </section>

        <div class="container my-4">
            <!-- Alert Messages -->
            <% if (success != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle me-2"></i><%= success %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>
            
            <% if (error != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-circle me-2"></i><%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>

            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="card shadow-sm">
                        <div class="card-header bg-white py-3">
                            <h5 class="mb-0"><i class="bi bi-person-fill me-2"></i>Personal Information</h5>
                        </div>
                        <div class="card-body p-4">
                            <form action="UpdateProfileServlet" method="post" id="editProfileForm">
                                <!-- Hidden user ID -->
                                <input type="hidden" name="userId" value="<%= userId %>">
                                
                                <!-- Name Row -->
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="firstName" class="form-label">First Name</label>
                                        <input type="text" class="form-control" id="firstName" name="firstName" 
                                               value="<%= firstName != null ? firstName : "" %>" placeholder="Enter first name">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="lastName" class="form-label">Last Name</label>
                                        <input type="text" class="form-control" id="lastName" name="lastName" 
                                               value="<%= lastName != null ? lastName : "" %>" placeholder="Enter last name">
                                    </div>
                                </div>

                                <!-- Username (Read-only) -->
                                <div class="mb-3">
                                    <label for="username" class="form-label">Username</label>
                                    <input type="text" class="form-control bg-light" id="username" 
                                           value="<%= username %>" readonly disabled>
                                    <small class="text-muted">Username cannot be changed</small>
                                </div>

                                <!-- Email -->
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email Address <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           value="<%= email != null ? email : "" %>" placeholder="Enter email address" required>
                                </div>

                                <!-- Phone -->
                                <div class="mb-3">
                                    <label for="phone" class="form-label">Phone Number</label>
                                    <input type="tel" class="form-control" id="phone" name="phone" 
                                           value="<%= phone != null ? phone : "" %>" placeholder="Enter phone number">
                                </div>

                                <hr class="my-4">
                                <h6 class="mb-3"><i class="bi bi-house-fill me-2"></i>Address Information</h6>

                                <!-- Block & Unit -->
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="blkNo" class="form-label">Block No.</label>
                                        <input type="text" class="form-control" id="blkNo" name="blkNo" 
                                               value="<%= blkNo != null ? blkNo : "" %>" placeholder="e.g., 123">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="unitNo" class="form-label">Unit No.</label>
                                        <input type="text" class="form-control" id="unitNo" name="unitNo" 
                                               value="<%= unitNo != null ? unitNo : "" %>" placeholder="e.g., #01-234">
                                    </div>
                                </div>

                                <!-- Address -->
                                <div class="mb-3">
                                    <label for="address" class="form-label">Street Address</label>
                                    <textarea class="form-control" id="address" name="address" rows="2" 
                                              placeholder="Enter street address"><%= address != null ? address : "" %></textarea>
                                </div>

                                <hr class="my-4">
                                <h6 class="mb-3"><i class="bi bi-telephone-fill me-2"></i>Emergency Contact</h6>

                                <!-- Emergency Contact -->
                                <div class="mb-4">
                                    <label for="emergencyContact" class="form-label">Emergency Contact Number</label>
                                    <input type="tel" class="form-control" id="emergencyContact" name="emergencyContact" 
                                           value="<%= emergencyContact != null ? emergencyContact : "" %>" 
                                           placeholder="Enter emergency contact number">
                                </div>

                                <!-- Buttons -->
                                <div class="d-flex gap-2 justify-content-end">
                                    <a href="userDashboard.jsp" class="btn btn-outline-secondary">
                                        <i class="bi bi-x-lg me-2"></i>Cancel
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-check-lg me-2"></i>Save Changes
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Change Password Card -->
                    <div class="card shadow-sm mt-4">
                        <div class="card-header bg-white py-3">
                            <h5 class="mb-0"><i class="bi bi-key-fill me-2"></i>Change Password</h5>
                        </div>
                        <div class="card-body p-4">
                            <form action="ChangePasswordServlet" method="post" id="changePasswordForm">
                                <input type="hidden" name="userId" value="<%= userId %>">
                                
                                <div class="mb-3">
                                    <label for="currentPassword" class="form-label">Current Password <span class="text-danger">*</span></label>
                                    <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                </div>

                                <div class="mb-3">
                                    <label for="newPassword" class="form-label">New Password <span class="text-danger">*</span></label>
                                    <input type="password" class="form-control" id="newPassword" name="newPassword" 
                                           minlength="8" required>
                                    <small class="text-muted">Minimum 8 characters</small>
                                </div>

                                <div class="mb-4">
                                    <label for="confirmPassword" class="form-label">Confirm New Password <span class="text-danger">*</span></label>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                </div>

                                <div class="d-flex justify-content-end">
                                    <button type="submit" class="btn btn-warning">
                                        <i class="bi bi-key me-2"></i>Change Password
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="footer.jsp" %>
    </main>

    <script>
        // Password confirmation validation
        document.getElementById('changePasswordForm').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('New passwords do not match!');
                return false;
            }
            
            if (newPassword.length < 8) {
                e.preventDefault();
                alert('Password must be at least 8 characters long!');
                return false;
            }
        });

        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>