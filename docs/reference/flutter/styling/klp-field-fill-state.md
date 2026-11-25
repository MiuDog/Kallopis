# KlpFieldFillState

Flutter · Stable · 語意風格

## 主要職責

輸入欄位底色要跟隨的互動狀態。

刻意把 [rest] 與 [hovered] 分開列舉，即使兩者目前解析成同一個顏色
（見 [KlpFieldStyle.colorFor]）——這是為了讓「hover 不改底色」這件事有
名字可以在程式碼裡明確表達，而不是省略 hovered 這個 case 導致日後被誤判
為漏寫。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_theme.dart';

final value = KlpFieldFillState.disabled;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpFieldFillState
```

## 建構子 KlpFieldFillState



```dart
const KlpFieldFillState()
```



## 成員與方法

### disabled

```dart
static const KlpFieldFillState disabled
```



### error

```dart
static const KlpFieldFillState error
```



### focused

```dart
static const KlpFieldFillState focused
```



### hovered

```dart
static const KlpFieldFillState hovered
```



### rest

```dart
static const KlpFieldFillState rest
```



### selected

```dart
static const KlpFieldFillState selected
```

由產品持有的選取狀態。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_theme/klp_theme.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_theme/klp_theme.dart`。
