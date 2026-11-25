# KlpComboboxOption

Flutter · Stable · 資料與型別

## 主要職責

[KlpCombobox] 的一個候選項。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpComboboxOption createExample(String id, String label) => KlpComboboxOption(id: id, label: label);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpComboboxOption
```

## 建構子 KlpComboboxOption



```dart
const KlpComboboxOption({required String id, required String label})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別碼，用於 `Key` 與比對，不用於顯示。 |
| `label` | `String` | 是 | — | 顯示文字，也是輸入時比對過濾的依據。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/forms/input/klp_combobox.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/input/klp_combobox.dart`。
