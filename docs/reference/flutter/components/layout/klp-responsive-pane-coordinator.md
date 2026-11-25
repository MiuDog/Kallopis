# KlpResponsivePaneCoordinator

Flutter · Stable · 布局元件

## 主要職責

依可用寬度與 typed breakpoint 切換 Pane 呈現。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpResponsivePaneCoordinator createExample(Widget wide, Widget compact) => KlpResponsivePaneCoordinator(wide: wide, compact: compact);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpResponsivePaneCoordinator extends StatelessWidget
```

## 建構子 KlpResponsivePaneCoordinator



```dart
const KlpResponsivePaneCoordinator({
	Key? key,
	required Widget wide,
	required Widget compact,
	KlpResponsivePaneBreakpoint breakpoint = KlpResponsivePaneBreakpoint.standard,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `wide` | `Widget` | 是 | — | 依公開型別提供此輸入。 |
| `compact` | `Widget` | 是 | — | 緊湊呈現選項。 |
| `breakpoint` | `KlpResponsivePaneBreakpoint` | 否 | KlpResponsivePaneBreakpoint.standard | 依公開型別提供此輸入。 |


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
- [KlpResponsivePaneBreakpoint](../../types/klp-responsive-pane-breakpoint.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart`。
