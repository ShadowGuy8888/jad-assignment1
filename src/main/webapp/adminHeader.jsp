<% 
	entities.User adminUser = (entities.User) session.getAttribute("currentUser");
%>
<nav class="navbar navbar-expand-lg bg-white border-bottom sticky-top">
	<div class="container-fluid">
		<a class="navbar-brand fw-bold" href="<%= request.getContextPath() %>/admin/dashboard"><i class="bi bi-heart-pulse text-primary me-2"></i>CareAdmin</a>
		<div class="d-flex align-items-center gap-3">
		    <span class="text-muted d-none d-md-inline">Welcome, <%= adminUser.getUsername() %></span>
		    <a href="<%= request.getContextPath() %>/logout.jsp" class="btn btn-outline-danger btn-sm"><i class="bi bi-box-arrow-right me-1"></i>Logout</a>
		</div>
	</div>
</nav>