# KlpPhaseToggle

Flutter · Stable · 輸入元件

## 主要職責

階段／多態切換按鈕組。

邊框軌道、正方形分段，寬度隨選項數量延展。支援二態、三態與多選項目。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpPhaseToggle<T> createExample<T>(List<KlpPhaseOption<T>> options, T? selected) => KlpPhaseToggle<T>(options: options, selected: selected);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpPhaseToggle<T> extends StatelessWidget
```

## 建構子 KlpPhaseToggle



```dart
const KlpPhaseToggle<T>({
	Key? key,
	required List<KlpPhaseOption<T>> options,
	required T? selected,
	ValueChanged<T>? onSelected,
	bool enabled = true,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `options` | `List<KlpPhaseOption<T>>` | 是 | — | 依公開型別提供此輸入。 |
| `selected` | `T?` | 是 | — | 由產品持有的選取狀態。 |
| `onSelected` | `void Function(T)?` | 否 | null | 將選取意圖交回產品。 |
| `enabled` | `bool` | 否 | true | 依公開型別提供此輸入。 |


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
- [KlpPhaseOption](../../types/klp-phase-option.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/forms/toggle/klp_phase_toggle.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/toggle/klp_phase_toggle.dart`。
