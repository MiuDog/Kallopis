# KlpBulkActionBar

Flutter · Experimental · 操作元件

## 主要職責

以摘要標籤與可換行動作呈現批次操作列。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpBulkActionBar createExample(String label, List<KlpEditorActionData> actions) => KlpBulkActionBar(label: label, actions: actions);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpBulkActionBar extends StatelessWidget
```

## 建構子 KlpBulkActionBar



```dart
const KlpBulkActionBar({
	Key? key,
	required String label,
	required List<KlpEditorActionData> actions,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `actions` | `List<KlpEditorActionData>` | 是 | — | 依公開型別提供此輸入。 |


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
- [KlpEditorActionData](../../types/klp-editor-action-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/actions/editor/klp_editor_action_bars.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/editor/klp_editor_action_bars.dart`。
