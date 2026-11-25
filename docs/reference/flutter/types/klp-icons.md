# KlpIcons

Flutter · Stable · 資料與型別

## 主要職責

Kallopis 使用的 Flaticon UIcons（Regular／Thin Rounded）語意別名。

字碼固定取自 `@flaticon/flaticon-uicons` 3.3.1。公開名稱維持 Kallopis
的產品中立語意，呼叫端不需要知道 Flaticon 的 CSS class 名稱。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
final value = KlpIcons.alertSquare;
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract final class KlpIcons
```

## 建構子 KlpIcons



```dart
KlpIcons()
```



## 成員與方法

### alertSquare

```dart
static const KlpIconData alertSquare
```



### archive

```dart
static const KlpIconData archive
```



### bookmark

```dart
static const KlpIconData bookmark
```



### box

```dart
static const KlpIconData box
```



### calendar

```dart
static const KlpIconData calendar
```



### check

```dart
static const KlpIconData check
```



### checkSquare

```dart
static const KlpIconData checkSquare
```



### chevronDown

```dart
static const KlpIconData chevronDown
```



### chevronUp

```dart
static const KlpIconData chevronUp
```



### circle

```dart
static const KlpIconData circle
```



### clipboard

```dart
static const KlpIconData clipboard
```



### clock

```dart
static const KlpIconData clock
```



### close

```dart
static const KlpIconData close
```



### collapse

```dart
static const KlpIconData collapse
```



### container

```dart
static const KlpIconData container
```



### copy

```dart
static const KlpIconData copy
```



### cpu

```dart
static const KlpIconData cpu
```



### diagramProject

```dart
static const KlpIconData diagramProject
```



### disclosureTriangle

```dart
static const KlpIconData disclosureTriangle
```



### edit

```dart
static const KlpIconData edit
```



### eye

```dart
static const KlpIconData eye
```



### eyeCrossed

```dart
static const KlpIconData eyeCrossed
```



### filter

```dart
static const KlpIconData filter
```



### folder

```dart
static const KlpIconData folder
```



### folderPlus

```dart
static const KlpIconData folderPlus
```



### globe

```dart
static const KlpIconData globe
```



### grid

```dart
static const KlpIconData grid
```



### gripVertical

```dart
static const KlpIconData gripVertical
```



### handWriting

```dart
static const KlpIconData handWriting
```



### inbox

```dart
static const KlpIconData inbox
```



### infoSquare

```dart
static const KlpIconData infoSquare
```



### keyboard

```dart
static const KlpIconData keyboard
```



### loader

```dart
static const KlpIconData loader
```



### lock

```dart
static const KlpIconData lock
```



### maximize

```dart
static const KlpIconData maximize
```



### menu

```dart
static const KlpIconData menu
```



### minus

```dart
static const KlpIconData minus
```



### more

```dart
static const KlpIconData more
```



### panelBottom

```dart
static const KlpIconData panelBottom
```



### panelLeft

```dart
static const KlpIconData panelLeft
```



### panelRight

```dart
static const KlpIconData panelRight
```



### panelSplit

```dart
static const KlpIconData panelSplit
```



### pencil

```dart
static const KlpIconData pencil
```



### plus

```dart
static const KlpIconData plus
```



### refresh

```dart
static const KlpIconData refresh
```



### restore

```dart
static const KlpIconData restore
```



### search

```dart
static const KlpIconData search
```



### settings

```dart
static const KlpIconData settings
```



### sidebar

```dart
static const KlpIconData sidebar
```



### sidebarLeft

```dart
static const KlpIconData sidebarLeft
```



### sidebarRight

```dart
static const KlpIconData sidebarRight
```



### slash

```dart
static const KlpIconData slash
```



### sparkles

```dart
static const KlpIconData sparkles
```



### splitCircle

```dart
static const KlpIconData splitCircle
```



### switchVertical

```dart
static const KlpIconData switchVertical
```



### telescope

```dart
static const KlpIconData telescope
```



### timer

```dart
static const KlpIconData timer
```



### trash

```dart
static const KlpIconData trash
```



### users

```dart
static const KlpIconData users
```



### x

```dart
static const KlpIconData x
```



### xSquare

```dart
static const KlpIconData xSquare
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpIconData](klp-icon-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/klp_icons.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/klp_icons.dart`。
