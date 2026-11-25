# KlpDocumentEditActions

Flutter · Experimental · 操作元件

## 主要職責

文件的進入編輯、儲存與取消動作組。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDocumentEditActions createExample(bool editing, String editLabel, String saveLabel, String cancelLabel) => KlpDocumentEditActions(editing: editing, editLabel: editLabel, saveLabel: saveLabel, cancelLabel: cancelLabel);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDocumentEditActions extends StatelessWidget
```

## 建構子 KlpDocumentEditActions



```dart
const KlpDocumentEditActions({
	Key? key,
	required bool editing,
	required String editLabel,
	required String saveLabel,
	required String cancelLabel,
	VoidCallback? onEdit,
	VoidCallback? onSave,
	VoidCallback? onCancel,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `editing` | `bool` | 是 | — | 依公開型別提供此輸入。 |
| `editLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `saveLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `cancelLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `onEdit` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |
| `onSave` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |
| `onCancel` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |


## 成員與方法

### build

```dart
Widget build(BuildContext context)
```

由 Flutter 依目前 context 建構畫面。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)。

- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/artifact/klp_artifact_workspace.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/artifact/klp_artifact_workspace.dart`。
