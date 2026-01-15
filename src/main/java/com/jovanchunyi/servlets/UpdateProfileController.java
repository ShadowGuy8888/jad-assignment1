// Author: Lau Chun Yi
package com.jovanchunyi.servlets;

import java.io.IOException;
import java.sql.SQLException;

import daos.UserDAO;
import entities.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/updateProfileController")
public class UpdateProfileController extends HttpServlet {
    private UserDAO userDAO;
    
    public UpdateProfileController() {
        this.userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Please login to access this page");
            return;
        }

        String firstName = req.getParameter("firstName");
        String lastName = req.getParameter("lastName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String emergencyContact = req.getParameter("emergencyContact");
        String blkNo = req.getParameter("blkNo");
        String unitNo = req.getParameter("unitNo");

        if (email == null || email.trim().isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/profile/edit?error=Email is required");
            return;
        }

        try {
            User user = new User();
            user.setId(currentUser.getId());
            user.setRole(currentUser.getRole());
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setEmail(email);
            user.setPhone(phone);
            user.setAddress(address);
            user.setEmergencyContact(emergencyContact);
            user.setBlkNo(blkNo);
            user.setUnitNo(unitNo);

            boolean success = userDAO.updateUser(user);

            if (success) {
                currentUser.setFirstName(firstName);
                currentUser.setLastName(lastName);
                currentUser.setEmail(email);
                currentUser.setPhone(phone);
                currentUser.setAddress(address);
                currentUser.setEmergencyContact(emergencyContact);
                currentUser.setBlkNo(blkNo);
                currentUser.setUnitNo(unitNo);
                session.setAttribute("currentUser", currentUser);

                res.sendRedirect(req.getContextPath() + "/profile/edit?success=Profile updated successfully!");
            } else {
                res.sendRedirect(req.getContextPath() + "/profile/edit?error=Failed to update profile. Please try again.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/profile/edit?error=Database error: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            res.sendRedirect(req.getContextPath() + "/profile/edit?error=" + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/profile/edit?error=An error occurred while updating the profile");
        }
    }
}
