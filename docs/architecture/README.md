# Kallopis 架構分析入口

本頁供本庫維護者與 AI 接手程式架構時使用。消費端組裝請先讀 [AI 使用手冊](../ai/README.md)；這裡描述的是目前原始碼的位置、依賴與遷移狀態。

新架構現況見 [目前重構架構總覽](current-refactor-overview.md)。長期目標與驗收條件見 [遷移計畫](restructure-migration-plan.md)，已完成工作的證據見 [進度紀錄](restructure-progress.md)。

## 圖集閱讀方式

從 [lib/src 圖集總索引](src/README.md) 進入實際目錄，再以各頁的宣告、依賴圖與原始碼連結追查細節。圖集由程式生成，描述現況，不取代設計契約。

| 問題 | 圖集起點 |
|---|---|
| application 啟動、screen、host 與環境 | [application](src/application/README.md) |
| 結構樹、資格、slot、registry | [composition](src/composition/README.md) |
| primitive、semantic 與解析 | [styling](src/styling/README.md) |
| 外部元件定義與受控 template | [foundation](src/foundation/README.md) |
| state、data、controller、navigation | [capabilities](src/capabilities/README.md) |
| 通用功能實作 | [features](src/features/README.md) |
| compilation、installation 與 Flutter renderer | [runtime](src/runtime/README.md)、[rendering](src/rendering/README.md) |
| 診斷、識別與生命週期 | [kernel](src/kernel/README.md) |

`legacy`、`widgets` 與 `legacy_*` 目錄是尚未轉換的 Flutter 實作收納位置，不能視為宣告式 consumer API。

## 更新圖集

程式結構移動、檔案增刪或 import／part 關係改變時，從 repository root 執行：

```powershell
python tool/architecture_atlas/generate.py --dart D:/flutter/bin/dart.bat
```

之後檢查生成結果與本頁、[目前重構架構總覽](current-refactor-overview.md) 的人工摘要是否一致。不要直接手改 `docs/architecture/src/` 的自動產生頁面。

## 深入設計文件

- [Application runtime](application-runtime-prototype.md)
- [外部元件與 template](component-template-prototype.md)
- [合格子插槽](component-slots-prototype.md)
- [styling contract](styling-contract-prototype.md)
- [navigation transaction](navigation-transaction-prototype.md)
- [受控導覽還原](controlled-navigation-restoration.md)
- [受控環境策略](controlled-environment-policy.md)
- [受控 form 規劃](controlled-form-prototype.md)
