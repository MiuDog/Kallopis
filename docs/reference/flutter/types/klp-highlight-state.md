# KlpHighlightState

Flutter · Stable · 資料與型別

## 主要職責

元件的狀態強度。

這個庫只承認兩種互動狀態的視覺強度，元件不得自行發明第三種——同一個狀態在不同
元件長得不一樣，是這個庫先前最明顯的不一致來源。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpHighlightState.hover;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpHighlightState
```

## 建構子 KlpHighlightState



```dart
const KlpHighlightState()
```



## 成員與方法

### hover

```dart
static const KlpHighlightState hover
```

指標懸停或鍵盤聚焦。中性的低強度高亮。

### none

```dart
static const KlpHighlightState none
```

沒有狀態，不畫任何東西。

### selected

```dart
static const KlpHighlightState selected
```

受控的選取狀態。跟隨 interaction 色，強度較高。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/interaction/klp_state_highlight.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/interaction/klp_state_highlight.dart`。
