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

# 添加远程仓库
git remote add origin https://github.com/tangxuan/TamperMonkeyScripts.git

# 推送到 GitHub，添加错误处理
MAX_RETRIES=3
retry_count=0
while [ $retry_count -lt $MAX_RETRIES ]; do
    git push -u origin main
    if [ $? -eq 0 ]; then
        echo "成功推送到 GitHub"
        break
    else
        retry_count=$((retry_count+1))
        if [ $retry_count -lt $MAX_RETRIES ]; then
            echo "推送失败，5秒后重试... ($retry_count/$MAX_RETRIES)"
            sleep 5
        else
            echo "推送失败，请检查网络连接和代理设置"
            echo "当前代理设置："
            git config --global --get http.proxy
            git config --global --get https.proxy
            exit 1
        fi
    fi
done

echo "Repository has been initialized and pushed to GitHub"
