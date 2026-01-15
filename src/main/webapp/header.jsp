<!-- Author: Jovan Yap Keat An -->
<header class="bg-white border-bottom">
    <div class="container py-3">
        <div class="d-flex align-items-center justify-content-between">
            <div class="d-flex align-items-center gap-2" onclick="location.href = '<%= request.getContextPath() %>/index.jsp';">
                <i class="bi bi-suit-heart-fill text-primary" style="font-size: 1.5em;"></i>
                <span class="fs-5 fw-semibold">Silver Care</span>
            </div>
            <nav class="d-flex align-items-center gap-4">
                <a href="<%= request.getContextPath() %>/index.jsp" class="text-decoration-none text-secondary fw-medium">Home</a>
                <a href="<%= request.getContextPath() %>/services?categoryName=all" class="text-decoration-none text-secondary fw-medium">Services</a>
                <a href="<%= request.getContextPath() %>/myBookings"><i class="fa-solid fa-cart-shopping text-secondary"></i></a>
            </nav>
            <div class="d-flex align-items-center gap-2">

            <% 
                entities.User headerCurrentUser = (entities.User) session.getAttribute("currentUser");
                if (headerCurrentUser != null && "USER".equals(headerCurrentUser.getRole())) {
            %>
	                <!-- Profile dropdown -->
	                <div class="dropdown">
	                    <button class="btn btn-outline-secondary dropdown-toggle" type="button" id="profileDropdown" data-bs-toggle="dropdown" aria-expanded="false">
	                        <i class="fa-solid fa-user"></i> <%= headerCurrentUser.getUsername() %>
	                    </button>
	                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="profileDropdown">
                        <li><a class="dropdown-item" href="<%= request.getContextPath() %>/profile">My Profile</a></li>
	                        <li><hr class="dropdown-divider"></li>
	                        <li>
	                            <form action="<%= request.getContextPath() %>/logout.jsp" method="POST" style="margin:0;">
	                                <button type="submit" class="dropdown-item">Logout</button>
	                            </form>
	                        </li>
	                    </ul>
	                </div>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-link text-dark text-decoration-none fw-medium">Login</a>
                <a href="<%= request.getContextPath() %>/register.jsp" class="btn btn-dark rounded">Register</a>
            <% } %>

            </div>
        </div>
    </div>
</header>
