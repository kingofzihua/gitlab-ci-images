# GitLab CI/CD Docker Images

本仓库用于构建和维护 GitLab CI/CD 流水线中使用的 Docker 镜像。每个目录对应一个独立的工具镜像，支持多架构（amd64/arm64）构建。

## 镜像列表

| 目录 | 说明 | 原始项目 | Docker 镜像 |
|------|------|----------|-------------|
| [gsemver](./gsemver) | Git Semantic Versioning 工具，用于自动化版本管理 | [arnaud-deprez/gsemver](https://github.com/arnaud-deprez/gsemver) | `kingofzihua/gsemver` |

## 使用方式

### gsemver

在 `.gitlab-ci.yml` 中使用：

```yaml
create_tag:
  stage: release
  image: kingofzihua/gsemver:latest
  script:
    - |
      git remote set-url origin "http://gitlab-ci-token:${GITLAB_USER_TOKEN}@${CI_REPOSITORY_URL#*@}"
      # 确保我们处于正确的分支
      git checkout $CI_COMMIT_BRANCH
      # 从远程仓库获取最新的标签信息，并删除本地不存在于远程的标签
      git fetch origin --prune --prune-tags
      
      NEXT_VERSION=$(gsemver bump)
      echo "Next version determined by commits: ${NEXT_VERSION}"
      
      if git ls-remote --tags origin | grep -q "refs/tags/${NEXT_VERSION}"; then
        # 如果标签已存在，则打印信息并成功退出。
        echo "Tag $NEXT_VERSION already exists. Nothing to do."
      else
        git config --global user.name "${GITLAB_USER_NAME}"
        git config --global user.email "${GITLAB_USER_EMAIL}"
        echo "Creating and pushing new tag: ${NEXT_VERSION}"
      
        git tag -a "${NEXT_VERSION}" -m "Release ${NEXT_VERSION}"
      
        git push origin --tags
        echo "Tag ${NEXT_VERSION} pushed successfully."
      fi

  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
```

**手动构建镜像：**

```bash
cd gsemver
sh ./build.sh 0.10.1  # 指定 gsemver 版本号
```

## 构建说明

每个镜像目录都包含：
- `Dockerfile` - 镜像构建文件
- `build.sh` - 构建脚本

所有镜像均支持 `linux/amd64` 和 `linux/arm64` 架构。

## 贡献

欢迎提交 Issue 和 Pull Request 来添加新的工具镜像。

## License

MIT
