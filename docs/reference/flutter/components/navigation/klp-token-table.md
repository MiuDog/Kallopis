# KlpTokenTable

Flutter · Experimental · 導覽元件

## 主要職責

可排序 Token 清單的表格呈現；排序狀態由呼叫端持有。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpTokenTable createExample(List<KlpTokenDefinitionData> tokens, String nameLabel, String typeLabel, String valueLabel, String referenceLabel, String statusLabel) => KlpTokenTable(tokens: tokens, nameLabel: nameLabel, typeLabel: typeLabel, valueLabel: valueLabel, referenceLabel: referenceLabel, statusLabel: statusLabel);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpTokenTable extends StatelessWidget
```

## 建構子 KlpTokenTable



```dart
const KlpTokenTable({
	Key? key,
	required List<KlpTokenDefinitionData> tokens,
	required String nameLabel,
	required String typeLabel,
	required String valueLabel,
	required String referenceLabel,
	required String statusLabel,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `tokens` | `List<KlpTokenDefinitionData>` | 是 | — | 依公開型別提供此輸入。 |
| `nameLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `typeLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `valueLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `referenceLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `statusLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |


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
- [KlpTokenDefinitionData](../../types/klp-token-definition-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/artifact/klp_artifact_workspace.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/artifact/klp_artifact_workspace.dart`。
