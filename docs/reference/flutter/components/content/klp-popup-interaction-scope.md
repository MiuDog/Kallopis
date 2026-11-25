# KlpPopupInteractionScope

Flutter · Stable · 內容元件

## 主要職責

供 App frame 注入視窗標題列保留範圍。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpPopupInteractionScope createExample(double topInset, Widget child) => KlpPopupInteractionScope(topInset: topInset, child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpPopupInteractionScope extends InheritedWidget
```

## 建構子 KlpPopupInteractionScope



```dart
const KlpPopupInteractionScope({
	Key? key,
	required double topInset,
	required Widget child,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `topInset` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |


## 成員與方法

### topInsetOf

```dart
static double topInsetOf(BuildContext context)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


### updateShouldNotify

```dart
bool updateShouldNotify(KlpPopupInteractionScope oldWidget)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `oldWidget` | `KlpPopupInteractionScope` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[InheritedWidget](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html)。

- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/overlays/klp_popup.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/overlays/klp_popup.dart`。
