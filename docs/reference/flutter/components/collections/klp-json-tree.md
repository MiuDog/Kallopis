# KlpJsonTree

Flutter · Stable · 資料呈現

## 主要職責

任意 JSON 相容值的可展開檢視器。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpJsonTree createExample(Object? value) => KlpJsonTree(value: value);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpJsonTree extends StatelessWidget
```

## 建構子 KlpJsonTree



```dart
const KlpJsonTree({
	Key? key,
	required Object? value,
	int defaultDepth = 1,
	Set<String> expandedPaths = const {},
	bool loading = false,
	bool invalid = false,
	ValueChanged<String>? onCopyPath,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `value` | `Object?` | 是 | — | 目前值。 |
| `defaultDepth` | `int` | 否 | 1 | 依公開型別提供此輸入。 |
| `expandedPaths` | `Set<String>` | 否 | const {} | 依公開型別提供此輸入。 |
| `loading` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `invalid` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `onCopyPath` | `void Function(String)?` | 否 | null | 依公開型別提供此輸入。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/collections/advanced/klp_advanced_data.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/advanced/klp_advanced_data.dart`。
