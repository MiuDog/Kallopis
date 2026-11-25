# KlpProgressState

Flutter · Stable · 資料與型別

## 主要職責

進度列的通用呈現狀態。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpProgressState.active;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpProgressState
```

## 建構子 KlpProgressState



```dart
const KlpProgressState()
```



## 成員與方法

### active

```dart
static const KlpProgressState active
```



### failure

```dart
static const KlpProgressState failure
```



### paused

```dart
static const KlpProgressState paused
```



### success

```dart
static const KlpProgressState success
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/collections/progress/klp_progress_state.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/progress/klp_progress_state.dart`。
