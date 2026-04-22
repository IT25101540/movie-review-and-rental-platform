package com.movieplatform.model;

/**
 * Regular user of the platform.
 * Demonstrates: Inheritance (extends Person) and Polymorphism (overrides getRole).
 */
public class User extends Person {

    public User() {
        super();
    }

    public User(String id, String name, String email, String password) {
        super(id, name, email, password);
    }

    @Override
    public String getRole() {
        return "USER";
    }

    /**
     * Create a User object from a pipe-delimited file line.
     * Expected format: ID|Name|Email|Password|USER
     */
    public static User fromFileString(String line) {
        String[] parts = line.split("\\|");
        if (parts.length < 5) return null;
        return new User(parts[0].trim(), parts[1].trim(), parts[2].trim(), parts[3].trim());
    }
}
