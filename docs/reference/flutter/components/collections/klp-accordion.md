# KlpAccordion

Flutter · Stable · 資料呈現

## 主要職責

可摺疊的內容區清單。

[multiple] 為 `false`（預設）時同一時間只能展開一項，再點其他標題會先收合原本
展開的那項；為 `true` 時各項互不影響。展開狀態是暫存的 UI 狀態而非產品資料，
因此元件自行持有——需要預先展開特定項目或觀察變化時用 [initialExpandedIds] 與
[onExpandedChanged]。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpAccordion createExample(List<KlpAccordionItemData> items) => KlpAccordion(items: items);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpAccordion extends StatefulWidget
```

## 建構子 KlpAccordion



```dart
const KlpAccordion({
	Key? key,
	required List<KlpAccordionItemData> items,
	bool multiple = false,
	Set<String> initialExpandedIds = const <String>{},
	ValueChanged<Set<String>>? onExpandedChanged,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `items` | `List<KlpAccordionItemData>` | 是 | — | 由產品提供的項目。 |
| `multiple` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `initialExpandedIds` | `Set<String>` | 否 | const <String>{} | 依公開型別提供此輸入。 |
| `onExpandedChanged` | `void Function(Set<String>)?` | 否 | null | 依公開型別提供此輸入。 |


## 成員與方法

### createState

```dart
State<KlpAccordion> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- [KlpAccordionItemData](../../types/klp-accordion-item-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/collections/accordion/klp_accordion.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/accordion/klp_accordion.dart`。
