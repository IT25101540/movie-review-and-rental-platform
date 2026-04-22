package com.movieplatform.model;

/**
 * Represents a movie in the platform catalog.
 * Demonstrates encapsulation with private fields and public accessors.
 */
public class Movie {

    private String id;
    private String title;
    private String genre;
    private String director;
    private int releaseYear;
    private double rentalPrice;

    public Movie() {
    }

    public Movie(String id, String title, String genre, String director, int releaseYear, double rentalPrice) {
        this.id = id;
        this.title = title;
        this.genre = genre;
        this.director = director;
        this.releaseYear = releaseYear;
        this.rentalPrice = rentalPrice;
    }

    // --- Getters and Setters ---

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getGenre() {
        return genre;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }

    public String getDirector() {
        return director;
    }

    public void setDirector(String director) {
        this.director = director;
    }

    public int getReleaseYear() {
        return releaseYear;
    }

    public void setReleaseYear(int releaseYear) {
        this.releaseYear = releaseYear;
    }

    public double getRentalPrice() {
        return rentalPrice;
    }

    public void setRentalPrice(double rentalPrice) {
        this.rentalPrice = rentalPrice;
    }

    /**
     * Serialize to pipe-delimited string for file storage.
     * Format: ID|Title|Genre|Director|Year|Price
     */
    public String toFileString() {
        return String.join("|", id, title, genre, director,
                String.valueOf(releaseYear), String.valueOf(rentalPrice));
    }

    /**
     * Deserialize from a pipe-delimited file line.
     */
    public static Movie fromFileString(String line) {
        String[] parts = line.split("\\|");
        if (parts.length < 6) return null;
        try {
            return new Movie(
                    parts[0].trim(),
                    parts[1].trim(),
                    parts[2].trim(),
                    parts[3].trim(),
                    Integer.parseInt(parts[4].trim()),
                    Double.parseDouble(parts[5].trim())
            );
        } catch (NumberFormatException e) {
            return null;
        }
    }

    @Override
    public String toString() {
        return "Movie{id='" + id + "', title='" + title + "', genre='" + genre + "'}";
    }
}
