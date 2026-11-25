# KlpRow

Flutter · Stable · 布局元件

## 主要職責

水平排列排版原語。取代 Row，支援自動間距設定。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpRow createExample() => KlpRow();
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpRow extends StatelessWidget
```

## 建構子 KlpRow



```dart
const KlpRow({
	Key? key,
	MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
	CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
	MainAxisSize mainAxisSize = MainAxisSize.max,
	TextBaseline? textBaseline,
	double? gap,
	List<Widget> children = const <Widget>[],
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `mainAxisAlignment` | `MainAxisAlignment` | 否 | MainAxisAlignment.start | 依公開型別提供此輸入。 |
| `crossAxisAlignment` | `CrossAxisAlignment` | 否 | CrossAxisAlignment.center | 依公開型別提供此輸入。 |
| `mainAxisSize` | `MainAxisSize` | 否 | MainAxisSize.max | 依公開型別提供此輸入。 |
| `textBaseline` | `TextBaseline?` | 否 | null | 依公開型別提供此輸入。 |
| `gap` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `children` | `List<Widget>` | 否 | const <Widget>[] | 產品提供的子內容。 |


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
- [宣告來源](../../../../../flutter/lib/src/foundation/layout/klp_row.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/layout/klp_row.dart`。
