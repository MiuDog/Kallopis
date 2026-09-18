# 區塊控制系統（實驗，機制接線）

本頁供組裝畫面的 AI 使用。目前已有受限插槽、來源繼承、連續 range 選取、單／多區塊指標與鍵盤拖曳、邊緣自動捲動，以及 task checkbox／toggle chevron 的本庫控制入口。完整實機體驗仍待完成；以下是唯一 consumer 組裝格式，不得另加 Widget 補入口。

## API 與組裝

產品匯入 `package:kallopis/kallopis_declarative.dart`。將本庫的 `KlpBlockControls` 放入 `KlpEditingContent.blockControls`：

```dart
final editor = KlpEditingContent(
	id: 'editor',
	source: source,
	blockControls: const KlpBlockControls(id: 'editor.blocks'),
);
```

`source` 必須先初始化，並實作 `KlpBlockControlSource`；來源實作細節見 [編輯提供者](editing-provider.md)。控制節點只有 `id`，直接繼承所屬編輯器的唯一來源，不另收 source、Widget、局部 style 或繪製 callback。

本插槽最多一個 child，資格為 `KlpBlockControlSlotChild`。缺少來源能力、脫離合法編輯器或使用非法 child 時拒絕安裝。未提供 `blockControls` 時維持原編輯內容行為。

## 提供者與操作

- 同次 `KlpEditingDrawing.blocks` 攜帶 `KlpBlockProjection`；必須與 drawing 共用 stamp 及 viewport。`KlpBlockItem` 分別提供 hit／visual 矩形，不可互相替代。
- `KlpBlockIntent` 包含 `select`、`moveBefore`、`moveAfter`、`convert`、`toggleTaskChecked`、`toggleCollapsed`、`undo`、`redo`。單選只帶 `blockId`；range select／move 另帶 `rangeEndId`，兩者都是 stable endpoints，不用列表 index。狀態控制不要求 consumer 先組裝選取命令。
- 文字與區塊共用來源的 `issueCommandSequence()`，不得在每個 widget／session 另設從零開始的序號。同一來源重新安裝後須繼續編號。
- 區塊操作前沿本庫中斷機制取消未確認組字，保留已提交內容；未知結果不重送。權威接受後，drawing 與 block 投影一起更新；接受不代表保存完成。
- 桌面指標 hover 區塊時，Kallopis 顯示該列 grip；一般啟動選取單一區塊，Shift 啟動則以既有權威 anchor 延伸到該列。選取後可拖往同幀選取範圍外區塊的前半或後半。Kallopis 自動管理 hit rect 命中、range ghost、落點線、Esc／pointer cancel 與單次提交，consumer 不接收拖曳 callback，也不提供座標或 decoration。
- 鍵盤聚焦同一 grip 後，Shift+上／下以權威 anchor 延伸或縮短連續 range；Space 提起完整 range，上／下巡覽所有會改變順序的插入位置，Space 或 Enter 放下，Esc 取消。每個結果位置只出現一次，consumer 不新增快捷鍵或重送相鄰 move 模擬拖曳。
- 指標停在上下 semantic edge 內時，本庫自動送出受控 viewport request。每次捲動接受後，Kallopis 以新 frame 重綁 drop session 並重新命中；consumer 不切換 navigation mode、不建立 Timer，也不保存 scroll 副本。

## 目前限制

### 段落／標題轉換（協定已驗證）

`KlpBlockIntent.convert` 使用封閉的 `KlpBlockTextKind`：`paragraph`、`heading1`、`heading2`、`heading3`。來源及目標皆限這四種類型。請求只能修改當前單一選取區塊，必須先完成既有組字中斷，再取得新 drawing 與核心確認的選取身分。

以下是提供者／本庫命令接線的請求格式，並非要求 consumer 額外組裝格式工具列：

```dart
final request = KlpBlockRequest(
	sequence: source.issueCommandSequence(),
	expected: confirmedDrawing.projection.stamp,
	blockId: selectedBlockId,
	intent: KlpBlockIntent.convert,
	conversion: KlpBlockTextKind.heading2,
);
```

`conversion` 僅 convert 必填，其他 intent 禁帶；convert 禁帶移動用的 `targetId`。原生 checked 接點要求 ABI 1.28，完整核對 frame、版本、環境與選取目標。核心保留原文字、標記、筆跡及 BlockId，走既有 undo／redo；不以 `fontSize` 取代標題語意。原生矩陣及真 DLL 提供者驗證已通過，可見格式入口尚未完成；證據見 [S3 契約](../architecture/block-controls-contract-plan.md#s3-首切片段落與標題語意轉換)。

`KlpBlockItem.textKind` 是提供者必填的可空欄位：段落為 `paragraph`，可轉換標題為 `heading1`～`heading3`，未支援的標題層級或其他區塊為 `null`。它須與 `kind` 一致；`null` 不表示段落，也不能用顯示字級反推。Krepis 透過獨立 checked 類型查詢提供這項投影，保留既有 C 區塊資料結構的 ABI 配置。

### Task 與 Toggle 狀態（ABI 1.29）

`KlpBlockItem.taskChecked` 只允許出現在 `taskListItem`，`toggleCollapsed` 只允許出現在 `toggleListItem`；其他 kind 兩者皆必須為 `null`。安裝 `KlpBlockControls` 後，Flutter renderer 自動根據同版本投影建立 checkbox 或 chevron，consumer 不提供 icon、位置、樣式或 callback。

使用者操作直接送出 `toggleTaskChecked` 或 `toggleCollapsed`。Kallopis 先取消尚未確認的組字，再以最新 drawing 的 stable ID 送出單一命令。收合若會隱藏目前選取，Krepis 在同一 history 交易將選取移回父 toggle；undo 會恢復子項選取與展開內容。產品不得先送 `select` 再送 toggle 模擬這個生命週期。

### 項目／編號清單（ABI 1.32）

組裝仍使用上方同一個 `KlpBlockControls`，不另安裝清單工具列。選取段落或清單後，跟隨區塊的「區塊類型」選單提供項目清單、編號清單及縮排操作。焦點在區塊把手時，可用 Tab 增加縮排、Shift+Tab 減少縮排；操作不可用時保留焦點導覽。

提供者投影 `nestingDepth`、`listOrdinal`、`canIndent`、`canOutdent`；序號與巢狀深度由核心計算，產品不自行編號或指定 marker。`listOrdinal` 只用於編號清單；清單深度必填，其他區塊不得提供清單欄位。

封閉 intent 為 `convertToUnorderedList`、`convertToOrderedList`、`convertListToParagraph`、`indentList`、`outdentList`。全部帶當前權威選取的 `blockId`／`rangeEndId`，單選兩者相同；不帶 `conversion` 或 `targetId`。每次操作只送一筆命令，由核心提供一次 undo。標題直接轉清單目前未支援，不能由 consumer 串兩次命令補洞。

清單標記排版使用 ABI 1.33，正文結構操作使用 ABI 1.34。正文折疊游標支援 Tab／Shift+Tab 清單縮排、Enter 分項及空項退出、項首 Backspace 相鄰合併；consumer 沿用既有編輯器安裝，不新增原生 Widget。提供者以 `KlpEditingCommandIntent` 傳遞 `paragraphBreak`、`backspace`、`indentList`、`outdentList`。核心保留 marks／屬性，操作一筆 history；跨區塊或非折疊選取、active composition 與不合法結構明確拒絕。真 DLL provider 已驗分項／合併、marks、縮排／退出與 history；Flutter 鍵盤／IME、手機段首 Backspace 及保存重開整體流程仍待實機驗收。這些限制不能用原生 Flutter Widget 或局部 style 補足；追蹤見 [清單契約](../architecture/list-blocks-contract-plan.md)。

### 已驗證範圍

核心單區塊移動、狀態切換、撤銷／重做及版本拒絕已有真實 DLL 驗證；ABI 1.30 CTest 另證明 stable range selection、membership／anchor／focus 投影、range move 與 undo。本庫 range drop／session 與架構邊界合跑 `+171: All tests passed!`，相關 Dart analyze 無問題；真實 ABI 1.30 DLL provider 與 CJK outline 兩項驗證通過。hover grip、指標／鍵盤 range 建立與拖曳已接入 renderer；Windows 實機讀屏仍待完成。

完整分步範圍與證據見 [K02 契約](../architecture/block-controls-contract-plan.md)。外層 Workspace 組裝見 [編輯內容系統](editor.md)。
