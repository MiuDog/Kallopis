# showKlpWorkspaceCommand

Flutter · Stable · 工具函式

## 主要職責

以 Kallopis 對話框完成命令的輸入、確認與結果流程。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final productShowKlpWorkspaceCommand = showKlpWorkspaceCommand;
```

<!-- reference-api:start -->

## 公開簽名

```dart
Future<KlpWorkspaceCommandResult> showKlpWorkspaceCommand(BuildContext context, KlpWorkspaceCommand command)
```

## 參數

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |
| `command` | `KlpWorkspaceCommand` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯


- [KlpWorkspaceCommand](../types/klp-workspace-command.md)
- [KlpWorkspaceCommandResult](../types/klp-workspace-command-result.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/anchored_popup/klp_anchored_popup.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/anchored_popup/klp_anchored_popup.dart`。
