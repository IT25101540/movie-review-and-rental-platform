package com.movieplatform.service;

import com.movieplatform.model.Rental;
import com.movieplatform.util.FileUtil;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Service layer for rental operations.
 */
public class RentalService {

    private final String filePath;

    public RentalService(String filePath) {
        this.filePath = filePath;
    }

    /**
     * Rent a movie for a user. Creates a new rental with ACTIVE status.
     * Rental period is 7 days from today.
     */
    public Rental rentMovie(String userId, String movieId) {
        // Check if user already has an active rental for this movie
        List<Rental> userRentals = getByUserId(userId);
        for (Rental r : userRentals) {
            if (r.getMovieId().equalsIgnoreCase(movieId) && r.isActive()) {
                return null; // already renting this movie
            }
        }

        String id = FileUtil.generateNextId(filePath, "R");
        String rentalDate = LocalDate.now().toString();
        String returnDate = LocalDate.now().plusDays(7).toString();

        Rental rental = new Rental(id, userId, movieId, rentalDate, returnDate, "ACTIVE");
        FileUtil.appendLine(filePath, rental.toFileString());
        return rental;
    }

    /**
     * Return a rented movie. Updates status to RETURNED.
     */
    public boolean returnMovie(String rentalId) {
        String line = FileUtil.findById(filePath, rentalId);
        if (line == null) return false;

        Rental rental = Rental.fromFileString(line);
        if (rental == null || !rental.isActive()) return false;

        rental.setStatus("RETURNED");
        rental.setReturnDate(LocalDate.now().toString());
        return FileUtil.updateLine(filePath, rentalId, rental.toFileString());
    }

    /**
     * Get all rentals for a specific user.
     */
    public List<Rental> getByUserId(String userId) {
        List<Rental> results = new ArrayList<>();
        List<String> lines = FileUtil.readAllLines(filePath);
        for (String line : lines) {
            Rental r = Rental.fromFileString(line);
            if (r != null && r.getUserId().equalsIgnoreCase(userId)) {
                results.add(r);
            }
        }
        return results;
    }

    /**
     * Get all active rentals.
     */
    public List<Rental> getAllActive() {
        List<Rental> results = new ArrayList<>();
        List<String> lines = FileUtil.readAllLines(filePath);
        for (String line : lines) {
            Rental r = Rental.fromFileString(line);
            if (r != null && r.isActive()) {
                results.add(r);
            }
        }
        return results;
    }

    /**
     * Get all rentals.
     */
    public List<Rental> getAllRentals() {
        List<Rental> results = new ArrayList<>();
        List<String> lines = FileUtil.readAllLines(filePath);
        for (String line : lines) {
            Rental r = Rental.fromFileString(line);
            if (r != null) results.add(r);
        }
        return results;
    }
}
