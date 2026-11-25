# KlpOklchColorPicker

Flutter · Stable · 輸入元件

## 主要職責

以三個二維色彩平面與四軸控制編輯 [KlpOklchColor]。

元件不持有產品狀態；呼叫端以 [value] 與 [onChanged] 控制目前色彩。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpOklchColorPicker createExample(KlpOklchColor value, void Function(KlpOklchColor)? onChanged) => KlpOklchColorPicker(value: value, onChanged: onChanged);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpOklchColorPicker extends StatelessWidget
```

## 建構子 KlpOklchColorPicker



```dart
const KlpOklchColorPicker({
	Key? key,
	required KlpOklchColor value,
	required ValueChanged<KlpOklchColor>? onChanged,
	KlpOklchChromaRange chromaRange = KlpOklchChromaRange.standard,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `value` | `KlpOklchColor` | 是 | — | 目前值。 |
| `onChanged` | `void Function(KlpOklchColor)?` | 是 | — | 將值的變更交回產品。 |
| `chromaRange` | `KlpOklchChromaRange` | 否 | KlpOklchChromaRange.standard | Chroma 平面與控制項的編輯範圍，不限制 [KlpOklchColor] 可表達的值。 |


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
- [KlpOklchChromaRange](../../types/klp-oklch-chroma-range.md)
- [KlpOklchColor](../../types/klp-oklch-color.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/forms/color/klp_oklch_color_picker.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/color/klp_oklch_color_picker.dart`。
