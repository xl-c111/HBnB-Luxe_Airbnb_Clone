# Fly.io Dockerfile for HBnB Backend
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    default-libmysqlclient-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements files
COPY requirements-constraints.txt .
COPY requirements-prod.txt .
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements-prod.txt

# Copy application code
COPY . .

# Create non-root user for security
RUN useradd -m -u 1000 hbnb && chown -R hbnb:hbnb /app
USER hbnb

# Expose port (Fly.io will set PORT env variable)
ENV PORT=8080
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:8080/health')" || exit 1

# Start gunicorn with 1 worker to fit in 256MB RAM
CMD gunicorn --bind 0.0.0.0:$PORT --workers 1 --threads 4 --timeout 60 run:app
