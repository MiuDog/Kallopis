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

修改路徑、公開匯出或架構圖集後，依 [圖集生成器](../architecture/README.md#更新圖集) 重建並檢查圖集。變更視覺結果時，另依專案規則執行適用 golden；未有已核准的視覺變更時不得更新 golden。

## 常見失敗

| 訊息或現象 | 原因 | 修正 |
|---|---|---|
| Flutter import 被拒絕 | consumer 建立了 Flutter 呈現層 | 改為 `KlpApplication` 和 Kallopis node tree |
| private `src` import 被拒絕 | 直接跨越公開邊界 | 只從 `kallopis_declarative.dart` 匯入 |
| style input 被拒絕 | 實例試圖掌管樣式 | 把參照移到 `KlpComponentDefinition` 的 semantic schema |
| child 型別錯誤 | 節點未實作容器所需資格 | 實作正確介面或改用相容容器 |
| primitive slots 錯誤 | 一個種類不是剛好八個值 | 建立完整 `KlpPrimitiveSet`，不做局部覆寫 |
| 元件未註冊 | application components 缺少 definition | 將唯一 `KlpComponentDefinition` 加入 `components` |

通過 analyzer 並不代表實際功能完成。每個新增功能仍需有對應的資料、slot、semantic、生命週期與 renderer 驗收；尚未支援的 capability 應明確維持未支援狀態。
