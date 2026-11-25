# KlpControlGeometry

Flutter · Stable · 語意風格

## 主要職責

表單與互動控制項的精確幾何。

## 公開入口

- `package:kallopis/kallopis_theme.dart`
- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_theme.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpControlGeometry createExample(double buttonHeightXSmall, double buttonHeightSmall, double buttonHeight, double buttonHeightLarge, double buttonHeightXLarge, double fieldHeight, double selectionControl, double selectionIndicatorInset, double selectionIcon, double toggleWidth, double toggleHeight, double toggleThumb, double toggleInset, double segmentedDenseHeight, double segmentedDenseInset, double segmentedDenseContentInset, double segmentedDenseItemHeight, double slidingSelectionHeight, double slidingSelectionSegmentWidth, double slidingSelectionPadding, double slidingSelectionIndicatorHeight, double scrollbarThickness, double sliderTrackHeight, double colorPlaneExtent, double textFieldIndicatorHeightFactor, double textFieldLineHeightFactor, int textFieldMinLines, int textFieldMaxLines, double fileExplorerRowHeightAdjustment) => KlpControlGeometry(buttonHeightXSmall: buttonHeightXSmall, buttonHeightSmall: buttonHeightSmall, buttonHeight: buttonHeight, buttonHeightLarge: buttonHeightLarge, buttonHeightXLarge: buttonHeightXLarge, fieldHeight: fieldHeight, selectionControl: selectionControl, selectionIndicatorInset: selectionIndicatorInset, selectionIcon: selectionIcon, toggleWidth: toggleWidth, toggleHeight: toggleHeight, toggleThumb: toggleThumb, toggleInset: toggleInset, segmentedDenseHeight: segmentedDenseHeight, segmentedDenseInset: segmentedDenseInset, segmentedDenseContentInset: segmentedDenseContentInset, segmentedDenseItemHeight: segmentedDenseItemHeight, slidingSelectionHeight: slidingSelectionHeight, slidingSelectionSegmentWidth: slidingSelectionSegmentWidth, slidingSelectionPadding: slidingSelectionPadding, slidingSelectionIndicatorHeight: slidingSelectionIndicatorHeight, scrollbarThickness: scrollbarThickness, sliderTrackHeight: sliderTrackHeight, colorPlaneExtent: colorPlaneExtent, textFieldIndicatorHeightFactor: textFieldIndicatorHeightFactor, textFieldLineHeightFactor: textFieldLineHeightFactor, textFieldMinLines: textFieldMinLines, textFieldMaxLines: textFieldMaxLines, fileExplorerRowHeightAdjustment: fileExplorerRowHeightAdjustment);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpControlGeometry
```

## 建構子 KlpControlGeometry



```dart
const KlpControlGeometry({
	double switchTrackWidth = 36,
	double switchTrackHeight = 20,
	double switchThumb = 16,
	double pageBackgroundHitRadius = KlpScale.space200,
	double presenceMarkerExtent = KlpScale.space200,
	double colorPickerCursorRadius = KlpScale.space200,
	double swatchExtent = KlpScale.space200,
	double segmentedProgressHeight = KlpScale.space200,
	required double buttonHeightXSmall,
	required double buttonHeightSmall,
	required double buttonHeight,
	required double buttonHeightLarge,
	required double buttonHeightXLarge,
	required double fieldHeight,
	required double selectionControl,
	required double selectionIndicatorInset,
	required double selectionIcon,
	required double toggleWidth,
	required double toggleHeight,
	required double toggleThumb,
	required double toggleInset,
	required double segmentedDenseHeight,
	required double segmentedDenseInset,
	required double segmentedDenseContentInset,
	required double segmentedDenseItemHeight,
	required double slidingSelectionHeight,
	required double slidingSelectionSegmentWidth,
	required double slidingSelectionPadding,
	required double slidingSelectionIndicatorHeight,
	required double scrollbarThickness,
	required double sliderTrackHeight,
	required double colorPlaneExtent,
	required double textFieldIndicatorHeightFactor,
	required double textFieldLineHeightFactor,
	required int textFieldMinLines,
	required int textFieldMaxLines,
	required double fileExplorerRowHeightAdjustment,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `switchTrackWidth` | `double` | 否 | 36 | 依公開型別提供此輸入。 |
| `switchTrackHeight` | `double` | 否 | 20 | 依公開型別提供此輸入。 |
| `switchThumb` | `double` | 否 | 16 | 依公開型別提供此輸入。 |
| `pageBackgroundHitRadius` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `presenceMarkerExtent` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `colorPickerCursorRadius` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `swatchExtent` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `segmentedProgressHeight` | `double` | 否 | KlpScale.space200 | 依公開型別提供此輸入。 |
| `buttonHeightXSmall` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `buttonHeightSmall` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `buttonHeight` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `buttonHeightLarge` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `buttonHeightXLarge` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `fieldHeight` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `selectionControl` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `selectionIndicatorInset` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `selectionIcon` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `toggleWidth` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `toggleHeight` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `toggleThumb` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `toggleInset` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `segmentedDenseHeight` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `segmentedDenseInset` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `segmentedDenseContentInset` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `segmentedDenseItemHeight` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `slidingSelectionHeight` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `slidingSelectionSegmentWidth` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `slidingSelectionPadding` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `slidingSelectionIndicatorHeight` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `scrollbarThickness` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `sliderTrackHeight` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `colorPlaneExtent` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `textFieldIndicatorHeightFactor` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `textFieldLineHeightFactor` | `double` | 是 | — | 依公開型別提供此輸入。 |
| `textFieldMinLines` | `int` | 是 | — | 依公開型別提供此輸入。 |
| `textFieldMaxLines` | `int` | 是 | — | 依公開型別提供此輸入。 |
| `fileExplorerRowHeightAdjustment` | `double` | 是 | — | 依公開型別提供此輸入。 |


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
KlpControlGeometry copyWith({
	double? switchTrackWidth,
	double? switchTrackHeight,
	double? switchThumb,
	double? pageBackgroundHitRadius,
	double? presenceMarkerExtent,
	double? colorPickerCursorRadius,
	double? swatchExtent,
	double? segmentedProgressHeight,
	double? buttonHeightXSmall,
	double? buttonHeightSmall,
	double? buttonHeight,
	double? buttonHeightLarge,
	double? buttonHeightXLarge,
	double? fieldHeight,
	double? selectionControl,
	double? selectionIndicatorInset,
	double? selectionIcon,
	double? toggleWidth,
	double? toggleHeight,
	double? toggleThumb,
	double? toggleInset,
	double? segmentedDenseHeight,
	double? segmentedDenseInset,
	double? segmentedDenseContentInset,
	double? segmentedDenseItemHeight,
	double? slidingSelectionHeight,
	double? slidingSelectionSegmentWidth,
	double? slidingSelectionPadding,
	double? slidingSelectionIndicatorHeight,
	double? scrollbarThickness,
	double? sliderTrackHeight,
	double? colorPlaneExtent,
	double? textFieldIndicatorHeightFactor,
	double? textFieldLineHeightFactor,
	int? textFieldMinLines,
	int? textFieldMaxLines,
	double? fileExplorerRowHeightAdjustment,
})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `switchTrackWidth` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `switchTrackHeight` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `switchThumb` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `pageBackgroundHitRadius` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `presenceMarkerExtent` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `colorPickerCursorRadius` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `swatchExtent` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `segmentedProgressHeight` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `buttonHeightXSmall` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `buttonHeightSmall` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `buttonHeight` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `buttonHeightLarge` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `buttonHeightXLarge` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `fieldHeight` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `selectionControl` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `selectionIndicatorInset` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `selectionIcon` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `toggleWidth` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `toggleHeight` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `toggleThumb` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `toggleInset` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `segmentedDenseHeight` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `segmentedDenseInset` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `segmentedDenseContentInset` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `segmentedDenseItemHeight` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `slidingSelectionHeight` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `slidingSelectionSegmentWidth` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `slidingSelectionPadding` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `slidingSelectionIndicatorHeight` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `scrollbarThickness` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `sliderTrackHeight` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `colorPlaneExtent` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `textFieldIndicatorHeightFactor` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `textFieldLineHeightFactor` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `textFieldMinLines` | `int?` | 否 | null | 依公開型別提供此輸入。 |
| `textFieldMaxLines` | `int?` | 否 | null | 依公開型別提供此輸入。 |
| `fileExplorerRowHeightAdjustment` | `double?` | 否 | null | 依公開型別提供此輸入。 |


### hashCode

```dart
int get hashCode
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpScale](klp-scale.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/styling/legacy_theme/klp_control_geometry.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/styling/legacy_theme/klp_control_geometry.dart`。
