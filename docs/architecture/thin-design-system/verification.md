# Single Architecture v1 驗證

日期：2026-09-20

## 已完成結果

- Kallopis 僅保留 `kallopis_theme.dart`、`kallopis_foundation.dart` 與直接 Flutter 契約的 `kallopis_experimental.dart`。
- Planist app root、workspace、sidebar、Explorer、window chrome、搜尋、資產、設定與編輯器均改為產品擁有的 Flutter Widget tree。
- 舊 application、composition、runtime、rendering、declarative adapters、相容入口及其專用測試、範例、工具、生成頁與遷移清冊已移除。
- 唯一產品使用方式記錄於 `docs/ai/product-usage.md`。

## Editor ownership 完成

`KlpBlockNoteEditor`、`KlpCanvaEditor` 與 `KlpResolvedAsset` 已從 Kallopis public surface 移除。Bridge、packaged assets、tooling、WebView dependency 與 Windows override 由 Planist 的 Flow／Canva modules 擁有；Workspace presentation 只組裝產品 editor。

## 機械證據

- Kallopis `dart analyze lib test`：通過，0 issue。
- Catalog `dart analyze lib test`：通過，0 issue。
- Planist `dart analyze lib test`：通過，僅有本次範圍外的既有 style info，沒有 error 或 warning。
- Kallopis 完整測試：396 項通過。
- Planist 垂直邊界與 editor contract：6/6 通過；受影響既有測試：57/57 通過。
- BlockNote 與 Canva production assets 重新建置；五項 BlockNote verifier 與兩項 Canva verifier 通過。
- Planist `single_architecture_smoke_test.dart`：通過，實際建立 Material app、workbench、stage 與 window header。
- Inventory、dartdoc reference、token discipline、l10n discipline 與 GitHub.io Reference 已重新執行；Reference 產生並驗證 17 個 module、515 個 canonical API 頁。
- Catalog 已加入 `KlpAppLayout`／floating action、`KlpFrameGroups`、`KlpDocumentTabs`、`KlpAnchoredPopup`／`KlpWorkspaceCommand` 的可操作範例；公開元件覆蓋、明暗模式與逐 specimen 渲染檢查通過。
- Kallopis 與 Planist production source 掃描：沒有舊 declarative public import 或 application host symbol。

## 人類驗收

本次沒有重設已接受的 Explorer、Frame、icon、按鈕列或 hover／selected 視覺。實機視覺品質與互動手感仍由人類接受；deterministic tests 不替代感官判斷。
