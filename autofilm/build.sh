#!/bin/bash

# 获取项目最新版本
repo="Akimio521/AutoFilm"
latest=$(curl -s https://api.github.com/repos/$repo/releases/latest)
latest=$(echo "$latest" | tr -d '\r')
app_ver=$(echo $latest | jq -r '.tag_name')
tag_ver=${app_ver#v}

# 获取镜像最新版本
image_name="$user/autofilm"
tags=$(curl -s "https://hub.docker.com/v2/repositories/$image_name/tags/" | jq -r '.results[].name')
if echo $tags | grep -q $tag_ver; then
  echo "$tag_ver 已存在, 无需构建"
  exit 0
fi

# 构建镜像
echo "开始构建 $tag_ver ..."
wget https://github.com/$repo/archive/refs/tags/$app_ver.tar.gz
tar -zxf $app_ver.tar.gz
mv AutoFilm-$tag_ver/app .
mv AutoFilm-$tag_ver/requirements.txt .

docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t $image_name:$tag_ver \
  -t $image_name:latest \
  -f Dockerfile . --push