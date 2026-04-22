<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="common/header.jsp">
    <jsp:param name="pageTitle" value="Login"/>
</jsp:include>

<div class="auth-container fade-in-up">
    <div class="auth-card">
        <div class="text-center mb-4">
            <i class="bi bi-person-circle" style="font-size: 3rem; color: var(--primary-light);"></i>
            <h2>Welcome Back</h2>
            <p class="auth-subtitle">Sign in to access your account</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert-custom">
                <i class="bi bi-exclamation-circle me-2"></i>${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" data-validate="true" id="loginForm">
            <div class="form-floating">
                <input type="email" class="form-control" id="loginEmail" name="email"
                       placeholder="Email" required>
                <label for="loginEmail"><i class="bi bi-envelope me-1"></i>Email address</label>
            </div>

            <div class="form-floating">
                <input type="password" class="form-control" id="loginPassword" name="password"
                       placeholder="Password" required>
                <label for="loginPassword"><i class="bi bi-lock me-1"></i>Password</label>
            </div>

            <button type="submit" class="btn btn-primary-custom w-100 mt-3 py-3" id="loginBtn">
                <i class="bi bi-box-arrow-in-right me-2"></i>Sign In
            </button>
        </form>

        <div class="text-center mt-4">
            <p class="text-secondary mb-0">
                Don't have an account?
                <a href="${pageContext.request.contextPath}/register" style="color: var(--primary-light); text-decoration: none; font-weight: 600;">Create one</a>
            </p>
        </div>
    </div>
</div>

<jsp:include page="common/footer.jsp"/>
