# 使用轻量级的 Alpine Linux作为基础镜像
FROM alpine:latest

# 设置一些元数据标签 (可选)
LABEL maintainer="kingofzihua <kingofzihua@outlook.com>"
LABEL description="A multi-arch Docker image with Git and gsemver for GitLab CI/CD."

# Docker 会在构建时自动传入 TARGETARCH (例如 amd64, arm64)
ARG TARGETARCH

# 设置gsemver的版本
ARG GSEMVER_VERSION="0.10.0"
# 根据 TARGETARCH 动态构建下载地址
ENV GSEMVER_URL="https://github.com/arnaud-deprez/gsemver/releases/download/v${GSEMVER_VERSION}/gsemver_${GSEMVER_VERSION}_linux_${TARGETARCH}.tar.gz"

# 安装依赖
RUN apk add --no-cache \
        git \
        wget \
        ca-certificates

# 下载 gsemver (单独步骤，方便排查下载问题)
RUN echo "Downloading gsemver from: ${GSEMVER_URL}" && \
    wget -O gsemver.tar.gz "${GSEMVER_URL}" || \
    (echo "Failed to download gsemver from ${GSEMVER_URL}" && exit 1)

# 解压并安装 gsemver
RUN tar -zxvf gsemver.tar.gz && \
    mv gsemver /usr/local/bin/gsemver && \
    chmod +x /usr/local/bin/gsemver && \
    rm gsemver.tar.gz

# 清理缓存
RUN apk del wget ca-certificates && \
    rm -rf /var/cache/apk/*

# 设置默认工作目录
WORKDIR /builds

# 验证gsemver是否安装成功
RUN gsemver