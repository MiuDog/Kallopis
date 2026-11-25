# KlpStatusIndicator

Flutter · Stable · 內容元件

## 主要職責

狀態指示標記與文字。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpStatusIndicator createExample(KlpStatusItemData data) => KlpStatusIndicator(data: data);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpStatusIndicator extends StatelessWidget
```

## 建構子 KlpStatusIndicator



```dart
const KlpStatusIndicator({
	Key? key,
	required KlpStatusItemData data,
	bool expanded = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `data` | `KlpStatusItemData` | 是 | — | 由容器注入的狀態資料。 |
| `expanded` | `bool` | 否 | false | 是否占滿可用寬度，並讓標籤在空間不足時省略。 |


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
- [KlpStatusItemData](../../types/klp-status-item-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/feedback/klp_status_indicator.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/feedback/klp_status_indicator.dart`。
