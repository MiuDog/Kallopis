# KlpKeyBindingAction

Flutter · Stable · 資料與型別

## 主要職責

提供按鍵綁定的操作資料；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 在產品介面沿用公開型別；實例由其擁有者提供。
void acceptValue(KlpKeyBindingAction value) {
	// 接入產品的資料處理。
}
```

<!-- reference-api:start -->

## 公開簽名

```dart
typedef KlpKeyBindingAction = VoidCallback
```

<!-- reference-api:end -->

## 使用限制與關聯



- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/interaction/keybinding/klp_key_binding_controller.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/interaction/keybinding/klp_key_binding_controller.dart`。
