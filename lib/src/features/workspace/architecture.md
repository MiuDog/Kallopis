# Workspace 宣告式框架

## Explorer 契約 v1（EXP-V1-r1）

目前資料切片 `EXP-DATA-01` 已 PLAN READY，見 [配對契約](../../../../docs/architecture/explorer-v1-plan/README.md)。`explorer/` 為 features 內的純資料責任，不是新增視覺或產品模組。公開發布與 renderer 尚待同批接線，不可從目前資料實作推定新 UI 已上線。

下方 KBF-PAIR-r2 的 page reference 尚未實作；其「非 category」條件須於 Explorer 接線時按新角色／能力重新配對，不得向 DATA 切片混入 Krepis 或產品頁面來源權威。

## Explorer 頁面來源配對（KBF-PAIR-r2）

新增 KP-W1，配對契約 READY、實作 pending；下方 FRAME-8-R1 維持。依 [共通配對](../../../../docs/architecture/blocknote-flow-pairing.md)，`KlpExplorer` 新增 optional 不可變 `pageReferences: Map<KlpId, KrepisPageReference>`，預設空；只標示有型別的來源頁面，不取得 catalog 權威或從 label 猜身分。

KP-W1 精確 write_paths：`components/klp_explorer.dart`、`components/adapters/klp_workspace_components_adapter.dart`、`presentation/klp_bound_explorer.dart`、`presentation/klp_workspace_presentation.dart`。原 onMove/canMove／selection／parent 邏輯保持；資料庫 drop 由另一個目的地事件處理，不呼叫 onMove。

來源映射的 key 必須對應可選取、非 category 節點；未映射的項目只保留既有 Explorer 移動。bound 原樣攜帶 typed mapping，runtime carrier 由 rendering 私有建立；不把 Flutter DragTarget 或 WebView 資訊交 consumer。

獨立 test-owned path 為 `test/klp_explorer_page_reference_test.dart`；覆蓋完整 page key、映射不可變、invalid key/role 拒絕、空映射相容及原 Explorer 多選 move 行為。KP-W1 cold-start 3k–6k tokens／25–60 分，無歷史 task ID，沿用目前模型；M1 宣告／角色驗證（1k–3k／15–30 分），M2 bound／相容測試與 scope（3k–6k／25–60 分），超上限回報。新測試與產品實作均未執行。

修訂 FRAME-8-R1；本輪 READY 依據為 [8px／微立體契約](../../../../spec/frame-relief-8px.md)。

本輪所有權是 `layout/`（公開 app layout、frame、groups 與 adapter）、`components/adapters/klp_workspace_block_adapter.dart`（既有 gap 語意）及 `presentation/`（不可變 bound 資料）。其他 workspace 功能保留既有契約。

公開新增 `KlpAppFrameSurface.flat/raised`，由 `KlpAppFrame.surface` 選擇，預設 flat 保留原有使用者行為。Frame 保持零內容 padding、12px 圓角；bare 角色不繪製表面。間距三組語意改為 distance i2。Styling 擁有微立體配方，adapter 從 resolved surface／shadow／compactGap 產生 bound 陰影、亮邊與尺度，不把 primitive 或產品特例交給 renderer。

依賴方向：composition／styling → features adapter → features presentation → rendering。禁止 consumer style callback、Flutter Widget 與局部像素覆寫。

目前單一切片完成上述公開選項、語意與 bound 接線；獨立 test owner 擁有 `test/klp_app_frame_style_test.dart`、`test/klp_frame_groups_test.dart`。驗證 default flat、raised 外部陰影不改 child bounds、深色亮邊 alpha 降低與完整 preset 替換後重新解析。視覺品質 human-pending。
