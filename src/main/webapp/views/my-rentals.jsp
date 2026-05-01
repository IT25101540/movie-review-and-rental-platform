<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="common/header.jsp">
    <jsp:param name="pageTitle" value="My Rentals"/>
</jsp:include>

<section class="container mb-5">
    <div class="section-header fade-in-up">
        <h1 class="section-title"><i class="bi bi-bag me-2" style="color: var(--primary-light);"></i>My Rentals</h1>
        <p class="section-subtitle">Your current and past movie rentals</p>
    </div>

    <!-- Success Messages -->
    <c:if test="${param.success == 'rented'}">
        <div class="alert-success-custom fade-in-up mb-3"><i class="bi bi-check-circle me-2"></i>Movie rented successfully!</div>
    </c:if>
    <c:if test="${param.success == 'returned'}">
        <div class="alert-success-custom fade-in-up mb-3"><i class="bi bi-check-circle me-2"></i>Movie returned successfully!</div>
    </c:if>

    <!-- Stats Summary -->
    <c:if test="${not empty rentals}">
        <div class="row g-3 mb-4 fade-in-up">
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-icon"><i class="bi bi-bag-check"></i></div>
                    <div>
                        <div class="stat-value">${rentals.size()}</div>
                        <div class="stat-label">Total Rentals</div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-icon" style="color: var(--success);"><i class="bi bi-play-circle"></i></div>
                    <div>
                        <%-- Count active rentals --%>
                        <c:set var="activeCount" value="0"/>
                        <c:forEach var="r" items="${rentals}">
                            <c:if test="${r.status == 'ACTIVE'}">
                                <c:set var="activeCount" value="${activeCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        <div class="stat-value">${activeCount}</div>
                        <div class="stat-label">Active Rentals</div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-icon" style="color: var(--text-secondary);"><i class="bi bi-archive"></i></div>
                    <div>
                        <div class="stat-value">${rentals.size() - activeCount}</div>
                        <div class="stat-label">Returned</div>
                    </div>
                </div>
            </div>
        </div>
    </c:if>

    <!-- Rental List -->
    <c:choose>
        <c:when test="${not empty rentals}">
            <div class="rentals-list">
                <c:forEach var="rental" items="${rentals}" varStatus="status">
                    <div class="rental-row fade-in-up" style="animation-delay: ${status.index * 0.05}s;">
                        <div class="rental-poster-mini poster-${requestScope['movieGenre_'.concat(rental.id)] == 'Sci-Fi' ? 'sci-fi' : 'default'}">
                            <c:set var="movieTitle" value="${requestScope['movieTitle_'.concat(rental.id)]}"/>
                            ${not empty movieTitle ? movieTitle.substring(0, 1) : '?'}
                        </div>
                        <div class="rental-info flex-grow-1">
                            <h5 class="rental-movie-title">
                                <c:choose>
                                    <c:when test="${not empty movieTitle}">
                                        <a href="${pageContext.request.contextPath}/movies/detail?id=${rental.movieId}">${movieTitle}</a>
                                    </c:when>
                                    <c:otherwise>Movie ID: ${rental.movieId}</c:otherwise>
                                </c:choose>
                            </h5>
                            <div class="rental-meta d-flex flex-wrap gap-3">
                                <span><i class="bi bi-calendar-plus me-1"></i>Rented: <strong>${rental.rentalDate}</strong></span>
                                <span><i class="bi bi-calendar-check me-1"></i>Due: <strong>${rental.returnDate}</strong></span>
                                <c:set var="moviePrice" value="${requestScope['moviePrice_'.concat(rental.id)]}"/>
                                <c:if test="${not empty moviePrice}">
                                    <span><i class="bi bi-currency-dollar me-1"></i>Price: <strong>$${moviePrice}</strong></span>
                                </c:if>
                            </div>
                        </div>
                        <div class="rental-actions">
                            <c:choose>
                                <c:when test="${rental.status == 'ACTIVE'}">
                                    <span class="status-badge status-active"><i class="bi bi-circle-fill me-1" style="font-size:0.5rem;"></i>Active</span>
                                    <form action="${pageContext.request.contextPath}/rentals/return" method="post" class="d-inline ms-2" onsubmit="return confirm('Return this movie?')">
                                        <input type="hidden" name="rentalId" value="${rental.id}">
                                        <button type="submit" class="btn btn-sm btn-outline-custom" id="returnBtn-${rental.id}">
                                            <i class="bi bi-arrow-return-left me-1"></i>Return
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge status-returned"><i class="bi bi-check-circle me-1"></i>Returned</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state fade-in-up">
                <i class="bi bi-bag d-block"></i>
                <h3>No Rentals Yet</h3>
                <p>You haven't rented any movies yet. Browse our catalog and start watching!</p>
                <a href="${pageContext.request.contextPath}/movies" class="btn btn-primary-custom mt-2">
                    <i class="bi bi-collection-play me-2"></i>Browse Movies
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</section>

<jsp:include page="common/footer.jsp"/>
