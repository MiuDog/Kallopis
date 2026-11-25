# KlpAdaptive

Flutter · Stable · 內容元件

## 主要職責

依明確覆寫、[KlpEnvironmentScope] 或實際執行平台選擇呈現分支。

只處理平台差異，不依據視窗尺寸切換平台策略。分支內部可自行處理
該平台的空間限制。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpAdaptive createExample(Widget Function(BuildContext) windows, Widget Function(BuildContext) android) => KlpAdaptive(windows: windows, android: android);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpAdaptive extends StatelessWidget implements KlpPanelLayout
```

## 建構子 KlpAdaptive



```dart
const KlpAdaptive({
	Key? key,
	required KlpAdaptiveBuilder windows,
	required KlpAdaptiveBuilder android,
	KlpAppPlatform? platform,
	KlpAdaptiveBuilder? macos,
	KlpAdaptiveBuilder? linux,
	KlpAdaptiveBuilder? ios,
	KlpAdaptiveBuilder? other,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `windows` | `Widget Function(BuildContext)` | 是 | — | 依公開型別提供此輸入。 |
| `android` | `Widget Function(BuildContext)` | 是 | — | 依公開型別提供此輸入。 |
| `platform` | `KlpAppPlatform?` | 否 | null | 依公開型別提供此輸入。 |
| `macos` | `Widget Function(BuildContext)?` | 否 | null | 依公開型別提供此輸入。 |
| `linux` | `Widget Function(BuildContext)?` | 否 | null | 依公開型別提供此輸入。 |
| `ios` | `Widget Function(BuildContext)?` | 否 | null | 依公開型別提供此輸入。 |
| `other` | `Widget Function(BuildContext)?` | 否 | null | 依公開型別提供此輸入。 |


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
- [KlpAppPlatform](../../platform/klp-app-platform.md)
- [KlpPanelLayout](../../types/klp-panel-layout.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/foundation/layout/klp_adaptive.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/layout/klp_adaptive.dart`。
