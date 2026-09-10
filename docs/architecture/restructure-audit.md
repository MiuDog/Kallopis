# 架構轉向前查核紀錄

日期：2026-09-09。對應 [重構架構與遷移計畫](restructure-migration-plan.md)。

## 查核邊界

查核目前工作目錄；未檢查外部 Notist／Krepis 實作，也未完成所有 869 個 Dart 檔的人工語義審查。來源入口、風格、布局、按鈕、路由與高階 editor 模組採抽樣追蹤；數量及全量驗證來自命令。

初始 Git：HEAD `8db8ea2`；619 修改、24 刪除、665 未追蹤狀態列。完整工作基準尚未備份，這是正式遷移 P0 的工作。本次僅保存狀態清單及驗證紀錄，不宣稱這些紀錄能恢復未追蹤內容。

環境：D:/flutter/bin/flutter.bat，Flutter 3.44.2 stable、Dart 3.12.2。此為本次實測，舊 AGENTS.md 環境表不再當作目前事實。套件 manifest 宣告 kallopis 0.8.0，Flutter 是目前唯一直接執行相依。

## 全量 Verify

執行 `.\tool\verify.ps1`，與 `.vscode/tasks.json` 的 Verify 指向同一入口；沒有傳 UpdateGoldens。總結 exit 1。

| 步驟 | 證據 | 結果 |
|---|---|---|
| Root／example pub get | 流程繼續至後續全部步驟，無相依失敗彙總 | 通過 |
| 格式 | `Formatted 1035 files (829 changed) in 4.07 seconds.`，exit 1 | 未通過 |
| Root analyze | `No issues found! (ran in 14.5s)` | 通過 |
| 元件清單 | `spec/component-inventory.md 已過期。請跑 dart run tool/inventory.dart。`，exit 1 | 未通過 |
| Catalog 語意分類新鮮度 | 無錯誤且未列入失敗彙總 | 通過 |
| Example analyze | `No issues found! (ran in 4.1s)` | 通過 |
| Root tests | `00:53 +661 -3: Some tests failed.`，exit 1 | 未通過 |
| Example tests | `01:59 +16 -63: Some tests failed.`，exit 1 | 未通過 |

格式步驟使用 `--output=none --set-exit-if-changed`，其中 changed 表示格式檢查判定會改變，不是本次寫回 829 個檔案。Tab 規約與 Dart formatter 的一致性需要 P0 判定；本次不擅自改成空格。pub get／測試可能寫入忽略的快取及失敗圖，不等於原始碼修改。

Root 的三個失敗：

- inventory_test.dart：元件清單過期。
- klp_section_test.dart：預期一個 KlpColumn，實際找到兩個。
- klp_tag_input_field_test.dart：預期一個 KlpColumn，實際找到兩個。

Example 的失敗包含 Catalog 匯出分類覆蓋與 golden 差異。例如 page_neutrals-ink-stone 的基準圖為 1400×1300，本次圖為 1400×1198；page_scale dark 有 0.88%、31301 像素差異。這只證明當前工作樹與期待值不同，沒有判定是實作錯誤還是已同意的視覺變更；不更新基準掩蓋差異。

frontend_architecture_boundary_test.dart 已由 root 全量測試執行，未列入三個失敗；未另行重複跑同一測試。整套測試不通過，不能宣稱可直接開始大規模搬檔。

## 架構圖集

執行 `python tool/architecture_atlas/generate.py --dart D:/flutter/bin/dart.bat --check`，exit 1。

輸出：

```text
Extracted 869 Dart files without syntax errors.
Generated 869 file pages, 210 folder pages, 2665 diagrams.
Atlas out of date
```

差異列於 manifest.json、shell/composition/app_screen/README.md、klp_app_screen.md，以及其 primitives 頁面。check 使用暫存輸出，沒有重新產生或手改現有圖集。人工摘要另有拆檔前來源路徑，需在 P7 同步核對。

## 本次交付與未完成項

已產出目標架構、依賴規則、能力契約、舊目錄對照、P0–P9 計畫、可檢驗驗收條件、風險回退與命名提案。

後續同輪補充已納入計畫：唯一總體結構樹、註冊解析、功能節點自動安裝、預設狀態與控制器、平台情境矩陣與失敗回收。這是新增目標，未宣稱既有程式已提供這些能力。

未進行程式重構、重新命名、修復既有失敗、更新 golden、外部產品遷移或遠端操作。提案內的目標檔案不表示已存在 API。

本頁記錄重構前的初始查核；當時命名提案已由後續保留 Kallopis、使用 Klp 前綴的決策取代。原候選的名稱搜尋不能當作 Kallopis 可用性證據。

## 原始證據位置

本機暫存目錄 `C:/Users/ASUS_TUF/AppData/Local/Temp/kallopis-architecture-audit-20260909/` 保存 status-before.txt、verify.log、atlas.log；暫存資料可能被清理，重要結論及輸出尾行已保存於本文件。正式 P0 應將完整快照與驗證證據保存到持久位置。
