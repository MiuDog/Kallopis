# KLP-0022：唯一 Flutter Design System 架構

階段：IMPLEMENTED

狀態：Implemented（2026-09-20）。宣告式 runtime 已移除；產品 editor host 已依 [KLP-0023](KLP-0023-product-editor-host-ownership.md) 移交 Planist。

擁有模組：Kallopis public surface。

目標版本：Single Architecture v1。

能力地平線：Kallopis 只提供產品無關的 semantic theme、字型、圖示、公開 Flutter 元件與元件內部互動品質；產品擁有 application root、Widget tree、布局、導航、產品狀態與業務流程。

## 目標與動機

移除 Kallopis 自建的第二套 UI framework，讓產品直接使用 Flutter 組合 Kallopis 元件。現行 repository 不保留 declarative runtime、相容宿主、雙軌入口或「稍後遷移」選項；需要追查舊設計時只使用 Git history。

這個版本不是在兩套架構間提供選擇，而是完成一次整體替換。Kallopis、Planist、Catalog、範例、測試與文件必須同時指向同一條產品使用路徑，否則不得宣稱交付。

## 需求與決策

| ID | 目標版本 | 優先級 | 需求或決策 | 可觀察驗收 | 狀態 |
| --- | --- | --- | --- | --- | --- |
| SA-01 | v1 | P1 | 所有 consumer 只使用 Flutter、`kallopis_theme.dart`、`kallopis_foundation.dart`，以及必要時的 `kallopis_experimental.dart`。 | 產品可建立 Widget、使用 `BuildContext` 與 Flutter layout；consumer source 不匯入 declarative public surface。 | accepted |
| SA-02 | v1 | P1 | Kallopis 保留 semantic theme、共用元件、元件內部互動、無障礙及平台適應責任。 | 公開元件仍由 Kallopis semantic style 取得外觀；已接受的 icon、按鈕列、Explorer、Frame 與 hover／selected 同色不回退。 | accepted |
| SA-03 | v1 | P1 | 畫面結構、Flutter app root、導航、產品流程、業務狀態與產品專用 Widget 由 consumer 擁有。 | Kallopis 不建立或驗證完整產品結構樹；產品不需向全域 catalog 註冊畫面能力。 | accepted |
| SA-04 | v1 | P1 | 移除 `kallopis_declarative.dart`、`runKlpApp`、`KlpApplicationHost`、`KlpApplication`、`KlpScreen` 及只能服務 declarative runtime 的公開／私有路徑。 | 現行 source、public barrels、package imports 與 API reference 均不存在這些入口；不得保留 shim、deprecated alias 或 feature flag。 | accepted |
| SA-05 | v1 | P1 | Planist 在同一替換中改為直接 Flutter 組合，不得保留 declarative fallback。 | Planist app root、畫面與功能全部可在沒有 declarative library 的情況下分析及啟動。 | accepted |
| SA-06 | v1 | P1 | 刪除只驗證舊 declarative 架構的測試、範例、Catalog specimen、生成頁與現行文件。 | 測試與範例只驗證新版公開元件及產品組合；現行文件沒有相容、過渡、雙軌或稍後移除敘述。 | accepted |
| SA-07 | v1 | P1 | 停止固定 254 項 runtime 遷移與所有封閉 catalog 完成閘門。 | 固定清冊不再存在於 current-truth、交付檢查或產品工作流；Git history 保留過去紀錄。 | accepted |
| SA-08 | v1 | P1 | Krepis／provider 的正文、selection、undo、persistence 權威及產品資料權威不變。 | 移除 UI runtime 不建立第二份資料權威；產品以既有 owner 的 state 投影到公開 Flutter 元件。 | accepted |
| SA-09 | v1 | P1 | 只提供一份產品使用指南，描述 app root、theme、畫面組合、資料投影及事件回傳。 | 新開發者不需閱讀 application／composition／runtime／rendering 或舊 Catalog 文件即可建立產品畫面。 | accepted |
| SA-10 | v1 | P1 | 現行 repository 只保留新版架構需要的檔案。 | 零 caller、舊架構專用、暫存 task packet、失效生成頁與被取代 current docs 已刪除；保留檔案均可由新版入口、工具或有效維護證據說明用途。 | accepted |
| SA-11 | v1 | P1 | Note／Canva 的產品 editor host、bridge、資產與工具由 Planist 擁有。 | Kallopis 不公開 editor host、不依賴 Krepis editor binding 或 WebView；Flow／Canva presentation 擁有 editor，Workspace presentation 只組裝。 | accepted |

## 唯一產品使用方式

```text
Flutter application root
	→ Kallopis semantic theme
	→ Kallopis public Flutter components
	→ Product-owned Widget composition
	→ Product-owned state／navigation／workflow
```

產品把自己的資料模型投影成公開元件輸入，並由 callback、intent 或 controller 把操作送回產品 owner。Kallopis 元件只掌管其內部暫態與跨產品共用的視覺／互動；Kallopis 不掌管產品流程。

產品沒有可選的 declarative、legacy 或 compatibility 模式。Kallopis 缺少某個產品專用畫面時，產品直接用 Flutter 建立 Widget，並從公開 semantic theme 取得共用視覺值；只有已證明跨產品重用的能力才提升為 Kallopis 元件。

## 範圍

範圍內：

- 唯一公開使用方式與產品指南。
- Kallopis 舊 declarative public surface、runtime、專用測試／範例／文件的移除。
- Planist caller 的完整遷移。
- Catalog 收斂為公開 Flutter 元件的展示與人工接受工具。
- 自動生成架構圖與 API reference 在刪除後重新產生。

範圍外：

- 重新設計已接受外觀。
- 轉移 Krepis 或產品資料權威。
- 為單一產品需求建立新的全域 schema、renderer 或中介模型。
- 在現行 tree 留下歷史副本；歷史由 Git 保存。

## 公開邊界

- `kallopis_theme.dart`：Stable semantic theme 與 context API。
- `kallopis_foundation.dart`：Stable Flutter 元件、布局與通用互動；所有產品的預設入口。
- `kallopis_experimental.dart`：尚未穩定、但仍採直接 Flutter Widget 契約的高階元件。
- `lib/src/`：private；consumer 不得直接引用。

不再存在第四個 declarative 入口。任何仍需透過 node、adapter、bound model、compiler 或私有 renderer 才能使用的能力，都不是新版已交付的 consumer 能力。

## 與先前決策的關係

- KLP-0019 的唯一結構樹、封閉 catalog、runtime compiler、私有 renderer 與禁止 consumer Widget 要求全部失效並從現行實作移除。
- KLP-0021 的完整生產力 App declarative 地平線與固定 254 項遷移要求全部失效。
- KLP-0014 只要依賴 panel tree／declarative composition 即失效；仍有價值的直接 Flutter 元件限制必須改寫到元件自己的公開契約。
- KLP-0020 的正文資料權威仍有效；依 KLP-0023，具體 editor host 由 Planist Flow／Canva presentation 擁有，由 Workspace presentation 組裝，並使用公開 Kallopis 元件取得共用視覺。
- 已接受的視覺結果仍有效；本決策改變組合與責任邊界，不授權外觀回退。

## 失敗行為與發布閘門

- 若某個 Planist flow 尚未遷移，版本保持未完成；不得恢復 compatibility surface 讓它暫時編譯。
- 若舊 runtime 中仍有新版需要的共用互動，先把該能力抽成公開 Flutter 元件，再刪除舊 owner；不得保留雙軌。
- 若刪除造成視覺或資料權威回歸，修正新版元件或產品接線；不得重建舊 host、adapter 或 renderer。
- Repository 搜尋不得發現現行 source／test／example／current docs 匯入或推薦 `kallopis_declarative.dart`。
- Kallopis 新版公開入口與 Planist 必須通過各自最高層級、直接涵蓋變更的局部分析與測試；感官品質另由人類接受。

## Readiness

所有 P1 已由使用者明確決定並完成。Kallopis public surface、Planist 垂直 modules、Catalog 與正式 Reference 均使用唯一 Flutter design-system 架構。
