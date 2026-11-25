# KlpCommandErrorPhase

Flutter · Stable · 資料與型別

## 主要職責

區分條件與 handler 失敗，供 caller 處理原始錯誤。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpCommandErrorPhase.condition;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpCommandErrorPhase
```

## 建構子 KlpCommandErrorPhase



```dart
const KlpCommandErrorPhase()
```



## 成員與方法

### condition

```dart
static const KlpCommandErrorPhase condition
```



### handler

```dart
static const KlpCommandErrorPhase handler
```

由產品提供的執行處理。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/actions/command_registry/klp_command_registry.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/command_registry/klp_command_registry.dart`。
