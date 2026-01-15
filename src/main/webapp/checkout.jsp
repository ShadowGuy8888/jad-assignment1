<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Silver Care</title>
    <%@ include file="designScripts.jsp" %>
</head>

<body class="bg-light min-vh-100">
    <%@ include file="header.jsp" %>

    <main class="flex-fill py-5 bg-light">
        <div class="container">
            <!-- Back Button -->
            <button class="btn btn-link text-decoration-none text-dark mb-4 p-0" onclick="location.href = '<%= request.getContextPath() %>/myBookings'">
                <i class="bi bi-arrow-left me-2"></i>Back to Cart
            </button>

            <!-- Page Title -->
            <div class="mb-5">
                <h1 class="mb-2">Checkout</h1>
                <p class="text-secondary">Complete your payment to confirm your booking</p>
            </div>

            <div class="row g-4">
                <!-- Left Column - Payment Forms -->
                <div class="col-lg-8">
                    <!-- Payment Method Card -->
                    <div class="card border mb-4">
                        <div class="card-header bg-white">
                            <h5 class="mb-0">Payment Method</h5>
                        </div>
                        <div class="card-body">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div class="form-check border rounded p-3">
                                        <input class="form-check-input" type="radio" name="paymentMethod" id="creditCard" value="card" checked>
                                        <label class="form-check-label w-100 d-flex align-items-center gap-2" for="creditCard">
                                            <i class="bi bi-credit-card fs-5"></i>
                                            <span>Credit/Debit Card</span>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Card Details Card -->
                    <div class="card border mb-4">
                        <div class="card-header bg-white">
                            <h5 class="mb-0">Card Details</h5>
                        </div>
                        <div class="card-body">
                            <form>
                                <div class="mb-3">
                                    <label for="cardNumber" class="form-label fw-semibold small">Card Number</label>
                                    <input type="text" class="form-control" id="cardNumber" placeholder="1234 5678 9012 3456" maxlength="19">
                                </div>
                                
                                <div class="mb-3">
                                    <label for="cardName" class="form-label fw-semibold small">Cardholder Name</label>
                                    <input type="text" class="form-control" id="cardName" placeholder="John Doe">
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="expiryDate" class="form-label fw-semibold small">Expiry Date</label>
                                        <input type="text" class="form-control" id="expiryDate" placeholder="MM/YY" maxlength="5">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="cvv" class="form-label fw-semibold small">CVV</label>
                                        <input type="password" class="form-control" id="cvv" placeholder="123" maxlength="3">
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Contact & Billing Information Card -->
                    <div class="card border">
                        <div class="card-header bg-white">
                            <h5 class="mb-0">Contact & Billing Information</h5>
                        </div>
                        <div class="card-body">
                            <form>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="email" class="form-label fw-semibold small">Email</label>
                                        <input type="email" class="form-control" id="email" placeholder="your@email.com" value="k@k.d">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="phone" class="form-label fw-semibold small">Phone</label>
                                        <input type="tel" class="form-control" id="phone" placeholder="(555) 123-4567">
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="address" class="form-label fw-semibold small">Address</label>
                                    <input type="text" class="form-control" id="address" placeholder="123 Main Street">
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="city" class="form-label fw-semibold small">City</label>
                                        <input type="text" class="form-control" id="city" placeholder="New York">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="zipCode" class="form-label fw-semibold small">ZIP Code</label>
                                        <input type="text" class="form-control" id="zipCode" placeholder="10001">
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Right Column - Order Summary -->
                <div class="col-lg-4">
                    <div class="card border sticky-top" style="top: 100px;">
                        <div class="card-header bg-white">
                            <h5 class="mb-0">Order Summary</h5>
                        </div>
                        <div class="card-body">
                            <!-- Order Items -->
                            <div class="mb-3 pb-3 border-bottom">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <div class="flex-fill">
                                        <p class="mb-1">Mobility Assistance</p>
                                        <p class="text-secondary small mb-0">Qty: 1</p>
                                    </div>
                                    <p class="mb-0">$38.00</p>
                                </div>
                            </div>

                            <!-- Price Breakdown -->
                            <div class="mb-3">
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-secondary small">Subtotal</span>
                                    <span class="small">$38.00</span>
                                </div>
                                <div class="d-flex justify-content-between mb-3">
                                    <span class="text-secondary small">GST (9%)</span>
                                    <span class="small">$3.42</span>
                                </div>
                                <hr>
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <span class="fw-semibold">Total</span>
                                    <span class="fs-3 text-success fw-bold">$41.42</span>
                                </div>
                            </div>

                            <!-- Complete Payment Button -->
                            <button class="btn btn-primary w-100 mb-3 d-flex align-items-center justify-content-center gap-2" onclick="location.href = '<%= request.getContextPath() %>/order/success'">
                                <i class="bi bi-lock-fill"></i>
                                Complete Payment
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <%@ include file="footer.jsp" %>
    
    <script>
        // Card number formatting
        document.getElementById('cardNumber').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\s/g, '');
            let formattedValue = value.match(/.{1,4}/g)?.join(' ') || value;
            e.target.value = formattedValue;
        });

        // Expiry date formatting
        document.getElementById('expiryDate').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            if (value.length >= 2) {
                value = value.slice(0, 2) + '/' + value.slice(2, 4);
            }
            e.target.value = value;
        });

        // CVV numbers only
        document.getElementById('cvv').addEventListener('input', function(e) {
            e.target.value = e.target.value.replace(/\D/g, '');
        });
    </script>
</body>
</html>