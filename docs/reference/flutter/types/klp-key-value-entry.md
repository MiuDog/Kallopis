# KlpKeyValueEntry

Flutter · Stable · 資料與型別

## 主要職責

[KlpKeyValueEditor] 裡的一組鍵值對，[id] 用來在清單改動時識別是哪一列
（純文字的 key 可能重複或暫時是空字串，不適合當識別碼）。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpKeyValueEntry createExample(String id, String keyText, String value) => KlpKeyValueEntry(id: id, keyText: keyText, value: value);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpKeyValueEntry
```

## 建構子 KlpKeyValueEntry



```dart
const KlpKeyValueEntry({
	required String id,
	required String keyText,
	required String value,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |
| `keyText` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `value` | `String` | 是 | — | 目前值。 |


## 成員與方法

### copyWith

```dart
KlpKeyValueEntry copyWith({String? keyText, String? value})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `keyText` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `value` | `String?` | 否 | null | 目前值。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/forms/structured/klp_key_value_editor.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/structured/klp_key_value_editor.dart`。
