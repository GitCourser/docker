FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    xvfb \
    libgtk-3-0 \
    libx11-xcb1 \
    libasound2 \
    chromium \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV TZ=Asia/Shanghai

RUN pip install --no-cache-dir camoufox playwright && \
    camoufox fetch
