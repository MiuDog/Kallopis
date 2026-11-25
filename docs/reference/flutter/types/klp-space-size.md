# KlpSpaceSize

Flutter · Stable · 資料與型別

## 主要職責

間距風格的枚舉型態。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpSpaceSize.action;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpSpaceSize
```

## 建構子 KlpSpaceSize



```dart
const KlpSpaceSize()
```



## 成員與方法

### action

```dart
static const KlpSpaceSize action
```

動作元件間距

### base

```dart
static const KlpSpaceSize base
```

標準基礎間距

### chromeToolbar

```dart
static const KlpSpaceSize chromeToolbar
```

Chrome 標題與工具列之間的間距

### comfortable

```dart
static const KlpSpaceSize comfortable
```

舒適間距

### commandMenuWidth

```dart
static const KlpSpaceSize commandMenuWidth
```

Command Menu 的標準寬度

### contentInline

```dart
static const KlpSpaceSize contentInline
```

內容行內間距

### contentInset

```dart
static const KlpSpaceSize contentInset
```

內容內縮間距

### contentStack

```dart
static const KlpSpaceSize contentStack
```

內容堆疊間距

### controlContent

```dart
static const KlpSpaceSize controlContent
```

控制項內圖示與文字之間的間距

### hairline

```dart
static const KlpSpaceSize hairline
```

微細間距

### item

```dart
static const KlpSpaceSize item
```

同一組合內相鄰項目的間距

### loose

```dart
static const KlpSpaceSize loose
```

鬆散間距

### navigationRailControl

```dart
static const KlpSpaceSize navigationRailControl
```

Navigation Rail 單一操作項目的方形尺寸

### navigationRailItem

```dart
static const KlpSpaceSize navigationRailItem
```

Navigation Rail 項目之間的間距

### overlayHeading

```dart
static const KlpSpaceSize overlayHeading
```

Overlay 標題與內容間距

### page

```dart
static const KlpSpaceSize page
```

頁面級間距

### placeholderAction

```dart
static const KlpSpaceSize placeholderAction
```

Placeholder 動作與內容之間的間距

### section

```dart
static const KlpSpaceSize section
```

區塊間距

### sectionLarge

```dart
static const KlpSpaceSize sectionLarge
```

大區塊間距

### skeletonLine

```dart
static const KlpSpaceSize skeletonLine
```

骨架屏單行高度

### tight

```dart
static const KlpSpaceSize tight
```

緊密間距

### toastIconSlot

```dart
static const KlpSpaceSize toastIconSlot
```

Toast 圖示占位尺寸

### xxs

```dart
static const KlpSpaceSize xxs
```

最小固定間距

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/layout/klp_space_size.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/layout/klp_space_size.dart`。
