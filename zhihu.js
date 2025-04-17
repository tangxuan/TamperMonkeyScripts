// ==UserScript==
// @name         知乎文章阅读优化
// @namespace    http://tampermonkey.net/
// @version      2025-04-17
// @description  优化知乎文章页面的阅读体验，调整页面宽度和行间距
// @author       You
// @match        https://zhuanlan.zhihu.com/*
// @icon         https://static.zhihu.com/heifetz/favicon.ico
// @grant        none
// ==/UserScript==

(function () {
    'use strict';
    // 获取主要内容容器
    var content = document.querySelector('.Post-Row-Content');
    var contentLeft = document.querySelector('.Post-Row-Content-left');

    // 设置整体内容区域宽度
    if (content) {
        content.style.width = '1440px';
    }

    // 设置左侧文章内容区域宽度和样式
    if (contentLeft) {
        contentLeft.style.width = '100%';
        contentLeft.style.paddingLeft = '100px';
        // 设置所有段落的行间距为2倍
        var paragraphs = contentLeft.querySelectorAll('p');
        Array.prototype.forEach.call(paragraphs, function (p) {
            p.style.setProperty('line-height', '2', 'important');
            // 添加段落间距
            p.style.setProperty('margin-bottom', '1em', 'important');
        });
    }

    // 移除右侧内容区域
    var contentRight = document.querySelector('.Post-Row-Content-right');
    if (contentRight) {
        contentRight.style.display = 'none';
    }
})();