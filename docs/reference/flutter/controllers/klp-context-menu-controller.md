# KlpContextMenuController

Flutter · Stable · 控制與生命週期

## 主要職責

讓子元件以既有 [KlpContextMenu] 的定位與外觀主動開啟選單。

controller 尚未掛載時呼叫不會產生作用；同一時間只應掛載到一個 context menu。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpContextMenuController createExample() => KlpContextMenuController();
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpContextMenuController
```

## 建構子 KlpContextMenuController



```dart
KlpContextMenuController()
```



## 成員與方法

### close

```dart
void close()
```



### isAttached

```dart
bool get isAttached
```



### openAt

```dart
void openAt(Offset globalPosition)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `globalPosition` | `Offset` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/overlays/klp_context_menu.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/overlays/klp_context_menu.dart`。
