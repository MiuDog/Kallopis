# KlpWindowHeaderKeys

Flutter · Stable · 資料與型別

## 主要職責

視窗標題列內部與測試共用的穩定識別鍵。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
final value = KlpWindowHeaderKeys.appIconSlot;
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract final class KlpWindowHeaderKeys
```

## 建構子 KlpWindowHeaderKeys



```dart
KlpWindowHeaderKeys()
```



## 成員與方法

### appIconSlot

```dart
static const String appIconSlot
```



### surface

```dart
static const String surface
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/window/klp_window_header_keys.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/window/klp_window_header_keys.dart`。
