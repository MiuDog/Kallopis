# KlpPageBackgroundEditor

Flutter · Stable · 內容元件

## 主要職責

編輯受限 point／line 背景 recipe 的受控視覺元件。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpPageBackgroundEditor createExample(KlpCustomPageBackgroundRecipe recipe, KlpPageBackgroundEditorTool tool, void Function(KlpCustomPageBackgroundRecipe) onChanged) => KlpPageBackgroundEditor(recipe: recipe, tool: tool, onChanged: onChanged);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpPageBackgroundEditor extends StatefulWidget
```

## 建構子 KlpPageBackgroundEditor



```dart
const KlpPageBackgroundEditor({
	Key? key,
	required KlpCustomPageBackgroundRecipe recipe,
	required KlpPageBackgroundEditorTool tool,
	required ValueChanged<KlpCustomPageBackgroundRecipe> onChanged,
	KlpPageBackgroundViewport? viewport,
	ValueChanged<KlpPageBackgroundSelection?>? onSelectionChanged,
	Widget? child,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `recipe` | `KlpCustomPageBackgroundRecipe` | 是 | — | 依公開型別提供此輸入。 |
| `tool` | `KlpPageBackgroundEditorTool` | 是 | — | 依公開型別提供此輸入。 |
| `onChanged` | `void Function(KlpCustomPageBackgroundRecipe)` | 是 | — | 將值的變更交回產品。 |
| `viewport` | `KlpPageBackgroundViewport?` | 否 | null | 依公開型別提供此輸入。 |
| `onSelectionChanged` | `void Function(KlpPageBackgroundSelection?)?` | 否 | null | 依公開型別提供此輸入。 |
| `child` | `Widget?` | 否 | null | 產品提供的內容。 |


## 成員與方法

### createState

```dart
State<KlpPageBackgroundEditor> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- [KlpCustomPageBackgroundRecipe](../../types/klp-custom-page-background-recipe.md)
- [KlpPageBackgroundEditorTool](../../types/klp-page-background-editor-tool.md)
- [KlpPageBackgroundSelection](../../types/klp-page-background-selection.md)
- [KlpPageBackgroundViewport](../../types/klp-page-background-viewport.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/foundation/surface/page_background/klp_page_background_editor.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/surface/page_background/klp_page_background_editor.dart`。
