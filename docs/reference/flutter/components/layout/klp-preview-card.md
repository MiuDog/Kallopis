# KlpPreviewCard

Flutter · Stable · 布局元件

## 主要職責

預覽內容、標題與中繼資訊的通用卡片。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpPreviewCard createExample(String title, Widget preview) => KlpPreviewCard(title: title, preview: preview);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpPreviewCard extends StatelessWidget
```

## 建構子 KlpPreviewCard



```dart
const KlpPreviewCard({
	Key? key,
	required String title,
	required Widget preview,
	List<String> metadata = const [],
	KlpPreviewCardSize previewSize = KlpPreviewCardSize.large,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `title` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `preview` | `Widget` | 是 | — | 依公開型別提供此輸入。 |
| `metadata` | `List<String>` | 否 | const [] | 依公開型別提供此輸入。 |
| `previewSize` | `KlpPreviewCardSize` | 否 | KlpPreviewCardSize.large | 依公開型別提供此輸入。 |


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
- [KlpPreviewCardSize](../../types/klp-preview-card-size.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/collections/preview_card/klp_preview_card.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/preview_card/klp_preview_card.dart`。
