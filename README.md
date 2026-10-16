# Kallopis

**Technis 團隊工程工具箱的視覺與互動風格指南。**

Kallopis 定義團隊共用的視覺語意、design token、元件狀態與組合規則，讓不同產品與平台維持一致的設計語言。消費端先閱讀風格指南，再依產品需求選用對應平台的套件與實作；畫面結構、導航、業務流程與資料仍由產品專案擁有。

**[閱讀 GitHub Pages 指南](https://technis-toolbox.github.io/Kallopis/)** · [正式風格規範](docs/design-tokens/KALLOPIS-DESIGN-MAP.md) · [Technis](https://github.com/technis-toolbox)

網站內容將另行整理；目前仍包含既有框架 API 與展示頁面。網址已改為 Technis 組織位置。組織目前使用 GitHub Free，私有 repository 的 Pages 需要支援私有庫 Pages 的方案才能提供服務；網站尚未恢復上線時，請由下列 repository 文件閱讀指南。

## 從指南開始

| 你要做的事 | 閱讀入口 |
| --- | --- |
| 了解整體風格與規範結構 | [通用視覺規範索引](docs/design-tokens/KALLOPIS-DESIGN-MAP.md) |
| 理解單位、顏色、繼承與運算 | [記號與解析基準](docs/design-tokens/notation.md) |
| 選擇文字、表面、互動與狀態語意 | [Semantic](docs/design-tokens/semantics.md) |
| 查閱顏色、尺寸等基礎值 | [Primitive](docs/design-tokens/primitives.md) |
| 組合元件及其狀態 | [元件與狀態配方](docs/design-tokens/recipes.md) |
| 將需求對應到設計語意 | [查表例子](docs/design-tokens/examples.md) |
| 確認平台差異與限制 | [現行差異與平台邊界](docs/design-tokens/platform-notes.md) |

## 在產品中導入

1. 從正式規範確認所需的視覺語意、狀態與組合規則。
2. 依產品平台閱讀對應導入指南，接入 theme、token 與元件能力。
3. 以相同語意核對各平台結果；平台無法對應的能力應明確記錄，不另行猜測共用預設。

| 平台 | 導入指南 | 套件與實作位置 |
| --- | --- | --- |
| Flutter | [Flutter 產品使用指南](docs/ai/product-usage.md) | `flutter/` |
| React | [React 產品使用指南](docs/ai/react-usage.md) | `react/` |

Flutter／React 消費端套件與現有實作繼續保留；本機依賴請指向對應平台目錄。框架入口的具體用法由平台指南說明，所有平台仍遵守相同的正式風格規範。

提供給 AI 的起始資料應包含本指南、此次需要的 semantic／配方、對應平台導入指南，以及目標產品的現行架構；依任務閱讀需要的章節。

## 維護團隊共識

[維護與修訂規則](docs/design-tokens/maintenance.md) 定義正式來源與修訂方式。風格正文以 `docs/design-tokens/` 的正式章節為準；JSON、CSS、ZIP 等舊匯出快照不構成另一份設計權威。

共用規範只收納產品無關的視覺與互動契約；產品功能、業務順序與專用畫面由消費端維護。Krepis 等其他工具的正文與保存責任不因風格導入而轉移。

## 專案維護入口

- [核心目標與責任](spec/multi-framework-design-system.md)
- [專案架構](architecture.md)
- [網站工具與本機建置](tool/reference_site/README.md)

既有舊版 GitHub Releases 與 Git tags 已清理；現行指南與實作以 repository 內容為準。
