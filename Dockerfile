# Use Python 3.12 slim for a smaller footprint
FROM python:3.12-slim

# Set environment variables for Python and UV
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    UV_PROJECT_ENVIRONMENT="/venv"

# Install system dependencies (git is required for cloning)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install uv (fast Python package manager)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# Set working directory
WORKDIR /app

# Clone Mellon directly into the image (Your preference)
RUN git clone https://github.com/cubiq/Mellon.git .

# Install dependencies using uv
RUN uv sync --all-extras

# Mellon's default port
EXPOSE 8088

# Start Mellon using uv
CMD ["uv", "run", "main.py"]