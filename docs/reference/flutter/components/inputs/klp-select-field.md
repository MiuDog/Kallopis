# KlpSelectField

Flutter · Stable · 輸入元件

## 主要職責

單選下拉欄位：目前值顯示為一列文字，點擊展開選項清單並就地插入版面
（不是彈出層），選中後自動收合。

[valueLabel] 是呼叫端算好的顯示文字，不會反查 [options] 對應哪一項——
這個元件不知道「目前選的是哪個 id」，只負責畫出清單與回報點擊。
需要彈出式選單而非就地展開時請改用 [KlpMenu]。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSelectField createExample(String label, String valueLabel, List<KlpChoiceOption> options, void Function(String)? onSelected) => KlpSelectField(label: label, valueLabel: valueLabel, options: options, onSelected: onSelected);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSelectField extends StatefulWidget
```

## 建構子 KlpSelectField



```dart
const KlpSelectField({
	Key? key,
	required String label,
	required String valueLabel,
	required List<KlpChoiceOption> options,
	required ValueChanged<String>? onSelected,
	bool enabled = true,
	bool readOnly = false,
	String? error,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `valueLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `options` | `List<KlpChoiceOption>` | 是 | — | 依公開型別提供此輸入。 |
| `onSelected` | `void Function(String)?` | 是 | — | 將選取意圖交回產品。 |
| `enabled` | `bool` | 否 | true | 依公開型別提供此輸入。 |
| `readOnly` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `error` | `String?` | 否 | null | 依公開型別提供此輸入。 |


## 成員與方法

### createState

```dart
State<KlpSelectField> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- [KlpChoiceOption](../../types/klp-choice-option.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/forms/selection/klp_select_field.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/selection/klp_select_field.dart`。
