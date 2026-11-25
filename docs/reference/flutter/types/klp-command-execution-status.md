# KlpCommandExecutionStatus

Flutter · Stable · 資料與型別

## 主要職責

命令執行或拒絕的結果種類，保留原 registry 判定。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpCommandExecutionStatus.busy;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpCommandExecutionStatus
```

## 建構子 KlpCommandExecutionStatus



```dart
const KlpCommandExecutionStatus()
```



## 成員與方法

### busy

```dart
static const KlpCommandExecutionStatus busy
```



### disabled

```dart
static const KlpCommandExecutionStatus disabled
```



### disposed

```dart
static const KlpCommandExecutionStatus disposed
```



### error

```dart
static const KlpCommandExecutionStatus error
```



### executed

```dart
static const KlpCommandExecutionStatus executed
```



### hidden

```dart
static const KlpCommandExecutionStatus hidden
```



### missing

```dart
static const KlpCommandExecutionStatus missing
```



<!-- reference-api:end -->

## 使用限制與關聯

- [Dock 受控操作](../../../guides/flutter/10-apply-klp-dock-action.md)：跨元件使用流程。
- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/actions/command_registry/klp_command_registry.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/command_registry/klp_command_registry.dart`。
