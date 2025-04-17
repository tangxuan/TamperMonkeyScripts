// ==UserScript==
// @name         知乎文章阅读优化
// @namespace    http://tampermonkey.net/
// @version      2025-04-17
// @description  优化知乎文章页面的阅读体验
// @author       You
// @match        https://zhuanlan.zhihu.com/*
// @icon         https://static.zhihu.com/heifetz/favicon.ico
// @grant        none
// ==/UserScript==

(function () {
    'use strict';
    const content = document.querySelector('.Post-Row-Content');
    const contentLeft = document.querySelector('.Post-Row-Content-left');
    
    if (content) {
        content.style.width = '1440px';
    }
    
    if (contentLeft) {
        contentLeft.style.width = 'calc(100% - 300px)';
        // 设置所有段落的行间距
        const paragraphs = contentLeft.querySelectorAll('p');
        paragraphs.forEach(p => {
            p.style.setProperty('line-height', '2', 'important');
        });
    }
})();