FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    UV_PROJECT_ENVIRONMENT="/venv"

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

WORKDIR /app

RUN git clone https://github.com/cubiq/Mellon.git .

# ✅ Copy config.ini so Mellon binds to 0.0.0.0
COPY config.ini /app/config.ini

RUN uv sync --extra nunchaku --extra spandrel --extra background-removal --extra quantization

EXPOSE 8088

CMD ["uv", "run", "main.py"]