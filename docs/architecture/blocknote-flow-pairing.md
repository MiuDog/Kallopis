# BlockNote Flow：Kallopis／Krepis 配對

Explorer 配對注意：EXP-V1-r2 已移除舊 Explorer 型別、onMove/canMove 與專用路徑。以下涉及 Explorer 的 pending 切片須依 [現行配對](explorer-v1-plan/README.md) 重新 PLAN；pageReferences 尚未公開，不得套用舊 Packet 開工。其他 Flow 契約保持。

修訂 `KBF-PAIR-r2`，2026-09-15。使用者已授權本任務提供 Kallopis 方配對；本輪同時擔任兩庫的配對 architecture owner。**兩庫技術契約已配對，實作與獨立驗收尚未交付**。

唯一 wire／正文 schema 來源為 [KBF-WIRE-r2](../../../Krepis-m0-checked-save/bindings/block_note/contracts/flow-protocol.md)，不在本檔維護第二份 schema。Krepis 的 [公開 API](../../../Krepis-m0-checked-save/bindings/block_note/architecture.md) 與 [產品定義](../../../Krepis-m0-checked-save/spec/block-note-flow-capabilities.md) 保持權威。本檔定義 Kallopis 如何滿足該契約，不取得 E owner 的磁碟版本及跨檔交易權威。

## 本輪接受的配對決定

| 項目 | Kallopis 的承諾 | 狀態 |
| --- | --- | --- |
| 頁面連結 | 正式 BlockNote schema 註冊 krepisPageLink；完整身分取最新投影、typed 開頁 | 契約接受，待實作 |
| 資料庫 | krepisDatabase table view；單一上游交易執行列命令，正式 undo/redo | 契約接受，待實作 |
| 拖放 | Explorer 提供 typed 頁面來源；renderer 換算座標、正式 editor 判定列位置；Flow 驗證後只執行一次命令 | 契約接受，待實作 |
| gate／reload | 所有正文入口受控、IME 排空、ack 可辨識、重建 editor 歷史基線 | 契約接受，待實作 |
| 不確定結果 | host incarnation、可靠事件交付與重新鎖定快照；不用舊 committed 正文覆蓋解鎖後輸入 | 契約接受，待實作 |
| E 持久版本 | E owner 在 resume 前重接 persist 的 expectedRevision | 仍待 E owner，不由本配對宣告完成 |

本輪只配對表格 view／列順序。Notion 圖片的屬性、排序、篩選、分組、AI、自動化與資料庫鎖定選單仍是參考；不新增這些產品行為。

## 公開宣告入口

以下是下一個 BUILD 使用的 API 契約，**目前 Dart 尚無這些新欄位**；既有 constructor 參數／節點 ID／插槽保持相容。

### KlpBlockNoteEditingContent

新增 optional named parameters：

| 欄位 | 型別與預設 | 語意 |
| --- | --- | --- |
| `pageProjections` | `Iterable<KrepisPageProjection>`，預設空；建構時轉不可變 List | 完整最新集合，缺項為 unknown；不持久化、不進 undo；每次宣告更新替換集合 |
| `onOpenPage` | `Future<void> Function(KrepisPageOpenRequest)?` | request 含 page、hostBlockId、可選 database/view/reference 身分；不與舊 onOpenReference 混用 |
| `onDatabaseDrop` | `Future<KrepisBlockNoteEditResult> Function(KrepisDatabaseDropRequest)?` | consumer 驗證後呼叫 session.insertDatabaseReference；缺 callback 不接受 drop，不私自插入 |

adapter → prepared → bound 全程保留 controller／callback 身分。使用 Kallopis 宣告節點時，pageProjections 是該呈現的唯一投影來源；renderer 透過 session.configurePages 更新，不要求 consumer 同時手動 configurePages。

`onOpened` 保留唯一呼叫 owner 與既有先後：bridge 建立 → appearance → 能力協商（新功能需要時）→ open 並確認 ready → 初始 pageProjections → 舊 pending commands flush → onOpened。既有 asset/reference 回呼原樣保留；onOpened 內既有插入不被重複執行。宣告重新準備只更新 projection/callback，不重開 editor。

Krepis 額外提供唯讀 `operationStatus` 與 broadcast `operationChanges`，讓 renderer 訂閱鎖定與 blocked。renderer 不覆寫 session.onChanged，不另設 registry；先訂閱再讀目前 status，依 statusVersion 去重。OperationStatus 由 Krepis 單一狀態產生，不保存另一份正文。

### Explorer 的頁面來源資料

`KlpExplorer` 新增 `Map<KlpId, KrepisPageReference> pageReferences = const {}`，建構時不可變複製；key 必須能對應本 Explorer 中的具身分、可選取且非 category 項目。未提供映射時，原 Explorer 內部移動行為維持，不能由 label/sourceId 猜 page 身分。

映射只表示來源頁面的投影身分，active／同專案／操作授權由 consumer 重驗。映射值不包含 Widget、座標、script 或 style。欄位僅讓既有列可作頁面參考來源，不新增一個視覺元件。

drag 到 database 只發 onDatabaseDrop，不呼叫 Explorer.onMove；drag 到 Explorer 維持既有 canMove/onMove。首版 typed request 是單頁：來源選取多頁時不部分取第一頁插入，不影響既有 Explorer 多選移動。需要批次 database drop 另行定義。

## 私有責任與相依方向

```mermaid
flowchart TD
	Explorer[Explorer pageReferences] --> Platform[Rendering 私有拖放與 WebView]
	Content[BlockNote content] --> Bound[Features prepared 與 bound]
	Bound --> Platform
	Platform --> Bridge[Krepis 公開 bridge 契約]
	Bridge --> Web[正式 BlockNote host]
	Web --> Events[已驗證的 typed event]
	Events --> Flow[Flow 回呼]
	Flow --> Session[Krepis Session 命令]
	Session --> Web
```

座標與 DOM 只在 rendering／web 內流動。Flow 只接完整 page、database/view/index/version。正常 drop 的唯一正文變更來自 Flow 驗證後送出的 Session 命令，Web 不在發出 drop event 時先插入。

| Module | 本 stage 所屬責任 |
| --- | --- |
| features/editing | 新 content 參數、bound 透傳、語意資料；不處理 wire Map 或 Flutter Widget |
| features/workspace | Explorer 頁面映射與 bound 透傳；不推定頁面 active，不把參考 drop 當 parent move |
| rendering | 私有跨表面 drag carrier、座標換算、host attachment 身分、transport receipt、typed 回呼與錯誤呈現 |
| tool/blocknote_editor | custom blocks、table 列交易、投影呈現、輸入 gate、正文快照／世代與 operation reconcile |
| Krepis | 公開值型別、wire decoder、session 狀態、保存排空及恢復快照；唯讀 observer |

Styling 仍由本庫 semantic resolver 提供；新增表格邊線、不可用狀態、drop 位置提示的值須在 features 的語意契約解析後交 bound。不得在 web/renderer 新增第二套預設 theme。新顯示字串由既有 foundation/localization 提供；操作 ID／debug error 不直接當產品文案。具體視覺接受維持 human-pending。

## 真實跨表面拖放

- 原 Explorer 的 Set<KlpId> 拖放資料由 rendering 內部 carrier 包含，追加對應的 typed page；不改 consumer 的 onMove 簽章。carrier 不外匯、不新建全域 session map。
- WebView 在有效單頁 drag 期間由 rendering 的私有接收區處理 drop；平台座標換成 WebView viewport 的正規化位置，經封閉 probe 交 web，以當下 DOM 列框判定 before/after index。consumer 不傳像素或自定 hit test。
- probe/release 綁定 dragId、hostInstanceId 與 session；放開時重新查詢實際命中與當前正文 version。empty database 的 body 命中 index 0；離開 database body 或找不到有效列即拒絕，不 fallback 到另一個 database。
- hit test 不依名稱或視覺上的第幾個資料庫定位；使用正式 custom block ID、viewId、referenceId。scroll/zoom/resize 只影響私有換算，結果仍為 typed placement。
- 平台 WebView 的 drag 接收與 overlay 行為必須由 Windows 真實宿主驗證；HTML dataTransfer 的桌面瀏覽器成功不能替代 Flutter/WebView 證據。
- 所有 probe 只讀。鎖定／blocked 期間取消 drop 預覽並拒絕 release。回呼只對一次有效 release 派發一次；過期 source、session 變更與重複 delivery 不再派發。

## 正式 editor 執行策略

1. 用本機鎖定的 0.54.2 custom schema 註冊兩個 block；頁面 title／available 從非正文投影讀取，DOM text 使用安全文字呈現，不當 HTML 執行。
2. table rows 僅有 wire 定義的頁面 occurrence 和順序。查找、insert/move/remove 的唯一演算法位於 web helper；Dart 只驗證公開型別與 envelope。
3. 完整驗證 expectedVersion、目標、索引及 payload 後，使用 `editor.transact` 提交，前後隔離 history 群組，沿既有 templateInsert.ts 的已使用模式；async 資產解析完成後再次驗證 session／epoch／gate。
4. 主入口先統一 gate；所有舊命令、toolbar、快捷鍵、paste/drop/undo/redo 與延後完成的 Promise 都不能繞過。`editor.isEditable=false` 加交易攔截是必要組合，不能只遮住 UI。
5. composing 中的 lock 先標 pending，攔新操作，等自然 compositionend 與最後 input transaction；不 blur、不合成事件、不抹除 composition。若逾時回 busy/detail=compositionPending 並維持 blocked，沒有成功 barrier，E 不得提交。
6. reload 以傳入正文建立全新 editor/history 世代，先 readonly 解析及比較持久快照，成功才原子切換 active editor。feature-enabled editor 設 trailingBlock=false，避免載入時自動追加段落；普通 legacy session 保留既有設定。舊 editor 的快照先保留，新世代不繼承其 history。不要用原 editor.replaceBlocks 當成清空 undo；React/BlockNoteView 管理 mount/unmount，舊 listener 與 async 結果按 epoch 失效。
7. host 的 protocol/runtime 維持在 editor 世代之外，持有 lock/reload receipt、hostInstanceId 與有界 outbox；只保留不可編輯快照，不另建 live 正文模型。

## 有序交付與恢復

KBF-WIRE-r2 定義 hostInstanceId（一次 JS 宿主生命週期）及 deliverySeq（每個 delivery 的序號）。正文 epoch/eventSeq 與 transport 序號分開，command.result 與 changed 可以指同一正文變更但各有 deliverySeq。

- JS 的單一 outbox 依序 await callHandler 的 typed receipt；只在 receipt 相符後移除。失敗停止後續交付，保留資料並收緊輸入 gate，不 fire-and-forget。
- Dart 收到 raw message，先由 Krepis.acceptFlowMessage 驗證／套用／去重，再回 receipt。typed page/drop 回呼在 receipt 之後非同步派發；不等待 callback 內 save 才回 receipt，避免 outbox 阻擋 snapshot 造成死鎖。
- 重複 delivery 回相同 receipt，不重複派發 typed 回呼。未知 future gap 需要 resync；不能直接略過未涵蓋的 changed。
- acquiring/reloading/releasing 不確定時，Krepis.reconcileOperation 觸發 host 重新封鎖輸入、排空既有有效編輯及 callback，回完整最終快照／版本／lock與reload狀態。此控制回覆使用獨立 recovery lane，不被已失敗的普通 outbox 頭部阻擋；快照明列涵蓋的 delivery/event 界線。
- 解鎖 ack 遺失後若已新增文字，reconcile 的新快照以較新的 revision 回復到 locked/dirty；不重播 committed document，不將其設為 clean。E owner 能再 saveLocked 保存新增輸入。
- 若 hostInstanceId 改變，代表先前 JS editor 已消失。renderer 不呼叫普通 open 去覆蓋 blocked session；Krepis 保留已取得的快照並回 recoveryRequired／hostReplaced。未曾傳出的瀏覽器記憶體無法被恢復時明示不完整，不宣稱資料已安全保存。由 E owner 決定重建 session，且不得清掉舊恢復資料。

## 模組切片與獨立證據

以下只列本 stage，精確 packet 由相應 module architecture 綁定；所有新測試與共享 fixture 由獨立 Test Author 凍結，產品實作者不得改。

| Slice | Owner／產出 | 必要證據 |
| --- | --- | --- |
| KP-F1 | features/editing：content、bound、observer 與 exports | constructor 相容、完整 typed callback、projection 更新不重開、onChanged 所有權不變 |
| KP-W1 | features/workspace：pageReferences → bound | 未映射不猜頁面、category／無效 key 拒絕、原 onMove 行為保持 |
| KP-B1 | web：custom blocks、projection、database 交易 | 鎖定 0.54.2 正式 bundle schema round-trip，單步 undo/redo、更名及不可用頁、無效位置零變更 |
| KP-B2 | web：barrier/reload/reconcile/outbox | 真實 history 基線、composition、pending async、事件亂序／ack 遺失、解鎖後新字保留 |
| KP-R1 | rendering：typed transport、observer、恢復、實際跨表面 drop | WebView attachment 不重開錯 session、source/target 精確、drop 不觸發 parent move、receipt 無死鎖 |

KP-F1/W1/B1/B2/R1 均尚未實作。跨模組新依賴只使用具名公開／套件內契約，不能以 internal import 例外繞過架構閘門。正式視覺與原生 IME／drag 需人類接受，deterministic 內容／事件驗收仍由獨立測試提供。

## 已核對的可行性證據與限制

本輪只做 source/API 核對，**不是 runtime 測試**：

- 本機 `@blocknote/core/package.json` 確認 0.54.2；`types/src/schema/propTypes.d.ts` 有 string/number/boolean，`blocks/createSpec.d.ts` 有 content none 的 createBlockSpec。
- `types/src/editor/BlockNoteEditor.d.ts` 第 351–375 行有 transact、第 566–571 行有 isEditable；initialContent 與 schema 可建立新 editor。`@blocknote/react/src/hooks/useCreateBlockNote.tsx` 使用 create/options/deps，BlockNoteView 負責 mount/unmount。
- 既有 [templateInsert.ts](../../tool/blocknote_editor/src/templateInsert.ts) 已使用 transact/closeHistory 隔離前後編輯；這是實作範例，不作為新 database 已通過的證據。
- 現有 [EditorApp.tsx](../../tool/blocknote_editor/src/EditorApp.tsx) 仍 void callHandler 且 open 使用 replaceBlocks；[Flutter host](../../lib/src/rendering/flutter/internal/klp_flutter_block_note_editing.dart) 仍以 send/open Future 判斷流程，沒有本配對的新 ack／reconcile。

| 基線 | SHA-256 |
| --- | --- |
| package-lock.json | 3317661838E0B4420CC741270BD4AD53906927C6A0B02FB1C0FCB59627138285 |
| EditorApp.tsx | 6AE8392F674F20792D4A45EA6800D3842333B5340387005B479E4C6E3C4C7E86 |
| templateInsert.ts | C2E86E621D07C39BE2D42FEB70AA4FEC0776139FB4FCED81391DA43F3E00B54F |
| klp_block_note_editing_content.dart | 11F46DD8D05A3AF7E0B83DF8BDF61A053A593E470FEE2478DB743703AB2671E7 |
| klp_flutter_block_note_editing.dart | 3FCB9E91D6E8387BAD0525011D813E831643253C2EDB9D071143FFA71B5B972C |

兩庫 runtime 對照與獨立測試仍是發布閘門；不能把本輪 owner 接受契約寫成已完成 F2/E3。E owner 的 expectedRevision 重接、乾淨派工基線及正式實作證據仍未完成。

本輪文件證據：Kallopis 7 份與 Krepis 4 份文件 read-back 通過，whitespace／fence 與限定 diff 檢查 exit 0；Krepis 11 個正式來源 hash 與 Kallopis 已核對的 4 個產品碼 hash 均未變。Mermaid 未渲染；沒有產品測試、獨立 conformance 測試或原生 WebView 驗收通過的宣告。
