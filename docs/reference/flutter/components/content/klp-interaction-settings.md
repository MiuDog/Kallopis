# KlpInteractionSettings

Flutter · Stable · 內容元件

## 主要職責

長按門檻的區域覆寫。

門檻的**預設值來自 theme**（`KlpMotionTheme.longPressThreshold`），這個 InheritedWidget
只負責「某一小塊 UI 要用不一樣的門檻」。原本它自己持有一份 `defaultThreshold` 常數，
與 theme 構成同一條規則的兩份實作——兩份實作必然靜默分岔，改了 theme 卻沒改這裡時
不會有任何錯誤，只是門檻沒變。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpInteractionSettings createExample(Widget child) => KlpInteractionSettings(child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpInteractionSettings extends InheritedWidget
```

## 建構子 KlpInteractionSettings



```dart
const KlpInteractionSettings({
	Key? key,
	required Widget child,
	Duration? longPressThreshold,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |
| `longPressThreshold` | `Duration?` | 否 | null | `null` 表示沿用 theme 的值。 |


## 成員與方法

### thresholdOf

```dart
static Duration thresholdOf(BuildContext context)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


### updateShouldNotify

```dart
bool updateShouldNotify(KlpInteractionSettings oldWidget)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `oldWidget` | `KlpInteractionSettings` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[InheritedWidget](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html)。

- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/foundation/interaction/klp_interaction_settings.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/interaction/klp_interaction_settings.dart`。
