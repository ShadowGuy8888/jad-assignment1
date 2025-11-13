<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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
                            <button class="btn btn-dark btn-lg px-4">
                                Explore Our Services
                                <svg class="ms-2" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M5 12h14"></path>
                                    <path d="m12 5 7 7-7 7"></path>
                                </svg>
                            </button>
                            <button class="btn btn-outline-dark btn-lg px-4">Get Started Today</button>
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
                        <div class="card h-100 border-2 card-hover">
                            <div class="card-body text-center p-4">
                                <div class="icon-circle mx-auto mb-3">
                                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#2563EB" stroke-width="2">
                                        <path d="M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5"></path>
                                    </svg>
                                </div>
                                <h5 class="mb-3">Compassionate Care</h5>
                                <p class="text-secondary mb-0">Our trained caregivers provide loving, respectful care tailored to individual needs</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="card h-100 border-2 card-hover">
                            <div class="card-body text-center p-4">
                                <div class="icon-circle mx-auto mb-3">
                                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#2563EB" stroke-width="2">
                                        <path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"></path>
                                    </svg>
                                </div>
                                <h5 class="mb-3">Trusted Professionals</h5>
                                <p class="text-secondary mb-0">All staff are thoroughly vetted, certified, and continuously trained</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="card h-100 border-2 card-hover">
                            <div class="card-body text-center p-4">
                                <div class="icon-circle mx-auto mb-3">
                                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#2563EB" stroke-width="2">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <path d="M12 6v6l4 2"></path>
                                    </svg>
                                </div>
                                <h5 class="mb-3">Flexible Scheduling</h5>
                                <p class="text-secondary mb-0">Care when you need it - hourly, daily, or ongoing support available</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="card h-100 border-2 card-hover">
                            <div class="card-body text-center p-4">
                                <div class="icon-circle mx-auto mb-3">
                                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#2563EB" stroke-width="2">
                                        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="9" cy="7" r="4"></circle>
                                        <path d="M22 21v-2a4 4 0 0 0-3-3.87"></path>
                                        <path d="M16 3.128a4 4 0 0 1 0 7.744"></path>
                                    </svg>
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
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#2563EB" stroke-width="2">
                                        <path d="M15 21v-8a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v8"></path>
                                        <path d="M3 10a2 2 0 0 1 .709-1.528l7-6a2 2 0 0 1 2.582 0l7 6A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                    </svg>
                                </div>
                                <h5 class="mb-2">In-Home Care</h5>
                                <p class="text-secondary mb-3">Compassionate care in the comfort of your own home</p>
                                <a href="#" class="text-primary text-decoration-none fw-semibold">
                                    View Services 
                                    <svg class="ms-1" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M5 12h14"></path>
                                        <path d="m12 5 7 7-7 7"></path>
                                    </svg>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="card h-100 border service-card">
                            <div class="card-body p-4">
                                <div class="icon-circle-sm mb-3">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#2563EB" stroke-width="2">
                                        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="9" cy="7" r="4"></circle>
                                        <path d="M22 21v-2a4 4 0 0 0-3-3.87"></path>
                                        <path d="M16 3.128a4 4 0 0 1 0 7.744"></path>
                                    </svg>
                                </div>
                                <h5 class="mb-2">Assisted Living Support</h5>
                                <p class="text-secondary mb-3">Support services for assisted living residents</p>
                                <a href="#" class="text-primary text-decoration-none fw-semibold">
                                    View Services 
                                    <svg class="ms-1" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M5 12h14"></path>
                                        <path d="m12 5 7 7-7 7"></path>
                                    </svg>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="card h-100 border service-card">
                            <div class="card-body p-4">
                                <div class="icon-circle-sm mb-3">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#2563EB" stroke-width="2">
                                        <path d="M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5"></path>
                                    </svg>
                                </div>
                                <h5 class="mb-2">Specialized Care</h5>
                                <p class="text-secondary mb-3">Expert care for specific health conditions</p>
                                <a href="#" class="text-primary text-decoration-none fw-semibold">
                                    View Services 
                                    <svg class="ms-1" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M5 12h14"></path>
                                        <path d="m12 5 7 7-7 7"></path>
                                    </svg>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="card h-100 border service-card">
                            <div class="card-body p-4">
                                <div class="icon-circle-sm mb-3">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#2563EB" stroke-width="2">
                                        <path d="M11 21.73a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73z"></path>
                                        <path d="M12 22V12"></path>
                                        <polyline points="3.29 7 12 12 20.71 7"></polyline>
                                    </svg>
                                </div>
                                <h5 class="mb-2">Additional Services</h5>
                                <p class="text-secondary mb-3">Transportation, meal delivery, and more</p>
                                <a href="#" class="text-primary text-decoration-none fw-semibold">
                                    View Services 
                                    <svg class="ms-1" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M5 12h14"></path>
                                        <path d="m12 5 7 7-7 7"></path>
                                    </svg>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- CTA Section -->
        <section class="py-5 bg-primary text-white">
            <div class="container py-4 text-center">
                <h2 class="mb-3">Ready to Get Started?</h2>
                <p class="lead mb-4">Join the Silver Care family today and discover the difference compassionate, professional care can make</p>
                <div class="d-flex flex-wrap gap-3 justify-content-center">
                    <button class="btn btn-light btn-lg px-4">Register Now</button>
                    <button class="btn btn-outline-light btn-lg px-4">Browse Services</button>
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
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="#FCD34D" stroke="#FCD34D">
                                        <path d="M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5"></path>
                                    </svg>
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="#FCD34D" stroke="#FCD34D">
                                        <path d="M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5"></path>
                                    </svg>
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="#FCD34D" stroke="#FCD34D">
                                        <path d="M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5"></path>
                                    </svg>
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="#FCD34D" stroke="#FCD34D">
                                        <path d="M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5"></path>
                                    </svg>
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="#FCD34D" stroke="#FCD34D">
                                        <path d="M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5"></path>
                                    </svg>
                                </div>
                                <p class="fst-italic text-secondary mb-3">"The caregivers at Silver Care have been wonderful with my mother. They treat her with such respect and kindness."</p>
                                <div>
                                    <p class="mb-0 fw-semibold">Margaret Thompson</p>
                                    <p class="small text-secondary mb-0">Daughter of Client</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card h-100 border">
                            <div class="card-body p-4">
                                <div class="d-flex mb-3">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="#FCD34D" stroke="#FCD34D">
                                        <path d="M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5"></path>
                                    </svg>
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="#FCD34D" stroke="#FCD34D">
                                        <path d="M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5"></path>
                                    </svg>
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="#FCD34D" stroke="#FCD34D">
                                        <path d="M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5"></path>
                                    </svg>
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="#FCD34D" stroke="#FCD34D">
                                        <path d="M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5"></path>
                                    </svg>
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="#FCD34D" stroke="#FCD34D">
                                        <path d="M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5"></path>
                                    </svg>
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
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="#FCD34D" stroke="#FCD34D">
                                        <path d="M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5"></path>
                                    </svg>
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="#FCD34D" stroke="#FCD34D">
                                        <path d="M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5"></path>
                                    </svg>
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="#FCD34D" stroke="#FCD34D">
                                        <path d="M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5"></path>
                                    </svg>
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="#FCD34D" stroke="#FCD34D">
                                        <path d="M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5"></path>
                                    </svg>
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="#FCD34D" stroke="#FCD34D">
                                        <path d="M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5"></path>
                                    </svg>
                                </div>
                                <p class="fst-italic text-secondary mb-3">"After my surgery, their post-operative care services helped me recover comfortably at home. Highly recommended!"</p>
                                <div>
                                    <p class="mb-0 fw-semibold">Susan Williams</p>
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