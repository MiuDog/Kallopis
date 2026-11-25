# KlpCommandDefinition

Flutter · Stable · 資料與型別

## 主要職責

產品擁有的命令定義；註冊時隔離 metadata，context 與業務仍由產品擁有。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'dart:async';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpCommandDefinition<C> createExample<C>(String id, String label, FutureOr<Object?> Function(C) handler) => KlpCommandDefinition<C>(id: id, label: label, handler: handler);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpCommandDefinition<C>
```

## 建構子 KlpCommandDefinition



```dart
const KlpCommandDefinition<C>({
	required String id,
	required String label,
	required FutureOr<Object?> Function(C) handler,
	String? description,
	String? category,
	List<String> keywords = const [],
	KlpIconData? icon,
	bool Function(C)? isVisible,
	bool Function(C)? isEnabled,
	bool Function(C)? isChecked,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `handler` | `FutureOr<Object?> Function(C)` | 是 | — | 由產品提供的執行處理。 |
| `description` | `String?` | 否 | null | 補充描述。 |
| `category` | `String?` | 否 | null | 分類資訊。 |
| `keywords` | `List<String>` | 否 | const [] | 搜尋關鍵字。 |
| `icon` | `KlpIconData?` | 否 | null | 操作或內容圖示。 |
| `isVisible` | `bool Function(C)?` | 否 | null | 依目前上下文判定是否可見。 |
| `isEnabled` | `bool Function(C)?` | 否 | null | 依目前上下文判定是否可啟動。 |
| `isChecked` | `bool Function(C)?` | 否 | null | 依目前上下文判定勾選狀態。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [Dock 受控操作](../../../guides/flutter/10-apply-klp-dock-action.md)：跨元件使用流程。
- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpIconData](klp-icon-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/actions/command_registry/klp_command_registry.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/command_registry/klp_command_registry.dart`。
