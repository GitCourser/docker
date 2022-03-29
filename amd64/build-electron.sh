#!/bin/bash

wget https://registry.npmmirror.com/-/binary/electron/12.1.0/electron-v12.1.0-linux-x64.zip
mkdir electron
unzip electron-v12.1.0-linux-x64.zip -d electron
wget -P electron https://github.com/electron/electron/raw/main/default_app/icon.png
DOCKER_BUILDKIT=1 docker build -f ./Dockerfile.electron --build-arg BUILDKIT_INLINE_CACHE=1 --build-arg ARG_APT_NO_RECOMMENDS=1 -t "$user"/electron:amd64 .
docker images

docker login -u "$user" -p "$passwd"
docker push "$user"/electron:amd64
