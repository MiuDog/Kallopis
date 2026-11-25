# KlpCommandKind

Flutter · Stable · 資料與型別

## 主要職責

命令入口的呈現種類；實際 checked 狀態仍由 registry 解析。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpCommandKind.action;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpCommandKind
```

## 建構子 KlpCommandKind



```dart
const KlpCommandKind()
```



## 成員與方法

### action

```dart
static const KlpCommandKind action
```



### toggle

```dart
static const KlpCommandKind toggle
```



<!-- reference-api:end -->

## 使用限制與關聯

- [Registered 命令工具列與選單](../../../guides/flutter/11-klp-registered-command-toolbar.md)：跨元件使用流程。
- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/actions/command_entries/klp_command_entries.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/command_entries/klp_command_entries.dart`。
