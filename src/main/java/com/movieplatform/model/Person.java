package com.movieplatform.model;

/**
 * Abstract base class representing a person in the system.
 * Demonstrates: Abstraction, Encapsulation, and Polymorphism (via getRole()).
 */
public abstract class Person {

    private String id;
    private String name;
    private String email;
    private String password;

    // Default constructor
    public Person() {
    }

    // Parameterized constructor
    public Person(String id, String name, String email, String password) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.password = password;
    }

    // --- Encapsulation: private fields with public getters/setters ---

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    // --- Polymorphism: subclasses must override this ---
    public abstract String getRole();

    /**
     * Serialize this person to a pipe-delimited string for file storage.
     * Format: ID|Name|Email|Password|Role
     */
    public String toFileString() {
        return String.join("|", id, name, email, password, getRole());
    }

    @Override
    public String toString() {
        return getRole() + "{id='" + id + "', name='" + name + "', email='" + email + "'}";
    }
}
