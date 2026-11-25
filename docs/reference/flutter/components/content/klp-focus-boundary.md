# KlpFocusBoundary

Flutter · Stable · 內容元件

## 主要職責

建立可回復焦點的邊界；對話框或導覽完成後可呼叫 [requestFocus]。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpFocusBoundary createExample(Widget child) => KlpFocusBoundary(child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpFocusBoundary extends StatefulWidget
```

## 建構子 KlpFocusBoundary



```dart
const KlpFocusBoundary({
	Key? key,
	required Widget child,
	bool autofocus = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |
| `autofocus` | `bool` | 否 | false | 依公開型別提供此輸入。 |


## 成員與方法

### createState

```dart
State<KlpFocusBoundary> createState()
```

由 Flutter 建立此元件的 State。

### requestFocus

```dart
static void requestFocus(BuildContext context)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。

- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/feedback/workflow/klp_finite_workflow.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/feedback/workflow/klp_finite_workflow.dart`。
