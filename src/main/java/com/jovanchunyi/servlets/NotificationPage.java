package com.jovanchunyi.servlets;

import daos.NotificationDAO;
import entities.Notification;
import entities.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/notifications")
public class NotificationPage extends HttpServlet {
	
	NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) 
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (session == null || currentUser == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");

        if ("markRead".equals(action)) {
            String notificationId = req.getParameter("id");
            notificationDAO.markAsRead(notificationId, String.valueOf(currentUser.getId()));
            res.sendRedirect(req.getContextPath() + "/notifications");
            return;
        }

        if ("markAllRead".equals(action)) {
            notificationDAO.markAllAsRead(String.valueOf(currentUser.getId()));
            res.sendRedirect(req.getContextPath() + "/notifications");
            return;
        }

        if ("delete".equals(action)) {
            String notificationId = req.getParameter("id");
            notificationDAO.deleteNotification(notificationId, String.valueOf(currentUser.getId()));
            res.sendRedirect(req.getContextPath() + "/notifications");
            return;
        }

        // Default: Get all notifications
        List<Notification> notifications = notificationDAO.getNotificationsByUserId(String.valueOf(currentUser.getId()));
        System.out.println(notifications);
        int unreadCount = notificationDAO.getUnreadCount(String.valueOf(currentUser.getId()));

        req.setAttribute("notifications", notifications);
        req.setAttribute("unreadCount", unreadCount);
        req.getRequestDispatcher("notifications.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) 
            throws ServletException, IOException {
        doGet(req, res);
    }
}
