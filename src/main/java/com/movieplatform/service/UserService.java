package com.movieplatform.service;

import com.movieplatform.model.Admin;
import com.movieplatform.model.Person;
import com.movieplatform.model.User;
import com.movieplatform.util.FileUtil;

import java.util.ArrayList;
import java.util.List;

/**
 * Service layer for user management operations.
 * Handles registration, authentication, search, update, and deletion.
 */
public class UserService {

    private final String filePath;

    public UserService(String filePath) {
        this.filePath = filePath;
    }

    /**
     * Register a new user. Auto-generates the next user ID.
     */
    public Person register(String name, String email, String password) {
        // Check if email already exists
        if (findByEmail(email) != null) {
            return null; // email taken
        }

        String id = FileUtil.generateNextId(filePath, "U");
        User user = new User(id, name, email, password);
        FileUtil.appendLine(filePath, user.toFileString());
        return user;
    }

    /**
     * Authenticate a user by email and password.
     * Returns the Person (User or Admin) if credentials match, null otherwise.
     */
    public Person login(String email, String password) {
        List<String> lines = FileUtil.readAllLines(filePath);
        for (String line : lines) {
            String[] parts = line.split("\\|");
            if (parts.length >= 5) {
                String storedEmail = parts[2].trim();
                String storedPassword = parts[3].trim();
                String role = parts[4].trim();

                if (storedEmail.equalsIgnoreCase(email) && storedPassword.equals(password)) {
                    if ("ADMIN".equalsIgnoreCase(role)) {
                        return Admin.fromFileString(line);
                    } else {
                        return User.fromFileString(line);
                    }
                }
            }
        }
        return null;
    }

    /**
     * Find a user/admin by their ID.
     */
    public Person findById(String id) {
        String line = FileUtil.findById(filePath, id);
        if (line == null) return null;
        return parsePerson(line);
    }

    /**
     * Find a user/admin by their email.
     */
    public Person findByEmail(String email) {
        List<String> lines = FileUtil.readAllLines(filePath);
        for (String line : lines) {
            String[] parts = line.split("\\|");
            if (parts.length >= 5 && parts[2].trim().equalsIgnoreCase(email)) {
                return parsePerson(line);
            }
        }
        return null;
    }

    /**
     * Search users by name (case-insensitive partial match).
     */
    public List<Person> searchByName(String name) {
        List<Person> results = new ArrayList<>();
        List<String> lines = FileUtil.readAllLines(filePath);
        for (String line : lines) {
            String[] parts = line.split("\\|");
            if (parts.length >= 5 && parts[1].trim().toLowerCase().contains(name.toLowerCase())) {
                Person p = parsePerson(line);
                if (p != null) results.add(p);
            }
        }
        return results;
    }

    /**
     * Get all users and admins.
     */
    public List<Person> getAllUsers() {
        List<Person> users = new ArrayList<>();
        List<String> lines = FileUtil.readAllLines(filePath);
        for (String line : lines) {
            Person p = parsePerson(line);
            if (p != null) users.add(p);
        }
        return users;
    }

    /**
     * Update an existing user's details.
     */
    public boolean update(Person person) {
        return FileUtil.updateLine(filePath, person.getId(), person.toFileString());
    }

    /**
     * Delete a user by ID.
     */
    public boolean delete(String id) {
        return FileUtil.deleteLine(filePath, id);
    }

    /**
     * Parse a file line into the appropriate Person subclass (User or Admin).
     */
    private Person parsePerson(String line) {
        String[] parts = line.split("\\|");
        if (parts.length < 5) return null;
        String role = parts[4].trim();
        if ("ADMIN".equalsIgnoreCase(role)) {
            return Admin.fromFileString(line);
        } else {
            return User.fromFileString(line);
        }
    }
}
