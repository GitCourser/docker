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

RUN groupadd -g ${GROUP_ID} ${GROUP_NAME} && \
    useradd -u ${USER_ID} -g ${GROUP_ID} -d ${HOME} -m -s /bin/bash ${USER_NAME}

COPY --chown=${USER_ID}:${GROUP_ID} ./src/ ${HOME}

RUN pip install --no-cache-dir camoufox playwright && \
    camoufox fetch
