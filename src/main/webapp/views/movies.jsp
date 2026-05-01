<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="common/header.jsp">
    <jsp:param name="pageTitle" value="Movies"/>
</jsp:include>

<section class="container mb-5">
    <!-- Page Header -->
    <div class="section-header fade-in-up">
        <h1 class="section-title"><i class="bi bi-collection-play me-2" style="color: var(--primary-light);"></i>Movie Catalog</h1>
        <p class="section-subtitle">Browse our full collection of movies available for rent</p>
    </div>

    <!-- Search & Filter Bar -->
    <div class="search-filter-bar fade-in-up fade-in-up-delay-1 mb-4">
        <form action="${pageContext.request.contextPath}/movies" method="get" class="d-flex flex-wrap gap-2 align-items-center">
            <div class="search-box flex-grow-1" style="max-width: 480px; min-width: 220px;">
                <i class="bi bi-search search-icon"></i>
                <input type="text" name="search" id="movieSearchInput"
                       value="${searchQuery}"
                       placeholder="Search by title, genre, or director..."
                       autocomplete="off">
                <button type="submit" class="search-btn">Search</button>
            </div>

            <select name="genre" id="genreFilter" class="form-select" style="max-width: 200px; background: var(--surface); color: var(--text-primary); border: 1px solid var(--border);" onchange="this.form.submit()">
                <option value="all" ${empty selectedGenre || selectedGenre == 'all' ? 'selected' : ''}>All Genres</option>
                <c:forEach var="genre" items="${genres}">
                    <option value="${genre}" ${selectedGenre == genre ? 'selected' : ''}>${genre}</option>
                </c:forEach>
            </select>

            <c:if test="${not empty searchQuery || (not empty selectedGenre && selectedGenre != 'all')}">
                <a href="${pageContext.request.contextPath}/movies" class="btn btn-outline-custom btn-sm">
                    <i class="bi bi-x-circle me-1"></i>Clear
                </a>
            </c:if>
        </form>
    </div>

    <!-- Success/Error Messages -->
    <c:if test="${param.success == 'added'}">
        <div class="alert-success-custom fade-in-up mb-3"><i class="bi bi-check-circle me-2"></i>Movie added successfully!</div>
    </c:if>
    <c:if test="${param.success == 'deleted'}">
        <div class="alert-success-custom fade-in-up mb-3"><i class="bi bi-check-circle me-2"></i>Movie deleted successfully!</div>
    </c:if>

    <!-- Admin Add Button -->
    <c:if test="${sessionScope.userRole == 'ADMIN'}">
        <div class="d-flex justify-content-end mb-3 fade-in-up">
            <a href="${pageContext.request.contextPath}/movies/add" class="btn btn-accent">
                <i class="bi bi-plus-circle me-2"></i>Add New Movie
            </a>
        </div>
    </c:if>

    <!-- Results count -->
    <c:if test="${not empty movies}">
        <p class="text-secondary mb-3 fade-in-up" style="font-size: 0.9rem;">
            Showing <strong style="color: var(--text-primary);">${movies.size()}</strong> movie(s)
            <c:if test="${not empty searchQuery}"> for "<strong style="color: var(--primary-light);">${searchQuery}</strong>"</c:if>
            <c:if test="${not empty selectedGenre && selectedGenre != 'all'}"> in <strong style="color: var(--primary-light);">${selectedGenre}</strong></c:if>
        </p>
    </c:if>

    <!-- Movie Grid -->
    <div class="row g-4">
        <c:forEach var="movie" items="${movies}" varStatus="status">
            <div class="col-lg-3 col-md-4 col-sm-6 movie-card-wrapper fade-in-up" data-genre="${movie.genre}">
                <div class="movie-card">
                    <div class="movie-card-poster poster-${movie.genre == 'Sci-Fi' ? 'sci-fi' : movie.genre == 'Crime' ? 'crime' : movie.genre == 'Action' ? 'action' : movie.genre == 'Drama' ? 'drama' : 'default'}">
                        <div class="poster-gradient">${movie.title.substring(0, 1)}</div>
                        <span class="genre-badge">${movie.genre}</span>
                        <span class="price-badge">$${movie.rentalPrice}</span>
                    </div>
                    <div class="movie-card-body">
                        <h5 class="movie-card-title">
                            <a href="${pageContext.request.contextPath}/movies/detail?id=${movie.id}">${movie.title}</a>
                        </h5>
                        <p class="movie-card-meta">
                            <i class="bi bi-camera-reels me-1"></i>${movie.director} &bull; ${movie.releaseYear}
                        </p>
                        <div class="movie-card-rating">
                            <div class="stars">
                                <c:set var="avgRating" value="${requestScope['rating_'.concat(movie.id)]}"/>
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${avgRating != null && i <= avgRating}">
                                            <i class="bi bi-star-fill"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="bi bi-star"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>
                            <span class="rating-text">
                                <c:set var="revCount" value="${requestScope['reviewCount_'.concat(movie.id)]}"/>
                                (${revCount != null ? revCount : 0} reviews)
                            </span>
                        </div>
                        <div class="movie-card-actions mt-2">
                            <a href="${pageContext.request.contextPath}/movies/detail?id=${movie.id}" class="btn btn-primary-custom btn-sm w-100">
                                <i class="bi bi-eye me-1"></i>View Details
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- Empty State -->
    <c:if test="${empty movies}">
        <div class="empty-state">
            <i class="bi bi-film d-block"></i>
            <h3>No Movies Found</h3>
            <p>
                <c:choose>
                    <c:when test="${not empty searchQuery}">No results for "${searchQuery}". Try a different search term.</c:when>
                    <c:otherwise>No movies are available in this category yet.</c:otherwise>
                </c:choose>
            </p>
            <a href="${pageContext.request.contextPath}/movies" class="btn btn-primary-custom mt-2">Browse All Movies</a>
        </div>
    </c:if>
</section>

<jsp:include page="common/footer.jsp"/>
