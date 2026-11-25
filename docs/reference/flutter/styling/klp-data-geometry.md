# KlpDataGeometry

Flutter · Stable · 語意風格

## 主要職責

程式碼、placeholder 與資料型元件的精確幾何。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_theme.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDataGeometry createExample(double codeActionButtonSize, double codeHeaderHeight, double codeTerminalDot, double codeTerminalDotGap, double codeHeaderPaddingX, double codeBodyPaddingX, double codeLineNumberWidth, double codeWrappedLineWidth, double codeMaximumHeight, double codeCollapsedHeight, double codeDisclosureSize, double filePreviewHeight, double previewCardCompactHeight, double previewCardStandardHeight, double previewCardLargeHeight, double dateGridCellHeight, double keyValueLabelWidthCompact, double keyValueLabelWidthStandard, double stepperMarkerSize, double stepperLabelWidth, double progressIndeterminateFraction, double placeholderMinimumHeight, double placeholderContentPaddingY, double placeholderActionPaddingY, double placeholderHatchBand, double placeholderHatchGap, double placeholderLabelTracking, double placeholderDetailMaximumWidth, double spinnerSquareFactor, double spinnerOrbitFactor, double spinnerCornerFactor) => KlpDataGeometry(codeActionButtonSize: codeActionButtonSize, codeHeaderHeight: codeHeaderHeight, codeTerminalDot: codeTerminalDot, codeTerminalDotGap: codeTerminalDotGap, codeHeaderPaddingX: codeHeaderPaddingX, codeBodyPaddingX: codeBodyPaddingX, codeLineNumberWidth: codeLineNumberWidth, codeWrappedLineWidth: codeWrappedLineWidth, codeMaximumHeight: codeMaximumHeight, codeCollapsedHeight: codeCollapsedHeight, codeDisclosureSize: codeDisclosureSize, filePreviewHeight: filePreviewHeight, previewCardCompactHeight: previewCardCompactHeight, previewCardStandardHeight: previewCardStandardHeight, previewCardLargeHeight: previewCardLargeHeight, dateGridCellHeight: dateGridCellHeight, keyValueLabelWidthCompact: keyValueLabelWidthCompact, keyValueLabelWidthStandard: keyValueLabelWidthStandard, stepperMarkerSize: stepperMarkerSize, stepperLabelWidth: stepperLabelWidth, progressIndeterminateFraction: progressIndeterminateFraction, placeholderMinimumHeight: placeholderMinimumHeight, placeholderContentPaddingY: placeholderContentPaddingY, placeholderActionPaddingY: placeholderActionPaddingY, placeholderHatchBand: placeholderHatchBand, placeholderHatchGap: placeholderHatchGap, placeholderLabelTracking: placeholderLabelTracking, placeholderDetailMaximumWidth: placeholderDetailMaximumWidth, spinnerSquareFactor: spinnerSquareFactor, spinnerOrbitFactor: spinnerOrbitFactor, spinnerCornerFactor: spinnerCornerFactor);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDataGeometry
```

## 建構子 KlpDataGeometry



```dart
const KlpDataGeometry({
	required double codeActionButtonSize,
	required double codeHeaderHeight,
	required double codeTerminalDot,
	required double codeTerminalDotGap,
	required double codeHeaderPaddingX,
	required double codeBodyPaddingX,
	required double codeLineNumberWidth,
	required double codeWrappedLineWidth,
	required double codeMaximumHeight,
	required double codeCollapsedHeight,
	required double codeDisclosureSize,
	required double filePreviewHeight,
	required double previewCardCompactHeight,
	required double previewCardStandardHeight,
	required double previewCardLargeHeight,
	required double dateGridCellHeight,
	required double keyValueLabelWidthCompact,
	required double keyValueLabelWidthStandard,
	required double stepperMarkerSize,
	required double stepperLabelWidth,
	required double progressIndeterminateFraction,
	required double placeholderMinimumHeight,
	required double placeholderContentPaddingY,
	required double placeholderActionPaddingY,
	required double placeholderHatchBand,
	required double placeholderHatchGap,
	required double placeholderLabelTracking,
	required double placeholderDetailMaximumWidth,
	required double spinnerSquareFactor,
	required double spinnerOrbitFactor,
	required double spinnerCornerFactor,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `codeActionButtonSize` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `codeHeaderHeight` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `codeTerminalDot` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `codeTerminalDotGap` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `codeHeaderPaddingX` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `codeBodyPaddingX` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `codeLineNumberWidth` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `codeWrappedLineWidth` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `codeMaximumHeight` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `codeCollapsedHeight` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `codeDisclosureSize` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `filePreviewHeight` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `previewCardCompactHeight` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `previewCardStandardHeight` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `previewCardLargeHeight` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `dateGridCellHeight` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `keyValueLabelWidthCompact` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `keyValueLabelWidthStandard` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `stepperMarkerSize` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `stepperLabelWidth` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `progressIndeterminateFraction` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `placeholderMinimumHeight` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `placeholderContentPaddingY` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `placeholderActionPaddingY` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `placeholderHatchBand` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `placeholderHatchGap` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `placeholderLabelTracking` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `placeholderDetailMaximumWidth` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `spinnerSquareFactor` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `spinnerOrbitFactor` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `spinnerCornerFactor` | `double` | 是 | — | 依公開型別提供此輸入。 |


## 成員與方法

### ==

```dart
bool ==(Object other)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `other` | `Object` | 是 | — | 依公開型別提供此輸入。 |


### hashCode

```dart
int get hashCode
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_theme/klp_data_geometry.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_theme/klp_data_geometry.dart`。
