# KlpSurfaceTone

Flutter · Stable · 資料與型別

## 主要職責

表面在視覺階層中的語意位置。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpSurfaceTone.accent;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpSurfaceTone
```

## 建構子 KlpSurfaceTone



```dart
const KlpSurfaceTone()
```



## 成員與方法

### accent

```dart
static const KlpSurfaceTone accent
```



### accentSoft

```dart
static const KlpSurfaceTone accentSoft
```



### app

```dart
static const KlpSurfaceTone app
```



### base

```dart
static const KlpSurfaceTone base
```



### component

```dart
static const KlpSurfaceTone component
```



### inset

```dart
static const KlpSurfaceTone inset
```



### muted

```dart
static const KlpSurfaceTone muted
```



### overlay

```dart
static const KlpSurfaceTone overlay
```



### raised

```dart
static const KlpSurfaceTone raised
```



### stage

```dart
static const KlpSurfaceTone stage
```



### transparent

```dart
static const KlpSurfaceTone transparent
```



<!-- reference-api:end -->

## 使用限制與關聯

- [2. 組合產品畫面](../../../guides/flutter/03-klp-surface.md)：跨元件使用流程。
- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/surface/klp_surface_tone.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/surface/klp_surface_tone.dart`。
