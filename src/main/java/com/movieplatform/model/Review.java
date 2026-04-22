package com.movieplatform.model;

/**
 * Represents a user review for a movie.
 * Demonstrates encapsulation with private fields and public accessors.
 */
public class Review {

    private String id;
    private String userId;
    private String movieId;
    private String comment;
    private int rating; // 1 to 5

    public Review() {
    }

    public Review(String id, String userId, String movieId, String comment, int rating) {
        this.id = id;
        this.userId = userId;
        this.movieId = movieId;
        this.comment = comment;
        this.rating = rating;
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

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = Math.max(1, Math.min(5, rating)); // clamp 1-5
    }

    /**
     * Serialize to pipe-delimited string.
     * Format: ID|UserID|MovieID|Rating|Comment
     */
    public String toFileString() {
        return String.join("|", id, userId, movieId, String.valueOf(rating), comment);
    }

    /**
     * Deserialize from a pipe-delimited file line.
     */
    public static Review fromFileString(String line) {
        String[] parts = line.split("\\|", 5);
        if (parts.length < 5) return null;
        try {
            return new Review(
                    parts[0].trim(),
                    parts[1].trim(),
                    parts[2].trim(),
                    parts[4].trim(),
                    Integer.parseInt(parts[3].trim())
            );
        } catch (NumberFormatException e) {
            return null;
        }
    }

    @Override
    public String toString() {
        return "Review{id='" + id + "', movieId='" + movieId + "', rating=" + rating + "}";
    }
}
