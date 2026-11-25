# KlpWindowAppIcon

Flutter · Stable · 內容元件

## 主要職責

以視窗按鈕尺寸包裝消費端圖示，圖形本身維持 App icon 語意尺寸。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpWindowAppIcon createExample(double controlExtent, double iconExtent, Widget child) => KlpWindowAppIcon(controlExtent: controlExtent, iconExtent: iconExtent, child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpWindowAppIcon extends StatelessWidget
```

## 建構子 KlpWindowAppIcon



```dart
const KlpWindowAppIcon({
	Key? key,
	required double controlExtent,
	required double iconExtent,
	required Widget child,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `controlExtent` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `iconExtent` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/workspace/shell/window/klp_window_app_icon.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/window/klp_window_app_icon.dart`。
