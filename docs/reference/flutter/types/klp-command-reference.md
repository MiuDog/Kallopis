# KlpCommandReference

Flutter · Stable · 資料與型別

## 主要職責

以命令 ID 與呈現種類組合入口，不保存產品命令狀態。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpCommandReference createExample(String commandId) => KlpCommandReference(commandId: commandId);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpCommandReference
```

## 建構子 KlpCommandReference



```dart
const KlpCommandReference({required String commandId, KlpCommandKind kind = KlpCommandKind.action})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `commandId` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `kind` | `KlpCommandKind` | 否 | KlpCommandKind.action | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [Registered 錨定與右鍵命令選單](../../../guides/flutter/13-klp-registered-command-popup.md)：跨元件使用流程。
- [Registered 命令工具列與選單](../../../guides/flutter/11-klp-registered-command-toolbar.md)：跨元件使用流程。
- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpCommandKind](klp-command-kind.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/actions/command_entries/klp_command_entries.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/command_entries/klp_command_entries.dart`。
