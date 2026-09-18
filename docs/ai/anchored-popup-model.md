# Anchored popup consumer guide

`KlpAnchoredPopup` 是受控宣告：consumer 擁有 `open`、資料與業務副作用；Kallopis 負責 trigger 錨定、panel、焦點與 dismiss。每次請求或資料結果改變，都建立並送出新的完整 declaration。

```dart
import 'package:kallopis/kallopis_declarative.dart';

KlpAnchoredPopup buildPopup({
	required bool open,
	required void Function(bool, KlpAnchoredPopupChangeReason) onOpenChanged,
	required void Function() onActivate,
	required void Function(String?) onRename,
	KlpAnchoredPopupState state = KlpAnchoredPopupState.ready,
	String? message,
}) {
	final popupId = KlpId.root('quick-actions');
	final triggerId = popupId.child('trigger');
	final archiveId = popupId.child('archive');
	final duplicateId = popupId.child('archive_copy');
	final trigger = KlpWorkspaceBlock(id: triggerId, kind: KlpWorkspaceBlockKind.action, title: '更多');
	return KlpAnchoredPopup(
		id: popupId,
		trigger: trigger,
		open: open,
		accessibilityLabel: '開啟快速操作',
		title: '快速操作',
		items: [
			KlpAnchoredPopupItem(
				id: archiveId,
				label: '未命名',
				current: true,
				onPressed: onActivate,
				commands: [KlpWorkspaceCommand(label: '更名', inputLabel: '名稱', onInvoke: onRename)],
			),
			KlpAnchoredPopupItem(id: duplicateId, label: '未命名', enabled: false),
		],
		state: state,
		message: message,
		onOpenChanged: onOpenChanged,
	);
}
```

組裝時只提供一個未選取的 `KlpWorkspaceBlockKind.action` trigger；trigger 不得有 `action`、`onPressed` 或 `actions`。本例只使用 `id`、`kind`、`title`；popup parent 是唯一 activation owner。

`onOpenChanged` 傳回的是開關 request。`trigger`、`outside`、`escape`、`anchorUnavailable` 都不會自行改寫 `open`；consumer 接受後，將新的完整 declaration 送回既有 application source。開關不派送 navigation、Stage 或 Explorer selection。

錨點暫時零尺寸或完全移出 viewport 時，會撤下可互動面板；若 consumer 保持 `open: true`，錨點恢復後會重新呈現。Consumer 明確移除整個宣告時，已退役的回呼不再執行。父 popup 關閉時，其子命令選單、輸入與確認視窗一併關閉。

`items`／`actions` 的 nullable 區段與 title、list、actions、feedback 次序由 library 固定；不要注入 Flutter Widget、style、任意 child 或巢狀 popup。item 以穩定 `KlpId` 識別，同一 popup 內 ID 不可重複，但 label 可以重複。

item 的 `current`／`enabled` 是資料投影。`onPressed` 可省略；commands 可獨立存在。`enabled: false` 會停用該列的所有 action 與 commands。item action、item commands、panel actions 執行後不自動關閉 popup；要關閉仍由 consumer 更新 `open`。

`state`／`message` 由 consumer 原樣回填以呈現 loading、ready、error、result。error 與 result 必須提供非空 message；清單、disabled、回饋或 callback 改變時，送出新的完整 declaration，相同身分可原地更新。

## 手動原生檢查

1. 鍵盤啟用 trigger 一次只開一次；焦點進入有效控制，Tab 在 popup 內循環。
2. 滑鼠測 trigger、panel 內列與 panel 外；外點只產生一次關閉 request。
3. Popup 開啟時按 Escape；child command 開啟時第一次 Escape 先關 child，第二次才關 popup。
4. 執行 item action 與 child command；確認內容／result 原地更新且 popup 不自動關閉。
5. 移動 trigger、縮小 viewport、移除 anchor；確認跟隨、翻轉／邊界限制及 `anchorUnavailable` 關閉 request。
