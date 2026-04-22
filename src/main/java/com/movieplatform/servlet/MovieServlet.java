package com.movieplatform.servlet;

import com.movieplatform.model.Movie;
import com.movieplatform.model.Review;
import com.movieplatform.service.MovieService;
import com.movieplatform.service.ReviewService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Servlet handling movie catalog operations.
 */
@WebServlet(urlPatterns = {"/", "/movies", "/movies/detail", "/movies/add", "/movies/update", "/movies/delete"})
public class MovieServlet extends HttpServlet {

    private MovieService movieService;
    private ReviewService reviewService;

    @Override
    public void init() throws ServletException {
        String dataDir = getServletContext().getInitParameter("dataDir");
        if (dataDir == null) dataDir = "src/main/resources/data/";
        movieService = new MovieService(dataDir + "movies.txt");
        reviewService = new ReviewService(dataDir + "reviews.txt");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/":
                handleHome(request, response);
                break;

            case "/movies":
                handleMovieList(request, response);
                break;

            case "/movies/detail":
                handleMovieDetail(request, response);
                break;

            case "/movies/add":
                // Admin check
                HttpSession session = request.getSession(false);
                if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
                request.setAttribute("genres", movieService.getAllGenres());
                request.getRequestDispatcher("/views/movie-form.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/movies/add":
                handleAddMovie(request, response);
                break;

            case "/movies/update":
                handleUpdateMovie(request, response);
                break;

            case "/movies/delete":
                handleDeleteMovie(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/");
        }
    }

    /**
     * Display the home page with featured movies.
     */
    private void handleHome(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Movie> movies = movieService.getAllMovies();

        // Calculate average ratings for each movie
        for (Movie m : movies) {
            double avg = reviewService.getAverageRating(m.getId());
            request.setAttribute("rating_" + m.getId(), avg);
            int reviewCount = reviewService.getByMovieId(m.getId()).size();
            request.setAttribute("reviewCount_" + m.getId(), reviewCount);
        }

        request.setAttribute("movies", movies);
        request.setAttribute("genres", movieService.getAllGenres());
        request.getRequestDispatcher("/views/home.jsp").forward(request, response);
    }

    /**
     * Display movie catalog with search and filter.
     */
    private void handleMovieList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String query = request.getParameter("search");
        String genre = request.getParameter("genre");

        List<Movie> movies;

        if (query != null && !query.trim().isEmpty()) {
            movies = movieService.search(query.trim());
        } else {
            movies = movieService.getAllMovies();
        }

        // Filter by genre if specified
        if (genre != null && !genre.trim().isEmpty() && !"all".equalsIgnoreCase(genre)) {
            movies.removeIf(m -> !m.getGenre().equalsIgnoreCase(genre.trim()));
        }

        // Calculate average ratings
        for (Movie m : movies) {
            double avg = reviewService.getAverageRating(m.getId());
            request.setAttribute("rating_" + m.getId(), avg);
            int reviewCount = reviewService.getByMovieId(m.getId()).size();
            request.setAttribute("reviewCount_" + m.getId(), reviewCount);
        }

        request.setAttribute("movies", movies);
        request.setAttribute("genres", movieService.getAllGenres());
        request.setAttribute("searchQuery", query);
        request.setAttribute("selectedGenre", genre);
        request.getRequestDispatcher("/views/movies.jsp").forward(request, response);
    }

    /**
     * Display a single movie's details with its reviews.
     */
    private void handleMovieDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        if (id == null || id.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/movies");
            return;
        }

        Movie movie = movieService.getById(id.trim());
        if (movie == null) {
            response.sendRedirect(request.getContextPath() + "/movies");
            return;
        }

        List<Review> reviews = reviewService.getByMovieId(id.trim());
        double avgRating = reviewService.getAverageRating(id.trim());

        request.setAttribute("movie", movie);
        request.setAttribute("reviews", reviews);
        request.setAttribute("avgRating", avgRating);
        request.setAttribute("reviewCount", reviews.size());
        request.getRequestDispatcher("/views/movie-detail.jsp").forward(request, response);
    }

    /**
     * Handle adding a new movie (admin only).
     */
    private void handleAddMovie(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String title = request.getParameter("title");
        String genre = request.getParameter("genre");
        String director = request.getParameter("director");
        String yearStr = request.getParameter("releaseYear");
        String priceStr = request.getParameter("rentalPrice");

        try {
            int year = Integer.parseInt(yearStr);
            double price = Double.parseDouble(priceStr);
            movieService.add(title.trim(), genre.trim(), director.trim(), year, price);
            response.sendRedirect(request.getContextPath() + "/movies?success=added");
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid year or price format.");
            request.getRequestDispatcher("/views/movie-form.jsp").forward(request, response);
        }
    }

    /**
     * Handle updating a movie (admin only).
     */
    private void handleUpdateMovie(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String id = request.getParameter("id");
        Movie movie = movieService.getById(id);
        if (movie == null) {
            response.sendRedirect(request.getContextPath() + "/movies");
            return;
        }

        String title = request.getParameter("title");
        String genre = request.getParameter("genre");
        String director = request.getParameter("director");
        String yearStr = request.getParameter("releaseYear");
        String priceStr = request.getParameter("rentalPrice");

        try {
            if (title != null && !title.trim().isEmpty()) movie.setTitle(title.trim());
            if (genre != null && !genre.trim().isEmpty()) movie.setGenre(genre.trim());
            if (director != null && !director.trim().isEmpty()) movie.setDirector(director.trim());
            if (yearStr != null && !yearStr.trim().isEmpty()) movie.setReleaseYear(Integer.parseInt(yearStr));
            if (priceStr != null && !priceStr.trim().isEmpty()) movie.setRentalPrice(Double.parseDouble(priceStr));

            movieService.update(movie);
            response.sendRedirect(request.getContextPath() + "/movies/detail?id=" + id + "&success=updated");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/movies/detail?id=" + id + "&error=invalid");
        }
    }

    /**
     * Handle deleting a movie (admin only).
     */
    private void handleDeleteMovie(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String id = request.getParameter("id");
        if (id != null) {
            movieService.delete(id.trim());
        }

        response.sendRedirect(request.getContextPath() + "/movies?success=deleted");
    }
}
