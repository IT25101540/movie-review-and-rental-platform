<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="common/header.jsp">
    <jsp:param name="pageTitle" value="My Profile"/>
</jsp:include>

<section class="container mb-5">
    <div class="section-header fade-in-up">
        <h1 class="section-title"><i class="bi bi-person-circle me-2" style="color: var(--primary-light);"></i>My Profile</h1>
        <p class="section-subtitle">View and update your account information</p>
    </div>

    <!-- Success/Error Messages -->
    <c:if test="${param.success == 'updated'}">
        <div class="alert-success-custom fade-in-up mb-3"><i class="bi bi-check-circle me-2"></i>Profile updated successfully!</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert-custom fade-in-up mb-3"><i class="bi bi-exclamation-circle me-2"></i>${error}</div>
    </c:if>

    <div class="row g-4">
        <!-- Profile Card -->
        <div class="col-lg-4">
            <div class="profile-card fade-in-up">
                <div class="profile-avatar">
                    <i class="bi bi-person-circle"></i>
                </div>
                <h3 class="profile-name">${profileUser.name}</h3>
                <p class="profile-email">${profileUser.email}</p>
                <span class="profile-role-badge ${profileUser.role == 'ADMIN' ? 'role-admin' : 'role-user'}">
                    <i class="bi bi-${profileUser.role == 'ADMIN' ? 'shield-check' : 'person-check'} me-1"></i>
                    ${profileUser.role}
                </span>
                <div class="profile-id-tag mt-3">
                    <i class="bi bi-fingerprint me-1"></i>ID: ${profileUser.id}
                </div>
            </div>
        </div>

        <!-- Edit Form -->
        <div class="col-lg-8">
            <div class="edit-profile-card fade-in-up fade-in-up-delay-1">
                <h4 class="mb-4"><i class="bi bi-gear me-2" style="color: var(--primary-light);"></i>Edit Profile</h4>
                <form action="${pageContext.request.contextPath}/users/update" method="post" id="profileForm" data-validate="true">
                    <input type="hidden" name="id" value="${profileUser.id}">

                    <div class="mb-4">
                        <label for="profileName" class="form-label text-secondary">Full Name</label>
                        <input type="text" class="form-control profile-input" id="profileName" name="name"
                               value="${profileUser.name}" required
                               placeholder="Your full name">
                    </div>

                    <div class="mb-4">
                        <label for="profileEmail" class="form-label text-secondary">Email Address</label>
                        <input type="email" class="form-control profile-input" id="profileEmail" name="email"
                               value="${profileUser.email}" required
                               placeholder="your@email.com">
                    </div>

                    <div class="mb-4">
                        <label for="profilePassword" class="form-label text-secondary">
                            New Password <span class="text-secondary" style="font-size: 0.8rem;">(leave blank to keep current)</span>
                        </label>
                        <div class="input-group">
                            <input type="password" class="form-control profile-input" id="profilePassword" name="password"
                                   placeholder="Enter new password (optional)">
                            <button class="btn btn-outline-custom" type="button" onclick="togglePassword('profilePassword', this)" id="togglePassBtn">
                                <i class="bi bi-eye"></i>
                            </button>
                        </div>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-primary-custom py-3 flex-grow-1" id="saveProfileBtn">
                            <i class="bi bi-save me-2"></i>Save Changes
                        </button>
                        <a href="${pageContext.request.contextPath}/rentals/my" class="btn btn-outline-custom py-3" style="min-width: 150px;">
                            <i class="bi bi-bag me-1"></i>My Rentals
                        </a>
                    </div>
                </form>
            </div>

            <!-- Quick Links -->
            <div class="quick-links-card fade-in-up fade-in-up-delay-2 mt-4">
                <h6 class="mb-3 text-secondary"><i class="bi bi-lightning me-2"></i>Quick Links</h6>
                <div class="d-flex flex-wrap gap-2">
                    <a href="${pageContext.request.contextPath}/rentals/my" class="btn btn-sm btn-outline-custom">
                        <i class="bi bi-bag me-1"></i>My Rentals
                    </a>
                    <a href="${pageContext.request.contextPath}/movies" class="btn btn-sm btn-outline-custom">
                        <i class="bi bi-collection-play me-1"></i>Browse Movies
                    </a>
                    <c:if test="${sessionScope.userRole == 'ADMIN'}">
                        <a href="${pageContext.request.contextPath}/users" class="btn btn-sm btn-accent">
                            <i class="bi bi-people me-1"></i>Manage Users
                        </a>
                        <a href="${pageContext.request.contextPath}/movies/add" class="btn btn-sm btn-accent">
                            <i class="bi bi-plus-circle me-1"></i>Add Movie
                        </a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-danger-custom">
                        <i class="bi bi-box-arrow-right me-1"></i>Logout
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
    function togglePassword(inputId, btn) {
        var input = document.getElementById(inputId);
        var icon = btn.querySelector('i');
        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.replace('bi-eye', 'bi-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.replace('bi-eye-slash', 'bi-eye');
        }
    }
</script>

<jsp:include page="common/footer.jsp"/>
