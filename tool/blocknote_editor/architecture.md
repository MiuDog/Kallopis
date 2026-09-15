# BlockNote 正式編輯器

修訂 `KBF-PAIR-r2`，2026-09-15。Flow prerequisites v1 配對契約已接受、實作 pending；既有 T1 範本契約與受保護驗收保持，需求位於 Planist `docs/planning/acceptance-handoff.md`「本批範本」段落。

本模組擁有 `src/` 及由既有 build 產生的 `../../assets/blocknote_editor/`。BlockNote 是正文與 undo 唯一權威；宿主命令由 EditorApp 轉成上游交易，不維持第二份正文。

`template.insert` 接受 `blocks` 與可選 `afterBlockId`。先完整驗證與解析資產，再插入完整子樹；指定 anchor 不存在時拒絕且正文不變。非同步解析後再次核對 session 與 anchor。未提供 anchor 時使用目前游標位置，無有效游標時使用文件末端。每次插入必須隔離為一次真正引擎 undo，redo 還原原插入身分。身分重配歸 Krepis；編輯器保留傳入身分並拒絕碰撞。

既有 T1 修復範圍為 `src/EditorApp.tsx`、`src/templateInsert.ts` 與正式 bundle。資產 hydrate/persist 僅為插入子樹所需而遞迴處理；T1 的不增加 UI 或依賴限制保持對該修復生效。Flow 新功能只按下節配對切片執行，不藉此改寫 T1。`tool/verify_blocknote_template.cjs`、其他測試及 fixture 唯讀。

驗收：既有正式 bundle 範本測試指定位置、父子內容與格式、單步 undo/redo、非法 anchor 不污染及 snapshot 重開。視覺與原生 WebView 操作仍待人工驗收。

## Flow 配對與所屬責任

[KBF-PAIR-r2](../../docs/architecture/blocknote-flow-pairing.md) 固定 Kallopis 的實作策略；正文 schema／wire 只引用該文件連到的 Krepis KBF-WIRE-r2，不另寫一份定義。

| Slice | 精確 source write_paths（相對本 module） | 責任 |
| --- | --- | --- |
| KP-B1 | `src/EditorApp.tsx`、`src/flowReferenceBlocks.tsx`、`src/flowDatabaseTransactions.ts`、`src/flowProtocol.ts` | custom page/database block、純顯示投影、單交易列操作、typed result；不先 drop 後雙重插入 |
| KP-B2 | `src/EditorApp.tsx`、`src/flowProtocol.ts`、`src/flowOperationHost.ts`、`src/flowMessageOutbox.ts` | 全輸入 gate、barrier、全新 editor/history 世代、有序 receipt、reconcile 及 hostInstanceId |

前置：Krepis r2 decoder／宣告與 conformance fixture 凍結；appearance／在地化只使用 Kallopis 既有或經對應 owner 凍結的解析值。樣式檔、依賴、package-lock 與非本模組檔案預設不可寫；新 table 呈現所需 style 必須另列窄白名單，不提供任意 CSS 擴充。

`flowDatabaseTransactions` 是列調位的唯一演算法 owner；Krepis 不做 live 列排序。`flowOperationHost` 擁有 host lock/attempt/reload receipt，但不保存第二份可編輯 blocks。`flowMessageOutbox` 只保存未確認事件；正文仍在 active editor，恢復期間只有不可變快照。

operation.lock 收斂 composition 與已接受 transaction 後才 ack。每個 async mutator 在 commit 前重驗 attempt/epoch/lock；readOnly UI 不能替代 gate。reload 建立新的 editor instance/history，不用 replaceBlocks 當清空歷史；活躍 JSX/BlockNoteView 只綁定當前世代，舊 listener 不可發布到新 epoch。

## 驗收、產物與估算

- Test Author 所屬新路徑：`tool/verify_blocknote_flow_references.cjs`、`tool/verify_blocknote_operation_gate.cjs`、`tool/fixtures/blocknote_flow_protocol.json`（相對 repo 根）。須使用正式 build 產物及凍結 fixture，驗證真實 custom schema、單步 undo/redo、重載歷史隔離與不確定結果恢復；產品 worker 不修改 tests。
- KP-B1 的 M1：schema/projection/codec round-trip（累計 5k–9k tokens／45–90 分）；M2：列命令/undo/rejection/直接 template 回歸（累計 10k–20k／1.5–3.5 小時）。
- KP-B2 的 M1：gate/IME/pending async（累計 7k–13k／1–2 小時）；M2：reload/outbox/reconcile 與故障案例（累計 15k–30k／2.5–5 小時）。
- 皆為 cold-start，無歷史 task ID，沿用目前模型及本機鎖定 npm dependencies；超過上限或遇未涵蓋資料遺失案例即回 architecture owner。等待 peer／人工操作不算估算內。
- `assets/blocknote_editor/` 是本 module 既有生成產物 ownership，只有 bundle delivery owner 的窄 packet 可以由 build 更新；不能手改或讓一般 source worker 跨範圍重建。
- 新能力測試尚未執行。0.54.2 的 custom props/transact/isEditable/initialContent/trailingBlock 目前只有本機來源核對證據；不能稱為 runtime 已通過。

## 本次執行補充（KBF-WEB-r2a）

本輪新隔離工作樹已準備，使用 KBF-WIRE-r2a 與 KBF-PAIR-r2a 精確契約。KP-B1/B2 共同提供一次可驗證的正式 editor stage；scope 僅含原表六個 source 路徑。公開頁面／資料庫型別與兩端共享 fixture 由 Krepis 協定定義。測試須先由獨立 Test Author 凍結。source worker 不改樣式檔或依賴；原文字／背景／字型由既有 appearance 繼承，資料顯示不另加固定風格。需要新增語意 token 時先向 owner 提出精確需求。bundle 由 delivery owner 建立到 D:/Projects/f2-delivery/editor-bundle，通過後才接回 assets。

## KBF-WEB-r2b 型別接線補充

KP-B1 另允許 src/templateInsert.ts 僅把 Block／BlockNoteEditor 型別泛化為已配對 Flow schema；交易、驗證與 history 行為不變。原預設 schema 型別不能承載 custom blocks，實際 tsc 已證實此接縫。既有範本驗收仍受保護。
