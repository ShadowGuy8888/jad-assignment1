<!--
  - Author: Jovan Yap Keat An
  - Date: 27 / 11 / 2025
  - Copyright Notice: © 2025 JovanYKA
  - @(#)
  - Description: ST0510/JAD Assignment 1 submission
  -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" import="java.sql.*, java.util.ArrayList, com.jovan.models.ServiceCategory" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
	<head>
	    <meta charset="UTF-8">
	    <link rel="stylesheet" href="css/serviceCategories.css">
	    <title>Service Categories</title>
	</head>
	<% 
		ArrayList<ServiceCategory> categories = new ArrayList<>();
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/silvercare", "root", "password");
	    Statement stmt = conn.createStatement();
	    ResultSet rs = stmt.executeQuery("SELECT * FROM service_category;");
	    while (rs.next()) {
	    	categories.add(
	    		new ServiceCategory(
	    			rs.getInt("id"), 
	    			rs.getString("name"), 
	    			rs.getString("description"), 
	    			rs.getString("image_url")
	    		)
	    	);
	    }
        rs.close();
        stmt.close();
        conn.close();
        request.setAttribute("categories", categories);
	%>
	<body>
		<%@ include file="header.jsp" %>
		<div class="container">
			<div class="categoriesContainer">
		        <c:forEach items="${categories}" var="cat">
		            <div class="categoryCard">
		                <img src="${cat.imageUrl}" alt="${cat.name}">
		                <h2>${cat.name}</h2>
		                <p>${cat.description}</p>
		            </div>
		        </c:forEach>
			</div>
		</div>
	</body>
</html>
