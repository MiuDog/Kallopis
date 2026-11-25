# KlpShortcutScope

Flutter · Stable · 資料與型別

## 主要職責

產品投影的快捷鍵作用域，依焦點鏈決定有效候選。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpShortcutScope.app;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpShortcutScope
```

## 建構子 KlpShortcutScope



```dart
const KlpShortcutScope()
```



## 成員與方法

### app

```dart
static const KlpShortcutScope app
```



### component

```dart
static const KlpShortcutScope component
```



### page

```dart
static const KlpShortcutScope page
```



### region

```dart
static const KlpShortcutScope region
```



<!-- reference-api:end -->

## 使用限制與關聯

- [Registered 快捷鍵純核心](../../../guides/flutter/14-klp-command-keymap.md)：跨元件使用流程。
- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/actions/command_keymap/klp_command_keymap.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/command_keymap/klp_command_keymap.dart`。
