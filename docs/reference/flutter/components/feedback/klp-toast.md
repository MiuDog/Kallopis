# KlpToast

Flutter · Stable · 狀態回饋

## 主要職責

短暫通知。**不負責排程與消失**——停留時間取自 `theme.motion.toastDwell`，
但實際的顯示與收起由呼叫端控制。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpToast createExample(String title) => KlpToast(title: title);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpToast extends StatelessWidget
```

## 建構子 KlpToast



```dart
const KlpToast({
	Key? key,
	required String title,
	String? message,
	KlpFeedbackTone tone = KlpFeedbackTone.info,
	String? actionLabel,
	VoidCallback? onAction,
	VoidCallback? onClose,
	String? closeLabel,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `title` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `message` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `tone` | `KlpFeedbackTone` | 否 | KlpFeedbackTone.info | 選擇語意呈現。 |
| `actionLabel` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `onAction` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |
| `onClose` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |
| `closeLabel` | `String?` | 否 | null | 關閉鈕的文字。有 [onClose] 時必填——庫不替產品決定用什麼語言。 |


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
- [KlpFeedbackTone](../../types/klp-feedback-tone.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/feedback/klp_toast.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/feedback/klp_toast.dart`。
