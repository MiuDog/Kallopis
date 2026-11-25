# KlpRegisteredCommandPopup

Flutter · Stable · 操作元件

## 主要職責

依 caller 錨點及主題呈現已註冊選單，不擁有產品開關或命令資料。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpRegisteredCommandPopup<C> createExample<C>(KlpCommandRegistry<C> registry, C Function() getContext, List<KlpCommandReference> items, String label, String emptyLabel, bool open, Rect anchor, void Function(KlpCommandExecutionResult) onResult, void Function(KlpCommandPopupDismissReason) onDismiss) => KlpRegisteredCommandPopup<C>(registry: registry, getContext: getContext, items: items, label: label, emptyLabel: emptyLabel, open: open, anchor: anchor, onResult: onResult, onDismiss: onDismiss);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpRegisteredCommandPopup<C> extends StatefulWidget
```

## 建構子 KlpRegisteredCommandPopup



```dart
const KlpRegisteredCommandPopup<C>({
	Key? key,
	required KlpCommandRegistry<C> registry,
	required C Function() getContext,
	required List<KlpCommandReference> items,
	required String label,
	required String emptyLabel,
	required bool open,
	required Rect anchor,
	required ValueChanged<KlpCommandExecutionResult> onResult,
	required ValueChanged<KlpCommandPopupDismissReason> onDismiss,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `registry` | `KlpCommandRegistry<C>` | 是 | — | 借用共用命令登錄表。 |
| `getContext` | `C Function()` | 是 | — | 取得當次產品執行上下文。 |
| `items` | `List<KlpCommandReference>` | 是 | — | 由產品提供的項目。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `emptyLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `open` | `bool` | 是 | — | 產品持有的開啟狀態。 |
| `anchor` | `Rect` | 是 | — | 依公開型別提供此輸入。 |
| `onResult` | `void Function(KlpCommandExecutionResult)` | 是 | — | 接收執行結果。 |
| `onDismiss` | `void Function(KlpCommandPopupDismissReason)` | 是 | — | 向產品提出關閉意圖。 |


## 成員與方法

### createState

```dart
State<KlpRegisteredCommandPopup<C>> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- [Registered 錨定與右鍵命令選單](../../../../guides/flutter/13-klp-registered-command-popup.md)：跨元件使用流程。
- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- [KlpCommandExecutionResult](../../types/klp-command-execution-result.md)
- [KlpCommandPopupDismissReason](../../types/klp-command-popup-dismiss-reason.md)
- [KlpCommandReference](../../types/klp-command-reference.md)
- [KlpCommandRegistry](../../controllers/klp-command-registry.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/actions/command_popup/klp_command_popup.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/command_popup/klp_command_popup.dart`。
