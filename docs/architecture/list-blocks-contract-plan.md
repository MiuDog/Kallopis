# N06／N07：受控清單區塊契約

日期：2026-09-12。狀態以 [交接頁](../session-handoff.md) 為準；清單呈現仍未完成。此頁細化 [完整筆記元件計畫](note-components-plan.md) 的無序／有序清單，不縮減 N01–N68。

## 目標

消費端只提供文件資料與功能安裝；Krepis 保存清單種類、深度、穩定順序與歷史，Kallopis 依語意投影顯示 marker 並送出封閉操作。消費端不能傳入 marker Widget、字串、序號、縮排距離、顏色或 painter。

完成條件包含：段落與兩種清單互轉、Enter 分段、Backspace 合併、Tab／Shift+Tab 縮排、重排後有序編號重算、連續 range 操作、undo／redo、IME 中斷、鍵盤與讀屏，以及 Flow／Canva 共用同一資料語意。

## 現有權威與缺口

| 層 | 現有能力 | 缺口 |
|---|---|---|
| Krepis record | `FlowBlockKind` 已有 unordered／ordered；ABI 1.32 attribute batch 已將深度、父層與後代形成交易不變條件 | marker layout 尚未完成 |
| Krepis renderer | 可排版各 `ParagraphRecord`，collapsed toggle 已依深度隱藏後代 | 文字 x／可用寬度未依清單深度調整；沒有 marker，ordinal 查詢尚未抽成 renderer 共用核心機制 |
| C／Dart binding | ABI 1.32 已投影清單資料並接通五種 checked range operation | 缺少 marker layout 投影 |
| Kallopis | K02 已有 range selection、drag、checked list command、選單與區塊把手焦點的 Tab／Shift+Tab | marker、正文游標的清單鍵盤生命週期與實機驗收待完成 |

## 資料與演算法

`nestingDepth` 是文件資料，範圍 0–32。合法序列必須滿足：第一個可見 block 深度為 0；相鄰深度最多增加 1；增加深度時前一個 block 必須可作容器前驅；移出後不得讓既有後代失去父層。所有驗證在 Krepis transaction 內完成，UI 的 disabled 只提供回饋。

有序 marker 不保存成文字。Krepis 由目前 Flow 順序、深度、kind 與 `ordered_start` 推導 `listOrdinal`：同深度的連續 ordered run 從第一項的 start 起算；遇到不同 kind、較淺深度或新的明確 start 重開。Kallopis 定義封閉格式政策，Krepis 依政策格式化與 shaping 核心 ordinal；Dart 不使用畫面 index 重算或自行產生 marker 文字。

投影至少包含：stable ID、kind、nestingDepth、optional listOrdinal、canIndent、canOutdent、hitRect、visualRect、selection endpoints 與完整 stamp。未知或不一致資料 fail closed。

## 封閉操作

| 意圖 | 輸入 | 原子結果 |
|---|---|---|
| `convertToUnorderedList` | selected stable range | 保留文字、marks、ink、ID；設定 unordered，清除 ordered start |
| `convertToOrderedList` | selected stable range | 保留內容；首項取得合法 start，其餘由核心推導 |
| `convertToParagraph` | selected stable range | 清除 list-only attributes；後代依同筆交易合法移出或拒絕 |
| `indentList` | selected stable range | 全 range 與其後代平移一層；不可超過父前驅或深度上限 |
| `outdentList` | selected stable range | 全 range 與其後代移出一層；depth 0 拒絕 |

命令攜帶完整 drawing stamp、frame、stable first／last endpoints 與提交時間。組字中先沿 K01 取消尚未確認內容；unknown outcome 不重送。成功只建立一筆 history。

### 交易形狀

現有 `Transaction` 一次只允許一個 structure command，因此 range 清單操作不能在外層逐項呼叫 single-block convert。Krepis 必須新增一種 attribute-batch structure command：在 commit 內解析 stable endpoints、正規化 rank、擴張必要後代、驗證候選深度序列，再一次 COW 更新全部 attributes。history 保存同一批 before／after attributes，undo／redo 遇到任一筆分岔即拒絕且不移動 history cursor。

FlowEditor 沿用既有 `accept_commit`、selection rebind 與 layout publication，只新增一個 range list operation 入口。checked ABI 使用完整 rendered input、既有 stable range 結構、封閉 operation enum 與提交時間；要求 request endpoints 等於目前 block selection。這一層不得複用 ABI 1.28 僅支援 paragraph／H1–H3 的 singleton converter。

## 呈現與互動

Krepis 使用由 Kallopis 整套 resolved style 注入的 `listIndent` 與 `markerGutter` 計算文字布局，並依核心 ordinal shaping bullet 或 number；Kallopis 使用同一 projection 的 command range 與 marker geometry 重播結果。marker 的大小、色彩、baseline 與選取狀態只來自 editing semantic。

Kallopis 擁有封閉 marker 格式政策與完整 semantic style；Krepis 執行該政策的 shaping、群組量度與 geometry，Kallopis 只重播同幀 marker commands。不得由 Flutter `TextPainter` 再量一次，也不得從 RGBA 猜 marker role。舊 style ABI 與 block-control struct 保持原大小；新版完整 style 與 marker geometry 使用新增 symbol，啟用新版後舊 setter 明確拒絕局部降級。

同一連續清單群組先取得最大 marker advance，再共用 gutter，形成 hanging indent。窄 viewport 不修改文件 depth 或 ordinal；群組依最大深度共同縮小視覺 indent step，優先保留至少八個正文 em。空間仍不足時裁切 marker gutter，正文、caret、selection 與 hit-test 繼續使用同一 text origin，不能讓各路徑各自 clamp。

Tab／Shift+Tab 只在 block selection 或 caret 位於 list block 且沒有 active composition 時送 list intent。Enter／Backspace 沿核心 split／merge；空 list item 的 Enter 轉成較淺層或 paragraph。drag 移動父項時，是否連同後代移動由 Krepis 先擴張 stable range，Kallopis 不自行掃描深度猜測。

### 下一個完整交付切片：核心清單排版（待實作）

本節是 2026-09-12 唯讀來源稽核後的交付邊界，不代表已實作。Krepis 來源以 `D:/Projects/Krepis-m0-checked-save` 為準；下列 `src/`、`include/` 與 `bindings/` 路徑均相對於該 worktree。

1. **共用正文幾何。** `src/flow_editor_render.cpp` 的 `FlowEditor::publish_display`、`src/flow_editor_hit_test.cpp` 的 `hit_text`，以及 `src/flow_editor_geometry.cpp` 的 `caret_rect`、`composition_rect`、`text_selection_rects` 現在各自以相同 padding 算全寬；尚無清單縮排。抽出核心共用 block geometry，統一 text origin、available width、marker gutter 與群組縮排結果，再接回 render、命中、游標、組字、選取與區塊 visual／drag geometry。沿用既有 `layouter_.layout`、`append_paragraph_layout`、layout index 與 display frame，不只移動畫面上的文字。
2. **ordinal 單一來源。** `src/krepis_c_checked_input.cpp` 目前在清單查詢內倒掃先前項目計算 ordinal。將其移為 renderer 與 checked query 共用的核心演算法；目前倒掃沒有遇到新 explicit start 就停止，須先確認資料如何區分明確 restart 與一般項目 start，再補齊契約與驗收，不能直接複製既有迴圈。
3. **完整 style 與同幀 marker 投影。** `include/krepis/krepis_c.h` 的 `KrepisEditorStyle` 沒有 list indent、gutter 或 marker policy 欄位，既有 setter 在 `src/krepis_c_checked_input.cpp` 嚴格檢查 struct 大小。以新增 symbol 接受完整 resolved style（名稱可用 StyleV2，名稱本身不是需求），保留舊 struct 大小；新版啟用後拒絕舊 setter 局部降級。另以新增 symbol 投影 marker command range、geometry 與明確角色，綁定同一 rendered stamp；不擴寫既有 block-control struct。
4. **Dart mapper 的責任。** 同步 `bindings/dart/lib/src/krepis_editor_style.dart` 與 `krepis_style_writer.dart` 的完整值映射，Kallopis 將 editing semantic 與封閉格式政策整套送入。回程 mapper 僅驗證並映射同幀 command range、角色及 geometry，交由既有重播路徑呈現；不量字、不重算序號、縮排或 baseline，也不從 RGBA 推測角色。
5. **一次驗收完整幾何。** 混合段落、兩層以上清單、跨位數序號、明確 restart、重排與 undo／redo 後，marker、正文換行、caret、組字、selection、hit-test 和拖曳位置須一致。窄 viewport 驗證群組共同縮小 indent step、八個正文 em 的保留目標，以及不足時裁切 gutter；depth／ordinal 不變，所有路徑使用同一 text origin，不各自 clamp。另驗 stale frame 拒絕、換 semantic style 後同幀更新與舊 setter 降級拒絕，再以真實 DLL 和 Windows 畫面確認；未通過前不得標為清單呈現完成。

此切片完成後仍須完成正文游標的 Tab／Shift+Tab、空項 Enter 等鍵盤生命週期與讀屏／觸控驗收，才能宣告完整清單功能交付。

## 當前切片：清單連續編輯

本輪沿既有 geometry、checked stamp、selection 與 history 接點，完成正文鍵盤到核心交易的流程，不新增 UI 組裝方式。

| 操作 | 可觀察結果 |
|---|---|
| 清單正文 Tab／Shift+Tab | 合法時增加／減少深度，正文游標保持可編輯；組字中不執行清單縮排 |
| 非空清單 Enter | 依游標分為兩項，保留兩側文字與 marks，選取落在新項起點 |
| 空清單 Enter | 巢狀項降低一層；depth 0 轉 paragraph |
| 項首 Backspace | 沿核心合法合併規則處理相鄰項，不丟文字、marks 或後代；不合法結構明確拒絕 |
| undo／redo | 每次結構操作一筆 history，恢復文件結構、marks 與相應選取 |

順序：定位直接入口與最小缺口 → Astra 鎖定既有上層測試／fixture → Sol 補核心及跨層接線 → 首條路徑可執行即局部驗證 → 同步 Catalog／AI 使用說明。保存重開復用既有 owner 能力核對本輪產生的結構，不新建保存系統。

明確 restart 的資料表示另列既有未決問題；本切片不得宣稱它已支援。平台實機操作未跑就明示，不以 provider 測試替代 Flutter 鍵盤／IME 驗收。

## 實作順序與驗證

1. projection：投影 depth、ordinal 與操作能力；鎖定 stale／非法序列拒絕。
2. transaction／checked ABI：單一與 range convert、indent、outdent；驗內容與 history。
3. layout／renderer：文字縮排、marker、選取與 drag geometry 使用同一 frame。
4. Flutter interaction：工具列、Tab／Shift+Tab、讀屏與觸控等價入口。
5. Catalog／Planist：混合段落、兩層清單、重排、保存重開與長文案例。

功能行為以現有成品蒸餾為入口：文字與區塊操作先對照 Notion，頁面／卡片與視覺層級對照 Craft，手寫對照 Concepts，空間操作對照 Miro。每個行為先記錄可觀察 trigger／result，再轉成上述權威契約；不為尚無成品證據的假設預建抽象。

依使用者測試策略，每個完整主體集中執行一次；只有失敗才細分。UI 尚在探索期，不建立新的 golden。

## 風險與回退

主要風險是把序號或父子關係複製到 Flutter、移動父項卻遺留後代、以及 marker 與核心文字使用不同 x。以同幀投影、transaction range expansion 與單一 style writer 避免。回退只停用 list 操作註冊，不改寫或降級已保存的 list records。

## 狀態與測試政策

當前完成／未驗證／部分修改僅見 [交接頁](../session-handoff.md)。舊測試尾行與逐次記錄已移出，本頁保留契約，不沿歷史 ABI 1.32 通過結果推定 1.33 可用。
必要測試與模型隔離按 AGENTS：功能主體完成後先局部上層，失敗才細分；未必要不新增／執行測試。
