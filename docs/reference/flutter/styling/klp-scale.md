# KlpScale

Flutter · Stable · 語意風格

## 主要職責

Layer 1：primitive token（原始階梯）。

這一層只有數值，**沒有語意**——`space400` 不知道自己會被用在哪裡。任何「這個位置該用
多少」的判斷都屬於 layer 2（semantic）或 layer 3（component）。

primitive 刻意維持 `static const` 且**不可被消費者覆寫**：它是設計語言的字彙表，不是
設定項。消費者要調整外觀，覆寫的是 semantic 或 component token（兩者都是
`ThemeExtension`），而不是重新定義「4 是多少」。

命名採數值階梯而非 t-shirt size，因為 t-shirt size 本身就是一種語意宣稱
（「md 是預設」），那屬於 layer 2。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_theme.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
final value = KlpScale.duration0;
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract final class KlpScale
```

## 建構子 KlpScale



```dart
KlpScale()
```



## 成員與方法

### duration0

```dart
static const Duration duration0
```



### duration100

```dart
static const Duration duration100
```



### duration150

```dart
static const Duration duration150
```



### duration400

```dart
static const Duration duration400
```



### duration500

```dart
static const Duration duration500
```



### easeEmphasized

```dart
static const Curve easeEmphasized
```



### easeStandard

```dart
static const Curve easeStandard
```



### font100

```dart
static const double font100
```



### font1000

```dart
static const double font1000
```



### font200

```dart
static const double font200
```



### font300

```dart
static const double font300
```



### font400

```dart
static const double font400
```



### font500

```dart
static const double font500
```



### font600

```dart
static const double font600
```



### font700

```dart
static const double font700
```



### font800

```dart
static const double font800
```



### font900

```dart
static const double font900
```



### leading100

```dart
static const double leading100
```



### leading116

```dart
static const double leading116
```



### leading120

```dart
static const double leading120
```



### leading122

```dart
static const double leading122
```



### leading127

```dart
static const double leading127
```



### leading128

```dart
static const double leading128
```



### leading133

```dart
static const double leading133
```



### leading142

```dart
static const double leading142
```



### leading150

```dart
static const double leading150
```



### leading150Legacy

```dart
static const double leading150Legacy
```



### leading155

```dart
static const double leading155
```



### leading200

```dart
static const double leading200
```



### leading300

```dart
static const double leading300
```



### leading350

```dart
static const double leading350
```



### leading400

```dart
static const double leading400
```



### leading450

```dart
static const double leading450
```



### leading500

```dart
static const double leading500
```



### leading550

```dart
static const double leading550
```



### leading650

```dart
static const double leading650
```



### opacity100

```dart
static const double opacity100
```



### opacity120

```dart
static const double opacity120
```



### opacity140

```dart
static const double opacity140
```



### opacity160

```dart
static const double opacity160
```



### opacity180

```dart
static const double opacity180
```



### opacity220

```dart
static const double opacity220
```



### opacity280

```dart
static const double opacity280
```



### opacity320

```dart
static const double opacity320
```



### opacity350

```dart
static const double opacity350
```

拖曳來源在原位置保留的預設不透明度。

### opacity440

```dart
static const double opacity440
```



### opacity480

```dart
static const double opacity480
```



### opacity550

```dart
static const double opacity550
```



### opacity620

```dart
static const double opacity620
```



### opacity720

```dart
static const double opacity720
```



### opacity780

```dart
static const double opacity780
```



### opacity820

```dart
static const double opacity820
```



### radius0

```dart
static const double radius0
```



### radius100

```dart
static const double radius100
```



### radius150

```dart
static const double radius150
```



### radius200

```dart
static const double radius200
```



### radius250

```dart
static const double radius250
```



### radius300

```dart
static const double radius300
```



### radius400

```dart
static const double radius400
```



### radius50

```dart
static const double radius50
```



### radiusFull

```dart
static const double radiusFull
```



### space0

```dart
static const double space0
```



### space100

```dart
static const double space100
```



### space1000

```dart
static const double space1000
```



### space1200

```dart
static const double space1200
```



### space1600

```dart
static const double space1600
```



### space200

```dart
static const double space200
```



### space2400

```dart
static const double space2400
```



### space250

```dart
static const double space250
```



### space300

```dart
static const double space300
```



### space400

```dart
static const double space400
```



### space50

```dart
static const double space50
```



### space600

```dart
static const double space600
```



### space800

```dart
static const double space800
```



### stroke0

```dart
static const double stroke0
```



### stroke100

```dart
static const double stroke100
```



### stroke200

```dart
static const double stroke200
```



### tracking0

```dart
static const double tracking0
```



### trackingTight

```dart
static const double trackingTight
```



### trackingWide

```dart
static const double trackingWide
```



### trackingWider

```dart
static const double trackingWider
```



### weight400

```dart
static const FontWeight weight400
```



### weight500

```dart
static const FontWeight weight500
```



### weight600

```dart
static const FontWeight weight600
```



### weight700

```dart
static const FontWeight weight700
```



### weight800

```dart
static const FontWeight weight800
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_tokens/primitive_token.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_tokens/primitive_token.dart`。
