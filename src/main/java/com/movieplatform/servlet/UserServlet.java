package com.movieplatform.servlet;

import com.movieplatform.model.Person;
import com.movieplatform.model.User;
import com.movieplatform.model.Admin;
import com.movieplatform.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Servlet handling all user-related operations:
 * Registration, Login, Logout, Search, Update, Delete.
 */
@WebServlet(urlPatterns = {"/register", "/login", "/logout", "/users", "/users/update", "/users/delete", "/profile"})
public class UserServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        String dataDir = getServletContext().getInitParameter("dataDir");
        if (dataDir == null) dataDir = "src/main/resources/data/";
        userService = new UserService(dataDir + "users.txt");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/register":
                request.getRequestDispatcher("/views/register.jsp").forward(request, response);
                break;

            case "/login":
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);
                break;

            case "/logout":
                HttpSession session = request.getSession(false);
                if (session != null) session.invalidate();
                response.sendRedirect(request.getContextPath() + "/");
                break;

            case "/users":
                handleUserSearch(request, response);
                break;

            case "/profile":
                handleProfile(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/register":
                handleRegister(request, response);
                break;

            case "/login":
                handleLogin(request, response);
                break;

            case "/users/update":
                handleUpdate(request, response);
                break;

            case "/users/delete":
                handleDelete(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/");
        }
    }

    /**
     * Handle user registration (Create operation).
     */
    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (name == null || email == null || password == null ||
                name.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }

        Person registered = userService.register(name.trim(), email.trim(), password.trim());

        if (registered == null) {
            request.setAttribute("error", "Email is already registered. Please use a different email.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }

        // Auto-login after registration
        HttpSession session = request.getSession();
        session.setAttribute("user", registered);
        session.setAttribute("userId", registered.getId());
        session.setAttribute("userName", registered.getName());
        session.setAttribute("userRole", registered.getRole());

        response.sendRedirect(request.getContextPath() + "/");
    }

    /**
     * Handle user login.
     */
    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required.");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            return;
        }

        Person person = userService.login(email.trim(), password.trim());

        if (person == null) {
            request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("user", person);
        session.setAttribute("userId", person.getId());
        session.setAttribute("userName", person.getName());
        session.setAttribute("userRole", person.getRole());

        response.sendRedirect(request.getContextPath() + "/");
    }

    /**
     * Handle user search (Read operation) — admin or search by ID/name.
     */
    private void handleUserSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String searchId = request.getParameter("id");
        String searchName = request.getParameter("name");

        List<Person> users;

        if (searchId != null && !searchId.trim().isEmpty()) {
            users = new java.util.ArrayList<>();
            Person found = userService.findById(searchId.trim());
            if (found != null) users.add(found);
        } else if (searchName != null && !searchName.trim().isEmpty()) {
            users = userService.searchByName(searchName.trim());
        } else {
            users = userService.getAllUsers();
        }

        request.setAttribute("users", users);
        request.setAttribute("searchId", searchId);
        request.setAttribute("searchName", searchName);
        request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);
    }

    /**
     * Handle user profile view.
     */
    private void handleProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String userId = (String) session.getAttribute("userId");
        Person person = userService.findById(userId);
        request.setAttribute("profileUser", person);
        request.getRequestDispatcher("/views/profile.jsp").forward(request, response);
    }

    /**
     * Handle user update (Update operation).
     */
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Only admin or the user themselves can update
        String currentUserId = (String) session.getAttribute("userId");
        String currentRole = (String) session.getAttribute("userRole");
        if (!"ADMIN".equals(currentRole) && !currentUserId.equals(id)) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        Person existing = userService.findById(id);
        if (existing == null) {
            response.sendRedirect(request.getContextPath() + "/users");
            return;
        }

        if (name != null && !name.trim().isEmpty()) existing.setName(name.trim());
        if (email != null && !email.trim().isEmpty()) existing.setEmail(email.trim());
        if (password != null && !password.trim().isEmpty()) existing.setPassword(password.trim());

        userService.update(existing);

        // Update session if user updated their own profile
        if (currentUserId.equals(id)) {
            session.setAttribute("userName", existing.getName());
        }

        if ("ADMIN".equals(currentRole)) {
            response.sendRedirect(request.getContextPath() + "/users?success=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/profile?success=updated");
        }
    }

    /**
     * Handle user deletion (admin only).
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String id = request.getParameter("id");
        if (id != null) {
            userService.delete(id.trim());
        }

        response.sendRedirect(request.getContextPath() + "/users?success=deleted");
    }
}
