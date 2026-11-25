# KlpDialog

Flutter · Stable · 狀態回饋

## 主要職責

對話框內容。**不負責彈出**——呼叫端自行決定用 `showDialog` 或其他方式呈現。
`secondaryLabel` 為必填：庫不替產品決定用什麼語言說「取消」。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDialog createExample(String label, String title, Widget child, String primaryLabel, void Function() onPrimary, String secondaryLabel) => KlpDialog(label: label, title: title, primaryLabel: primaryLabel, onPrimary: onPrimary, secondaryLabel: secondaryLabel, child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDialog extends StatelessWidget
```

## 建構子 KlpDialog



```dart
const KlpDialog({
	Key? key,
	required String label,
	required String title,
	required Widget child,
	required String primaryLabel,
	required VoidCallback onPrimary,
	required String secondaryLabel,
	VoidCallback? onSecondary,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `title` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |
| `primaryLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `onPrimary` | `void Function()` | 是 | — | 依公開型別提供此輸入。 |
| `secondaryLabel` | `String` | 是 | — | 次要動作的文字。**沒有預設值是刻意的**——庫不替產品決定用什麼語言說「取消」。 |
| `onSecondary` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/overlays/klp_dialog.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/overlays/klp_dialog.dart`。
