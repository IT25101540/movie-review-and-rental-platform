package com.movieplatform.service;

import com.movieplatform.model.Review;
import com.movieplatform.util.FileUtil;

import java.util.ArrayList;
import java.util.List;

/**
 * Service layer for review operations.
 */
public class ReviewService {

    private final String filePath;

    public ReviewService(String filePath) {
        this.filePath = filePath;
    }

    /**
     * Add a new review.
     */
    public Review addReview(String userId, String movieId, int rating, String comment) {
        String id = FileUtil.generateNextId(filePath, "RV");
        Review review = new Review(id, userId, movieId, comment, rating);
        FileUtil.appendLine(filePath, review.toFileString());
        return review;
    }

    /**
     * Get all reviews for a specific movie.
     */
    public List<Review> getByMovieId(String movieId) {
        List<Review> results = new ArrayList<>();
        List<String> lines = FileUtil.readAllLines(filePath);
        for (String line : lines) {
            Review r = Review.fromFileString(line);
            if (r != null && r.getMovieId().equalsIgnoreCase(movieId)) {
                results.add(r);
            }
        }
        return results;
    }

    /**
     * Get all reviews by a specific user.
     */
    public List<Review> getByUserId(String userId) {
        List<Review> results = new ArrayList<>();
        List<String> lines = FileUtil.readAllLines(filePath);
        for (String line : lines) {
            Review r = Review.fromFileString(line);
            if (r != null && r.getUserId().equalsIgnoreCase(userId)) {
                results.add(r);
            }
        }
        return results;
    }

    /**
     * Get the average rating for a movie.
     */
    public double getAverageRating(String movieId) {
        List<Review> reviews = getByMovieId(movieId);
        if (reviews.isEmpty()) return 0;
        double sum = 0;
        for (Review r : reviews) {
            sum += r.getRating();
        }
        return sum / reviews.size();
    }

    /**
     * Delete a review by ID.
     */
    public boolean deleteReview(String id) {
        return FileUtil.deleteLine(filePath, id);
    }

    /**
     * Get all reviews.
     */
    public List<Review> getAllReviews() {
        List<Review> reviews = new ArrayList<>();
        List<String> lines = FileUtil.readAllLines(filePath);
        for (String line : lines) {
            Review r = Review.fromFileString(line);
            if (r != null) reviews.add(r);
        }
        return reviews;
    }
}
