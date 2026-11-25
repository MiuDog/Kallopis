# KlpComponentDefinitionData

Flutter · Experimental · 資料與型別

## 主要職責

一個元件定義的產品中立預覽資料。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpComponentDefinitionData createExample(String id, String name, String statusLabel, Widget preview) => KlpComponentDefinitionData(id: id, name: name, statusLabel: statusLabel, preview: preview);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpComponentDefinitionData
```

## 建構子 KlpComponentDefinitionData



```dart
const KlpComponentDefinitionData({
	required String id,
	required String name,
	required String statusLabel,
	required Widget preview,
	String? description,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |
| `name` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `statusLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `preview` | `Widget` | 是 | — | 依公開型別提供此輸入。 |
| `description` | `String?` | 否 | null | 補充描述。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/artifact/klp_artifact_workspace.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/artifact/klp_artifact_workspace.dart`。
