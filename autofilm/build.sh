#!/bin/bash

repo="Akimio521/AutoFilm"
latest=$(curl -s https://api.github.com/repos/$repo/releases/latest)
latest=$(echo "$latest" | tr -d '\r')
app_ver=$(echo $latest | jq -r '.tag_name')
tag_ver=${app_ver#v}

image_name="$user/autofilm"
tags=$(curl -s "https://hub.docker.com/v2/repositories/$image_name/tags/" | jq -r '.results[].name')
if echo $tags | grep -q $tag_ver; then
  echo "$tag_ver 已存在"
  exit 0
fi

echo "开始构建 $tag_ver ..."
