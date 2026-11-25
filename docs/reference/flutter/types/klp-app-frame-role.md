# KlpAppFrameRole

Flutter · Stable · 資料與型別

## 主要職責

Frame 的內容主次角色，不綁定左右位置。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpAppFrameRole.auxiliary;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpAppFrameRole
```

## 建構子 KlpAppFrameRole



```dart
const KlpAppFrameRole()
```



## 成員與方法

### auxiliary

```dart
static const KlpAppFrameRole auxiliary
```



### content

```dart
static const KlpAppFrameRole content
```



### rightSidebar

```dart
static const KlpAppFrameRole rightSidebar
```



### sidebar

```dart
static const KlpAppFrameRole sidebar
```



### toolbarControls

```dart
static const KlpAppFrameRole toolbarControls
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/layout/klp_app_layout.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/layout/klp_app_layout.dart`。
