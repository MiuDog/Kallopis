# 現代風生產力佈局

模板識別：`modern-productivity-layout`。契約版本：v1。

單一全高左側欄，右區為 Header＋Stage。導航與原右側工具功能都由左欄內的按鈕列切換。產品提供功能清單、內容與受控選取；模板維持面板身分、狀態與共用視覺。

## 開啟預覽

- [React 即時調整](../../examples/react/index.html?template=modern-productivity-layout)
- [Flutter 即時調整](../../examples/flutter/index.html?template=modern-productivity-layout)

預覽使用套件的真實公開元件。上方控制區用來調整設定，下方才是可套用的模板；控制區不屬於產品布局。可切換 light／dark／ultraDark／transparent，調整細節、檢查功能及草稿，再按「複製設定」取得完整啟動片段。還原設定只還原樣式，保持目前選取與兩份草稿。

## 快速套用

1. 取得 Kallopis 對應框架套件，安裝公開主題與資產。
2. 複製對應的最小起始範例到作品，保留公開 import。
3. 在預覽調整需要的細節，複製啟動片段；它匯入起始範例並套用目前有效設定。
4. 替換側欄功能清單、Header 與 Stage，將選取與資料回呼接回作品。

[Flutter 起始範例](https://github.com/MiuDog/Kallopis/blob/main/flutter/example/lib/modern_productivity_starter.dart) 使用 `package:kallopis/kallopis_foundation.dart`；Flutter dependency 的 package root 為 repository 的 `flutter/`，可用本機 path 或指定 Git commit 的 subdirectory。主題交給 `MaterialApp`，宿主提供有限寬高。

[React 起始範例](https://github.com/MiuDog/Kallopis/blob/main/react/example/modern-productivity-starter.tsx) 使用 `@kallopis/react`。從 repository 的 `react/` 執行 `npm ci`、`npm run build`、`npm pack`，在 consumer 安裝產生的 tarball；同時匯入 `@kallopis/react/styles.css`。主題由 `KlpThemeProvider` 提供，宿主須有確定的寬高。

公開元件皆名為 `KlpModernProductivityLayout`；面板為 Flutter 的 `KlpModernProductivityPanel`／React 的同名公開型別。必要輸入為 panels、selectedId、header、stage；onSelected 為切換提案，sidebarWidth 可選。沒有獨立右側欄插槽。

## 調整細節

| 要調整的細節 | 入口 | 範圍 |
| --- | --- | --- |
| 功能名稱、順序與內容 | panels 的 id／label／content | 產品擁有；id 保持穩定 |
| 目前顯示的功能 | selectedId／onSelected | 受控；切換保持面板掛載與草稿 |
| 側欄寬度 | sidebarWidth；缺省 theme.geometry.layout.primaryPaneWidth | 期望寬度；有限 host 可縮配 |
| Header 最小高度 | theme.spacing.chromeHeader | 只影響右區 header |
| 外距與欄間距 | theme.spacing.space2 | Root inset／gutter 各自一處配置，不疊加 margin |
| 按鈕列間距 | theme.spacing.actionGap | 左欄切換列 |
| 側欄圓角 | theme.shape.panel | frame-sidebar；Stage 維持無圓角 |
| 切換按鈕高度 | theme.geometry.control.buttonHeight | 既有中尺度按鈕配方 |

預覽的語意選項讀取正式 pack 的 dimension primitives，輸出 `p(...)` 引用；不任意增加另一份設計預設。所有變更交給既有 style pack 驗證，違反尺寸限制時顯示錯誤並保留上一份有效設定。數值引用的詳義見 [正式視覺規範](../design-tokens/KALLOPIS-DESIGN-MAP.md)。

單一作品以局部 theme／style pack overrides 調整，不修改共享預設。功能性變更透過公開 props；不用 private import、手寫共用按鈕樣式或第二份 theme。共用預設的變更仍由正式規範擁有。

## 版本與適用限制

本次基於 Flutter kallopis 0.8.0／React @kallopis/react 0.1.0 的 repository 版本；尚未上架 pub.dev／npm。跨作品使用時鎖定已驗證的 Git commit 或自行產出的 package tarball。公開 GitHub 文件與 Pages 不代表套件 registry 已發版。

模板契約識別保持固定；後續新增可選參數須保留原預設，移除角色／改選取或狀態生命週期等破壞性變更須提供版本及遷移說明。模板不擁有正文模型、保存、undo、作品導航或商業流程。

目前涵蓋有限工作區、唯一左欄、右區 Header／Stage、受控功能切換、局部參數與設定片段。窄版重排、側欄收合、拖曳 resize 與 Dock 不屬於 v1。窄宿主沿有限尺寸分配並裁切；不能將這點宣稱為完整行動版介面。

## 驗證範圍

已觀察兩框架核心保護檢查、public consumer build／analyze，以及真實瀏覽器中的六項調整、四模式、兩面板草稿、還原、複製設定與作用面板鍵盤巡訪。感官品質仍由使用者接受。原 Catalog／specimen 清冊維持機械驗證；[完整需求](../../spec/modern-productivity-layout-v1.md) 與 [框架契約](../architecture/modern-productivity-layout-contract.md) 提供責任邊界。
