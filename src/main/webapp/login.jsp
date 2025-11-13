<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <%@ include file="designScripts.jsp" %>
    
    <style>
        body {
            background-color: #F9FAFB;
            min-height: 100vh;
        }
        .main-content {
            min-height: calc(100vh - 80px);
        }
    </style>
</head>
<body>
	<%@ include file="header.jsp" %>

    <main class="main-content d-flex justify-content-center align-items-center py-5">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <div class="text-center mb-4">
                        <div class="d-inline-flex align-items-center justify-content-center rounded-circle bg-primary bg-opacity-10 mb-3" style="width: 80px; height: 80px;">
                            <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#2563EB" stroke-width="2">
                                <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path>
                                <polyline points="10 17 15 12 10 7"></polyline>
                                <line x1="15" y1="12" x2="3" y2="12"></line>
                            </svg>
                        </div>
                        <h1 class="display-6 fw-bold mb-2">Welcome Back</h1>
                        <p class="text-secondary">Login to access your account and manage your care services</p>
                    </div>

                    <div class="card border-0 shadow-sm">
                        <div class="card-body p-4 p-md-5">
                            <h2 class="h4 fw-bold mb-2">Login</h2>
                            <p class="text-secondary mb-4">Enter your credentials to access your account</p>
                            
                            <form id="loginForm">
                                <div class="mb-3">
                                    <label for="emailInput" class="form-label fw-semibold">Email Address</label>
                                    <input type="email" class="form-control bg-light" id="emailInput" placeholder="your@email.com">
                                </div>
                                
                                <div class="mb-4">
                                    <label for="passwordInput" class="form-label fw-semibold">Password</label>
                                    <input type="password" class="form-control bg-light" id="passwordInput" placeholder="Enter your password">
                                </div>
                                
                                <button type="submit" class="btn btn-dark w-100 fw-semibold py-2">Login</button>
                            </form>
                            
                            <p class="text-center text-secondary mt-4 mb-4">
                                Don't have an account? <a href="#" class="text-primary text-decoration-none fw-medium">Register here</a>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</body>
</html>