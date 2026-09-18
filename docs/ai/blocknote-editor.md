# BlockNote 正文編輯器（實驗）

F2／E3 的頁面連結、表格資料庫、typed 拖放與操作鎖／重載已完成 [Kallopis／Krepis 配對契約](../architecture/blocknote-flow-pairing.md)，**尚未實作發布**。新參數與命令目前不可直接接入；下方現有 API 說明保持有效，不以配對文件代替能力交付證據。

新建正文以 BlockNote 文件為唯一權威。Consumer 提供版本化初始文件與宿主持久化 callback，再用 `KlpBlockNoteEditingContent` 放入 screen body。Consumer 不提供 WebView、Widget、script、局部 style 或 editor theme。

```dart
final session = KlpBlockNoteSessionController.hosted(
	documentId: 'notes.example',
	sessionId: 'notes.example.open-1',
	initialDocument: KlpBlockNoteDocument(
		schemaVersion: KlpBlockNoteDocument.supportedSchemaVersion,
		blockNoteVersion: KlpBlockNoteDocument.supportedBlockNoteVersion,
		blocks: const [
			{'type': 'paragraph', 'content': '正文'},
		],
	),
	persist: (document) async {
		await repository.replaceDocument(document.toJson());
	},
);

final body = KlpBlockNoteEditingContent(
	id: KlpId.parse('notes.editor'),
	controller: session,
);
```

`persist` 必須在 durable replacement 完成後才結束 Future。保存期間若又收到修改，已取得的快照仍可完成保存，但 session 維持 dirty；失敗或快照逾時也維持 dirty，使用者可以再次保存。關閉宿主前呼叫 `requestClose()`；只有回傳 `KlpBlockNoteCloseResult.closed` 才可結束，`blocked` 表示仍有修改或保存正在進行。

保存格式固定為：

```json
{
	"format": "kallopis.blocknote",
	"schemaVersion": 1,
	"blockNoteVersion": "0.54.2",
	"blocks": []
}
```

讀入時應使用 `KlpBlockNoteDocument.fromJson()`，未知格式、schema 或 BlockNote 版本會拒絕載入。不要將舊 Krepis 文件自動轉成此格式；資料遷移必須另行定義。

目前正式 renderer 使用 package 內封裝的 BlockNote 0.54.2 與本機 WebView2。外部網址導覽會被拒絕。圖片保存只接受空網址或自包含的 `data:image/`；遠端與 `blob:` URL 會使快照驗證失敗並保留 dirty，避免重開後遺失圖片。Windows Catalog 的可執行入口與 asset 重建命令見 [`tool/blocknote_editor/README.md`](../../tool/blocknote_editor/README.md)。
