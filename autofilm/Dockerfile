FROM python:3.12-alpine

ENV TZ=Asia/Shanghai

COPY app /app
COPY requirements.txt requirements.txt

RUN apk add build-base linux-headers --no-cache &&\
    pip install --no-cache-dir -r requirements.txt &&\
    apk del build-base linux-headers &&\
    rm -rf /root/.cache /var/cache/apk/* /tmp /var/lib/apt/lists /var/tmp &&\
    rm requirements.txt

VOLUME ["/config", "/logs", "/media"]

CMD ["python", "/app/main.py"]
