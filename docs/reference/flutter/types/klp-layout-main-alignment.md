# KlpLayoutMainAlignment

Flutter · Stable · 資料與型別

## 主要職責

水平布局的主軸對齊選項。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpLayoutMainAlignment.end;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpLayoutMainAlignment
```

## 建構子 KlpLayoutMainAlignment



```dart
const KlpLayoutMainAlignment()
```



## 成員與方法

### end

```dart
static const KlpLayoutMainAlignment end
```



### start

```dart
static const KlpLayoutMainAlignment start
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/layout/klp_app_layout.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/layout/klp_app_layout.dart`。
