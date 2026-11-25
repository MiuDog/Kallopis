# Kallopis React 產品使用入口

[完整 Reference](../reference/react/README.md) · [速成接入](../reference/react/quickstart.md) · [畫面範例](../examples/README.md)

具名組裝：[Kallopis 雙區工作台（sidebar-stage-workbench）](../../templates/sidebar-stage-workbench/README.md)。使用者提到此名稱時直接複製模板，填入 sidebar／stage／header 產品內容，不重做布局設計。

側欄與 Stage header 組裝遵守[正式配方的 Header 規則](../design-tokens/recipes.md#側欄與-stage-header（2026-10-17-使用者已確認）)。React 的 sidebar 可使用 `KlpFrame` header 插槽搭配公開 icon button；Stage header 使用原生布局在主內容 Frame 上方保留實際空間，背景繼承工作區，不以 Frame 內的透明標題替代。

## 本機執行

[閱讀此流程](../guides/react/01-getting-started.md)

## 第一個組合

[閱讀此流程](../guides/react/02-klp-theme-provider.md)

## 語意與 API 對應

[閱讀此流程](../guides/react/03-klp-text.md)

## 維護

[閱讀此流程](../guides/react/04-getting-started.md)

## 可替換風格

[閱讀此流程](../guides/react/05-create-klp-style-pack.md)

## 一般布局與尺寸限制

[閱讀此流程](../guides/react/06-klp-theme-provider.md)

## Dock 布局資料保存

[閱讀此流程](../guides/react/07-klp-dock-layout-data.md)

## Dock 受控操作

[閱讀此流程](../guides/react/08-apply-klp-dock-action.md)

## Dock 有限尺寸

[閱讀此流程](../guides/react/09-resolve-klp-dock-geometry.md)

## React Dock 元件

[閱讀此流程](../guides/react/10-klp-dock-layout.md)

## React 命令核心

[閱讀此流程](../guides/react/11-klp-command-registry.md)

## React 命令工具列與選單

[閱讀此流程](../guides/react/12-klp-registered-command-toolbar.md)

## React 命令面板

[閱讀此流程](../guides/react/13-klp-registered-command-palette.md)

## React 錨定與右鍵命令選單

[閱讀此流程](../guides/react/14-klp-registered-command-popup.md)

## Registered 快捷鍵純核心

[閱讀此流程](../guides/react/15-klp-command-keymap.md)

## 原生快捷鍵宿主

[閱讀此流程](../guides/react/16-klp-command-shortcut-host.md)

## React 專屬元件展示

[閱讀此流程](../guides/react/17-klp-button.md)
