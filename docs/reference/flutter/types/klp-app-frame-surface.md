# KlpAppFrameSurface

Flutter · Stable · 資料與型別

## 主要職責

Frame 表面選項。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpAppFrameSurface.flat;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpAppFrameSurface
```

## 建構子 KlpAppFrameSurface



```dart
const KlpAppFrameSurface()
```



## 成員與方法

### flat

```dart
static const KlpAppFrameSurface flat
```



### raised

```dart
static const KlpAppFrameSurface raised
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/layout/klp_app_layout.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/layout/klp_app_layout.dart`。
