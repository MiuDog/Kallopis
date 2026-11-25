# KlpSurfaceSeparation

Flutter · Stable · 語意風格

## 主要職責

表面的分層手法：純色階層 (tone)、實線邊框 (outline)、霧化透明 (frosted)、原生 Box 漸層 (gradient) 或傳統陰影 (shadow)。

多種手法各有適用場景。不推薦單純依賴陰影；現代介面更推崇純色階明度差、
清晰邊框、壓克力霧化或微漸層光澤。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_theme.dart';

final value = KlpSurfaceSeparation.frosted;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpSurfaceSeparation
```

## 建構子 KlpSurfaceSeparation



```dart
const KlpSurfaceSeparation()
```



## 成員與方法

### frosted

```dart
static const KlpSurfaceSeparation frosted
```

霧化透明 / 毛玻璃分層（BackdropFilter 搭配半透明表面）。

### gradient

```dart
static const KlpSurfaceSeparation gradient
```

原生 Box 漸層與微光分層。

### outline

```dart
static const KlpSurfaceSeparation outline
```

用實線邊框分層，不使用陰影（推薦之清晰結構手法）。

### shadow

```dart
static const KlpSurfaceSeparation shadow
```

用陰影分層（不推薦之傳統做法，僅為相容性保留）。

### tone

```dart
static const KlpSurfaceSeparation tone
```

單調特殊顏色 / 表面色階分層（純色明度階梯，無邊框無陰影）。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_theme/klp_surface_theme.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_theme/klp_surface_theme.dart`。
