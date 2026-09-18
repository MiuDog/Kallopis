# 編輯模式與導覽系統（實驗）

供 AI 與 consumer 組裝編輯器的模式能力。K04 的資料、插槽、來源確認與核心捲動機制已通過相關協定驗證。工具列的可見入口、鍵盤／讀屏切換與實機捲動驗收尚未交付，不能將安裝成功視為完整模式切換體驗。

## 前置需求與組裝

畫面匯入 `package:kallopis/kallopis_declarative.dart`，使用既有編輯器唯一來源；來源另實作 `KlpEditorModeSource`。提供者型別從 `package:kallopis/kallopis_editing_provider.dart` 匯入。

目前 Dart binding 建立 Krepis 原生 engine 需 ABI 1.28；模式所需 Flow 高度接口於 1.26 加入。開啟流程須注入完整 `KrepisKallopisModeLabels`，含文字／導覽／手寫的模式及工具標籤、手寫停用原因。這些是提供者資料，不由畫面節點另建語系或 handler；原生範例見 [Catalog 入口](../../example/editor_native/README.md)。

```dart
final editor = KlpEditingContent(
	id: 'editor',
	source: source,
	modeToolbar: const KlpModeToolbar(id: 'editor.modes'),
);
```

`modeToolbar` 只接受 `KlpModeToolSlotChild`，最多一個。本庫工具列只帶 id，從父編輯器繼承來源；不另外注入模式 controller、原生 handler、Widget 或 style。可以與 [區塊控制](block-controls.md) 和 [定位命令](anchored-commands.md) 同時組裝，仍共用來源與提交序號。

唯讀來源可提供導覽模式；若宣告可用的文字工具，必須同時具 `KlpEditableSource`。缺少完整手寫處理時不得啟用手寫。首次安裝與後續投影更新都會核對此規則，不能先以停用資料通過再改成不具備的能力。

## 資料格式與權責

| 型別 | 內容及限制 |
|---|---|
| `KlpEditorModeItem` | 穩定 id、label、文字／導覽／手寫用途、可用性及停用原因。 |
| `KlpEditorToolItem` | 工具 id、所屬 modeId、支援 pointer 類別與單一輸入通道；不能用 callback 存在代表能力已可用。 |
| `KlpEditorModeProjection` | 完整 stamp、mode revision、activeModeId／activeToolId、transition、模式與工具集合及 viewport。 |
| `KlpEditorViewportProjection` | 同幀 width／height、核心內容高度與 scrollY；捲動範圍由內容高度和可視高度決定。 |
| `KlpEditorModeRequest` | 來源核發 sequence、expected stamp、modeRevision 與目標 modeId／toolId。 |
| `KlpEditorViewportRequest` | 同一序號及版本規則，加上實際垂直 deltaY；不由 consumer 自算排版或平移舊 frame。 |

來源負責確認模式、工具與能力；核心保持內容、選取與排版權威。本庫負責平台事件分流與呈現。模式 revision 不能假冒文件內容版本；模式切換也不代表保存完成。

## 切換生命週期

切換時先封鎖新事件，等待在途操作，取消未確認組字並保留已提交文字。取得新 stamp 後才要求來源確認；接受並發布新模式後，本庫才啟用相應輸入處理。未知結果先重新同步，不自動重送，也不能先把按鈕顯示成切換成功。

明確拒絕或目標在等待中撤銷時，若來源仍確認文字模式可用，本庫會在結束在途狀態後恢復原文字輸入；不將 rejected 改成 accepted。未知結果、來源失效或關閉時不能恢復。

文字、導覽與手寫須維持輸入排他；同一次事件不能同時選字、捲動與落筆。導覽使用核心提供的實際範圍，捲動後重新取得同幀幾何與命中資料。尚未完成的手寫擷取、預覽與提交不能標示可用。

## 排錯與目前界線

| 情況 | 處理方式 |
|---|---|
| 模式／工具 id 不符或重複 | 修正提供者註冊資料，不用 label 或索引代替身分。 |
| 工具能力停用 | 呈現來源的停用原因；不能用空 handler 假裝開啟。 |
| 切換結果未知 | 保留最後一致資料並重新同步；不得繼續派送依賴新模式的事件。 |
| 捲動後版本或幾何不符 | 重新取得一致核心 frame，不在 consumer 補座標偏移。 |
| 節點存在但沒有工具列 | 可見入口尚未交付，不以 Flutter Widget 另建操作通道。 |

驗證證據：K04 與 K01–K03 回歸、架構邊界合計 188 項獨立通過；恢復路徑後續 13 項補驗通過，靜態分析無問題，真實 DLL／C ABI 檢查通過。這些不是 UI 或實機手勢驗收。實作及剩餘驗收依 [K04 契約](../architecture/editor-mode-contract-plan.md)；完整手寫另依 [K05 契約](../architecture/handwriting-input-contract-plan.md)。
