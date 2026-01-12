<!--
  This README was generated with the help of GitHub Copilot.
  If you have any questions or suggestions, feel free to open an issue or contact the author.
  By Dragontx: 有问题请打他……
-->

# TamperMonkeyScripts

# Enhance English Reading Experience 油猴脚本

## 功能介绍

本脚本用于提升网页英文阅读体验，自动美化段落文本：

- 针对所有网页的 `<p>` 标签内容，在英文逗号后自动添加 3 个空格，在英文句号后自动添加 7 个空格，增强英文分句的可读性。
- 仅处理 `<p>` 标签内的纯文本内容，不影响标签结构、样式或子标签。
- 支持延迟加载、滚动加载和单页应用（SPA）等动态内容，自动增量处理新出现的段落。
- 对已处理过的段落做缓存，避免重复处理，提升性能。
- 兼容主流网站和论文页面（如 arxiv.org 等）。

## 使用方法

1. 安装 Tampermonkey 等用户脚本管理器。
2. 新建脚本，将本项目的 `enhance-english-reading.user.js` 代码粘贴保存。
3. 脚本自动在所有网页生效，无需手动操作。

## zhihu.js

### 功能介绍

本脚本用于优化知乎专栏文章页面的阅读体验：

- 自动将知乎专栏文章页面的主内容区宽度调整为 1440px，提升大屏阅读体验。
- 左侧正文内容宽度设置为 100%，并增加左侧内边距（padding-left: 100px），让内容更居中。
- 自动将正文所有段落（p标签）的行间距设置为 2，并增加段落间距（margin-bottom: 1em），让阅读更舒适。
- 自动隐藏右侧内容区，减少干扰，专注阅读。
- 仅在 https://zhuanlan.zhihu.com/* 页面生效。

### 使用方法

1. 安装 Tampermonkey 等用户脚本管理器。
2. 新建脚本，将本项目的 `zhihu.js` 代码粘贴保存。
3. 打开知乎专栏文章页面，脚本自动生效。

---
## doubao.js

### 功能介绍

本脚本用于优化豆包AI助手的对话界面：

- 自动将豆包AI对话界面的内容区宽度调整为900px，提升阅读体验。
- 调整内容区左侧内边距为80px，让内容更居中。
- 自动将所有段落（p标签）的行间距设置为1.8，并增加段落间距（margin-bottom: 1em），让阅读更舒适。
- 仅在 https://www.doubao.com/chat/* 页面生效。

### 使用方法

1. 安装 Tampermonkey 等用户脚本管理器。
2. 新建脚本，将本项目的 `doubao.js` 代码粘贴保存。
3. 打开豆包AI对话页面，脚本自动生效。

---
如有更多定制需求，欢迎反馈！