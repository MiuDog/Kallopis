# KlpShortcutConflictKind

Flutter · Stable · 資料與型別

## 主要職責

區分快捷鍵完整重疊與 chord 前綴重疊。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpShortcutConflictKind.exact;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpShortcutConflictKind
```

## 建構子 KlpShortcutConflictKind



```dart
const KlpShortcutConflictKind()
```



## 成員與方法

### exact

```dart
static const KlpShortcutConflictKind exact
```



### prefix

```dart
static const KlpShortcutConflictKind prefix
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/actions/command_keymap/klp_command_keymap.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/command_keymap/klp_command_keymap.dart`。
