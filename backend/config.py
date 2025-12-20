import os
from dotenv import load_dotenv

load_dotenv()


class Config:
    # Safe defaults for local development; production is validated separately
    SECRET_KEY = os.getenv('SECRET_KEY', 'dev-secret-key')
    JWT_SECRET_KEY = os.getenv('JWT_SECRET_KEY') or SECRET_KEY
    DEBUG = False
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    FRONTEND_URL = os.getenv('FRONTEND_URL', 'http://localhost:3000')
    RATELIMIT_STORAGE_URI = os.getenv('RATELIMIT_STORAGE_URI', 'memory://')


class DevelopmentConfig(Config):
    DEBUG = True
    SQLALCHEMY_DATABASE_URI = os.getenv("SQLALCHEMY_DATABASE_URI")

    #  build database URI from environment variables
    DB_USER = os.getenv('DB_USER', 'hbnb_user')
    DB_PASSWORD = os.getenv('DB_PASSWORD', '1234')
    DB_HOST = os.getenv('DB_HOST', 'localhost')
    DB_NAME = os.getenv('DB_NAME', 'hbnb_db')



class ProductionConfig(Config):
    """Production configuration"""
    DEBUG = False

    # Fix DATABASE_URL to use PyMySQL driver explicitly and remove SSL from URL
    _db_url = os.getenv('DATABASE_URL')
    if _db_url:
        # Replace mysql:// with mysql+pymysql://
        if _db_url.startswith('mysql://'):
            _db_url = _db_url.replace('mysql://', 'mysql+pymysql://', 1)
        # Remove ?ssl=true or &ssl=true from URL (will be handled in engine options)
        import re
        _db_url = re.sub(r'[?&]ssl=(true|True|1)', '', _db_url)
        # Clean up any trailing ? or &
        _db_url = re.sub(r'[?&]$', '', _db_url)
        SQLALCHEMY_DATABASE_URI = _db_url
    else:
        SQLALCHEMY_DATABASE_URI = None

    # Configure SSL for PyMySQL
    SQLALCHEMY_ENGINE_OPTIONS = {
        'connect_args': {
            'ssl': {'ssl_mode': 'REQUIRED'}
        }
    }

    SECRET_KEY = os.getenv('SECRET_KEY')
    JWT_SECRET_KEY = os.getenv('JWT_SECRET_KEY') or SECRET_KEY

    # Production security settings
    SESSION_COOKIE_SECURE = True
    SESSION_COOKIE_HTTPONLY = True
    SESSION_COOKIE_SAMESITE = 'Lax'

    JWT_ACCESS_TOKEN_EXPIRES = 3600  # 1 hour
    RATELIMIT_STORAGE_URI = (
        os.getenv('RATELIMIT_STORAGE_URI')
        or os.getenv('REDIS_URL')
        or Config.RATELIMIT_STORAGE_URI
    )

class TestingConfig(Config):
    TESTING = True
    DEBUG = True
    # Use in-memory SQLite for fast, isolated tests (no MySQL required)
    SQLALCHEMY_DATABASE_URI = "sqlite:///:memory:"
    BCRYPT_LOG_ROUNDS = 4  # Minimal rounds for testing (default is 12, very slow!)
    JWT_SECRET_KEY = "test-secret-key"
    SQLALCHEMY_TRACK_MODIFICATIONS = False
