# KlpFieldGroup

Flutter · Stable · 輸入元件

## 主要職責

把多個相關輸入（例如一組 checkbox）當成單一 [KlpField] 呈現，用
[legend] 取代單一欄位的 `label`。

內部直接委派給 [KlpField]，因此標籤／錯誤的排版與單一欄位完全一致；
差別只在 `child` 換成 [children] 這組垂直排列的子項目。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpFieldGroup createExample(String legend, List<Widget> children) => KlpFieldGroup(legend: legend, children: children);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpFieldGroup extends StatelessWidget
```

## 建構子 KlpFieldGroup



```dart
const KlpFieldGroup({
	Key? key,
	required String legend,
	required List<Widget> children,
	String? error,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `legend` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `children` | `List<Widget>` | 是 | — | 產品提供的子內容。 |
| `error` | `String?` | 否 | null | 依公開型別提供此輸入。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/forms/core/klp_field_group.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/core/klp_field_group.dart`。
