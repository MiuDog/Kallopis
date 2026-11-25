# KlpDeviceAdaptive

Flutter · Stable · 內容元件

## 主要職責

依 Kallopis 裝置分類選擇 desktop、tablet 或 phone 呈現策略。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDeviceAdaptive createExample(Widget Function(BuildContext) desktop, Widget Function(BuildContext) tablet, Widget Function(BuildContext) phone) => KlpDeviceAdaptive(desktop: desktop, tablet: tablet, phone: phone);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDeviceAdaptive extends StatelessWidget implements KlpPanelLayout
```

## 建構子 KlpDeviceAdaptive



```dart
const KlpDeviceAdaptive({
	Key? key,
	required KlpAdaptiveBuilder desktop,
	required KlpAdaptiveBuilder tablet,
	required KlpAdaptiveBuilder phone,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `desktop` | `Widget Function(BuildContext)` | 是 | — | 依公開型別提供此輸入。 |
| `tablet` | `Widget Function(BuildContext)` | 是 | — | 依公開型別提供此輸入。 |
| `phone` | `Widget Function(BuildContext)` | 是 | — | 依公開型別提供此輸入。 |


## 成員與方法

### build

```dart
Widget build(BuildContext context)
```

由 Flutter 依目前 context 建構畫面。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


### buildPanelLayout

```dart
Widget buildPanelLayout(BuildContext context)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)。
- 繼承／實作：[KlpPanelLayout](../../types/klp-panel-layout.md)。
- [KlpAdaptiveBuilder](../../types/klp-adaptive-builder.md)
- [KlpPanelLayout](../../types/klp-panel-layout.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/foundation/layout/klp_device_adaptive.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/layout/klp_device_adaptive.dart`。
