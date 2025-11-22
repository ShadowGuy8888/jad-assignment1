<!--
  - Author: Jovan Yap Keat An
  - Date: 27 / 11 / 2025
  - Copyright Notice: © 2025 JovanYKA
  - @(#)
  - Description: ST0510/JAD Assignment 1 submission
  -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Silver Care - Our Services</title>
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
    </style>
</head>
<%
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/silvercare", "root", "password");
    
	String selectedCategory = request.getParameter("categoryName");
	if (selectedCategory == null) selectedCategory = "all";

    List<String> allCategories = new ArrayList<>();
    allCategories.add("all"); // always include "all" option

    PreparedStatement ps = conn.prepareStatement("SELECT DISTINCT name FROM service_category;");
	ResultSet rs = ps.executeQuery();
    while (rs.next()) allCategories.add(rs.getString("name"));
    if (!allCategories.contains(selectedCategory)) selectedCategory = "all";

%>
<body>
    <%@ include file="header.jsp" %>

    <main>
        <!-- Hero Section -->
        <section class="hero-gradient py-5">
            <div class="container py-4">
                <h1 class="text-center mb-3">Our Care Services</h1>
                <p class="text-center text-secondary fs-5 mb-0">Comprehensive care solutions tailored to your needs</p>
            </div>
        </section>

        <!-- Services Section with Tabs -->
        <section class="py-5">
            <div class="container">
                <!-- Tabs Navigation -->
				<ul class="nav nav-pills mb-4 flex-column flex-lg-row" id="serviceTabs" role="tablist">
				    <li class="nav-item flex-fill mb-2 mb-lg-0" role="presentation">
				        <button class="nav-link <%= selectedCategory.equals("all") ? "active" : "" %> w-100 text-center"
				                onclick="(() => location.href='services.jsp?categoryName=all')()" role="tab">
				            All Services
				        </button>
				    </li>
                <% 
                	ps = conn.prepareStatement("SELECT name FROM service_category;");
                	rs = ps.executeQuery();
                	while (rs.next()) {
                		String categoryName = rs.getString("name");
                %>
					    <li class="nav-item flex-fill mb-2 mb-lg-0" role="presentation">
					        <button class="nav-link <%= selectedCategory.equals(categoryName) ? "active" : "" %> w-100 text-center"
					                onclick="location.href='services.jsp?categoryName=<%= categoryName %>'" role="tab">
					            <%= categoryName %>
					        </button>
					    </li>
				<% 
                	}
				%>
				</ul>
                <div class="row g-4">
					<% 
					    ps = conn.prepareStatement(
				            "SELECT " +
		                    "    s.id, " +
		                    "    s.name service_name, " +
		                    "    s.description, " +
		                    "    s.hourly_rate, " +
		                    "    s.image_url, " +
		                    "    sc.name service_category_name, " +
		                    "    GROUP_CONCAT(cq.name SEPARATOR \", \") qualifications " +
		                    "FROM service s " +
		                    "JOIN service_category sc ON s.category_id = sc.id " +
		                    "LEFT JOIN service_caregiver_qualification scq ON s.id = scq.service_id " +
		                    "LEFT JOIN caregiver_qualification cq ON scq.caregiver_qualification_id = cq.qualification_id " +
		                    "GROUP BY s.id " +
		                    "HAVING ? = \"all\" OR sc.name = ?;"
					    );
					    
					    ps.setString(1, selectedCategory);
					    ps.setString(2, selectedCategory);
					    rs = ps.executeQuery();
					    while (rs.next()) {
					%>
		                    <form class="col-md-6 col-lg-4" action="serviceDetails.jsp">
		                        <div class="card h-100 border service-card">
		                            <div class="card-body d-flex flex-column">
		                                <div class="d-flex justify-content-between align-items-start mb-3">
		                                    <div class="icon-box">
		                                        <i class="bi bi-house-door text-primary" style="font-size: 1.5em;"></i>
		                                    </div>
		                                    <span class="badge bg-secondary"><%= rs.getString(6) %></span>
		                                </div>
		                                <h5 class="card-title mb-2"><%= rs.getString(2) %></h5>
		                                <p class="text-secondary mb-3"><%= rs.getString(3) %></p>
		                                <div class="mb-3">
		                                    <div class="d-flex align-items-center gap-2 mb-2 small">
		                                        <i class="fa-solid fa-dollar-sign text-secondary"></i>
		                                        <span class="text-success fw-semibold">&nbsp;$<%= rs.getString(4) %> per hour</span>
		                                    </div>
		                                </div>
		                                <div class="border-top pt-3 mb-3">
		                                    <p class="small text-secondary mb-2">Caregiver Qualifications: <%= rs.getString(7) %></p>
		                                </div>
		                                <input type="hidden" name="serviceId" value="<%= rs.getString(1) %>">
		                                <input type="submit" class="btn btn-primary w-100 mt-auto" value="View Details & Book"></input>
		                            </div>
		                        </div>
		                    </form>
		            <%
					    }
				        rs.close();
				        ps.close();
				        conn.close();
		        	%>
                </div>
            </div>
        </section>

        <!-- Need Help Section -->
        <section class="py-5 bg-light">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-8 text-center">
                        <h2 class="mb-3">Need Help Choosing?</h2>
                        <p class="text-secondary mb-4">Our care coordinators are available to help you find the perfect services for your loved one's needs. Contact us for a free consultation.</p>
                        <div class="d-flex flex-wrap gap-3 justify-content-center">
                            <button class="btn btn-primary btn-lg px-4">Call (555) 123-4567</button>
                            <button class="btn btn-outline-secondary btn-lg px-4">Request Consultation</button>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <%@ include file="footer.jsp" %>
</body>
</html>
