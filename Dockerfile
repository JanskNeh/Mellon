# Use Python 3.12 slim for a smaller footprint
FROM python:3.12-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    UV_PROJECT_ENVIRONMENT="/venv"

# Install system dependencies (git is required for Mellon)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install uv (fast Python package manager)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# Set working directory
WORKDIR /app

# Clone Mellon directly into the image
RUN git clone https://github.com/cubiq/Mellon.git .

# Install dependencies using uv
RUN uv sync --all-extras

# Expose the default Mellon port
EXPOSE 8000

# Start Mellon
CMD ["uv", "run", "main.py"]