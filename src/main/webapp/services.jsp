<!-- Author: Jovan Yap Keat An -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*, entities.Service, entities.ServiceCategory" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Our Services</title>
    <%@ include file="designScripts.jsp" %>
    <style>
        .hero-gradient {
            background: linear-gradient(135deg, #EFF6FF 0%, #DBEAFE 100%);
        }
        .icon-box {
            width: 48px;
            height: 48px;
            background-color: #DBEAFE;
            border-radius: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .service-card {
            transition: box-shadow 0.3s ease;
        }
        .service-card:hover {
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }
        .nav-pills .nav-link {
            color: #1F2937;
            border: 1px solid transparent;
            border-radius: 0.75rem;
            padding: 0.5rem 1rem;
            transition: all 0.2s;
        }
        .nav-pills .nav-link.active {
            background-color: #FFFFFF;
            color: #1F2937;
            border-color: #E5E7EB;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
        }
        .nav-pills {
            background-color: #F3F4F6;
            padding: 4px;
            border-radius: 0.75rem;
        }
        .service-image {
            object-fit: cover;
            border-radius: 0.5rem;
        }
    </style>
</head>
<%
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    if (selectedCategory == null) selectedCategory = "all";
    List<ServiceCategory> categories = (List<ServiceCategory>) request.getAttribute("categories");
    List<Service> services = (List<Service>) request.getAttribute("services");
    if (categories == null) categories = new ArrayList<>();
    if (services == null) services = new ArrayList<>();
    Map<Integer, String> categoryNames = new HashMap<>();
    for (ServiceCategory c : categories) categoryNames.put(c.getId(), c.getName());
%>
<body>
    <%@ include file="header.jsp" %>

    <main>
        <section class="hero-gradient py-5">
            <div class="container py-4">
                <h1 class="text-center mb-3">Our Care Services</h1>
                <p class="text-center text-secondary fs-5 mb-0">Comprehensive care solutions tailored to your needs</p>
            </div>
        </section>

        <section class="py-5">
            <div class="container">
                <!-- Tabs Navigation -->
                <ul class="nav nav-pills mb-4 flex-column flex-lg-row" id="serviceTabs" role="tablist">
                    <li class="nav-item flex-fill mb-2 mb-lg-0" role="presentation">
                        <button class="nav-link <%= "all".equals(selectedCategory) ? "active" : "" %> w-100 text-center"
                                onclick="location.href='<%= request.getContextPath() %>/services?categoryName=all'" role="tab">
                            All Services
                        </button>
                    </li>
            <%
                for (ServiceCategory c : categories) {
                    String categoryName = c.getName();
            %>
                            <li class="nav-item flex-fill mb-2 mb-lg-0" role="presentation">
                                <button class="nav-link <%= categoryName.equals(selectedCategory) ? "active" : "" %> w-100 text-center"
                                        onclick="location.href='<%= request.getContextPath() %>/services?categoryName=<%= categoryName %>'" role="tab">
                                    <%= categoryName %>
                                </button>
                            </li>
            <%
                }
            %>
                </ul>
            
                <div class="row g-4">
            <%
                    for (Service s : services) {
                        String badgeName = categoryNames.getOrDefault(s.getCategoryId(), "Unknown");
            %>
                            <form class="col-md-6 col-lg-4" action="<%= request.getContextPath() %>/service/details" method="GET">
                                <div class="card h-100 border service-card">
                                    <div class="card-body d-flex flex-column">
                                        <div class="d-flex justify-content-between align-items-start mb-3">
                                            <img src="<%= s.getImageUrl() %>" 
                                                 alt="service_img" 
                                                 class="service-image img-fluid" 
                                                 style="width: 80px; height: 80px;" />
                                            <span class="badge bg-secondary"><%= badgeName %></span>
                                        </div>
                                        <h5 class="card-title mb-2"><%= s.getName() %></h5>
                                        <p class="text-secondary mb-3"><%= s.getDescription() %></p>
                                        <div class="mb-3">
                                            <div class="d-flex align-items-center gap-2 mb-2 small">
                                                <i class="fa-solid fa-dollar-sign text-secondary"></i>
                                                <span class="text-success fw-semibold">&nbsp;$<%= s.getHourlyRate() %> per hour</span>
                                            </div>
                                        </div>
                                        <input type="hidden" name="serviceId" value="<%= s.getId() %>">
                                        <button type="submit" class="btn btn-primary w-100 mt-auto">View Details & Book</button>
                                    </div>
                                </div>
                            </form>
            <%
                    }
            %>
                </div>
            </div>
        </section>
    </main>

    <%@ include file="footer.jsp" %>
</body>
</html>
