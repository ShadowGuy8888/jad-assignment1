<!-- Author: Jovan Yap Keat An -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <%@ include file="designScripts.jsp" %>
</head>
<% if (session.getAttribute("currentUser") != null) response.sendRedirect("logout.jsp"); %>
<body>
	<%@ include file="header.jsp" %>

    <main class="main-content d-flex justify-content-center align-items-center py-5">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <div class="text-center mb-4">
                        <div class="d-inline-flex align-items-center justify-content-center rounded-circle bg-primary bg-opacity-10 mb-3" style="width: 80px; height: 80px;">
                            <i class="fa-solid fa-right-to-bracket fa-2x text-primary"></i>
                        </div>
                        <h1 class="display-6 fw-bold mb-2">Welcome Back</h1>
                        <p class="text-secondary">Login to access your account and manage your care services</p>
                    </div>

                    <div class="card border-0 shadow-sm">
                        <div class="card-body p-md-5">
                            <h2 class="h4 fw-bold mb-2">Login</h2>
                            <p class="text-secondary mb-4">Enter your credentials to access your account</p>
                            
						<% 
						    String errMsg = (String) request.getAttribute("error");
						    if (errMsg != null) {
						%>
						    	<small class="text-danger"><%= errMsg %></small>
						<%
						    }
						%>
                            
                            <form action="<%= request.getContextPath() %>/login" method="POST">
                                <div class="mb-3">
                                    <label for="usernameInput" class="form-label">Username</label>
                                    <input type="text" class="form-control" id="usernameInput" name="usernameInput" placeholder="yourUsername">
                                </div>
                                
                                <div class="mb-4">
                                    <label for="passwordInput" class="form-label">Password</label>
                                    <input type="password" class="form-control" id="passwordInput" name="passwordInput" placeholder="yourPassword">
                                </div>
                                
                                <button type="submit" class="btn btn-dark w-100 fw-semibold py-2">Login</button>
                            </form>
                            
                            <p class="text-center text-secondary mt-4 mb-4">
                                Don't have an account? <a href="register.jsp" class="text-primary text-decoration-none">Register here</a>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
