#!/bin/bash

# 检查是否传入了版本参数
if [ -z "$1" ]; then
  echo "错误: 请提供 gsemver 版本号"
  echo "用法: sh build.sh <版本号>"
  echo "示例: sh build.sh 0.10.1"
  exit 1
fi

VERSION=$1

echo "正在构建 gsemver:${VERSION} ..."

docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --build-arg GSEMVER_VERSION=${VERSION} \
  --tag kingofzihua/gsemver:${VERSION} \
  --tag kingofzihua/gsemver:latest \
  --push .