# KlpThemePreviewTile

Flutter · Stable · 內容元件

## 主要職責

以插圖預覽受控的 Kallopis 顏色模式。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpThemePreviewTile createExample(KlpThemePreviewMode mode, String label, String description) => KlpThemePreviewTile(mode: mode, label: label, description: description);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpThemePreviewTile extends StatelessWidget
```

## 建構子 KlpThemePreviewTile



```dart
const KlpThemePreviewTile({
	Key? key,
	required KlpThemePreviewMode mode,
	required String label,
	required String description,
	bool selected = false,
	bool enabled = true,
	VoidCallback? onSelected,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `mode` | `KlpThemePreviewMode` | 是 | — | 風格模式。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `description` | `String` | 是 | — | 補充描述。 |
| `selected` | `bool` | 否 | false | 由產品持有的選取狀態。 |
| `enabled` | `bool` | 否 | true | 依公開型別提供此輸入。 |
| `onSelected` | `void Function()?` | 否 | null | 將選取意圖交回產品。 |


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
- [KlpThemePreviewMode](../../styling/klp-theme-preview-mode.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/theme/klp_theme_preview_tile.dart`。
