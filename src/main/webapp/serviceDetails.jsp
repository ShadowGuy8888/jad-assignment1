<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
<body>
	<%@ include file="header.jsp" %>

    <main>
        <!-- Breadcrumb Section -->
        <section class="bg-light py-3 border-bottom">
            <div class="container">
                <button class="btn btn-link text-decoration-none p-0 text-dark">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="me-2">
                        <path d="m12 19-7-7 7-7"></path>
                        <path d="M19 12H5"></path>
                    </svg>
                    Back to Services
                </button>
            </div>
        </section>

        <!-- Service Detail Section -->
        <section class="py-5">
            <div class="container">
                <div class="row g-4">
                    <!-- Left Column - Service Details -->
                    <div class="col-lg-8">
                        <!-- Service Header -->
                        <div class="mb-4">
                            <span class="badge bg-primary mb-2">In-Home Care</span>
                            <h1 class="mb-3">Personal Care Assistance</h1>
                            <div class="d-flex flex-wrap gap-4 text-secondary">
                                <div class="d-flex align-items-center gap-2">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#16A34A" stroke-width="2">
                                        <line x1="12" x2="12" y1="2" y2="22"></line>
                                        <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path>
                                    </svg>
                                    <span class="text-success fw-semibold">$35 per hour</span>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <path d="M12 6v6l4 2"></path>
                                    </svg>
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
                                <p class="text-secondary mb-0">Our trained caregivers provide compassionate assistance with personal care activities to help maintain dignity and independence. Services include bathing, dressing, grooming, toileting, and mobility assistance.</p>
                            </div>
                        </div>

                        <!-- Qualifications Card -->
                        <div class="card border">
                            <div class="card-header bg-white">
                                <h4 class="mb-0 h5 d-flex align-items-center gap-2">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="m15.477 12.89 1.515 8.526a.5.5 0 0 1-.81.47l-3.58-2.687a1 1 0 0 0-1.197 0l-3.586 2.686a.5.5 0 0 1-.81-.469l1.514-8.526"></path>
                                        <circle cx="12" cy="8" r="6"></circle>
                                    </svg>
                                    Caregiver Qualifications
                                </h4>
                            </div>
                            <div class="card-body">
                                <ul class="list-unstyled mb-0">
                                    <li class="d-flex align-items-start gap-2 mb-3">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#16A34A" stroke-width="2" class="flex-shrink-0" style="margin-top: 2px;">
                                            <circle cx="12" cy="12" r="10"></circle>
                                            <path d="m9 12 2 2 4-4"></path>
                                        </svg>
                                        <span>Certified Nursing Assistant (CNA)</span>
                                    </li>
                                    <li class="d-flex align-items-start gap-2 mb-3">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#16A34A" stroke-width="2" class="flex-shrink-0" style="margin-top: 2px;">
                                            <circle cx="12" cy="12" r="10"></circle>
                                            <path d="m9 12 2 2 4-4"></path>
                                        </svg>
                                        <span>First Aid Certified</span>
                                    </li>
                                    <li class="d-flex align-items-start gap-2 mb-0">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#16A34A" stroke-width="2" class="flex-shrink-0" style="margin-top: 2px;">
                                            <circle cx="12" cy="12" r="10"></circle>
                                            <path d="m9 12 2 2 4-4"></path>
                                        </svg>
                                        <span>Background Checked</span>
                                    </li>
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
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <circle cx="8" cy="21" r="1"></circle>
                                                <circle cx="19" cy="21" r="1"></circle>
                                                <path d="M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12"></path>
                                            </svg>
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