# KlpAnchoredPopupItem

Flutter · Stable · 資料與型別

## 主要職責

Popup 內的平面資料列；穩定身分與可重複顯示名稱彼此分離。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpAnchoredPopupItem createExample(String id, String label) => KlpAnchoredPopupItem(id: id, label: label);
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpAnchoredPopupItem
```

## 建構子 KlpAnchoredPopupItem



```dart
KlpAnchoredPopupItem({
	required String id,
	required String label,
	String? subtitle,
	KlpIconData? icon,
	bool current = false,
	bool enabled = true,
	FutureOr<void> Function()? onPressed,
	List<KlpWorkspaceCommand> commands = const [],
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `subtitle` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `icon` | `KlpIconData?` | 否 | null | 操作或內容圖示。 |
| `current` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `enabled` | `bool` | 否 | true | 依公開型別提供此輸入。 |
| `onPressed` | `FutureOr<void> Function()?` | 否 | null | 啟動時通知產品；nullable 回呼的停用規則依元件契約。 |
| `commands` | `List<KlpWorkspaceCommand>` | 否 | const [] | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpWorkspaceCommand](klp-workspace-command.md)
- [KlpIconData](klp-icon-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/anchored_popup/klp_anchored_popup.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/anchored_popup/klp_anchored_popup.dart`。
