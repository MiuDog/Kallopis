# KlpThemeModePicker

Flutter · Experimental · 輸入元件

## 主要職責

以 Kallopis 預覽磚排列受控的顏色模式選項。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpThemeModePicker createExample(List<KlpThemeModeOption> options, KlpThemePreviewMode selected, void Function(KlpThemePreviewMode) onSelected) => KlpThemeModePicker(options: options, selected: selected, onSelected: onSelected);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpThemeModePicker extends StatelessWidget
```

## 建構子 KlpThemeModePicker



```dart
const KlpThemeModePicker({
	Key? key,
	required List<KlpThemeModeOption> options,
	required KlpThemePreviewMode selected,
	required ValueChanged<KlpThemePreviewMode> onSelected,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `options` | `List<KlpThemeModeOption>` | 是 | — | 依公開型別提供此輸入。 |
| `selected` | `KlpThemePreviewMode` | 是 | — | 由產品持有的選取狀態。 |
| `onSelected` | `void Function(KlpThemePreviewMode)` | 是 | — | 將選取意圖交回產品。 |


## 成員與方法

### build

```dart
Widget build(BuildContext context)
```

由 Flutter 依目前 context 建構畫面。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)。
- [KlpThemeModeOption](../../styling/klp-theme-mode-option.md)
- [KlpThemePreviewMode](../../styling/klp-theme-preview-mode.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/settings/klp_theme_mode_picker.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/settings/klp_theme_mode_picker.dart`。
