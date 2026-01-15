<!-- Author: Jovan Yap Keat An -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Silver Care - Compassionate Care for Your Loved Ones</title>
    <%@ include file="designScripts.jsp" %>
    <style>
        body {
            min-height: 100vh;
        }
        .hero-section {
            background: linear-gradient(135deg, #DBEAFE 0%, #BFDBFE 100%);
        }
        .icon-circle {
            width: 64px;
            height: 64px;
            background-color: #DBEAFE;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .icon-circle-sm {
            width: 48px;
            height: 48px;
            background-color: #DBEAFE;
            border-radius: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .card-hover {
            transition: all 0.3s ease;
        }
        .card-hover:hover {
            border-color: #BFDBFE !important;
        }
        .service-card:hover {
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }
        .sticky-top {
            z-index: 1020;
        }
        .badge-cart {
            position: absolute;
            top: -8px;
            right: -8px;
            width: 20px;
            height: 20px;
            font-size: 0.75rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>

    <main>
        <!-- Hero Section -->
        <section class="hero-section py-5">
            <div class="container py-5">
                <div class="row">
                    <div class="col-lg-8 mx-auto text-center">
                        <h1 class="display-4 fw-bold mb-4">Compassionate Care for Your Loved Ones</h1>
                        <p class="lead text-secondary mb-4">Professional in-home care services, assisted living support, and specialized care to help seniors live with dignity and independence</p>
                        <div class="d-flex flex-wrap gap-3 justify-content-center">
                            <button class="btn btn-dark btn-lg px-4" onclick="location.href = '<%= request.getContextPath() %>/services?categoryName=all'">
                                Explore Our Services
                                <i class="bi bi-arrow-right text-light"></i>
                            </button>
                            <% if (session.getAttribute("currentUser") == null) { %>
                            	<button class="btn btn-outline-dark btn-lg px-4" onclick="location.href = '<%= request.getContextPath() %>/register.jsp'">
                             		Get Started Today
                             	</button>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Why Choose Section -->
        <section class="py-5 bg-white">
            <div class="container py-4">
                <h2 class="text-center mb-5">Why Choose Silver Care?</h2>
                <div class="row g-4">
                    <div class="col-md-6 col-lg-3">
                        <div class="card h-100 border-2">
                            <div class="card-body text-center p-4">
                                <div class="icon-circle mx-auto mb-3">
                                    <i class="bi bi-heart-fill text-primary" style="font-size: 1.5em"></i>
                                </div>
                                <h5 class="mb-3">Compassionate Care</h5>
                                <p class="text-secondary mb-0">Our trained caregivers provide loving, respectful care tailored to individual needs</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="card h-100 border-2">
                            <div class="card-body text-center p-4">
                                <div class="icon-circle mx-auto mb-3">
                                    <i class="bi bi-shield-check text-primary" style="font-size: 1.5em"></i>
                                </div>
                                <h5 class="mb-3">Trusted Professionals</h5>
                                <p class="text-secondary mb-0">All staff are thoroughly vetted, certified, and continuously trained</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="card h-100 border-2">
                            <div class="card-body text-center p-4">
                                <div class="icon-circle mx-auto mb-3">
                                    <i class="bi bi-clock text-primary" style="font-size: 1.5em"></i>
                                </div>
                                <h5 class="mb-3">Flexible Scheduling</h5>
                                <p class="text-secondary mb-0">Care when you need it - hourly, daily, or ongoing support available</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="card h-100 border-2">
                            <div class="card-body text-center p-4">
                                <div class="icon-circle mx-auto mb-3">
                                    <i class="fa-solid fa-user-group text-primary" style="font-size: 1.5em"></i>
                                </div>
                                <h5 class="mb-3">Family Partnership</h5>
                                <p class="text-secondary mb-0">We work closely with families to ensure the best possible care experience</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Services Section -->
        <section class="py-5 bg-light">
            <div class="container py-4">
                <div class="text-center mb-5">
                    <h2 class="mb-3">Our Care Services</h2>
                    <p class="lead text-secondary">We offer comprehensive care services designed to meet the unique needs of every client</p>
                </div>
                <div class="row g-4">
                    <div class="col-md-6 col-lg-3">
                        <div class="card h-100 border service-card">
                            <div class="card-body p-4">
                                <div class="icon-circle-sm mb-3">
                                    <i class="bi bi-house-door text-primary" style="font-size: 1.5em;"></i>
                                </div>
                                <h5 class="mb-2">In-Home Care</h5>
                                <p class="text-secondary mb-3">Compassionate care in the comfort of your own home</p>
                                <a href="<%= request.getContextPath() %>/services?categoryName=In-Home%20Care" class="text-primary text-decoration-none fw-semibold">
                                    View Services 
                                    <i class="bi bi-arrow-right text-primary"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="card h-100 border service-card">
                            <div class="card-body p-4">
                                <div class="icon-circle-sm mb-3">
                                    <i class="fa-solid fa-user-group text-primary" style="font-size: 1.5em"></i>
                                </div>
                                <h5 class="mb-2">Assisted Living Support</h5>
                                <p class="text-secondary mb-3">Support services for assisted living residents</p>
                                <a href="<%= request.getContextPath() %>/services?categoryName=Assisted%20Living%20Support" class="text-primary text-decoration-none fw-semibold">
                                    View Services 
                                    <i class="bi bi-arrow-right text-primary"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="card h-100 border service-card">
                            <div class="card-body p-4">
                                <div class="icon-circle-sm mb-3">
                                    <i class="bi bi-heart-fill text-primary" style="font-size: 1.5em"></i>
                                </div>
                                <h5 class="mb-2">Specialized Care</h5>
                                <p class="text-secondary mb-3">Expert care for specific health conditions</p>
                                <a href="<%= request.getContextPath() %>/services?categoryName=Specialized%20Care" class="text-primary text-decoration-none fw-semibold">
                                    View Services 
                                    <i class="bi bi-arrow-right text-primary"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="card h-100 border service-card">
                            <div class="card-body p-4">
                                <div class="icon-circle-sm mb-3">
                                    <i class="bi bi-box text-primary" style="font-size: 1.5em;"></i>
                                </div>
                                <h5 class="mb-2">Additional Services</h5>
                                <p class="text-secondary mb-3">Transportation, meal delivery, and more</p>
                                <a href="<%= request.getContextPath() %>/services?categoryName=Additional%20Services" class="text-primary text-decoration-none fw-semibold">
                                    View Services 
                                    <i class="bi bi-arrow-right text-primary"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Testimonials Section -->
        <section class="py-5 bg-white">
            <div class="container py-4">
                <h2 class="text-center mb-5">What Families Say About Us</h2>
                <div class="row g-4">
                    <div class="col-md-4">
                        <div class="card h-100 border">
                            <div class="card-body p-4">
                                <div class="d-flex mb-3">
                                    <i class="bi bi-heart-fill text-warning"></i>
                                    <i class="bi bi-heart-fill text-warning"></i>
                                    <i class="bi bi-heart-fill text-warning"></i>
                                    <i class="bi bi-heart-fill text-warning"></i>
                                    <i class="bi bi-heart-fill text-warning"></i>
                                </div>
                                <p class="fst-italic text-secondary mb-3">"The caregivers at Silver Care have been wonderful with my mother. They treat her with such respect and kindness."</p>
                                <div>
                                    <p class="mb-0 fw-semibold">Susan Tay</p>
                                    <p class="small text-secondary mb-0">Daughter of Client</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card h-100 border">
                            <div class="card-body p-4">
                                <div class="d-flex mb-3">
                                    <i class="bi bi-heart-fill text-warning"></i>
                                    <i class="bi bi-heart-fill text-warning"></i>
                                    <i class="bi bi-heart-fill text-warning"></i>
                                    <i class="bi bi-heart-fill text-warning"></i>
                                    <i class="bi bi-heart-fill text-warning"></i>
                                </div>
                                <p class="fst-italic text-secondary mb-3">"Professional, reliable, and caring. Silver Care has given our family peace of mind knowing Dad is in good hands."</p>
                                <div>
                                    <p class="mb-0 fw-semibold">Robert Chen</p>
                                    <p class="small text-secondary mb-0">Son of Client</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card h-100 border">
                            <div class="card-body p-4">
                                <div class="d-flex mb-3">
                                    <i class="bi bi-heart-fill text-warning"></i>
                                    <i class="bi bi-heart-fill text-warning"></i>
                                    <i class="bi bi-heart-fill text-warning"></i>
                                    <i class="bi bi-heart-fill text-warning"></i>
                                    <i class="bi bi-heart-fill text-warning"></i>
                                </div>
                                <p class="fst-italic text-secondary mb-3">"After my surgery, their post-operative care services helped me recover comfortably at home. Highly recommended!"</p>
                                <div>
                                    <p class="mb-0 fw-semibold">Freya Wong</p>
                                    <p class="small text-secondary mb-0">Client</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        
        <%@ include file="footer.jsp" %>
    </main>
</body>
</html>
