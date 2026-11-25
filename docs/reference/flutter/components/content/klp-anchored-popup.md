# KlpAnchoredPopup

Flutter · Stable · 內容元件

## 主要職責

由 trigger 實際 bounds 錨定的受控 popup。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpAnchoredPopup createExample(Widget Function(BuildContext, void Function(), bool) triggerBuilder, bool open, String accessibilityLabel, void Function(bool, KlpAnchoredPopupChangeReason) onOpenChanged) => KlpAnchoredPopup(triggerBuilder: triggerBuilder, open: open, accessibilityLabel: accessibilityLabel, onOpenChanged: onOpenChanged);
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpAnchoredPopup extends StatefulWidget
```

## 建構子 KlpAnchoredPopup



```dart
KlpAnchoredPopup({
	Key? key,
	required KlpAnchoredPopupTriggerBuilder triggerBuilder,
	required bool open,
	required String accessibilityLabel,
	String? title,
	List<KlpAnchoredPopupItem>? items,
	List<KlpWorkspaceCommand>? actions,
	KlpAnchoredPopupState state = KlpAnchoredPopupState.ready,
	String? message,
	required void Function(bool, KlpAnchoredPopupChangeReason) onOpenChanged,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `triggerBuilder` | `Widget Function(BuildContext, void Function(), bool)` | 是 | — | 依公開型別提供此輸入。 |
| `open` | `bool` | 是 | — | 產品持有的開啟狀態。 |
| `accessibilityLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `title` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `items` | `List<KlpAnchoredPopupItem>?` | 否 | null | 由產品提供的項目。 |
| `actions` | `List<KlpWorkspaceCommand>?` | 否 | null | 依公開型別提供此輸入。 |
| `state` | `KlpAnchoredPopupState` | 否 | KlpAnchoredPopupState.ready | 依公開型別提供此輸入。 |
| `message` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `onOpenChanged` | `void Function(bool, KlpAnchoredPopupChangeReason)` | 是 | — | 依公開型別提供此輸入。 |


## 成員與方法

### createState

```dart
State<KlpAnchoredPopup> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- [KlpAnchoredPopupChangeReason](../../types/klp-anchored-popup-change-reason.md)
- [KlpAnchoredPopupItem](../../types/klp-anchored-popup-item.md)
- [KlpAnchoredPopupState](../../types/klp-anchored-popup-state.md)
- [KlpAnchoredPopupTriggerBuilder](../../types/klp-anchored-popup-trigger-builder.md)
- [KlpWorkspaceCommand](../../types/klp-workspace-command.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/anchored_popup/klp_anchored_popup.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/anchored_popup/klp_anchored_popup.dart`。
