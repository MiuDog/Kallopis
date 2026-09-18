# EXP-V1-r2 驗證紀錄

日期：2026-09-15。這是本輪 Explorer 替換的證據，不是全庫或全產品通過聲明。

## 人類接受

2026-09-15 使用者在圖示與放置長條對齊修訂後回覆「通過，進入下一步」。目前 Explorer 外觀已接受，具體基準見 [Catalog](../../ai/explorer-catalog.md)。下方的測試結果為各次實際執行紀錄，本次接受文件更新未重跑程式測試；Planist Sidebar 組裝與未通過的產品測試不在此接受範圍。

## 通過

| 範圍 | 結果 |
| --- | --- |
| 獨立作者的 Explorer 模型、互動、命令、sidebar、封閉目錄及 application 清冊 | 132 tests PASS |
| 整合後 frontend architecture boundary ＋ declarative public API | 157 tests PASS |
| Planist 純記憶體完整森林、展開及啟用／選取投影 | 2 tests PASS |
| KLP 9 個受影響來源範圍 analyze | 無問題 |
| Planist 4 接線檔＋遷移 integration test analyze | 無問題 |
| Planist 新接線測試 analyze | 無問題 |
| Planist workspace/layout 宣告式 consumer 邊界 | PASS |
| Catalog standalone Flutter web 編譯／啟動 | PASS |
| 整合完整性 | 原檔對 snapshot 比對無衝突；來源與已測隔離工作樹一致；7 份受保護測試與獨立作者來源一致 |
| 舊入口清理 | 7 個舊來源、7 個過時 atlas 頁及舊 Sidebar-v2 Explorer 計畫刪除；公開面與清冊無舊 item schema |

132 項測試來自 `klp_explorer_model_contract_test`、`klp_explorer_test`、`klp_sidebar_v2_explorer_contract_test`、`klp_sidebar_interactions_test`、`klp_workspace_components_declarative_test`、`klp_application_catalog_contract_test`、`klp_closed_component_catalog_contract_test`。既有測試檔名保留以維持歷史；內容已改用公開新契約。

其中測試篩選明確排除既有 `floating action drags without activation, clamps and keeps footer fixed`：獨立作者在遷移前來源重跑也得到 expected 588／actual 592。未刪除或放寬該測試。

Planist 測試 `test/explorer_v1_wiring_test.dart` 驗證產品既有 single selection 跟隨啟用；onSelectionChanged 為 optional 且未接，onActivate 更新目前文件，再投影 selectedIds。此輪沒有增加多選產品流程。

## 尚未通過／限制

- Planist `sidebar_command_integration_test.dart` 原有 3 項 business tests 仍失敗：未掛載的 Flow 目錄、`createEntry(folder)` 回 wrongKind、找不到舊收藏命令名稱。保留原業務斷言；只遷移測試中的 KLP API 用法，不加入產品未要求的功能。未取得可執行的完整遷移前 Planist snapshot，因此不宣稱已由 baseline 重跑證明三者皆為既有失敗。
- Planist **全 frontend/lib** consumer 檢查未通過：未修改的 `features/workspace/content/pln_assets_content.dart:54` 仍使用 `kallopis_legacy_file_picker.dart`。本次改動的 layout 範圍通過；沒有加入忽略例外。
- 完整舊 Catalog 的 `foundation_pages.dart` 尚有既存 `KlpApp(appIcon: ...)` 參數錯誤，與此次刪除的 Explorer 無關。獨立 Explorer Catalog 不依賴該頁，已可執行。
- Catalog 的內部 harness 使用 3 個 `lib/src` imports，example analyze 會回報 3 個 implementation_imports info；公開 consumer API 的邊界測試通過，沒有為 harness 暴露 runtime 或加 analyzer 忽略規則。
- Atlas 僅整合本次受影響來源與祖先索引，共更新 33 頁，並核對對應來源 SHA256；不宣稱未修改的整套 atlas 通過 freshness。

## 實際 Catalog 檢查

使用正式 renderer 在瀏覽器檢視淺色、深色、布局／命中框、一般／窄欄、長標題、深層與空節點。點擊普通列得到 `activate: plain`；行內確認使用共享對話框，提交後顯示 `已確認執行`。Catalog 已保留供人類檢查。

這些是編譯、事件與可見畫面的觀察。尺寸、風格、互動手感與易用性仍為 **human-pending**；不以本紀錄替使用者接受候選。

## 重跑入口

```powershell
# Kallopis 根目錄
D:/flutter/bin/flutter.bat test test/frontend_architecture_boundary_test.dart test/klp_declarative_public_api_test.dart
D:/flutter/bin/dart.bat run tool/verify_declarative_consumer.dart D:/Projects/Planist/frontend/lib/features/workspace/layout
# Planist/frontend
D:/flutter/bin/flutter.bat test test/explorer_v1_wiring_test.dart
```

Catalog 入口與啟動指令見 [Catalog](../../ai/explorer-catalog.md)，API 見 [Workspace.Explorer](../../ai/explorer-model.md)。
