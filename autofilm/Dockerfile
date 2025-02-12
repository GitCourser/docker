FROM python:3.12.5-alpine

ENV TZ=Asia/Shanghai

COPY app /app
COPY requirements.txt requirements.txt

RUN apk update &&\
    apk upgrade &&\
    rm -rf /tmp /var/lib/apt/lists /var/tmp &&\
    pip install --no-cache-dir -r requirements.txt &&\
    rm requirements.txt

VOLUME ["/config", "/logs", "/media"]

CMD ["python", "/app/main.py"]
