#!/bin/bash

# SSH key 检查和生成
if [ ! -f ~/.ssh/id_dragontx4g ]; then
    echo "没有找到 SSH key，开始生成新的 SSH key..."
    read -p "请输入你的 GitHub 邮箱: " github_email
    ssh-keygen -t ed25519 -C "$github_email"
    
    echo -e "\n你的 SSH 公钥如下（已自动复制到剪贴板）："
    cat ~/.ssh/id_dragontx4g.pub | tee >(pbcopy)
    
    echo -e "\n请按照以下步骤添加 SSH key 到 GitHub："
    echo "1. 访问 https://github.com/settings/keys"
    echo "2. 点击 'New SSH key'"
    echo "3. 为这个 key 起个标题（比如：MacBook Pro）"
    echo "4. 粘贴上面显示的公钥内容"
    echo "5. 点击 'Add SSH key'"
    
    read -p "完成后按回车键继续..."
    
    # 测试 SSH 连接
    echo "测试 SSH 连接..."
    ssh -T git@github.com
fi

# 初始化 Git 仓库（如果需要的话）
if [ ! -d .git ]; then
    git init
    echo "Git repository initialized"
fi

# 添加所有文件到暂存区（替换原来只添加 zhihu.js 的逻辑）
git add .

# 提交更改
read -p "请输入提交信息 (默认: Update files): " commit_msg
commit_msg=${commit_msg:-"Update files"}
git commit -m "$commit_msg"

# 如果还没有设置远程仓库，需要先设置
if ! git remote | grep -q '^origin$'; then
    echo "Please enter your GitHub repository URL:"
    read repo_url
    git remote add origin $repo_url
fi

# 推送到 GitHub
git push -u origin master

echo "Changes have been pushed to GitHub"
