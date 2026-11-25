# KlpShortcutHandlingState

Flutter · Stable · 資料與型別

## 主要職責

一次按鍵解析的生命週期結果，不代表產品命令成功與否。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpShortcutHandlingState.cancelled;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpShortcutHandlingState
```

## 建構子 KlpShortcutHandlingState



```dart
const KlpShortcutHandlingState()
```



## 成員與方法

### cancelled

```dart
static const KlpShortcutHandlingState cancelled
```



### executed

```dart
static const KlpShortcutHandlingState executed
```



### ignored

```dart
static const KlpShortcutHandlingState ignored
```



### prefix

```dart
static const KlpShortcutHandlingState prefix
```



### recording

```dart
static const KlpShortcutHandlingState recording
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/actions/command_keymap/klp_command_keymap.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/command_keymap/klp_command_keymap.dart`。
