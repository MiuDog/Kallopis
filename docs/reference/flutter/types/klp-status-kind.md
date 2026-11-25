# KlpStatusKind

Flutter · Stable · 資料與型別

## 主要職責

狀態語意種類。所有種類統一以純色圓點呈現，種類只負責解析預設顏色。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpStatusKind.check;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpStatusKind
```

## 建構子 KlpStatusKind



```dart
const KlpStatusKind()
```



## 成員與方法

### check

```dart
static const KlpStatusKind check
```



### circle

```dart
static const KlpStatusKind circle
```



### cross

```dart
static const KlpStatusKind cross
```



### dot

```dart
static const KlpStatusKind dot
```



### running

```dart
static const KlpStatusKind running
```



### splitDot

```dart
static const KlpStatusKind splitDot
```



### waiting

```dart
static const KlpStatusKind waiting
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/status/klp_status_kind.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/status/klp_status_kind.dart`。
