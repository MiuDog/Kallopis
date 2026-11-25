# KlpSemanticRegion

Flutter · Stable · 內容元件

## 主要職責

將一般內容群組的可及性語意限制在基礎互動原語。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSemanticRegion createExample(String label, Widget child) => KlpSemanticRegion(label: label, child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSemanticRegion extends StatelessWidget
```

## 建構子 KlpSemanticRegion



```dart
const KlpSemanticRegion({
	Key? key,
	required String label,
	required Widget child,
	String? value,
	bool? enabled,
	bool? focusable,
	bool container = true,
	bool explicitChildNodes = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |
| `value` | `String?` | 否 | null | 目前值。 |
| `enabled` | `bool?` | 否 | null | 依公開型別提供此輸入。 |
| `focusable` | `bool?` | 否 | null | 依公開型別提供此輸入。 |
| `container` | `bool` | 否 | true | 依公開型別提供此輸入。 |
| `explicitChildNodes` | `bool` | 否 | false | 依公開型別提供此輸入。 |


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
- [宣告來源](../../../../../flutter/lib/src/foundation/interaction/klp_semantic_region.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/interaction/klp_semantic_region.dart`。
