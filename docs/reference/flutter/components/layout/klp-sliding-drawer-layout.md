# KlpSlidingDrawerLayout

Flutter · Stable · 布局元件

## 主要職責

讓側欄與舞台維持同層，並由受控進度推動舞台的抽屜布局。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSlidingDrawerLayout createExample(ValueListenable<double> progress, bool tracking, double drawerExtent, Widget stage, Widget drawer) => KlpSlidingDrawerLayout(progress: progress, tracking: tracking, drawerExtent: drawerExtent, stage: stage, drawer: drawer);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSlidingDrawerLayout extends StatelessWidget
```

## 建構子 KlpSlidingDrawerLayout



```dart
const KlpSlidingDrawerLayout({
	Key? key,
	required ValueListenable<double> progress,
	required bool tracking,
	required double drawerExtent,
	required Widget stage,
	required Widget drawer,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `progress` | `ValueListenable<double>` | 是 | — | 依公開型別提供此輸入。 |
| `tracking` | `bool` | 是 | — | 依公開型別提供此輸入。 |
| `drawerExtent` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `stage` | `Widget` | 是 | — | 依公開型別提供此輸入。 |
| `drawer` | `Widget` | 是 | — | 依公開型別提供此輸入。 |


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
- [宣告來源](../../../../../flutter/lib/src/foundation/layout/klp_sliding_drawer_layout.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/layout/klp_sliding_drawer_layout.dart`。
