# KlpCombobox

Flutter · Stable · 輸入元件

## 主要職責

可輸入的下拉選單。輸入框重用 [KlpTextField]，下拉面板重用 [KlpMenu]。

這是受控元件：[query]、[options] 由呼叫端持有，本元件只負責過濾、鍵盤
導覽與事件分發。方向鍵移動候選，Enter 選定；允許自由文字時，沒有醒目
候選的 Enter 會觸發 [onFreeTextSubmitted]；Esc 收起面板。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpCombobox createExample(String label, String query, List<KlpComboboxOption> options, String menuLabel, void Function(String) onQueryChanged, void Function(KlpComboboxOption) onSelected) => KlpCombobox(label: label, query: query, options: options, menuLabel: menuLabel, onQueryChanged: onQueryChanged, onSelected: onSelected);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpCombobox extends StatefulWidget
```

## 建構子 KlpCombobox



```dart
const KlpCombobox({
	Key? key,
	required String label,
	required String query,
	required List<KlpComboboxOption> options,
	required String menuLabel,
	required ValueChanged<String> onQueryChanged,
	required ValueChanged<KlpComboboxOption> onSelected,
	String? placeholder,
	String? helper,
	String? error,
	bool enabled = true,
	bool allowFreeText = false,
	ValueChanged<String>? onFreeTextSubmitted,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `query` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `options` | `List<KlpComboboxOption>` | 是 | — | 依公開型別提供此輸入。 |
| `menuLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `onQueryChanged` | `void Function(String)` | 是 | — | 依公開型別提供此輸入。 |
| `onSelected` | `void Function(KlpComboboxOption)` | 是 | — | 將選取意圖交回產品。 |
| `placeholder` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `helper` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `error` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `enabled` | `bool` | 否 | true | 依公開型別提供此輸入。 |
| `allowFreeText` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `onFreeTextSubmitted` | `void Function(String)?` | 否 | null | 依公開型別提供此輸入。 |


## 成員與方法

### createState

```dart
State<KlpCombobox> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- [KlpComboboxOption](../../types/klp-combobox-option.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/forms/input/klp_combobox.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/input/klp_combobox.dart`。
