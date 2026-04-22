<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="common/header.jsp">
    <jsp:param name="pageTitle" value="Home"/>
</jsp:include>

<!-- Hero Section -->
<section class="hero-section">
    <div class="container">
        <div class="fade-in-up">
            <h1 class="hero-title">
                Discover & Rent<br>
                <span class="gradient-text">Amazing Movies</span>
            </h1>
            <p class="hero-subtitle">
                Browse our curated collection, read reviews from fellow cinephiles, and rent your favorites instantly.
            </p>
        </div>

        <div class="search-container fade-in-up fade-in-up-delay-1">
            <form action="${pageContext.request.contextPath}/movies" method="get">
                <div class="search-box">
                    <i class="bi bi-search search-icon"></i>
                    <input type="text" name="search" placeholder="Search movies by title, genre, or director..."
                           id="homeSearchInput" autocomplete="off">
                    <button type="submit" class="search-btn">Search</button>
                </div>
            </form>
        </div>
    </div>
</section>

<!-- Featured Movies Section -->
<section class="container mb-5">
    <div class="section-header fade-in-up fade-in-up-delay-2">
        <h2 class="section-title"><i class="bi bi-fire me-2" style="color: var(--accent);"></i>Featured Movies</h2>
        <p class="section-subtitle">Hand-picked selection from our catalog</p>
    </div>

    <div class="row g-4">
        <c:forEach var="movie" items="${movies}" varStatus="status">
            <div class="col-lg-3 col-md-4 col-sm-6 movie-card-wrapper fade-in-up fade-in-up-delay-${status.index % 4 + 1}"
                 data-genre="${movie.genre}">
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
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <c:if test="${empty movies}">
        <div class="empty-state">
            <i class="bi bi-film d-block"></i>
            <h3>No Movies Yet</h3>
            <p>Check back soon for our latest releases!</p>
        </div>
    </c:if>

    <div class="text-center mt-4 fade-in-up">
        <a href="${pageContext.request.contextPath}/movies" class="btn btn-outline-custom">
            <i class="bi bi-grid me-1"></i>View All Movies
        </a>
    </div>
</section>

<jsp:include page="common/footer.jsp"/>
