# KlpControlSize

Flutter · Stable · 資料與型別

## 主要職責

控制項五段標準尺寸階級。

實際高度由各元件的 geometry 解析；KlpButton 預設依序使用
28／32／36／40／48px，不改寫其他控制項的尺寸階級。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpControlSize.lg;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpControlSize
```

## 建構子 KlpControlSize



```dart
const KlpControlSize()
```



## 成員與方法

### lg

```dart
static const KlpControlSize lg
```



### md

```dart
static const KlpControlSize md
```



### sm

```dart
static const KlpControlSize sm
```



### xl

```dart
static const KlpControlSize xl
```



### xs

```dart
static const KlpControlSize xs
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/interaction/controls/klp_control_size.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/interaction/controls/klp_control_size.dart`。
