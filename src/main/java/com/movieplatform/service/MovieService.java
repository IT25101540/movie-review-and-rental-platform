package com.movieplatform.service;

import com.movieplatform.model.Movie;
import com.movieplatform.util.FileUtil;

import java.util.ArrayList;
import java.util.List;

/**
 * Service layer for movie catalog operations.
 */
public class MovieService {

    private final String filePath;

    public MovieService(String filePath) {
        this.filePath = filePath;
    }

    /**
     * Get all movies in the catalog.
     */
    public List<Movie> getAllMovies() {
        List<Movie> movies = new ArrayList<>();
        List<String> lines = FileUtil.readAllLines(filePath);
        for (String line : lines) {
            Movie m = Movie.fromFileString(line);
            if (m != null) movies.add(m);
        }
        return movies;
    }

    /**
     * Find a movie by its ID.
     */
    public Movie getById(String id) {
        String line = FileUtil.findById(filePath, id);
        if (line == null) return null;
        return Movie.fromFileString(line);
    }

    /**
     * Search movies by title or genre (case-insensitive partial match).
     */
    public List<Movie> search(String query) {
        List<Movie> results = new ArrayList<>();
        List<String> lines = FileUtil.readAllLines(filePath);
        String q = query.toLowerCase();
        for (String line : lines) {
            Movie m = Movie.fromFileString(line);
            if (m != null && (m.getTitle().toLowerCase().contains(q)
                    || m.getGenre().toLowerCase().contains(q)
                    || m.getDirector().toLowerCase().contains(q))) {
                results.add(m);
            }
        }
        return results;
    }

    /**
     * Get all unique genres from the movie catalog.
     */
    public List<String> getAllGenres() {
        List<String> genres = new ArrayList<>();
        List<Movie> movies = getAllMovies();
        for (Movie m : movies) {
            if (!genres.contains(m.getGenre())) {
                genres.add(m.getGenre());
            }
        }
        return genres;
    }

    /**
     * Add a new movie to the catalog.
     */
    public Movie add(String title, String genre, String director, int releaseYear, double rentalPrice) {
        String id = FileUtil.generateNextId(filePath, "M");
        Movie movie = new Movie(id, title, genre, director, releaseYear, rentalPrice);
        FileUtil.appendLine(filePath, movie.toFileString());
        return movie;
    }

    /**
     * Update an existing movie.
     */
    public boolean update(Movie movie) {
        return FileUtil.updateLine(filePath, movie.getId(), movie.toFileString());
    }

    /**
     * Delete a movie by ID.
     */
    public boolean delete(String id) {
        return FileUtil.deleteLine(filePath, id);
    }
}
