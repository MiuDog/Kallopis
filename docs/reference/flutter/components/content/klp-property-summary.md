# KlpPropertySummary

Flutter · Experimental · 內容元件

## 主要職責

實體的屬性摘要卡片：一排狀態徽章、一排標籤，再加一行中繼資料文字，
依序垂直排列。

三段固定按這個順序（badges → tags → metadata）呈現，不是各自獨立可
重排的插槽；若版面需要不同順序或省略某一段，請直接組合
[KlpBadge]／[KlpTag]／[KlpText] 而不是硬塞空清單進來。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpPropertySummary createExample(List<KlpPropertyBadgeData> badges, List<String> tags, String metadata) => KlpPropertySummary(badges: badges, tags: tags, metadata: metadata);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpPropertySummary extends StatelessWidget
```

## 建構子 KlpPropertySummary



```dart
const KlpPropertySummary({
	Key? key,
	required List<KlpPropertyBadgeData> badges,
	required List<String> tags,
	required String metadata,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `badges` | `List<KlpPropertyBadgeData>` | 是 | — | 依公開型別提供此輸入。 |
| `tags` | `List<String>` | 是 | — | 依公開型別提供此輸入。 |
| `metadata` | `String` | 是 | — | 依公開型別提供此輸入。 |


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
- [KlpPropertyBadgeData](../../types/klp-property-badge-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/page_chrome/klp_page_chrome.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/page_chrome/klp_page_chrome.dart`。
