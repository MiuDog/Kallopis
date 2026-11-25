# KlpStatusRole

Flutter · Stable · 資料與型別

## 主要職責

Kallopis 提供的狀態色彩角色。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpStatusRole.danger;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpStatusRole
```

## 建構子 KlpStatusRole



```dart
const KlpStatusRole()
```



## 成員與方法

### danger

```dart
static const KlpStatusRole danger
```



### info

```dart
static const KlpStatusRole info
```



### label

```dart
String get label
```

色票旁顯示的穩定角色名稱。

### success

```dart
static const KlpStatusRole success
```



### warning

```dart
static const KlpStatusRole warning
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/forms/selection/models/klp_status_role.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/selection/models/klp_status_role.dart`。
