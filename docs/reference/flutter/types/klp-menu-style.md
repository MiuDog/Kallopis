# KlpMenuStyle

Flutter · Stable · 資料與型別

## 主要職責

[KlpMenu] 系列元件共用的文字角色，目前只有一項。獨立成類別是為了讓未來
若要新增更多共用樣式常數時有現成的落點，不必再改動呼叫端。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
final value = KlpMenuStyle.textRole;
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract final class KlpMenuStyle
```

## 建構子 KlpMenuStyle



```dart
KlpMenuStyle()
```



## 成員與方法

### textRole

```dart
static const KlpTextRole textRole
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpTextRole](klp-text-role.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/overlays/klp_menu.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/overlays/klp_menu.dart`。
