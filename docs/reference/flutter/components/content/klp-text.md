# KlpText

Flutter · Stable · 內容元件

## 主要職責

以語意角色指定樣式的文字原語。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpText createExample(String data) => KlpText(data);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpText extends StatelessWidget
```

## 建構子 KlpText



```dart
const KlpText(
	String data, {
	Key? key,
	KlpTextRole role = KlpTextRole.body,
	KlpTextTone tone = KlpTextTone.automatic,
	int? maxLines,
	TextOverflow? overflow,
	TextAlign? textAlign,
	Color? color,
	TextDecoration? decoration,
	String? ellipsisText,
	bool excludeFromSemantics = false,
	KlpTextTracking? tracking,
	bool applyOpticalShift = true,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `data` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `role` | `KlpTextRole` | 否 | KlpTextRole.body | 依公開型別提供此輸入。 |
| `tone` | `KlpTextTone` | 否 | KlpTextTone.automatic | 選擇語意呈現。 |
| `maxLines` | `int?` | 否 | null | 依公開型別提供此輸入。 |
| `overflow` | `TextOverflow?` | 否 | null | 依公開型別提供此輸入。 |
| `textAlign` | `TextAlign?` | 否 | null | 依公開型別提供此輸入。 |
| `color` | `Color?` | 否 | null | 依公開型別提供此輸入。 |
| `decoration` | `TextDecoration?` | 否 | null | 依公開型別提供此輸入。 |
| `ellipsisText` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `excludeFromSemantics` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `tracking` | `KlpTextTracking?` | 否 | null | 依公開型別提供此輸入。 |
| `applyOpticalShift` | `bool` | 否 | true | 依公開型別提供此輸入。 |


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

- [Dock 受控操作](../../../../guides/flutter/10-apply-klp-dock-action.md)：跨元件使用流程。
- [2. 組合產品畫面](../../../../guides/flutter/03-klp-surface.md)：跨元件使用流程。
- 框架繼承成員：[StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)。
- [KlpTextRole](../../types/klp-text-role.md)
- [KlpTextTone](../../types/klp-text-tone.md)
- [KlpTextTracking](../../types/klp-text-tracking.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/foundation/content/klp_text_widget.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/content/klp_text_widget.dart`。
