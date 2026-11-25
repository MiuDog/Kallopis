# KlpSplitPaneSize

Flutter · Stable · 資料與型別

## 主要職責

分割版面固定 pane 的語意尺寸。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpSplitPaneSize.primary;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpSplitPaneSize
```

## 建構子 KlpSplitPaneSize



```dart
const KlpSplitPaneSize()
```



## 成員與方法

### primary

```dart
static const KlpSplitPaneSize primary
```

主要導覽 pane。

### secondary

```dart
static const KlpSplitPaneSize secondary
```

次要檢查 pane。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/layout/klp_split_pane_size.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/layout/klp_split_pane_size.dart`。
