# KlpTimeline

Flutter · Stable · 內容元件

## 主要職責

時間軸：事件依序排列，每項有標記、標題、時間、可選內容。

只負責排版與標記／連接線的視覺語言；事件的先後順序、時間格式與內容完全由
呼叫端的 [items] 決定，這裡不做排序也不解讀時間字串。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpTimeline createExample(List<KlpTimelineItemData> items) => KlpTimeline(items: items);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpTimeline extends StatelessWidget
```

## 建構子 KlpTimeline



```dart
const KlpTimeline({Key? key, required List<KlpTimelineItemData> items})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `items` | `List<KlpTimelineItemData>` | 是 | — | 由產品提供的項目。 |


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
- [KlpTimelineItemData](../../types/klp-timeline-item-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/collections/timeline/klp_timeline.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/timeline/klp_timeline.dart`。
