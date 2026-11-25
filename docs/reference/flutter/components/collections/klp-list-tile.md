# KlpListTile

Flutter · Stable · 資料呈現

## 主要職責

以一致的 Kallopis 視覺呈現可選取的單列資料或動作。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpListTile createExample(String title) => KlpListTile(title: title);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpListTile extends StatelessWidget
```

## 建構子 KlpListTile



```dart
const KlpListTile({
	Key? key,
	required String title,
	String? subtitle,
	KlpIconData? icon,
	Widget? trailing,
	bool selected = false,
	VoidCallback? onPressed,
	bool compact = false,
	KlpFeedbackTone? tone,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `title` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `subtitle` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `icon` | `KlpIconData?` | 否 | null | 操作或內容圖示。 |
| `trailing` | `Widget?` | 否 | null | 後方內容。 |
| `selected` | `bool` | 否 | false | 由產品持有的選取狀態。 |
| `onPressed` | `void Function()?` | 否 | null | 啟動時通知產品；nullable 回呼的停用規則依元件契約。 |
| `compact` | `bool` | 否 | false | 緊湊呈現選項。 |
| `tone` | `KlpFeedbackTone?` | 否 | null | 選擇語意呈現。 |


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
- [KlpFeedbackTone](../../types/klp-feedback-tone.md)
- [KlpIconData](../../types/klp-icon-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/collections/list_tile/klp_list_tile.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/list_tile/klp_list_tile.dart`。
