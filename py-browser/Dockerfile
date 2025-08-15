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
    pip install --no-cache-dir camoufox playwright && \
    camoufox fetch && \
    mkdir -p /shared && \
    mv /root/.cache/camoufox /shared/ && \
    groupadd browser || true && \
    chgrp -R browser /shared && \
    chmod -R 775 /shared && \
    ln -sf /shared/camoufox /root/.cache/camoufox
