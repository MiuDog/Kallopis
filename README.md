# Kallopis

Kallopis 是 `-ist` 產品家族共用的跨框架 design system。核心目標為先建立框架無關的視覺語意、token 與通用元件組合規範，再由 Flutter、React 等框架庫落實；各框架庫位於本專案第一層子目錄。產品擁有畫面結構、導航與業務流程。

目標與責任以 [跨框架核心目標](spec/multi-framework-design-system.md) 為準。共通視覺直接採用 [既有統整規範](docs/design-tokens/KALLOPIS-DESIGN-MAP.md)，按責任分章維護；文件網站直接讀正式章節。Flutter 套件位於第一層 `flutter/`，React 核心庫位於 `react/`，可替換風格檔位於 `styles/`。

[文件網站](https://miudog.github.io/Kallopis/)提供通用視覺規範、產品使用指南、Flutter API、React 互動元件，以及雙框架 GUI 場景。

本機 Flutter consumer 的 path dependency 請指向 `D:/Projects/Kallopis/flutter`，或對應的 repository 相對路徑；套件名稱仍是 `kallopis`。根目錄不再是 Flutter package。安裝、分析、測試與 example 操作從 `flutter/` 執行；網站工具仍從 repository 根執行。本次未修改其他產品 repository 的 caller。

目前已實作的 Flutter 架構由 [KLP-0022](spec/decisions/KLP-0022-thin-design-system-boundary.md) 定義。舊 declarative framework、application host、runtime、renderer 與相容入口已移除。

## 框架入口

- [Flutter 產品使用](docs/ai/product-usage.md)：`flutter/` package 與 Widget 組合。
- [React 產品使用](docs/ai/react-usage.md)：`react/` 核心元件、四主題與展示。
- [通用視覺規範](docs/design-tokens/KALLOPIS-DESIGN-MAP.md)：唯一視覺來源與維護規則。
- [整合驗證](docs/architecture/multi-framework-verification.md)：已觀察證據及既有失敗。

## Flutter 使用入口

一般產品使用：

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';
```

產品直接建立 `MaterialApp` 與 Flutter Widget tree，使用 `buildKlpTheme` 安裝主題，並以 Kallopis 公開元件及 `context.klp` semantic token 維持共用視覺。尚未穩定的直接 Flutter 元件可額外匯入 `kallopis_experimental.dart`。

## React 使用入口

React consumer 從 `@kallopis/react` 匯入公開元件與 `KlpThemeProvider`，並載入 `@kallopis/react/styles.css`。產品擁有 React tree 與業務狀態，風格由同一份正式規範生成；完整安裝及使用方式見 [React 產品使用指南](docs/ai/react-usage.md)。

## 現代風生產力佈局模板

[現代風生產力佈局](docs/templates/modern-productivity-layout.md) 提供 Flutter／React 共用的全高左側欄＋右區 Header／Stage。原右側工具功能整合到左側按鈕列；consumer 擁有功能清單、選取與草稿。

模板包含公開 `KlpModernProductivityLayout`、最小起始範例、六項細節調整、四模式即時預覽與可複製啟動設定。局部 style pack override 不建立第二份預設；[模板指南](https://miudog.github.io/Kallopis/docs/guides/modern-productivity-layout.html) 提供兩框架接入與預覽。pub.dev／npm 尚未上架，使用 repository 的框架套件或自行打包。

## Workbench 與互動展示

兩框架提供 Dock 布局、分頁、分割與縮放、布局保存還原、命令註冊、工具列、選單、命令面板及快捷鍵核心與宿主。能力及合法組裝規則見 [Workbench 規範](spec/workbench-v1.md)，風格資料與 override 契約見 [可替換風格檔](spec/style-pack-v1.md)。

- [React 互動元件](https://miudog.github.io/Kallopis/docs/react/components/index.html)：24 個公開可渲染元件的專屬展示。
- [React GUI 場景](https://miudog.github.io/Kallopis/docs/react/scenarios/index.html)與 [Flutter GUI 場景](https://miudog.github.io/Kallopis/docs/flutter/scenarios/index.html)：VS Code、Blockbench、Blender 使用場景，展示公開元件的組合方式。
- [Flutter 公開型別](https://miudog.github.io/Kallopis/docs/components/index.html)：依公開 library 擷取；API 清單不等於已完成的互動展示數量。

GUI 場景的正文、程式碼、3D 與終端內容是明示示意；實際執行核心由產品或上游擁有。

截至 2026-10-13 交接，Flutter 已有原生瀏覽器驗證的專屬展示為 176／273；另 14 個 advanced form 展示完成來源、分析及 web build，尚待原生驗證。剩餘展示、完整風格與窄瀏覽器稽核、柔和按鈕與區塊總間距 8px 仍在接續中；完整 Workbench 目標尚未關閉。上述數字記錄展示驗證範圍，視覺品質與操作手感由人類接受。

## 建置文件網站

從 repository 根執行；Flutter、React 的建置及完整網站驗證命令見 [網站工具說明](tool/reference_site/README.md)。正式輸出為 `build/reference-site`，由 GitHub Pages workflow 驗證後發布。網站產物不提交 Git，README 正文會同步生成網站的 Project overview 頁面並進入搜尋。

## 責任邊界

- Kallopis 擁有 semantic theme、公開共用元件及其內部視覺與互動。
- Consumer 擁有畫面結構、導航、產品流程、業務狀態與產品專用 Widget。
- Consumer 不引用 `lib/src`、不建立第二份共用 theme，也不重建 declarative／compatibility 路徑。
- Krepis／provider 繼續擁有正文、selection、undo 與 persistence；UI 組合不轉移資料權威。
- Catalog 展示公開 Flutter 元件狀態並供人工視覺接受，不是產品 runtime。

## 文件

- [Flutter 產品使用指南](docs/ai/product-usage.md)
- [React 產品使用指南](docs/ai/react-usage.md)
- [Single Architecture v1](docs/architecture/thin-design-system/architecture.md)
- [前端責任邊界](docs/architecture/frontend-boundaries.md)
- [風格規格](spec/style-v1.md)
