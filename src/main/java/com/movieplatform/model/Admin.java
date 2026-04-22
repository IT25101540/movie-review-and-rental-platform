package com.movieplatform.model;

/**
 * Admin user with elevated privileges.
 * Demonstrates: Inheritance (extends Person) and Polymorphism (overrides getRole).
 */
public class Admin extends Person {

    public Admin() {
        super();
    }

    public Admin(String id, String name, String email, String password) {
        super(id, name, email, password);
    }

    @Override
    public String getRole() {
        return "ADMIN";
    }

    /**
     * Create an Admin object from a pipe-delimited file line.
     * Expected format: ID|Name|Email|Password|ADMIN
     */
    public static Admin fromFileString(String line) {
        String[] parts = line.split("\\|");
        if (parts.length < 5) return null;
        return new Admin(parts[0].trim(), parts[1].trim(), parts[2].trim(), parts[3].trim());
    }
}
