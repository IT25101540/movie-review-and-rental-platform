package com.movieplatform.model;

/**
 * Represents a movie rental transaction.
 * Demonstrates encapsulation with private fields and public accessors.
 */
public class Rental {

    private String id;
    private String userId;
    private String movieId;
    private String rentalDate;
    private String returnDate;
    private String status; // "ACTIVE" or "RETURNED"

    public Rental() {
    }

    public Rental(String id, String userId, String movieId, String rentalDate, String returnDate, String status) {
        this.id = id;
        this.userId = userId;
        this.movieId = movieId;
        this.rentalDate = rentalDate;
        this.returnDate = returnDate;
        this.status = status;
    }

    // --- Getters and Setters ---

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getMovieId() {
        return movieId;
    }

    public void setMovieId(String movieId) {
        this.movieId = movieId;
    }

    public String getRentalDate() {
        return rentalDate;
    }

    public void setRentalDate(String rentalDate) {
        this.rentalDate = rentalDate;
    }

    public String getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(String returnDate) {
        this.returnDate = returnDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    /**
     * Check if the rental is currently active.
     */
    public boolean isActive() {
        return "ACTIVE".equalsIgnoreCase(status);
    }

    /**
     * Serialize to pipe-delimited string.
     * Format: ID|UserID|MovieID|RentalDate|ReturnDate|Status
     */
    public String toFileString() {
        return String.join("|", id, userId, movieId, rentalDate,
                returnDate != null ? returnDate : "", status);
    }

    /**
     * Deserialize from a pipe-delimited file line.
     */
    public static Rental fromFileString(String line) {
        String[] parts = line.split("\\|");
        if (parts.length < 6) return null;
        return new Rental(
                parts[0].trim(),
                parts[1].trim(),
                parts[2].trim(),
                parts[3].trim(),
                parts[4].trim().isEmpty() ? null : parts[4].trim(),
                parts[5].trim()
        );
    }

    @Override
    public String toString() {
        return "Rental{id='" + id + "', movieId='" + movieId + "', status='" + status + "'}";
    }
}
