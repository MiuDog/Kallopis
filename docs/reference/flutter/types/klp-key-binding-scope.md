# KlpKeyBindingScope

Flutter · Stable · 資料與型別

## 主要職責

快捷鍵解析的責任層級。數值越小，解析優先權越高。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpKeyBindingScope.app;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpKeyBindingScope
```

## 建構子 KlpKeyBindingScope



```dart
const KlpKeyBindingScope()
```



## 成員與方法

### app

```dart
static const KlpKeyBindingScope app
```



### component

```dart
static const KlpKeyBindingScope component
```



### page

```dart
static const KlpKeyBindingScope page
```



### region

```dart
static const KlpKeyBindingScope region
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/interaction/keybinding/klp_key_binding.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/interaction/keybinding/klp_key_binding.dart`。
