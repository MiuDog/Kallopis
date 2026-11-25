# KlpFileExplorerItem

Flutter · Stable · 資料與型別

## 主要職責

檔案瀏覽器中的節點資料模型（可為折疊資料夾或一般檔案項目）。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpFileExplorerItem createExample(String id, String label) => KlpFileExplorerItem(id: id, label: label);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpFileExplorerItem
```

## 建構子 KlpFileExplorerItem



```dart
const KlpFileExplorerItem({
	required String id,
	required String label,
	KlpIconData? icon,
	List<KlpFileExplorerItem> children = const [],
	bool folder = false,
	bool expanded = false,
	bool selected = false,
	String? badge,
	KlpFeedbackTone? tone,
	Widget? trailing,
	Object? data,
	Widget Function(BuildContext, Widget)? rowWrapper,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `icon` | `KlpIconData?` | 否 | null | 操作或內容圖示。 |
| `children` | `List<KlpFileExplorerItem>` | 否 | const [] | 產品提供的子內容。 |
| `folder` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `expanded` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `selected` | `bool` | 否 | false | 由產品持有的選取狀態。 |
| `badge` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `tone` | `KlpFeedbackTone?` | 否 | null | 選擇語意呈現。 |
| `trailing` | `Widget?` | 否 | null | 後方內容。 |
| `data` | `Object?` | 否 | null | 依公開型別提供此輸入。 |
| `rowWrapper` | `Widget Function(BuildContext, Widget)?` | 否 | null | 產品可在既有 row 外接選單與拖放，不替換 row 風格。 |


## 成員與方法

### isFolder

```dart
bool get isFolder
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpFeedbackTone](klp-feedback-tone.md)
- [KlpIconData](klp-icon-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/explorer/klp_file_explorer.dart`。
