# KlpFormSection

Flutter · Stable · 輸入元件

## 主要職責

表單中的一個可摺疊分組，帶標題、選填說明與一組欄位。

[collapsed] 與 [onToggle] 由呼叫端持有狀態——這個元件本身不記憶展開與否，
純粹依 [collapsed] 決定要不要畫出 [children]。互動標題沿用本庫的
焦點及鍵盤原語；[onToggle] 為 null 時保持靜態標題。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpFormSection createExample(String title, List<Widget> children) => KlpFormSection(title: title, children: children);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpFormSection extends StatelessWidget
```

## 建構子 KlpFormSection



```dart
const KlpFormSection({
	Key? key,
	required String title,
	required List<Widget> children,
	String? description,
	bool collapsed = false,
	VoidCallback? onToggle,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `title` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `children` | `List<Widget>` | 是 | — | 產品提供的子內容。 |
| `description` | `String?` | 否 | null | 補充描述。 |
| `collapsed` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `onToggle` | `void Function()?` | 否 | null | 將展開或切換意圖交回產品。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/forms/core/klp_form_section.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/core/klp_form_section.dart`。
