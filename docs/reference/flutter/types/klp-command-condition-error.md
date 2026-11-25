# KlpCommandConditionError

Flutter · Stable · 資料與型別

## 主要職責

保留條件解析的原始錯誤，讓產品決定呈現與恢復方式。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 在產品介面沿用公開型別；實例由其擁有者提供。
void acceptValue(KlpCommandConditionError value) {
	// 接入產品的資料處理。
}
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpCommandConditionError
```

## 成員與方法

### error

```dart
final Object error
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/actions/command_registry/klp_command_registry.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/command_registry/klp_command_registry.dart`。
