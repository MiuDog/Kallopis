# KlpWorkspaceCommand

Flutter · Stable · 資料與型別

## 主要職責

工作區命令資料；互動流程由 Kallopis 呈現，產品變更由 [onInvoke] 執行。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'dart:async';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpWorkspaceCommand createExample(String label, FutureOr<void> Function(String?) onInvoke) => KlpWorkspaceCommand(label: label, onInvoke: onInvoke);
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpWorkspaceCommand
```

## 建構子 KlpWorkspaceCommand



```dart
KlpWorkspaceCommand({
	required String label,
	bool enabled = true,
	bool destructive = false,
	String? inputLabel,
	String? initialValue,
	String? confirmation,
	String submitLabel = 'OK',
	String cancelLabel = 'Cancel',
	KlpWorkspaceCommandShortcut? shortcut,
	required FutureOr<void> Function(String?) onInvoke,
	ValueChanged<KlpWorkspaceCommandResult>? onResult,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `enabled` | `bool` | 否 | true | 依公開型別提供此輸入。 |
| `destructive` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `inputLabel` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `initialValue` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `confirmation` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `submitLabel` | `String` | 否 | 'OK' | 依公開型別提供此輸入。 |
| `cancelLabel` | `String` | 否 | 'Cancel' | 依公開型別提供此輸入。 |
| `shortcut` | `KlpWorkspaceCommandShortcut?` | 否 | null | 依公開型別提供此輸入。 |
| `onInvoke` | `FutureOr<void> Function(String?)` | 是 | — | 依公開型別提供此輸入。 |
| `onResult` | `void Function(KlpWorkspaceCommandResult)?` | 否 | null | 接收執行結果。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpWorkspaceCommandResult](klp-workspace-command-result.md)
- [KlpWorkspaceCommandShortcut](klp-workspace-command-shortcut.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/anchored_popup/klp_anchored_popup.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/anchored_popup/klp_anchored_popup.dart`。
