# EXP-V1-r3 — 箭頭與後代收合驗證

日期：2026-09-15。對應 [EXP-17～19](../../../spec/explorer-composition.md)。程式已實作並合回 Kallopis／Planist 工作目錄；本次沒有提交或推送原專案。EXP-V1-r3 Catalog 外觀與互動已由使用者於 2026-09-15 回覆「同意」接受。

## 結果

- 節點與分類箭頭使用同一 `disclosureIconExtent` 語意（distance i3，預設 12px）；一般圖示及箭頭命中寬度仍為 20px。
- 分類一律有箭頭，可收合的空分類支援指標、標題策略、左右鍵、Enter／Space；不可收合分類只呈現向下指示。
- `KlpExplorerData.expandedIdsAfter(id, expanded, collapseDescendants: false)` 提供單樹不可變提案；true 會遍歷完整 children，清除所有後代含隱藏後代。快照、其他樹及選取不變。
- Planist sidebar 預設選擇 true，透過 `setExplorerExpansion` 一次驗證並提交分類與節點展開集合；非法提案不部分提交、不通知。

## 程式證據

執行環境為 Windows、`D:/flutter/bin/`。在隔離工作樹測試，不存取或覆寫原筆記資料；Planist 測試只複製既有 i18n 資源供測試設定讀取。

| 檢查 | 結果 |
| --- | --- |
| KLP `flutter test test/klp_explorer_expansion_revision_test.dart test/klp_explorer_model_contract_test.dart test/klp_explorer_test.dart --reporter expanded` | 23 項通過 |
| Planist/frontend `flutter test test/explorer_expansion_revision_test.dart test/explorer_v1_wiring_test.dart --no-pub --reporter expanded` | 5 項通過 |
| KLP Explorer 模型／adapter／bound 與 renderer 局部 `dart analyze` | 無問題 |
| Planist 三個修改來源檔局部 `dart analyze` | 無問題 |
| Catalog 兩個修改來源檔局部 `dart analyze` | 無 error／warning；既有庫內 harness 的 3 個 `implementation_imports` info 保留 |
| features／rendering／Catalog／Planist 四個 BUILD slices 與兩個 Test Author 範圍檢查 | 全部 pass |
| `dart run tool/verify_declarative_consumer.dart ../Planist/frontend/lib` | 未通過：既有 `pln_assets_content.dart:54` 使用 `kallopis_legacy_file_picker.dart`；隔離基準同樣含該引用，檔案與本輪基準 hash 一致，本次未修改 |

獨立 Test Author 的新保護涵蓋空分類、錯誤展開提案、不可变集合、隱藏多層後代、其他樹與選取隔離、箭頭幾何、滑鼠／鍵盤等价及產品單次通知。新 API 未存在時為編譯阻擋，不冒稱行為 Red。

Planist 第一次執行因測試的 `_compose` 只走訪最外層群組而取得空集合；目前 Sidebar 已有巢狀 `KlpFrameGroup`。Test Author 修正新測試及既有 wiring test 的遍歷，保留全部原斷言；相同測試範圍重跑通過。這是測試 harness 修正，不新增產品布局。

受保護 SHA256：

- KLP `klp_explorer_expansion_revision_test.dart`：`FF4C96F5FD8285CBEB4541900F0F05F7A203D072E234DD6939E4BBD6EFCDD808`
- Planist `explorer_expansion_revision_test.dart`：`005B080F38B24801184E714D12B2B382FFCFD9B9157E8DD25DC05D87C9B036D3`
- Planist `explorer_v1_wiring_test.dart`：`607D2EDB636E9E864779DE7883C588D083738486C78D64BA8FF6B7EC4C51B75B`

## 實際 Catalog

已在正式 Web renderer 檢視一般／窄欄畫面，並操作「遞迴收合後代」→收合分類→重新展開分類。讀回狀態確認子節點為 Expand、深層後代隱藏，另一欄保持原展開狀態；空分類由 Collapse 切換為 Expand。沒有觀察到 console error；Flutter 自動替換 viewport meta 的既有警告保留。

本輪檢視網址：[Explorer Catalog](http://127.0.0.1:5881)。也可從 Kallopis/example 執行：

```powershell
D:/flutter/bin/flutter.bat run -d web-server --web-hostname 127.0.0.1 --web-port 5881 -t lib/explorer_catalog.dart
```

使用者於 2026-09-15 回覆「同意」，本輪 Catalog 外觀與互動已接受。此接受不延伸為完整 Planist 原生應用或無關商業流程的驗證。

## 工作範圍

隔離基準及 Task Packets 留在 `D:/Projects/.codex-explorer-20260915/`；各 module 的 architecture.md 為 EXP-V1-r3。實作逐 slice 經 scope checker 通過後才建立隔離提交供下一 slice 取用，原專案的 Git index／提交保持。

合回 11 個程式來源前，逐檔比較原工作目錄與隔離基準，確認沒有同時發生的來源修改；只複製這 11 檔。測試、契約與文件由其責任角色更新。Flutter 產生的建置檔及插件註冊檔不合回。

Cold-start 每個程式 slice 估計 5～15 分鐘／2k～6k tokens；程式 slice 均在時間範圍內完成。精確分角色 token 用量未由執行環境提供，不捏造測量值。
