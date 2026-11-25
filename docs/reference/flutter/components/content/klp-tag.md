# KlpTag

Flutter · Stable · 內容元件

## 主要職責

可移除或可點擊的分類標籤。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpTag createExample(String label) => KlpTag(label: label);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpTag extends StatelessWidget
```

## 建構子 KlpTag



```dart
const KlpTag({
	Key? key,
	required String label,
	String? prefix,
	VoidCallback? onRemove,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 標籤文字。 |
| `prefix` | `String?` | 否 | null | 前綴符號，例如 `#`。 |
| `onRemove` | `void Function()?` | 否 | null | 移除標籤的回呼。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/collections/badge/klp_badge.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/badge/klp_badge.dart`。
