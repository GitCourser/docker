#!/bin/bash

DOCKER_BUILDKIT=1 docker build --build-arg BUILDKIT_INLINE_CACHE=1 --build-arg ARG_APT_NO_RECOMMENDS=1 -t "$user"/ubuntu:amd64 .
docker images

docker login -u "$user" -p "$passwd"
docker push "$user"/ubuntu:amd64
