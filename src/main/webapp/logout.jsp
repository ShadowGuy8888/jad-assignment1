<!-- Author: Jovan Yap Keat An -->
<%@ page language="java" %>
<%
    session.invalidate();
    response.sendRedirect("login.jsp");
%>