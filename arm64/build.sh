#!/bin/bash

sudo apt-get update
sudo apt-get install -y --no-install-recommends qemu-user-static binfmt-support
# ls -l /usr/bin/qemu-*
update-binfmts --enable qemu-aarch64
cp /usr/bin/qemu-aarch64-static .

DOCKER_BUILDKIT=1 docker build --build-arg BUILDKIT_INLINE_CACHE=1 --build-arg ARG_APT_NO_RECOMMENDS=1 -t "$user"/ubuntu:arm64 .
docker images
