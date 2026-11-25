# KlpLinearLayoutResult

Flutter · Stable · 資料與型別

## 主要職責

尺寸與 caller 隔離；留白由呈現層決定對齊位置。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 在產品介面沿用公開型別；實例由其擁有者提供。
void acceptValue(KlpLinearLayoutResult value) {
	// 接入產品的資料處理。
}
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpLinearLayoutResult
```

## 成員與方法

### compressed

```dart
final bool compressed
```

compressed：間距被縮小或 minimum 無法全部滿足。

### extents

```dart
final List<double> extents
```



### gutter

```dart
final double gutter
```



### unused

```dart
final double unused
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/layout/klp_linear_layout.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/layout/klp_linear_layout.dart`。
