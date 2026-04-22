</main>

<!-- Footer -->
<footer class="site-footer">
    <div class="container">
        <div class="row">
            <div class="col-md-4 mb-4 mb-md-0">
                <h5 class="footer-brand"><i class="bi bi-film me-2"></i>CineVault</h5>
                <p class="text-secondary">Your premium destination for movie reviews and rentals. Discover, review, and enjoy the best of cinema.</p>
            </div>
            <div class="col-md-2 mb-4 mb-md-0">
                <h6 class="footer-heading">Explore</h6>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/movies">Movies</a></li>
                </ul>
            </div>
            <div class="col-md-2 mb-4 mb-md-0">
                <h6 class="footer-heading">Account</h6>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/login">Login</a></li>
                    <li><a href="${pageContext.request.contextPath}/register">Sign Up</a></li>
                </ul>
            </div>
            <div class="col-md-4">
                <h6 class="footer-heading">About This Project</h6>
                <p class="text-secondary small">Built with Java Spring Boot, JSP Servlets, and Bootstrap 5. A SLIIT OOP Lab Project demonstrating encapsulation, inheritance, and polymorphism.</p>
            </div>
        </div>
        <hr class="footer-divider">
        <div class="text-center">
            <p class="text-secondary mb-0 small">&copy; 2026 CineVault. All rights reserved.</p>
        </div>
    </div>
</footer>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- Custom JS -->
<script src="${pageContext.request.contextPath}/static/js/app.js"></script>
</body>
</html>
