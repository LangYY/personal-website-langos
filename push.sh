#!/usr/bin/env bash
# 一键：建 GitHub 仓库 + 推送。先在本机装好 gh 并 gh auth login。
# 用法：在解压后的文件夹里执行  bash push.sh
set -e

REPO="personal-website-langos"

# 1. 确认已登录
if ! gh auth status >/dev/null 2>&1; then
  echo "未登录 GitHub CLI，先运行： gh auth login"
  exit 1
fi

# 2. 初始化本地 git
if [ ! -d .git ]; then
  git init
  git branch -M main
fi
git add .
git commit -m "LANG OS personal website" || echo "（无新变更可提交）"

# 3. 建远程仓库并推送（已存在则直接推）
if gh repo view "$REPO" >/dev/null 2>&1; then
  git remote add origin "https://github.com/$(gh api user -q .login)/$REPO.git" 2>/dev/null || true
  git push -u origin main
else
  gh repo create "$REPO" --public --source=. --remote=origin --push
fi

echo "完成：https://github.com/$(gh api user -q .login)/$REPO"
