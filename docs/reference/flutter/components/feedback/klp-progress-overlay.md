# KlpProgressOverlay

Flutter · Stable · 狀態回饋

## 主要職責

提供覆蓋內容的進度提示；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpProgressOverlay createExample(Widget child, bool visible, String label) => KlpProgressOverlay(visible: visible, label: label, child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpProgressOverlay extends StatelessWidget
```

## 建構子 KlpProgressOverlay



```dart
const KlpProgressOverlay({
	Key? key,
	required Widget child,
	required bool visible,
	required String label,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |
| `visible` | `bool` | 是 | — | 依公開型別提供此輸入。 |
| `label` | `String` | 是 | — | 顯示標籤。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/feedback/view_states/klp_view_states.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/feedback/view_states/klp_view_states.dart`。
