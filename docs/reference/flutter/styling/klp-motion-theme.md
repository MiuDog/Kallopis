# KlpMotionTheme

Flutter · Stable · 語意風格

## 主要職責

Layer 2：motion 的 semantic token。

每個欄位描述**一種過場的角色**，不是某個元件的動畫。元件要動畫時讀這裡的角色，
不自己寫 `Duration(milliseconds: 140)`——寫死的 duration 是風格不對齊最難察覺的來源，
因為它不會出錯，只會讓兩個看起來一樣的元件動得不一樣快。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_theme.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpMotionTheme createExample(Duration themeTransition, Duration styleTransition, Duration stateTransition, Duration overlayEnter, Duration overlayExit, Duration toastDwell, Duration tooltipDelay, Duration longPressThreshold, Curve standard, Curve emphasized) => KlpMotionTheme(themeTransition: themeTransition, styleTransition: styleTransition, stateTransition: stateTransition, overlayEnter: overlayEnter, overlayExit: overlayExit, toastDwell: toastDwell, tooltipDelay: tooltipDelay, longPressThreshold: longPressThreshold, standard: standard, emphasized: emphasized);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpMotionTheme extends ThemeExtension<KlpMotionTheme>
```

## 建構子 KlpMotionTheme



```dart
const KlpMotionTheme({
	required Duration themeTransition,
	required Duration styleTransition,
	required Duration stateTransition,
	required Duration overlayEnter,
	required Duration overlayExit,
	required Duration toastDwell,
	required Duration tooltipDelay,
	Duration tooltipDwell = const Duration(milliseconds: 4000),
	Duration spinnerCycle = const Duration(milliseconds: 1000),
	required Duration longPressThreshold,
	required Curve standard,
	required Curve emphasized,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `themeTransition` | `Duration` | 是 | — | 明暗主題切換。預設瞬間完成——整個畫面漸變會讓切換感覺遲鈍。 |
| `styleTransition` | `Duration` | 是 | — | 強調色等樣式變更。 |
| `stateTransition` | `Duration` | 是 | — | hover／focus／pressed 等互動狀態變化。這是使用者最常看到的過場。 |
| `overlayEnter` | `Duration` | 是 | — | 選單、彈出層、對話框進場。 |
| `overlayExit` | `Duration` | 是 | — | 同上，退場。退場比進場快是通用慣例——使用者已經決定要關掉了。 |
| `toastDwell` | `Duration` | 是 | — | Toast 停留時間。 |
| `tooltipDelay` | `Duration` | 是 | — | 游標停留多久才顯示 tooltip。 |
| `tooltipDwell` | `Duration` | 否 | const Duration(milliseconds: 4000) | 依公開型別提供此輸入。 |
| `spinnerCycle` | `Duration` | 否 | const Duration(milliseconds: 1000) | 依公開型別提供此輸入。 |
| `longPressThreshold` | `Duration` | 是 | — | 長按判定門檻。這不是動畫，但同屬「時間」這個維度，而且**是無障礙參數**——<br>行動不便的使用者需要更長的門檻。放進 theme 才能整體調整。 |
| `standard` | `Curve` | 是 | — | 依公開型別提供此輸入。 |
| `emphasized` | `Curve` | 是 | — | 依公開型別提供此輸入。 |


## 成員與方法

### ==

```dart
bool ==(Object other)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `other` | `Object` | 是 | — | 依公開型別提供此輸入。 |


### copyWith

```dart
KlpMotionTheme copyWith({
	Duration? themeTransition,
	Duration? styleTransition,
	Duration? stateTransition,
	Duration? overlayEnter,
	Duration? overlayExit,
	Duration? toastDwell,
	Duration? tooltipDelay,
	Duration? tooltipDwell,
	Duration? spinnerCycle,
	Duration? longPressThreshold,
	Curve? standard,
	Curve? emphasized,
})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `themeTransition` | `Duration?` | 否 | null | 依公開型別提供此輸入。 |
| `styleTransition` | `Duration?` | 否 | null | 依公開型別提供此輸入。 |
| `stateTransition` | `Duration?` | 否 | null | 依公開型別提供此輸入。 |
| `overlayEnter` | `Duration?` | 否 | null | 依公開型別提供此輸入。 |
| `overlayExit` | `Duration?` | 否 | null | 依公開型別提供此輸入。 |
| `toastDwell` | `Duration?` | 否 | null | 依公開型別提供此輸入。 |
| `tooltipDelay` | `Duration?` | 否 | null | 依公開型別提供此輸入。 |
| `tooltipDwell` | `Duration?` | 否 | null | 依公開型別提供此輸入。 |
| `spinnerCycle` | `Duration?` | 否 | null | 依公開型別提供此輸入。 |
| `longPressThreshold` | `Duration?` | 否 | null | 依公開型別提供此輸入。 |
| `standard` | `Curve?` | 否 | null | 依公開型別提供此輸入。 |
| `emphasized` | `Curve?` | 否 | null | 依公開型別提供此輸入。 |


### hashCode

```dart
int get hashCode
```



### lerp

```dart
KlpMotionTheme lerp(KlpMotionTheme? other, double t)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `other` | `KlpMotionTheme?` | 是 | — | 依公開型別提供此輸入。 |
| `t` | `double` | 是 | — | 依公開型別提供此輸入。 |


### reduced

```dart
KlpMotionTheme reduced()
```

尊重系統的「減少動態效果」設定。無障礙規則屬於庫的責任，不該由每個消費者各自實作
——那必然會有人漏掉。

### standardMotion

```dart
static const KlpMotionTheme standardMotion
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[ThemeExtension<KlpMotionTheme>](https://api.flutter.dev/flutter/material/ThemeExtension-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_theme/klp_motion_theme.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_theme/klp_motion_theme.dart`。
