# KlpPalette

Flutter · Stable · 語意風格

## 主要職責

Kallopis primitive 色彩字彙表，不承載產品或元件語意。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_theme.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
final value = KlpPalette.amber500;
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract final class KlpPalette
```

## 建構子 KlpPalette



```dart
KlpPalette()
```



## 成員與方法

### amber500

```dart
static const Color amber500
```



### blue500

```dart
static const Color blue500
```



### clay300

```dart
static const Color clay300
```



### clay50

```dart
static const Color clay50
```



### clay500

```dart
static const Color clay500
```



### clay800

```dart
static const Color clay800
```



### clay900

```dart
static const Color clay900
```



### gold300

```dart
static const Color gold300
```



### gold50

```dart
static const Color gold50
```



### gold500

```dart
static const Color gold500
```



### gold800

```dart
static const Color gold800
```



### gold900

```dart
static const Color gold900
```



### green100

```dart
static const Color green100
```



### green400

```dart
static const Color green400
```



### green500

```dart
static const Color green500
```



### green600

```dart
static const Color green600
```



### green800

```dart
static const Color green800
```



### green900

```dart
static const Color green900
```



### ink100

```dart
static const Color ink100
```



### ink1000

```dart
static const Color ink1000
```



### ink150

```dart
static const Color ink150
```



### ink200

```dart
static const Color ink200
```



### ink250

```dart
static const Color ink250
```



### ink300

```dart
static const Color ink300
```



### ink350

```dart
static const Color ink350
```



### ink400

```dart
static const Color ink400
```



### ink450

```dart
static const Color ink450
```



### ink50

```dart
static const Color ink50
```



### ink500

```dart
static const Color ink500
```



### ink550

```dart
static const Color ink550
```



### ink600

```dart
static const Color ink600
```



### ink650

```dart
static const Color ink650
```



### ink700

```dart
static const Color ink700
```



### ink750

```dart
static const Color ink750
```



### ink800

```dart
static const Color ink800
```



### ink850

```dart
static const Color ink850
```



### ink900

```dart
static const Color ink900
```



### ink950

```dart
static const Color ink950
```



### line

```dart
static const Color line
```



### ochre300

```dart
static const Color ochre300
```



### ochre50

```dart
static const Color ochre50
```



### ochre500

```dart
static const Color ochre500
```



### ochre800

```dart
static const Color ochre800
```



### ochre900

```dart
static const Color ochre900
```



### parchment100

```dart
static const Color parchment100
```



### parchment150

```dart
static const Color parchment150
```



### parchment200

```dart
static const Color parchment200
```



### parchment250

```dart
static const Color parchment250
```



### parchment350

```dart
static const Color parchment350
```



### parchment50

```dart
static const Color parchment50
```



### parchment550

```dart
static const Color parchment550
```



### parchment700

```dart
static const Color parchment700
```



### parchment75

```dart
static const Color parchment75
```



### parchment750

```dart
static const Color parchment750
```



### parchment800

```dart
static const Color parchment800
```



### parchment825

```dart
static const Color parchment825
```



### parchment900

```dart
static const Color parchment900
```



### parchment925

```dart
static const Color parchment925
```



### parchment950

```dart
static const Color parchment950
```



### pureBlack

```dart
static const Color pureBlack
```



### pureWhite

```dart
static const Color pureWhite
```



### red100

```dart
static const Color red100
```



### red300

```dart
static const Color red300
```



### red400

```dart
static const Color red400
```



### red600

```dart
static const Color red600
```



### red800

```dart
static const Color red800
```



### red900

```dart
static const Color red900
```



### sand300

```dart
static const Color sand300
```



### sand50

```dart
static const Color sand50
```



### sand500

```dart
static const Color sand500
```



### sand800

```dart
static const Color sand800
```



### sand900

```dart
static const Color sand900
```



### scrim

```dart
static const Color scrim
```



### terracotta300

```dart
static const Color terracotta300
```



### terracotta50

```dart
static const Color terracotta50
```



### terracotta500

```dart
static const Color terracotta500
```



### terracotta800

```dart
static const Color terracotta800
```



### terracotta900

```dart
static const Color terracotta900
```



### transparent

```dart
static const Color transparent
```



### transparentSurface

```dart
static const Color transparentSurface
```



### transparentSurfaceInset

```dart
static const Color transparentSurfaceInset
```



### umber300

```dart
static const Color umber300
```



### umber50

```dart
static const Color umber50
```



### umber500

```dart
static const Color umber500
```



### umber800

```dart
static const Color umber800
```



### umber900

```dart
static const Color umber900
```



### warmNeutral100

```dart
static const Color warmNeutral100
```



### warmNeutral200

```dart
static const Color warmNeutral200
```



### warmNeutral25

```dart
static const Color warmNeutral25
```



### warmNeutral300

```dart
static const Color warmNeutral300
```



### warmNeutral400

```dart
static const Color warmNeutral400
```



### warmNeutral450

```dart
static const Color warmNeutral450
```



### warmNeutral50

```dart
static const Color warmNeutral50
```



### warmNeutral500

```dart
static const Color warmNeutral500
```



### warmNeutral600

```dart
static const Color warmNeutral600
```



### warmNeutral700

```dart
static const Color warmNeutral700
```



### warmNeutral750

```dart
static const Color warmNeutral750
```



### warmNeutral800

```dart
static const Color warmNeutral800
```



### warmNeutral900

```dart
static const Color warmNeutral900
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_tokens/primitive_token.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_tokens/primitive_token.dart`。
