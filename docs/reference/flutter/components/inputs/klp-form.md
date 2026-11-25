# KlpForm

Flutter · Stable · 輸入元件

## 主要職責

整份表單的最外層版面：錯誤總覽、各個區塊（[sections]）與底部動作列
依序排列，各區塊之間插入固定間距。

不管理欄位資料或驗證邏輯——[sections] 由呼叫端組好（通常是多個
[KlpFormSection]），[errorSummary] 通常放 [KlpFormErrorSummary]，
[actions] 通常放 [KlpFormActions]。三者皆為可選，缺席時不佔版位。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpForm createExample(List<Widget> sections) => KlpForm(sections: sections);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpForm extends StatelessWidget
```

## 建構子 KlpForm



```dart
const KlpForm({
	Key? key,
	required List<Widget> sections,
	Widget? errorSummary,
	Widget? actions,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `sections` | `List<Widget>` | 是 | — | 產品投影的區段資料。 |
| `errorSummary` | `Widget?` | 否 | null | 依公開型別提供此輸入。 |
| `actions` | `Widget?` | 否 | null | 依公開型別提供此輸入。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/forms/core/klp_form.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/core/klp_form.dart`。
