# KlpPagination

Flutter · Stable · 導覽元件

## 主要職責

上一頁／頁碼／下一頁的受控分頁元件。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpPagination createExample(int page, int pageCount, String previousLabel, String nextLabel, void Function(int)? onPageChanged) => KlpPagination(page: page, pageCount: pageCount, previousLabel: previousLabel, nextLabel: nextLabel, onPageChanged: onPageChanged);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpPagination extends StatelessWidget
```

## 建構子 KlpPagination



```dart
const KlpPagination({
	Key? key,
	required int page,
	required int pageCount,
	required String previousLabel,
	required String nextLabel,
	required ValueChanged<int>? onPageChanged,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `page` | `int` | 是 | — | 依公開型別提供此輸入。 |
| `pageCount` | `int` | 是 | — | 依公開型別提供此輸入。 |
| `previousLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `nextLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `onPageChanged` | `void Function(int)?` | 是 | — | 依公開型別提供此輸入。 |


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

- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/navigation/widgets/controls/klp_pagination.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/controls/klp_pagination.dart`。
