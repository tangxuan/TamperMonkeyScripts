// ==UserScript==
// @name         调整豆包内容区宽度（精准层级版）
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  基于豆包内容区精准DOM层级，模糊匹配随机类名，稳定修改内容区padding
// @author       You
// @match        https://www.doubao.com/*
// @grant        GM_addStyle
// @run-at       document-start
// ==/UserScript==

(function() {
    'use strict';

    // 注入自定义CSS，核心逻辑：
    // DOM层级结构（从父到子）：
    // data-testid="message-list"  → 消息列表的根容器（稳定标识）
    //   └─ [class*="inter-"]      → 单条消息的外层容器（原inter-H_fm37，模糊匹配inter-前缀）
    //      └─ [class*="container-"] → 消息容器1（原container-PvPoAn，模糊匹配container-前缀）
    //         └─ [class*="item-"]   → 消息容器2（原item-kDun2N，模糊匹配item-前缀）
    //            └─ [class*="container-"].chrome70-container → 目标容器（原container-SrVXPg，padding生效处）
    //               └─ data-testid="union_message" → 消息内容核心标识（稳定标识）
    GM_addStyle(`
        /* 基于完整DOM层级精准定位，仅匹配消息列表内的目标容器，避免全局污染 */
        [data-testid="message-list"]
            [class*="inter-"]
            [class*="container-"]
            [class*="item-"]
            [class*="container-"] {
            /* 覆盖原padding，数值可根据需求调整（如0px、15px等） */
            padding-left: 10px !important;
            padding-right: 10px !important;
            /* 可选：如需调整最大宽度，取消下方注释并修改数值 */
            /* max-width: 1400px !important; */
        }

        /* 兜底匹配：结合union_message标识，进一步确保精准性 */
        [data-testid="message-list"] [data-testid="union_message"]:parent([class*="container-"]) {
            padding-left: 10px !important;
            padding-right: 10px !important;
        }
    `);

    // 额外兜底：若CSS注入时机问题导致失效，用JS动态适配（可选）
    function fallbackAdjustPadding() {
        // 按层级查找目标元素
        const targetElements = document.querySelectorAll('[data-testid="message-list"] [data-testid="union_message"]:parent([class*="container-"])');

        // 遍历修改样式
        targetElements.forEach(el => {
            el.style.paddingLeft = '10px';
            el.style.paddingRight = '10px';
            el.style.setProperty('padding-left', '10px', 'important');
            el.style.setProperty('padding-right', '10px', 'important');
        });
    }

    // 页面加载后执行兜底逻辑，监听DOM变化适配动态加载
    window.addEventListener('load', fallbackAdjustPadding);
    const observer = new MutationObserver((mutations) => {
        if (mutations.some(m => m.addedNodes.length > 0)) {
            fallbackAdjustPadding();
        }
    });
    observer.observe(document.body, { childList: true, subtree: true });
})();