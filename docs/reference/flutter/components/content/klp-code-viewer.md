# KlpCodeViewer

Flutter · Stable · 內容元件

## 主要職責

提供程式碼內容的共用呈現；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpCodeViewer createExample(String code) => KlpCodeViewer(code: code);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpCodeViewer extends StatefulWidget
```

## 建構子 KlpCodeViewer



```dart
const KlpCodeViewer({
	Key? key,
	required String code,
	String? language,
	List<KlpCodeLanguageOption> languageOptions = KlpCodeLanguages.options,
	KlpCodeViewerLabels labels = KlpCodeViewerLabels.english,
	bool showLineNumbers = false,
	int startLine = 1,
	bool wrapped = false,
	bool loading = false,
	bool expandable = false,
	bool expanded = false,
	KlpCodeViewportLimit? viewportLimit,
	Widget? content,
	bool viewSelected = false,
	ValueChanged<String>? onLanguageChanged,
	VoidCallback? onToggleWrap,
	VoidCallback? onToggleLineNumbers,
	VoidCallback? onToggleView,
	VoidCallback? onToggleExpand,
	VoidCallback? onCopy,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `code` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `language` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `languageOptions` | `List<KlpCodeLanguageOption>` | 否 | KlpCodeLanguages.options | 依公開型別提供此輸入。 |
| `labels` | `KlpCodeViewerLabels` | 否 | KlpCodeViewerLabels.english | 依公開型別提供此輸入。 |
| `showLineNumbers` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `startLine` | `int` | 否 | 1 | 依公開型別提供此輸入。 |
| `wrapped` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `loading` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `expandable` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `expanded` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `viewportLimit` | `KlpCodeViewportLimit?` | 否 | null | 依公開型別提供此輸入。 |
| `content` | `Widget?` | 否 | null | 依公開型別提供此輸入。 |
| `viewSelected` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `onLanguageChanged` | `void Function(String)?` | 否 | null | 依公開型別提供此輸入。 |
| `onToggleWrap` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |
| `onToggleLineNumbers` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |
| `onToggleView` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |
| `onToggleExpand` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |
| `onCopy` | `void Function()?` | 否 | null | 依公開型別提供此輸入。 |


## 成員與方法

### createState

```dart
State<KlpCodeViewer> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- [KlpCodeLanguageOption](../../types/klp-code-language-option.md)
- [KlpCodeLanguages](../../types/klp-code-languages.md)
- [KlpCodeViewerLabels](../../types/klp-code-viewer-labels.md)
- [KlpCodeViewportLimit](../../types/klp-code-viewport-limit.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/collections/code/klp_code_viewer.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/code/klp_code_viewer.dart`。
