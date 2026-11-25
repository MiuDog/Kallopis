# KlpTokenDefinitionData

Flutter · Experimental · 資料與型別

## 主要職責

一筆產品中立的 Token 呈現資料。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpTokenDefinitionData createExample(String name, String typeLabel, String valueLabel, String statusLabel) => KlpTokenDefinitionData(name: name, typeLabel: typeLabel, valueLabel: valueLabel, statusLabel: statusLabel);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpTokenDefinitionData
```

## 建構子 KlpTokenDefinitionData



```dart
const KlpTokenDefinitionData({
	required String name,
	required String typeLabel,
	required String valueLabel,
	required String statusLabel,
	String? referenceLabel,
	Widget? preview,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `name` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `typeLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `valueLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `statusLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `referenceLabel` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `preview` | `Widget?` | 否 | null | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/artifact/klp_artifact_workspace.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/artifact/klp_artifact_workspace.dart`。
