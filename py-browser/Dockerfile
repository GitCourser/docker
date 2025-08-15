FROM python:3.11-slim

ENV TZ=Asia/Shanghai

RUN apt-get update && apt-get install -y \
    xvfb \
    libgtk-3-0 \
    libx11-xcb1 \
    libasound2 \
    chromium && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /root/.cache && \
    mkdir -p /shared/camoufox && \
    groupadd browser || true && \
    chgrp -R browser /shared && \
    chmod -R 775 /shared && \
    ln -sf /shared/camoufox /root/.cache/camoufox && \
    pip install --no-cache-dir camoufox playwright && \
    camoufox fetch
