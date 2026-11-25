# KlpFormActions

Flutter · Stable · 操作元件

## 主要職責

表單底部的動作列：送出／取消／重設按鈕，靠右對齊並在寬度不足時自動換行。

[cancelLabel]／[resetLabel] 為 null 時對應按鈕不會出現，[submitLabel] 與
[onSubmit] 恆為必填——表單至少要能送出。[submitting] 為 true 時三個按鈕
一併停用，避免送出過程中使用者重複觸發或誤按取消／重設。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpFormActions createExample(String submitLabel, void Function()? onSubmit) => KlpFormActions(submitLabel: submitLabel, onSubmit: onSubmit);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpFormActions extends StatelessWidget
```

## 建構子 KlpFormActions



```dart
const KlpFormActions({
	Key? key,
	required String submitLabel,
	required VoidCallback? onSubmit,
	String? cancelLabel,
	VoidCallback? onCancel,
	String? resetLabel,
	VoidCallback? onReset,
	bool submitting = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `submitLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `onSubmit` | `void Function()?` | 是 | — | 依公開型別提供此輸入。 |
| `cancelLabel` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `onCancel` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |
| `resetLabel` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `onReset` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |
| `submitting` | `bool` | 否 | false | 依公開型別提供此輸入。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/forms/core/klp_form_actions.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/core/klp_form_actions.dart`。
