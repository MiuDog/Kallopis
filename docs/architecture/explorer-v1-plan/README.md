# Explorer 契約 v1 — EXP-V1-r2

## EXP-V1-r3 箭頭與後代收合

依 EXP-17～19，PLAN／BUILD 已完成，局部驗證通過；EXP-V1-r3 Catalog 外觀與互動已由使用者於 2026-09-15 回覆「同意」接受。分類一律顯示箭頭，可收合空分類可切換；一般節點仍需有子項。兩種箭頭使用 disclosureIconExtent（distance i3，12px），命中及一般圖示保持 20px。KlpExplorerData.expandedIdsAfter(KlpId id, bool expanded, {bool collapseDescendants = false}) 回傳該項所屬樹的不可變完整展開集合，不提交資料；遞迴模式移除所有後代含隱藏後代，其他樹與選取不變。未知項或不可切換項拋 explorer_invalid_expansion。既有 onExpandedChanged(id, bool) 保持。 Planist 批次提交接口與各模組 architecture.md 已配對。選擇純計算方法保留既有回呼，避免逐後代回呼導致中間狀態，也不新增 KLP 內部 expansion 權威。依序完成 features、rendering、Catalog、Planist slices；獨立測試保護公開狀態轉移。EXP-V1-r3 Catalog 已由使用者接受。冷啟動估計各程式 slice 2k～6k tokens／5～15 分鐘，Flutter/Dart 本機執行，歷史參考 EXP-V1-r2 無可比實測用量。每 slice 以局部 analyze／測試與 scope gate 為里程碑；超過兩倍估計時回報原因。


依據：[已接受規格 EXP-01～16](../../../spec/explorer-composition.md)。本輪已完成資料、呈現、公開入口與呼叫端替換；2026-09-15 使用者已接受最後一輪 Explorer Catalog，基準見 [Catalog](../../ai/explorer-catalog.md)。本文取代舊 Sidebar-v2 Explorer 計畫與 EXP-V1-r1 資料獨立切片。

## 模組責任與實際路徑

| 所有者 | 路徑 | 責任 |
| --- | --- | --- |
| features / Workspace.Explorer | `lib/src/features/workspace/explorer/` | 可實作 item interface、完整森林快照、有限能力、結構資格與封閉節點 |
| Explorer adapter | `explorer/internal/klp_explorer_adapter.dart` | 獨立 semantic keys、共享森林掛載驗證、綁定受 frame lease 保護的事件 |
| Workspace.Command | `workspace/components/klp_workspace_command.dart`、`workspace/presentation/` | 命令資料及 async 結果；不執行商業邏輯 |
| rendering | `lib/src/rendering/flutter/internal/klp_flutter_explorer.dart` | 平坦可見列、受控選取／啟用／展開、鍵盤、拖放重驗證 |
| rendering / commands | `lib/src/rendering/flutter/internal/klp_flutter_commands.dart` | Explorer／WorkspaceBlock 共用選單、輸入、確認與卸載處理 |
| application | `lib/src/application/bootstrap/internal/` | 封閉 adapter 安裝清冊；不允許 consumer 註冊 renderer |
| 公開 library | `lib/kallopis_declarative.dart` | 唯一 Explorer 入口；資料模型及受限根節點 |
| Planist | `frontend/lib/features/workspace/layout/pln_sidebar_*.dart`、`pln_workspace_sidebar.dart` | 產品投影、完整森林組裝、事件與業務提交；不移入 KLP |

Consumer 精確 API、合法組裝及程式範本見 [Workspace.Explorer](../../ai/explorer-model.md)。風格與視覺檢查見 [Catalog](../../ai/explorer-catalog.md)。不增加產品專用模板或第二份資料／theme 權威。

## 分類箭頭修訂 EXP-V1-r2-arrow

使用者要求分類箭頭位於文字後方且縮小。現在由獨立 disclosureIconExtent 解析 distance i3（預設 12px），分類標題與箭頭緊接排列；命中寬度維持 20px，列高跟隨獨立分類列高用途（目前 28px）。一般節點依 EXP-V1-r3 使用相同箭頭尺度，前置位置不變。局部 analyze 通過，Catalog 已實際確認文字後方箭頭及收合／展開事件；12px 為本輪可調整候選。

## 拖曳視覺修訂 EXP-V1-r2-drag

拖曳預覽保留原 row.icon 與標題，與正式列共用圖示映射及 resolved 尺寸。插入線只對當次許可的目標顯示：before 在列上緣；after／inside 在完整可見子樹末端，inside 依子層縮排。指示依 EXP-V1-r2-drop-gap 填滿原有列間隙，使用 resolved focusColor，厚度為 gap、兩端半徑為 gap/2；不再使用 focusWidth 畫細線，不改命中與布局高度。首尾無間隙時顯示在列內側邊界。資料模型、權限及 onDrop 提交責任保持。

## 已接受列高 EXP-V1-r2-density

分類與節點列高各調為 28px（原 32px）。兩個用途各自校準自己的 resolved extent 至 7/8，保留完整 preset 的比例替換；不與圖示、padding、gap 相減連動。Catalog 已更新，字級與圖示大小保持。

## 關鍵契約

- Item 是 interface 資料，role 僅 category/node；只有樹根可有分類。Node 類型明列 canHaveChildren；hasChildren 由完整 children 推導。
- Data 一次捕捉完整不可變森林；樹 ID 與出現 ID 不重複，scope 每樹恰一份，選取／展開狀態必須一致。所有成員在同 runtime 掛載且共用同一 data。更新重新宣告，沒有 SnapshotStore。
- 根 schema `kallopis.explorer`，內部 schema `kallopis.explorer.entry`。Internal entry 不匯出，不接受外部 KlpNode 來註冊視覺。
- SelectionChange 包含 scopeId／selectedIds／anchorId；onActivate 與 onExpandedChanged 分離。primaryAction／selectable／collapsible／draggable 不由產品類型推導。
- 拖放預設拒絕；preview／commit 同樣驗證 sourceIds、targetId、before／inside／after 與 consumer 當次許可，實際資料提交在 consumer。
- 命令 FutureOr<void>，結果 completed／canceled／failed；選單、輸入、確認共享 renderer。取消不 invoke，失效 lease 不提交。
- 普通樹透明；node/category extent、icon、category font、indent、inset、gap、disclosure、action 各有語意用途，不互相用尺寸相減推導。

## 清理範圍

已刪除 workspace/components 的舊 Explorer、舊 bound item，以及 navigation/widgets/explorer 的舊 Widget／models 共 7 個來源檔。Foundation 舊 Explorer exports、舊 item schema、舊版公開資料型別、共享 renderer 內的專用分支均已移除；沒有 shim。相鄰 KlpFileExplorer 是另一個 Stable API，未包含在本次替換。

Catalog 導航與 specimen、兩份清冊、來源 atlas、consumer 文件及 Planist 4 個接線檔同步遷移。歷史 Task Packet 保留審計用途，不再作新 BUILD 指令。尚未實作的 KBF page-reference 需求須按新 API 重新配對；舊檔案邊界失效，不能直接開工。

## 驗證與剩餘閘門

獨立 Test Author 維護模型、互動、命令、公開目錄與安裝測試。132 項相關測試通過；既有浮動操作 footer 座標測試遷移前同樣失敗（expected 588 / actual 592），保留斷言並與本輪測試證據分開記錄。

Planist 4 個接線檔及遷移的 integration test analyze 通過；既有 3 個 business tests 未通過，涉及目錄未掛載、舊 folder 建立及命令名稱，不能以改測試或插入未授權產品功能處理。Explorer Catalog 已獲使用者接受；這不代表上述產品問題已修復。全庫其他視覺治理維持各自 DEFINE／READY 狀態。

完整命令結果、未通過項與整合限制見 [驗證紀錄](verification.md)。
