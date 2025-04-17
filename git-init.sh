#!/bin/bash

# 检查网络连接
ping -c 1 github.com > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "无法连接到 GitHub，检查网络连接..."
    echo "如果你在使用代理，请设置 git 代理："
    echo "git config --global http.proxy http://127.0.0.1:33210"
    echo "git config --global https.proxy http://127.0.0.1:33210"
    
    read -p "是否要设置代理? (y/n) " setup_proxy
    if [ "$setup_proxy" = "y" ]; then
        git config --global http.proxy http://127.0.0.1:33210
        git config --global https.proxy http://127.0.0.1:33210
        echo "代理已设置"
    fi
fi

# 初始化 Git 仓库
git init

# 添加文件到暂存区
git add .

# 第一次提交
git commit -m "Initial commit: 添加知乎文章阅读优化脚本"

# 检查并删除已存在的远程仓库
if git remote | grep -q '^origin$'; then
    git remote remove origin
    echo "已移除现有的远程仓库"
fi

# 添加远程仓库
git remote add origin https://github.com/tangxuan/TamperMonkeyScripts.git

# 获取当前分支名
current_branch=$(git rev-parse --abbrev-ref HEAD)
if [ -z "$current_branch" ]; then
    current_branch="master"  # 默认使用 master
fi

# 推送到 GitHub，添加错误处理
MAX_RETRIES=3
retry_count=0
while [ $retry_count -lt $MAX_RETRIES ]; do
    git push -u origin $current_branch
    if [ $? -eq 0 ]; then
        echo "成功推送到 GitHub"
        break
    else
        retry_count=$((retry_count+1))
        if [ $retry_count -lt $MAX_RETRIES ]; then
            echo "推送失败，5秒后重试... ($retry_count/$MAX_RETRIES)"
            sleep 5
        else
            echo "推送失败，请尝试手动执行以下命令："
            echo "git push -u origin $current_branch"
            exit 1
        fi
    fi
done

echo "Repository has been initialized and pushed to GitHub"
