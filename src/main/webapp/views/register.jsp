<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="common/header.jsp">
    <jsp:param name="pageTitle" value="Register"/>
</jsp:include>

<div class="auth-container fade-in-up">
    <div class="auth-card">
        <div class="text-center mb-4">
            <i class="bi bi-person-plus" style="font-size: 3rem; color: var(--success);"></i>
            <h2>Create Account</h2>
            <p class="auth-subtitle">Join CineVault and start exploring movies</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert-custom">
                <i class="bi bi-exclamation-circle me-2"></i>${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post" data-validate="true" id="registerForm">
            <div class="form-floating">
                <input type="text" class="form-control" id="registerName" name="name"
                       placeholder="Full Name" required>
                <label for="registerName"><i class="bi bi-person me-1"></i>Full Name</label>
            </div>

            <div class="form-floating">
                <input type="email" class="form-control" id="registerEmail" name="email"
                       placeholder="Email" required>
                <label for="registerEmail"><i class="bi bi-envelope me-1"></i>Email address</label>
            </div>

            <div class="form-floating">
                <input type="password" class="form-control" id="registerPassword" name="password"
                       placeholder="Password" required>
                <label for="registerPassword"><i class="bi bi-lock me-1"></i>Password</label>
            </div>

            <button type="submit" class="btn btn-primary-custom w-100 mt-3 py-3" id="registerBtn">
                <i class="bi bi-person-plus me-2"></i>Create Account
            </button>
        </form>

        <div class="text-center mt-4">
            <p class="text-secondary mb-0">
                Already have an account?
                <a href="${pageContext.request.contextPath}/login" style="color: var(--primary-light); text-decoration: none; font-weight: 600;">Sign In</a>
            </p>
        </div>
    </div>
</div>

<jsp:include page="common/footer.jsp"/>
