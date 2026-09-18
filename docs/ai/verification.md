# 驗證指南

新宣告式 consumer 必須在 CI 內執行 AST 邊界檢查。它會拒絕 Flutter、`dart:ui`、private `lib/src`、舊 Kallopis 入口和常見的 renderer／style 逃生輸入。

## consumer 檢查

```powershell
D:\flutter\bin\dart.bat run tool/verify_declarative_consumer.dart path\to\consumer\lib
```

目標可以是單一 `.dart` 檔或目錄。成功時輸出為 `Declarative consumer verification passed.`；有違規時會逐檔列出路徑與原因，並以非零結束碼失敗。

本庫的最小範例可這樣檢查：

```powershell
D:\flutter\bin\dart.bat run tool/verify_declarative_consumer.dart example\lib\klp_runtime_demo.dart
```

## 本庫檢查

先執行靜態分析，再依改動範圍執行相關測試。架構與公開 API 有變動時，至少執行：

```powershell
$env:Path = 'D:\flutter\bin;' + $env:Path
flutter analyze --fatal-infos
flutter test test/frontend_architecture_boundary_test.dart
flutter test test/klp_declarative_public_api_test.dart
flutter test test/verify_declarative_consumer_test.dart
```

修改路徑、公開匯出或架構圖集後，依 [圖集生成器](../architecture/README.md#更新圖集) 重建並檢查圖集。Pixel 外觀、視覺品味與互動感受由人工驗收，不建立或更新 golden；程式測試只保護可確定的幾何、語意、無障礙、狀態、生命週期與錯誤契約。

## 常見失敗

| 訊息或現象 | 原因 | 修正 |
|---|---|---|
| Flutter import 被拒絕 | consumer 建立了 Flutter 呈現層 | 改為 `KlpApplication` 和 Kallopis node tree |
| private `src` import 被拒絕 | 直接跨越公開邊界 | 只從 `kallopis_declarative.dart` 匯入 |
| style input 被拒絕 | 實例試圖掌管樣式 | 使用既有元件語意；缺少能力時提出庫內元件／semantic 契約 |
| child 型別錯誤 | 節點不符合容器所需資格 | 改用已實作正確資格的公開庫元件或相容容器；consumer 自行實作資格不會加入 catalog |
| primitive slots 錯誤 | 一個種類不是剛好八個值 | 建立完整 `KlpPrimitiveSet`，不做局部覆寫 |
| 元件型別未支援 | 使用了非公開或非庫擁有 node | 改用 `kallopis_declarative.dart` 已公開元件，或提出庫內能力需求 |

通過 analyzer 並不代表實際功能完成。每個新增功能仍需有對應的資料、slot、semantic、生命週期與 renderer 驗收；尚未支援的 capability 應明確維持未支援狀態。
