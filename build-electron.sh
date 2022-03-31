#!/bin/bash

if [ "$platform" == "arm64" ]; then
    sudo apt-get update
    sudo apt-get install -y --no-install-recommends qemu-user-static binfmt-support
    # ls -l /usr/bin/qemu-*
    update-binfmts --enable qemu-aarch64
    cp /usr/bin/qemu-aarch64-static .
fi

if [ "$platform" == "arm64" ]; then
    elec=arm64
fi
if [ "$platform" == "amd64" ]; then
    elec=x64
fi

wget https://registry.npmmirror.com/-/binary/electron/12.1.0/electron-v12.1.0-linux-"$elec".zip
mkdir electron
unzip electron-v12.1.0-linux-"$elec".zip -d electron
wget -P electron https://github.com/electron/electron/raw/main/default_app/icon.png

DOCKER_BUILDKIT=1 docker build \
    -f ./Dockerfile."$platform" \
    --build-arg BUILDKIT_INLINE_CACHE=1 \
    --build-arg ARG_APT_NO_RECOMMENDS=1 \
    --build-arg ARG_MERGE_STAGE_BROWSER_BASE="stage_electron" \
    -t "$user"/electron:"$platform" .

docker images

docker login -u "$user" -p "$passwd"
docker push "$user"/electron:"$platform"
