from flask import Flask
from flask_restx import Api
from app.extensions import db, bcrypt, jwt, limiter, migrate
from app.api.v1.users import api as users_ns
from app.api.v1.reviews import api as reviews_ns
from app.api.v1.places import api as places_ns
from app.api.v1.amenities import api as amenities_ns
from app.api.v1.auth import api as auth_ns
from app.api.v1.bookings import api as bookings_ns
from app.api.v1.payments import api as payments_ns
import os
import logging
from logging.handlers import RotatingFileHandler
import sentry_sdk
from sentry_sdk.integrations.flask import FlaskIntegration
from dotenv import load_dotenv
from flask_cors import CORS

# Load environment variables
load_dotenv()


def _is_production_config(config_class):
    if isinstance(config_class, str):
        return config_class.endswith("ProductionConfig")
    return getattr(config_class, "__name__", "") == "ProductionConfig"


def _validate_production_config(app):
    required_keys = ["SECRET_KEY", "JWT_SECRET_KEY", "SQLALCHEMY_DATABASE_URI"]
    missing = [key for key in required_keys if not app.config.get(key)]
    if missing:
        missing_list = ", ".join(missing)
        raise RuntimeError(f"Missing required production settings: {missing_list}")


def _setup_logging(app):
    if app.debug or app.testing:
        return

    log_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "logs"))
    os.makedirs(log_dir, exist_ok=True)
    log_path = os.path.join(log_dir, "hbnb.log")

    handler = RotatingFileHandler(log_path, maxBytes=10_000_000, backupCount=10)
    formatter = logging.Formatter(
        "%(asctime)s level=%(levelname)s logger=%(name)s msg=%(message)s"
    )
    handler.setFormatter(formatter)
    handler.setLevel(logging.INFO)

    app.logger.setLevel(logging.INFO)
    if not any(
        isinstance(existing, RotatingFileHandler) for existing in app.logger.handlers
    ):
        app.logger.addHandler(handler)


def _init_sentry():
    dsn = os.getenv("SENTRY_DSN")
    if not dsn:
        return

    sentry_sdk.init(
        dsn=dsn,
        integrations=[FlaskIntegration()],
        environment=os.getenv("SENTRY_ENVIRONMENT", "production"),
        traces_sample_rate=float(os.getenv("SENTRY_TRACES_SAMPLE_RATE", "0.0")),
    )


def create_app(config_class="config.DevelopmentConfig"):
    app = Flask(__name__, static_folder="../base_files", static_url_path="")
    app.config.from_object(config_class)

    if _is_production_config(config_class):
        _validate_production_config(app)

    # initialize extensions
    db.init_app(app)
    jwt.init_app(app)
    bcrypt.init_app(app)
    limiter.init_app(app)
    migrate.init_app(app, db)

    _setup_logging(app)
    _init_sentry()

    # Configure CORS - Allow frontend origin from config
    frontend_url = app.config.get("FRONTEND_URL", "*")
    CORS(
        app, resources={r"/api/*": {"origins": frontend_url}}, supports_credentials=True
    )

    # Configure authorization for Swagger UI
    authorizations = {
        "Bearer Auth": {
            "type": "apiKey",
            "in": "header",
            "name": "Authorization",
            "description": (
                "Type in the *'Value'* input box below: "
                "**'Bearer &lt;JWT&gt;'**, where JWT is the token "
                "from /api/v1/auth/login"
            ),
        }
    }

    # register API namespace
    api = Api(
        app,
        version="1.0",
        title="HBnB API",
        description=(
            "HBnB - Luxury Property Rental Platform API\n\n"
            "Complete REST API for property listings, bookings, "
            "reviews, and payments.\n\n"
            "**Authentication:** Most endpoints require JWT authentication. "
            "Use /api/v1/auth/login to get your access token, "
            'then click "Authorize" button above.'
        ),
        authorizations=authorizations,
        security="Bearer Auth",
        doc="/doc",  # Swagger UI available at /doc
    )
    api.add_namespace(users_ns, path="/api/v1/users")
    api.add_namespace(reviews_ns, path="/api/v1/reviews")
    api.add_namespace(places_ns, path="/api/v1/places")
    api.add_namespace(amenities_ns, path="/api/v1/amenities")
    api.add_namespace(auth_ns, path="/api/v1/auth")
    api.add_namespace(bookings_ns, path="/api/v1/bookings")
    api.add_namespace(payments_ns, path="/api/v1/payments")

    @app.route("/health")
    def health_check():
        """Simple health check endpoint for monitoring"""
        try:
            # Check database connection
            db.session.execute(db.text("SELECT 1"))
            db_status = "healthy"
        except Exception:
            db_status = "unhealthy"

        return {"status": "healthy", "database": db_status}, 200

    @app.after_request
    def set_security_headers(response):
        response.headers.setdefault("X-Content-Type-Options", "nosniff")
        response.headers.setdefault("X-Frame-Options", "DENY")
        response.headers.setdefault("X-XSS-Protection", "1; mode=block")
        response.headers.setdefault("Referrer-Policy", "no-referrer-when-downgrade")
        # Content-Security-Policy kept minimal; adjust if you add inline scripts/styles
        response.headers.setdefault("Content-Security-Policy", "default-src 'self'")
        return response

    return app
