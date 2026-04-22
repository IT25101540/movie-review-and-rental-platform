package com.movieplatform.servlet;

import com.movieplatform.model.Review;
import com.movieplatform.service.ReviewService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet handling review operations.
 */
@WebServlet(urlPatterns = {"/reviews/add", "/reviews/delete"})
public class ReviewServlet extends HttpServlet {

    private ReviewService reviewService;

    @Override
    public void init() throws ServletException {
        String dataDir = getServletContext().getInitParameter("dataDir");
        if (dataDir == null) dataDir = "src/main/resources/data/";
        reviewService = new ReviewService(dataDir + "reviews.txt");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/reviews/add":
                handleAddReview(request, response);
                break;

            case "/reviews/delete":
                handleDeleteReview(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/");
        }
    }

    /**
     * Handle submitting a new review.
     */
    private void handleAddReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String userId = (String) session.getAttribute("userId");
        String movieId = request.getParameter("movieId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        if (movieId == null || ratingStr == null || comment == null ||
                movieId.trim().isEmpty() || comment.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/movies/detail?id=" + movieId + "&error=missing");
            return;
        }

        try {
            int rating = Integer.parseInt(ratingStr);
            rating = Math.max(1, Math.min(5, rating)); // clamp 1-5

            reviewService.addReview(userId, movieId.trim(), rating, comment.trim());
            response.sendRedirect(request.getContextPath() + "/movies/detail?id=" + movieId + "&success=reviewed");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/movies/detail?id=" + movieId + "&error=invalid");
        }
    }

    /**
     * Handle deleting a review (admin or review owner).
     */
    private void handleDeleteReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String reviewId = request.getParameter("reviewId");
        String movieId = request.getParameter("movieId");

        if (reviewId != null) {
            reviewService.deleteReview(reviewId.trim());
        }

        response.sendRedirect(request.getContextPath() + "/movies/detail?id=" + movieId + "&success=deleted");
    }
}
