// Author: Jovan Yap Keat An
package com.jovanchunyi.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import daos.UserDAO;
import entities.User;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Date;

@WebServlet("/register")
public class RegisterController extends HttpServlet {

    private UserDAO userDAO;
    
    public RegisterController() {
        this.userDAO = new UserDAO();
    }

	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String username = req.getParameter("usernameInput");
        String password = req.getParameter("passwordInput");
        String confirmPassword = req.getParameter("confirmPasswordInput");
        String email = req.getParameter("emailInput");
        String firstName = req.getParameter("firstNameInput");
        String lastName = req.getParameter("lastNameInput");
        String phone = req.getParameter("phoneInput");
        String emergencyPhone = req.getParameter("emergencyPhoneInput");
        String address = req.getParameter("addressInput");
        String blkNo = req.getParameter("blockNoInput");
        String unitNo = req.getParameter("unitNoInput");

        if (username == null || username.isEmpty()
        	|| password == null || password.isEmpty()
        	|| !password.equals(confirmPassword)) {
            req.setAttribute("error", "Passwords do not match! All fields are required!");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }
        
        try {
            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setPhone(phone);
            user.setAddress(address);
            user.setEmergencyContact(emergencyPhone);
            user.setBlkNo(blkNo);
            user.setUnitNo(unitNo);
            user.setRole("USER");
            
            if (userDAO.usernameExists(username)) {
                req.setAttribute("error", "Username already exists");
                req.getRequestDispatcher("register.jsp").forward(req, res);
                return;
            }
            if (email != null && !email.isEmpty() && userDAO.emailExists(email)) {
                req.setAttribute("error", "Email already registered");
                req.getRequestDispatcher("register.jsp").forward(req, res);
                return;
            }
            
            String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
            user.setPassword(hashed);
            boolean success = userDAO.create(user);
            
            if (success) {
                HttpSession session = req.getSession();
                user.setPassword(null);
                session.setAttribute("currentUser", user);
                session.setAttribute("loginTimestamp", new Date());
                res.sendRedirect(req.getContextPath() + "/index.jsp");
            } else {
                req.setAttribute("error", "Registration failed. Please try again.");
                req.getRequestDispatcher("register.jsp").forward(req, res);
            }

        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("register.jsp").forward(req, res);
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Database error occurred. Please try again.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Registration failed. Please try again.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
        }
	}
}
