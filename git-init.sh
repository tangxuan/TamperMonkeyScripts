#!/bin/bash

# 设置代理函数
setup_proxy() {
    local proxy_addr=${1:-"http://127.0.0.1:33210"}
    git config --global http.proxy "$proxy_addr"
    git config --global https.proxy "$proxy_addr"
    echo "代理已设置为 $proxy_addr"
}

# 检查代理连接
check_proxy() {
    # 增加超时时间，添加详细输出
    curl -v -x $(git config --global --get http.proxy) -I https://github.com -s -m 10
    return $?
}

# 清除代理设置
clear_proxy() {
    git config --global --unset http.proxy
    git config --global --unset https.proxy
    echo "已清除代理设置"
}

# 检查网络连接
ping -c 1 github.com > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "无法连接到 GitHub，检查网络连接..."
    echo "如果你在使用代理，请设置 git 代理："
    echo "git config --global http.proxy http://127.0.0.1:33210"
    echo "git config --global https.proxy http://127.0.0.1:33210"
    
    read -p "是否要设置代理? (y/n) " setup_proxy_choice
    if [ "$setup_proxy_choice" = "y" ]; then
        setup_proxy
    fi
fi

# 检查并设置代理
echo "检查代理连接..."
if ! check_proxy; then
    echo "代理连接失败，正在设置代理..."
    setup_proxy
    if ! check_proxy; then
        echo "代理设置后仍然无法连接，请检查代理服务是否正常运行"
        echo "当前代理设置："
        git config --global --get http.proxy
        git config --global --get https.proxy
        exit 1
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

# 在推送之前添加代理检查和配置
echo "正在验证代理连接..."
if ! check_proxy; then
    echo "当前代理无法连接，是否要："
    echo "1) 重试当前代理"
    echo "2) 输入新的代理地址"
    echo "3) 清除代理设置"
    read -p "请选择 (1/2/3): " proxy_choice
    
    case $proxy_choice in
        1)
            setup_proxy
            ;;
        2)
            read -p "请输入代理地址 (格式: http://ip:port): " new_proxy
            setup_proxy "$new_proxy"
            ;;
        3)
            clear_proxy
            ;;
    esac
    
    if ! check_proxy; then
        echo "代理设置失败，请手动检查网络配置"
        exit 1
    fi
fi

# 推送到 GitHub，添加错误处理
MAX_RETRIES=3
retry_count=0
while [ $retry_count -lt $MAX_RETRIES ]; do
    if ! check_proxy; then
        echo "代理连接已断开，重新设置代理..."
        setup_proxy
    fi
    
    git push -u origin $current_branch
    if [ $? -eq 0 ]; then
        echo "成功推送到 GitHub"
        break
    else
        retry_count=$((retry_count+1))
        if [ $retry_count -lt $MAX_RETRIES ]; then
            echo "推送失败，检查代理并5秒后重试... ($retry_count/$MAX_RETRIES)"
            sleep 5
        else
            echo "推送失败，请检查以下内容："
            echo "1. 代理服务是否正常运行"
            echo "2. GitHub 仓库是否存在并有权限"
            echo "3. 当前代理设置："
            git config --global --get http.proxy
            git config --global --get https.proxy
            echo "4. 尝试手动执行："
            echo "git push -u origin $current_branch"
            exit 1
        fi
    fi
done

echo "Repository has been initialized and pushed to GitHub"
