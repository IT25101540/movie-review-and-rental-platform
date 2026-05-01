<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../common/header.jsp">
    <jsp:param name="pageTitle" value="Manage Users"/>
</jsp:include>

<section class="container mb-5">
    <div class="section-header fade-in-up">
        <h1 class="section-title"><i class="bi bi-people me-2" style="color: var(--primary-light);"></i>User Management</h1>
        <p class="section-subtitle">Admin panel — view, search, update, and delete users</p>
    </div>

    <!-- Success Messages -->
    <c:if test="${param.success == 'updated'}">
        <div class="alert-success-custom fade-in-up mb-3"><i class="bi bi-check-circle me-2"></i>User updated successfully!</div>
    </c:if>
    <c:if test="${param.success == 'deleted'}">
        <div class="alert-success-custom fade-in-up mb-3"><i class="bi bi-check-circle me-2"></i>User deleted successfully!</div>
    </c:if>

    <!-- Search Bar -->
    <div class="search-filter-bar fade-in-up mb-4">
        <form action="${pageContext.request.contextPath}/users" method="get" class="d-flex flex-wrap gap-2 align-items-center">
            <div class="search-box" style="max-width: 340px; min-width: 200px;">
                <i class="bi bi-search search-icon"></i>
                <input type="text" name="name" id="userSearchName"
                       value="${searchName}" placeholder="Search by name...">
                <button type="submit" class="search-btn">Search</button>
            </div>
            <div class="search-box" style="max-width: 240px; min-width: 160px;">
                <i class="bi bi-person-badge search-icon"></i>
                <input type="text" name="id" id="userSearchId"
                       value="${searchId}" placeholder="Search by ID...">
            </div>
            <c:if test="${not empty searchId || not empty searchName}">
                <a href="${pageContext.request.contextPath}/users" class="btn btn-outline-custom btn-sm">
                    <i class="bi bi-x-circle me-1"></i>Clear
                </a>
            </c:if>
        </form>
    </div>

    <!-- Stats Row -->
    <c:if test="${not empty users}">
        <p class="text-secondary mb-3 fade-in-up" style="font-size:0.9rem;">
            Showing <strong style="color: var(--text-primary);">${users.size()}</strong> user(s)
        </p>
    </c:if>

    <!-- Users Table -->
    <c:choose>
        <c:when test="${not empty users}">
            <div class="admin-table-wrapper fade-in-up">
                <table class="admin-table" id="usersTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th style="text-align:center;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${users}">
                            <tr>
                                <td><code style="color: var(--primary-light); font-size: 0.85rem;">${user.id}</code></td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="user-avatar-mini">
                                            ${user.name.substring(0, 1).toUpperCase()}
                                        </div>
                                        <span>${user.name}</span>
                                    </div>
                                </td>
                                <td class="text-secondary">${user.email}</td>
                                <td>
                                    <span class="status-badge ${user.role == 'ADMIN' ? 'role-admin' : 'role-user'}">
                                        <i class="bi bi-${user.role == 'ADMIN' ? 'shield-check' : 'person-check'} me-1"></i>
                                        ${user.role}
                                    </span>
                                </td>
                                <td>
                                    <div class="d-flex gap-2 justify-content-center">
                                        <button class="btn btn-sm btn-outline-custom"
                                                data-bs-toggle="modal"
                                                data-bs-target="#editUserModal-${user.id}"
                                                id="editBtn-${user.id}">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <c:if test="${user.id != sessionScope.userId}">
                                            <form action="${pageContext.request.contextPath}/users/delete" method="post" class="d-inline" onsubmit="return confirm('Delete user ${user.name}? This cannot be undone.')">
                                                <input type="hidden" name="id" value="${user.id}">
                                                <button type="submit" class="btn btn-sm btn-danger-custom" id="deleteBtn-${user.id}">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${user.id == sessionScope.userId}">
                                            <span class="text-secondary" style="font-size:0.75rem;line-height:2.2rem;">(you)</span>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>

                            <!-- Edit User Modal -->
                            <div class="modal fade" id="editUserModal-${user.id}" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered">
                                    <div class="modal-content" style="background: var(--surface); border: 1px solid var(--border);">
                                        <div class="modal-header border-0">
                                            <h5 class="modal-title"><i class="bi bi-pencil-square me-2"></i>Edit User — ${user.name}</h5>
                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <form action="${pageContext.request.contextPath}/users/update" method="post">
                                                <input type="hidden" name="id" value="${user.id}">
                                                <div class="mb-3">
                                                    <label class="form-label text-secondary">Full Name</label>
                                                    <input type="text" class="form-control" name="name" value="${user.name}" required
                                                           style="background: var(--surface-elevated); color: var(--text-primary); border: 1px solid var(--border);">
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label text-secondary">Email</label>
                                                    <input type="email" class="form-control" name="email" value="${user.email}" required
                                                           style="background: var(--surface-elevated); color: var(--text-primary); border: 1px solid var(--border);">
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label text-secondary">
                                                        New Password <span style="font-size:0.78rem; opacity:0.6;">(blank = unchanged)</span>
                                                    </label>
                                                    <input type="password" class="form-control" name="password" placeholder="Leave blank to keep current"
                                                           style="background: var(--surface-elevated); color: var(--text-primary); border: 1px solid var(--border);">
                                                </div>
                                                <div class="d-grid mt-4">
                                                    <button type="submit" class="btn btn-primary-custom">
                                                        <i class="bi bi-save me-2"></i>Save Changes
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state fade-in-up">
                <i class="bi bi-people d-block"></i>
                <h3>No Users Found</h3>
                <p>
                    <c:choose>
                        <c:when test="${not empty searchId || not empty searchName}">No users match your search criteria.</c:when>
                        <c:otherwise>No users are registered in the system.</c:otherwise>
                    </c:choose>
                </p>
                <a href="${pageContext.request.contextPath}/users" class="btn btn-primary-custom mt-2">View All Users</a>
            </div>
        </c:otherwise>
    </c:choose>
</section>

<jsp:include page="../common/footer.jsp"/>
