#!/bin/bash

# 初始化 Git 仓库
git init

# 添加文件到暂存区
git add .

# 第一次提交
git commit -m "Initial commit: 添加知乎文章阅读优化脚本"

# 添加远程仓库
git remote add origin git@github.com:tangxuan/TamperMonkeyScripts.git

# 推送到 GitHub
git push -u origin main

echo "Repository has been initialized and pushed to GitHub"
