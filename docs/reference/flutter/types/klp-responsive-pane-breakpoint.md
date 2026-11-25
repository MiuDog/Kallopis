# KlpResponsivePaneBreakpoint

Flutter · Stable · 資料與型別

## 主要職責

Pane 協調器可選用的 theme breakpoint。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpResponsivePaneBreakpoint.content;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpResponsivePaneBreakpoint
```

## 建構子 KlpResponsivePaneBreakpoint



```dart
const KlpResponsivePaneBreakpoint()
```



## 成員與方法

### content

```dart
static const KlpResponsivePaneBreakpoint content
```



### primary

```dart
static const KlpResponsivePaneBreakpoint primary
```



### resolve

```dart
double resolve(BuildContext context)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


### secondary

```dart
static const KlpResponsivePaneBreakpoint secondary
```



### standard

```dart
static const KlpResponsivePaneBreakpoint standard
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_breakpoint.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/composition/pane/klp_responsive_pane_breakpoint.dart`。
