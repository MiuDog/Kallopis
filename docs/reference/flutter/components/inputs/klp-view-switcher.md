# KlpViewSwitcher

Flutter · Stable · 輸入元件

## 主要職責

以輕量分段表面呈現同層級檢視的受控切換器。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpViewSwitcher createExample(List<KlpViewOption> options, String selectedId, void Function(String)? onSelected) => KlpViewSwitcher(options: options, selectedId: selectedId, onSelected: onSelected);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpViewSwitcher extends StatelessWidget
```

## 建構子 KlpViewSwitcher



```dart
const KlpViewSwitcher({
	Key? key,
	required List<KlpViewOption> options,
	required String selectedId,
	required ValueChanged<String>? onSelected,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `options` | `List<KlpViewOption>` | 是 | — | 依公開型別提供此輸入。 |
| `selectedId` | `String` | 是 | — | 產品持有的選取識別。 |
| `onSelected` | `void Function(String)?` | 是 | — | 將選取意圖交回產品。 |


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
- [KlpViewOption](../../types/klp-view-option.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/navigation/widgets/controls/klp_view_switcher.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/controls/klp_view_switcher.dart`。
