/**
 * CineVault - Client-side JavaScript
 * Handles: navbar scroll effect, star rating widget, form validation, search filtering
 */

document.addEventListener('DOMContentLoaded', function () {

    // --- Navbar Scroll Effect ---
    const navbar = document.getElementById('mainNavbar');
    if (navbar) {
        window.addEventListener('scroll', function () {
            if (window.scrollY > 50) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });
    }

    // --- Star Rating Widget ---
    const starRatingContainers = document.querySelectorAll('.star-rating');
    starRatingContainers.forEach(function (container) {
        const inputs = container.querySelectorAll('input[type="radio"]');
        const labels = container.querySelectorAll('label');

        labels.forEach(function (label) {
            label.addEventListener('click', function () {
                const value = this.getAttribute('for').replace('star', '');
                const hiddenInput = document.getElementById('ratingValue');
                if (hiddenInput) {
                    hiddenInput.value = value;
                }
            });
        });
    });

    // --- Form Validation ---
    const forms = document.querySelectorAll('form[data-validate]');
    forms.forEach(function (form) {
        form.addEventListener('submit', function (e) {
            let isValid = true;
            const requiredFields = form.querySelectorAll('[required]');

            requiredFields.forEach(function (field) {
                removeError(field);
                if (!field.value.trim()) {
                    isValid = false;
                    showError(field, 'This field is required.');
                }
            });

            // Email validation
            const emailFields = form.querySelectorAll('input[type="email"]');
            emailFields.forEach(function (field) {
                if (field.value.trim() && !isValidEmail(field.value.trim())) {
                    isValid = false;
                    showError(field, 'Please enter a valid email address.');
                }
            });

            // Password minimum length
            const passwordFields = form.querySelectorAll('input[type="password"]');
            passwordFields.forEach(function (field) {
                if (field.value.trim() && field.value.length < 4) {
                    isValid = false;
                    showError(field, 'Password must be at least 4 characters.');
                }
            });

            if (!isValid) {
                e.preventDefault();
            }
        });
    });

    // --- Helper Functions ---
    function isValidEmail(email) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    }

    function showError(field, message) {
        field.classList.add('is-invalid');
        const errorDiv = document.createElement('div');
        errorDiv.className = 'invalid-feedback';
        errorDiv.textContent = message;
        field.parentNode.appendChild(errorDiv);
    }

    function removeError(field) {
        field.classList.remove('is-invalid');
        const existing = field.parentNode.querySelector('.invalid-feedback');
        if (existing) existing.remove();
    }

    // --- Fade-in Animation on Scroll ---
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
            if (entry.isIntersecting) {
                entry.target.classList.add('fade-in-up');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    document.querySelectorAll('.movie-card, .review-card').forEach(function (el) {
        observer.observe(el);
    });

    // --- Genre Filter (client-side) ---
    const genrePills = document.querySelectorAll('.genre-pill[data-genre]');
    genrePills.forEach(function (pill) {
        pill.addEventListener('click', function (e) {
            // If it's a link, let it navigate
            if (this.tagName === 'A') return;

            e.preventDefault();
            const genre = this.dataset.genre;

            // Update active state
            genrePills.forEach(function (p) { p.classList.remove('active'); });
            this.classList.add('active');

            // Filter cards
            const cards = document.querySelectorAll('.movie-card-wrapper');
            cards.forEach(function (card) {
                if (genre === 'all' || card.dataset.genre === genre) {
                    card.style.display = '';
                } else {
                    card.style.display = 'none';
                }
            });
        });
    });

    // --- Auto-dismiss alerts ---
    const alerts = document.querySelectorAll('.alert-success-custom');
    alerts.forEach(function (alert) {
        setTimeout(function () {
            alert.style.transition = 'opacity 0.5s ease';
            alert.style.opacity = '0';
            setTimeout(function () { alert.remove(); }, 500);
        }, 4000);
    });

    // --- Confirm Delete ---
    const deleteButtons = document.querySelectorAll('[data-confirm]');
    deleteButtons.forEach(function (btn) {
        btn.addEventListener('click', function (e) {
            const message = this.dataset.confirm || 'Are you sure you want to delete this?';
            if (!confirm(message)) {
                e.preventDefault();
            }
        });
    });
});
