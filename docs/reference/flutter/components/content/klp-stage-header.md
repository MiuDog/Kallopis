# KlpStageHeader

Flutter · Stable · 內容元件

## 主要職責

Stage 頂部的兩行識別標頭。

第一行顯示專案與區域，第二行顯示目前項目與類型；呼叫端只提供語意資料，
排版、間距與文字層級一律由 Kallopis theme 決定。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpStageHeader createExample(String projectName, String sectionLabel, String title, String typeLabel) => KlpStageHeader(projectName: projectName, sectionLabel: sectionLabel, title: title, typeLabel: typeLabel);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpStageHeader extends StatelessWidget
```

## 建構子 KlpStageHeader



```dart
const KlpStageHeader({
	Key? key,
	required String projectName,
	required String sectionLabel,
	required String title,
	required String typeLabel,
	List<Widget> actions = const [],
	bool wrapTitle = true,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `projectName` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `sectionLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `title` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `typeLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `actions` | `List<Widget>` | 否 | const [] | 依公開型別提供此輸入。 |
| `wrapTitle` | `bool` | 否 | true | 依公開型別提供此輸入。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/workspace/shell/stage/klp_stage_header.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/stage/klp_stage_header.dart`。
