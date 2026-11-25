# KlpAppPlatform

Flutter · Stable · 平台整合

## 主要職責

Kallopis 支援的執行平台分類。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpAppPlatform.android;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpAppPlatform
```

## 建構子 KlpAppPlatform



```dart
const KlpAppPlatform()
```



## 成員與方法

### android

```dart
static const KlpAppPlatform android
```



### ios

```dart
static const KlpAppPlatform ios
```



### linux

```dart
static const KlpAppPlatform linux
```



### macos

```dart
static const KlpAppPlatform macos
```



### other

```dart
static const KlpAppPlatform other
```



### web

```dart
static const KlpAppPlatform web
```



### windows

```dart
static const KlpAppPlatform windows
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/platform/klp_app_platform.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/platform/klp_app_platform.dart`。
