#!/bin/bash

if [ $platform == "arm64" ]; then
    sudo apt-get update
    sudo apt-get install -y --no-install-recommends qemu-user-static binfmt-support
    # ls -l /usr/bin/qemu-*
    update-binfmts --enable qemu-aarch64
    cp /usr/bin/qemu-aarch64-static .
fi

DOCKER_BUILDKIT=1 docker build \
    -f ./Dockerfile.$platform \
    -t $user/alpine-chromium:$platform .

docker images

docker login -u $user -p $passwd
docker push $user/alpine-chromium:$platform
