<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="common/header.jsp">
    <jsp:param name="pageTitle" value="${movie.title}"/>
</jsp:include>

<section class="container mb-5">

    <!-- Back Link -->
    <div class="fade-in-up mb-3">
        <a href="${pageContext.request.contextPath}/movies" class="text-secondary text-decoration-none" style="font-size: 0.9rem;">
            <i class="bi bi-arrow-left me-1"></i>Back to Movies
        </a>
    </div>

    <!-- Success/Error Messages -->
    <c:if test="${param.success == 'reviewed'}">
        <div class="alert-success-custom fade-in-up mb-3"><i class="bi bi-check-circle me-2"></i>Your review was submitted successfully!</div>
    </c:if>
    <c:if test="${param.success == 'deleted'}">
        <div class="alert-success-custom fade-in-up mb-3"><i class="bi bi-check-circle me-2"></i>Review deleted.</div>
    </c:if>
    <c:if test="${param.success == 'rented'}">
        <div class="alert-success-custom fade-in-up mb-3"><i class="bi bi-check-circle me-2"></i>Movie rented! Check your <a href="${pageContext.request.contextPath}/rentals/my" style="color:var(--success);">My Rentals</a>.</div>
    </c:if>
    <c:if test="${param.error == 'already_rented'}">
        <div class="alert-custom fade-in-up mb-3"><i class="bi bi-exclamation-circle me-2"></i>You already have an active rental for this movie.</div>
    </c:if>
    <c:if test="${param.error == 'missing'}">
        <div class="alert-custom fade-in-up mb-3"><i class="bi bi-exclamation-circle me-2"></i>Please fill in all review fields.</div>
    </c:if>

    <!-- Movie Detail Card -->
    <div class="movie-detail-card fade-in-up">
        <div class="row g-0">
            <!-- Poster -->
            <div class="col-md-3 col-lg-2">
                <div class="movie-detail-poster poster-${movie.genre == 'Sci-Fi' ? 'sci-fi' : movie.genre == 'Crime' ? 'crime' : movie.genre == 'Action' ? 'action' : movie.genre == 'Drama' ? 'drama' : 'default'}">
                    <div class="poster-gradient-large">${movie.title.substring(0, 1)}</div>
                </div>
            </div>

            <!-- Info -->
            <div class="col-md-9 col-lg-10 p-4">
                <div class="d-flex flex-wrap justify-content-between align-items-start gap-2">
                    <div>
                        <span class="genre-badge-lg">${movie.genre}</span>
                        <h1 class="detail-title mt-2">${movie.title}</h1>
                        <p class="detail-meta">
                            <i class="bi bi-camera-reels me-1"></i> Directed by <strong>${movie.director}</strong>
                            &nbsp;&bull;&nbsp;
                            <i class="bi bi-calendar me-1"></i> ${movie.releaseYear}
                        </p>
                    </div>
                    <div class="text-end">
                        <div class="rental-price-badge">$${movie.rentalPrice} <span style="font-size:0.7rem;opacity:0.7;">/rental</span></div>
                    </div>
                </div>

                <!-- Rating Summary -->
                <div class="rating-summary mt-3 mb-4">
                    <div class="stars stars-lg">
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
                    <span class="rating-score">
                        <c:choose>
                            <c:when test="${avgRating > 0}"><fmt:formatNumber value="${avgRating}" maxFractionDigits="1"/> / 5</c:when>
                            <c:otherwise>No ratings yet</c:otherwise>
                        </c:choose>
                    </span>
                    <span class="rating-count">&nbsp;(${reviewCount} review${reviewCount != 1 ? 's' : ''})</span>
                </div>

                <!-- Action Buttons -->
                <div class="d-flex flex-wrap gap-2">
                    <c:choose>
                        <c:when test="${sessionScope.userId != null}">
                            <form action="${pageContext.request.contextPath}/rentals/rent" method="post" class="d-inline" id="rentForm-${movie.id}">
                                <input type="hidden" name="movieId" value="${movie.id}">
                                <button type="submit" class="btn btn-accent" id="rentBtn-${movie.id}">
                                    <i class="bi bi-bag-plus me-2"></i>Rent This Movie
                                </button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary-custom">
                                <i class="bi bi-box-arrow-in-right me-2"></i>Login to Rent
                            </a>
                        </c:otherwise>
                    </c:choose>

                    <!-- Admin Actions -->
                    <c:if test="${sessionScope.userRole == 'ADMIN'}">
                        <button class="btn btn-outline-custom" data-bs-toggle="modal" data-bs-target="#editMovieModal">
                            <i class="bi bi-pencil me-1"></i>Edit
                        </button>
                        <form action="${pageContext.request.contextPath}/movies/delete" method="post" class="d-inline" onsubmit="return confirm('Delete this movie permanently?')">
                            <input type="hidden" name="id" value="${movie.id}">
                            <button type="submit" class="btn btn-danger-custom">
                                <i class="bi bi-trash me-1"></i>Delete
                            </button>
                        </form>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Reviews Section -->
    <div class="row mt-5">
        <div class="col-lg-8">
            <h2 class="section-title fade-in-up" style="font-size: 1.5rem;">
                <i class="bi bi-chat-square-quote me-2" style="color: var(--primary-light);"></i>Reviews
                <span class="badge-count ms-2">${reviewCount}</span>
            </h2>

            <!-- Write Review Form -->
            <c:if test="${sessionScope.userId != null}">
                <div class="review-form-card fade-in-up mt-3 mb-4">
                    <h5 class="mb-3"><i class="bi bi-pencil-square me-2"></i>Write a Review</h5>
                    <form action="${pageContext.request.contextPath}/reviews/add" method="post" id="reviewForm">
                        <input type="hidden" name="movieId" value="${movie.id}">
                        <div class="mb-3">
                            <label class="form-label text-secondary" style="font-size:0.85rem;">Rating</label>
                            <div class="star-picker" id="starPicker">
                                <c:forEach begin="1" end="5" var="i">
                                    <i class="bi bi-star star-pick" data-val="${i}" id="star-${i}"></i>
                                </c:forEach>
                            </div>
                            <input type="hidden" name="rating" id="ratingInput" value="5">
                        </div>
                        <div class="mb-3">
                            <label for="commentInput" class="form-label text-secondary" style="font-size:0.85rem;">Comment</label>
                            <textarea class="form-control" id="commentInput" name="comment" rows="3"
                                      placeholder="Share your thoughts on this movie..." required
                                      style="background: var(--surface-elevated); color: var(--text-primary); border: 1px solid var(--border); resize: none;"></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary-custom" id="submitReviewBtn">
                            <i class="bi bi-send me-2"></i>Submit Review
                        </button>
                    </form>
                </div>
            </c:if>
            <c:if test="${sessionScope.userId == null}">
                <div class="review-form-card fade-in-up mt-3 mb-4 text-center py-4">
                    <i class="bi bi-person-lock" style="font-size: 2rem; color: var(--text-secondary);"></i>
                    <p class="mt-2 text-secondary">Please <a href="${pageContext.request.contextPath}/login" style="color: var(--primary-light);">login</a> to write a review.</p>
                </div>
            </c:if>

            <!-- Review List -->
            <c:forEach var="review" items="${reviews}">
                <div class="review-card fade-in-up">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <div class="review-author">
                            <i class="bi bi-person-circle me-1"></i>
                            <span class="review-user-id">User ${review.userId}</span>
                        </div>
                        <div class="stars stars-sm">
                            <c:forEach begin="1" end="5" var="i">
                                <c:choose>
                                    <c:when test="${i <= review.rating}">
                                        <i class="bi bi-star-fill"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="bi bi-star"></i>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            <span class="ms-1" style="color: var(--text-secondary); font-size: 0.8rem;">${review.rating}/5</span>
                        </div>
                    </div>
                    <p class="review-comment">${review.comment}</p>
                    <c:if test="${sessionScope.userRole == 'ADMIN' || sessionScope.userId == review.userId}">
                        <div class="text-end">
                            <form action="${pageContext.request.contextPath}/reviews/delete" method="post" class="d-inline" onsubmit="return confirm('Delete this review?')">
                                <input type="hidden" name="reviewId" value="${review.id}">
                                <input type="hidden" name="movieId" value="${movie.id}">
                                <button type="submit" class="btn btn-sm btn-danger-custom"><i class="bi bi-trash"></i> Delete</button>
                            </form>
                        </div>
                    </c:if>
                </div>
            </c:forEach>

            <c:if test="${empty reviews}">
                <div class="empty-state" style="padding: 3rem 2rem;">
                    <i class="bi bi-chat-square d-block"></i>
                    <h4>No Reviews Yet</h4>
                    <p>Be the first to review this movie!</p>
                </div>
            </c:if>
        </div>

        <!-- Sidebar -->
        <div class="col-lg-4 mt-4 mt-lg-0">
            <div class="sidebar-card fade-in-up">
                <h6 class="sidebar-title"><i class="bi bi-info-circle me-2"></i>Movie Info</h6>
                <table class="info-table">
                    <tr><td class="info-label">ID</td><td>${movie.id}</td></tr>
                    <tr><td class="info-label">Title</td><td>${movie.title}</td></tr>
                    <tr><td class="info-label">Genre</td><td><span class="genre-badge-sm">${movie.genre}</span></td></tr>
                    <tr><td class="info-label">Director</td><td>${movie.director}</td></tr>
                    <tr><td class="info-label">Year</td><td>${movie.releaseYear}</td></tr>
                    <tr><td class="info-label">Price</td><td class="price-highlight">$${movie.rentalPrice}/rental</td></tr>
                </table>
            </div>
        </div>
    </div>
</section>

<!-- Edit Movie Modal (Admin Only) -->
<c:if test="${sessionScope.userRole == 'ADMIN'}">
<div class="modal fade" id="editMovieModal" tabindex="-1" aria-labelledby="editMovieModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="background: var(--surface); border: 1px solid var(--border);">
            <div class="modal-header border-0">
                <h5 class="modal-title" id="editMovieModalLabel"><i class="bi bi-pencil-square me-2"></i>Edit Movie</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/movies/update" method="post" id="editMovieForm">
                    <input type="hidden" name="id" value="${movie.id}">
                    <div class="mb-3">
                        <label class="form-label text-secondary">Title</label>
                        <input type="text" class="form-control" name="title" value="${movie.title}" required
                               style="background: var(--surface-elevated); color: var(--text-primary); border: 1px solid var(--border);">
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-secondary">Genre</label>
                        <input type="text" class="form-control" name="genre" value="${movie.genre}" required
                               style="background: var(--surface-elevated); color: var(--text-primary); border: 1px solid var(--border);">
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-secondary">Director</label>
                        <input type="text" class="form-control" name="director" value="${movie.director}" required
                               style="background: var(--surface-elevated); color: var(--text-primary); border: 1px solid var(--border);">
                    </div>
                    <div class="row g-2">
                        <div class="col-6">
                            <label class="form-label text-secondary">Release Year</label>
                            <input type="number" class="form-control" name="releaseYear" value="${movie.releaseYear}" min="1900" max="2099"
                                   style="background: var(--surface-elevated); color: var(--text-primary); border: 1px solid var(--border);">
                        </div>
                        <div class="col-6">
                            <label class="form-label text-secondary">Rental Price ($)</label>
                            <input type="number" class="form-control" name="rentalPrice" value="${movie.rentalPrice}" step="0.01" min="0"
                                   style="background: var(--surface-elevated); color: var(--text-primary); border: 1px solid var(--border);">
                        </div>
                    </div>
                    <div class="d-grid mt-4">
                        <button type="submit" class="btn btn-primary-custom" id="saveMovieBtn">
                            <i class="bi bi-save me-2"></i>Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</c:if>

<script>
    // Star picker for review form
    (function () {
        var stars = document.querySelectorAll('.star-pick');
        var ratingInput = document.getElementById('ratingInput');
        if (!stars.length) return;
        var currentRating = parseInt(ratingInput.value) || 5;
        highlightStars(currentRating);

        stars.forEach(function (star) {
            star.addEventListener('mouseenter', function () {
                highlightStars(parseInt(star.dataset.val));
            });
            star.addEventListener('mouseleave', function () {
                highlightStars(currentRating);
            });
            star.addEventListener('click', function () {
                currentRating = parseInt(star.dataset.val);
                ratingInput.value = currentRating;
                highlightStars(currentRating);
            });
        });

        function highlightStars(n) {
            stars.forEach(function (s) {
                var v = parseInt(s.dataset.val);
                if (v <= n) {
                    s.classList.remove('bi-star');
                    s.classList.add('bi-star-fill', 'active');
                } else {
                    s.classList.remove('bi-star-fill', 'active');
                    s.classList.add('bi-star');
                }
            });
        }
    })();
</script>

<jsp:include page="common/footer.jsp"/>
