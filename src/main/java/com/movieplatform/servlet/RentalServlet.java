package com.movieplatform.servlet;

import com.movieplatform.model.Movie;
import com.movieplatform.model.Rental;
import com.movieplatform.service.MovieService;
import com.movieplatform.service.RentalService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Servlet handling rental operations.
 */
@WebServlet(urlPatterns = {"/rentals/rent", "/rentals/return", "/rentals/my"})
public class RentalServlet extends HttpServlet {

    private RentalService rentalService;
    private MovieService movieService;

    @Override
    public void init() throws ServletException {
        String dataDir = getServletContext().getInitParameter("dataDir");
        if (dataDir == null) dataDir = "src/main/resources/data/";
        rentalService = new RentalService(dataDir + "rentals.txt");
        movieService = new MovieService(dataDir + "movies.txt");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/rentals/my".equals(path)) {
            handleMyRentals(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/rentals/rent":
                handleRentMovie(request, response);
                break;

            case "/rentals/return":
                handleReturnMovie(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/");
        }
    }

    /**
     * Display user's rental history.
     */
    private void handleMyRentals(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String userId = (String) session.getAttribute("userId");
        List<Rental> rentals = rentalService.getByUserId(userId);

        // Attach movie titles for display
        for (Rental r : rentals) {
            Movie movie = movieService.getById(r.getMovieId());
            if (movie != null) {
                request.setAttribute("movieTitle_" + r.getId(), movie.getTitle());
                request.setAttribute("moviePrice_" + r.getId(), movie.getRentalPrice());
            }
        }

        request.setAttribute("rentals", rentals);
        request.getRequestDispatcher("/views/my-rentals.jsp").forward(request, response);
    }

    /**
     * Handle renting a movie.
     */
    private void handleRentMovie(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String userId = (String) session.getAttribute("userId");
        String movieId = request.getParameter("movieId");

        if (movieId == null || movieId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/movies");
            return;
        }

        Rental rental = rentalService.rentMovie(userId, movieId.trim());

        if (rental == null) {
            response.sendRedirect(request.getContextPath() + "/movies/detail?id=" + movieId + "&error=already_rented");
        } else {
            response.sendRedirect(request.getContextPath() + "/rentals/my?success=rented");
        }
    }

    /**
     * Handle returning a rented movie.
     */
    private void handleReturnMovie(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String rentalId = request.getParameter("rentalId");

        if (rentalId != null) {
            rentalService.returnMovie(rentalId.trim());
        }

        response.sendRedirect(request.getContextPath() + "/rentals/my?success=returned");
    }
}
