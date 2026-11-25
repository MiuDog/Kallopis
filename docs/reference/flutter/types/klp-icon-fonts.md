# KlpIconFonts

Flutter · Stable · 資料與型別

## 主要職責

新舊呈現共用字型資產名稱，不依賴 theme 或 Widget。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
final value = KlpIconFonts.package;
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract final class KlpIconFonts
```

## 建構子 KlpIconFonts



```dart
KlpIconFonts()
```



## 成員與方法

### package

```dart
static const String package
```



### regular

```dart
static const String regular
```



### thin

```dart
static const String thin
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/klp_icon_fonts.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/klp_icon_fonts.dart`。
