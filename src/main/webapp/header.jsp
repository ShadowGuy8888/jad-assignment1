<header class="bg-white border-bottom">
    <div class="container py-3">
        <div class="d-flex align-items-center justify-content-between">
            <div class="d-flex align-items-center gap-2">
                <i class="bi bi-suit-heart-fill text-primary" style="font-size: 1.5em;"></i>
                <span class="fs-5 fw-semibold">Silver Care</span>
            </div>
            <nav class="d-flex align-items-center gap-4">
                <a href="index.jsp" class="text-decoration-none text-secondary fw-medium">Home</a>
                <a href="services.jsp?categoryName=all" class="text-decoration-none text-secondary fw-medium">Services</a>
                <i class="fa-solid fa-cart-shopping text-secondary"></i>
            </nav>
            <div class="d-flex align-items-center gap-2">

            <% 
                String username = (String) session.getAttribute("username");
                if (username != null) { 
            %>
	                <!-- Profile dropdown -->
	                <div class="dropdown">
	                    <button class="btn btn-outline-secondary dropdown-toggle" type="button" id="profileDropdown" data-bs-toggle="dropdown" aria-expanded="false">
	                        <i class="fa-solid fa-user"></i> <%= username %>
	                    </button>
	                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="profileDropdown">
	                        <li><a class="dropdown-item" href="profile.jsp">Edit Profile</a></li>
	                        <li><hr class="dropdown-divider"></li>
	                        <li>
	                            <form action="logout.jsp" method="post" style="margin:0;">
	                                <button type="submit" class="dropdown-item">Logout</button>
	                            </form>
	                        </li>
	                    </ul>
	                </div>
            <% } else { %>
                <a href="login.jsp" class="btn btn-link text-dark text-decoration-none fw-medium">Login</a>
                <a href="register.jsp" class="btn btn-dark rounded">Register</a>
            <% } %>

            </div>
        </div>
    </div>
</header>