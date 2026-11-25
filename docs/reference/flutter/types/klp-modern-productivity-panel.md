# KlpModernProductivityPanel

Flutter · Stable · 資料與型別

## 主要職責

現代風生產力模板的一項受控側欄內容。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpModernProductivityPanel createExample(String id, String label, Widget content) => KlpModernProductivityPanel(id: id, label: label, content: content);
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpModernProductivityPanel
```

## 建構子 KlpModernProductivityPanel



```dart
const KlpModernProductivityPanel({
	required String id,
	required String label,
	required Widget content,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 跨切換與重排保持穩定的功能識別。 |
| `label` | `String` | 是 | — | 功能切換按鈕的文字與可存取名稱。 |
| `content` | `Widget` | 是 | — | 產品提供且保留掛載的功能內容。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/layout/klp_modern_productivity_layout.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/layout/klp_modern_productivity_layout.dart`。
