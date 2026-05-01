<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="common/header.jsp">
    <jsp:param name="pageTitle" value="Add Movie"/>
</jsp:include>

<section class="container mb-5">
    <div class="auth-container">
        <div class="auth-card" style="max-width: 600px;">
            <div class="text-center mb-4">
                <i class="bi bi-film" style="font-size: 3rem; color: var(--primary-light);"></i>
                <h2 class="mt-2">Add New Movie</h2>
                <p class="auth-subtitle">Add a movie to the CineVault catalog</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert-custom mb-3">
                    <i class="bi bi-exclamation-circle me-2"></i>${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/movies/add" method="post" id="addMovieForm" data-validate="true">
                <div class="mb-3">
                    <label for="movieTitle" class="form-label text-secondary">Movie Title <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="movieTitle" name="title"
                           placeholder="e.g. The Dark Knight" required
                           style="background: var(--surface-elevated); color: var(--text-primary); border: 1px solid var(--border); padding: 0.75rem 1rem;">
                </div>

                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label for="movieGenre" class="form-label text-secondary">Genre <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="movieGenre" name="genre"
                               list="genreOptions" placeholder="e.g. Action, Drama, Sci-Fi" required
                               style="background: var(--surface-elevated); color: var(--text-primary); border: 1px solid var(--border); padding: 0.75rem 1rem;">
                        <datalist id="genreOptions">
                            <c:forEach var="g" items="${genres}">
                                <option value="${g}"/>
                            </c:forEach>
                            <option value="Action"/>
                            <option value="Drama"/>
                            <option value="Comedy"/>
                            <option value="Sci-Fi"/>
                            <option value="Crime"/>
                            <option value="Thriller"/>
                            <option value="Horror"/>
                            <option value="Romance"/>
                            <option value="Animation"/>
                            <option value="Documentary"/>
                        </datalist>
                    </div>
                    <div class="col-md-6">
                        <label for="movieDirector" class="form-label text-secondary">Director <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="movieDirector" name="director"
                               placeholder="e.g. Christopher Nolan" required
                               style="background: var(--surface-elevated); color: var(--text-primary); border: 1px solid var(--border); padding: 0.75rem 1rem;">
                    </div>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <label for="movieYear" class="form-label text-secondary">Release Year <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="movieYear" name="releaseYear"
                               placeholder="e.g. 2024" min="1888" max="2099" required
                               style="background: var(--surface-elevated); color: var(--text-primary); border: 1px solid var(--border); padding: 0.75rem 1rem;">
                    </div>
                    <div class="col-md-6">
                        <label for="moviePrice" class="form-label text-secondary">Rental Price ($) <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="moviePrice" name="rentalPrice"
                               placeholder="e.g. 3.99" step="0.01" min="0" required
                               style="background: var(--surface-elevated); color: var(--text-primary); border: 1px solid var(--border); padding: 0.75rem 1rem;">
                    </div>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary-custom flex-grow-1 py-3" id="addMovieBtn">
                        <i class="bi bi-plus-circle me-2"></i>Add Movie
                    </button>
                    <a href="${pageContext.request.contextPath}/movies" class="btn btn-outline-custom py-3" style="min-width: 120px;">
                        <i class="bi bi-x me-1"></i>Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>
</section>

<jsp:include page="common/footer.jsp"/>
