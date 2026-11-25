# KlpAppLayoutInset

Flutter · Stable · 資料與型別

## 主要職責

App background 上第一層的通用 Workbench 布局根。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpAppLayoutInset.none;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpAppLayoutInset
```

## 建構子 KlpAppLayoutInset



```dart
const KlpAppLayoutInset()
```



## 成員與方法

### none

```dart
static const KlpAppLayoutInset none
```

讓單一端點的內容貼齊可用範圍。

### standard

```dart
static const KlpAppLayoutInset standard
```

套用 App frame 之間的標準外距。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/layout/klp_app_layout.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/layout/klp_app_layout.dart`。
