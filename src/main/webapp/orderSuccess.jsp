<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Confirmed</title>
    <%@ include file="designScripts.jsp" %>
</head>

<body class="bg-light min-vh-100">
    <%@ include file="header.jsp" %>

    <main class="flex-fill py-5 bg-light">
        <div class="container" style="max-width: 800px;">
            <!-- Success Message -->
            <div class="text-center mb-5">
                <div class="d-inline-flex align-items-center justify-content-center rounded-circle bg-success bg-opacity-10 mb-3" style="width: 80px; height: 80px;">
                    <i class="bi bi-check-circle-fill text-success" style="font-size: 3rem;"></i>
                </div>
                <h1 class="mb-2">Booking Confirmed!</h1>
                <p class="text-secondary">Thank you for choosing Silver Care. Your booking has been successfully confirmed.</p>
            </div>

            <!-- Order Details Card -->
            <div class="card border mb-4">
                <div class="card-header bg-white">
                    <h5 class="mb-0">Order Details</h5>
                </div>
                <div class="card-body">
                    <div class="row g-4 mb-4">
                        <div class="col-md-6">
                            <p class="text-secondary small mb-1">Order Number</p>
                            <p class="mb-0 font-monospace">ORD-1768203638771</p>
                        </div>
                        <div class="col-md-6">
                            <p class="text-secondary small mb-1">Order Date</p>
                            <p class="mb-0">12/01/2026, 15:40:38</p>
                        </div>
                        <div class="col-md-6">
                            <p class="text-secondary small mb-1">Payment Method</p>
                            <p class="mb-0">CARD</p>
                        </div>
                        <div class="col-md-6">
                            <p class="text-secondary small mb-1">Total Amount</p>
                            <p class="mb-0 fs-4 text-success fw-bold">$41.42</p>
                        </div>
                    </div>

                    <hr>

                    <div>
                        <h6 class="mb-3">Contact Information</h6>
                        <div class="d-flex flex-column gap-2">
                            <div class="d-flex align-items-center gap-2 small">
                                <i class="bi bi-envelope text-secondary"></i>
                                <span>k@k.d</span>
                            </div>
                            <div class="d-flex align-items-center gap-2 small">
                                <i class="bi bi-telephone text-secondary"></i>
                                <span>97880442</span>
                            </div>
                            <div class="d-flex align-items-start gap-2 small">
                                <i class="bi bi-house text-secondary mt-1"></i>
                                <span>rrhfdh, uhfourehu 943943</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Booked Services Card -->
            <div class="card border mb-4">
                <div class="card-header bg-white">
                    <h5 class="mb-0">Booked Services</h5>
                </div>
                <div class="card-body">
                    <div class="border rounded p-3">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <div>
                                <h6 class="mb-1">Mobility Assistance</h6>
                                <p class="text-secondary small mb-0">Assisted Living Support</p>
                            </div>
                            <div class="text-end">
                                <p class="text-secondary small mb-0">Qty: 1</p>
                                <p class="mb-0">$38.00</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- What's Next Card -->
            <div class="card border mb-4">
                <div class="card-header bg-white">
                    <h5 class="mb-0">What's Next?</h5>
                </div>
                <div class="card-body">
                    <div class="d-flex flex-column gap-3">
                        <!-- Email Confirmation -->
                        <div class="d-flex gap-3">
                            <i class="bi bi-envelope-fill text-primary fs-5 flex-shrink-0" style="margin-top: 2px;"></i>
                            <div>
                                <p class="fw-semibold mb-1">Confirmation Email</p>
                                <p class="text-secondary small mb-0">You'll receive a confirmation email at k@k.d with all booking details.</p>
                            </div>
                        </div>

                        <!-- Caregiver Assignment -->
                        <div class="d-flex gap-3">
                            <i class="bi bi-box-seam-fill text-primary fs-5 flex-shrink-0" style="margin-top: 2px;"></i>
                            <div>
                                <p class="fw-semibold mb-1">Caregiver Assignment</p>
                                <p class="text-secondary small mb-0">We'll assign a qualified caregiver to your service and notify you within 24 hours.</p>
                            </div>
                        </div>

                        <!-- Track Booking -->
                        <div class="d-flex gap-3">
                            <i class="bi bi-file-text-fill text-primary fs-5 flex-shrink-0" style="margin-top: 2px;"></i>
                            <div>
                                <p class="fw-semibold mb-1">Track Your Booking</p>
                                <p class="text-secondary small mb-0">You can track the status of your booking in your dashboard, including real-time caregiver check-in/check-out updates.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-3">
                <div class="col-sm-6">
                    <button class="btn btn-primary w-100" onclick="location.href='<%= request.getContextPath() %>/myBookings'">
                        <i class="bi bi-calendar-check me-2"></i>View My Bookings
                    </button>
                </div>
                <div class="col-sm-6">
                    <button class="btn btn-outline-secondary w-100" onclick="location.href='<%= request.getContextPath() %>/index.jsp'">
                        <i class="bi bi-house me-2"></i>Return to Home
                    </button>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="footer.jsp" %>
</body>
</html>