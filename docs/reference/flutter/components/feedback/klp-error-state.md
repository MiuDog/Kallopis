# KlpErrorState

Flutter · Stable · 狀態回饋

## 主要職責

提供錯誤狀態提示；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpErrorState createExample(String title, String message) => KlpErrorState(title: title, message: message);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpErrorState extends StatelessWidget
```

## 建構子 KlpErrorState



```dart
const KlpErrorState({
	Key? key,
	required String title,
	required String message,
	KlpIconData? icon,
	String? retryLabel,
	VoidCallback? onRetry,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `title` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `message` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `icon` | `KlpIconData?` | 否 | null | 操作或內容圖示。 |
| `retryLabel` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `onRetry` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |


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
- [KlpIconData](../../types/klp-icon-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/feedback/view_states/klp_view_states.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/feedback/view_states/klp_view_states.dart`。
