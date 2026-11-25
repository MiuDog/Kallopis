# KlpRegisteredCommandToolbar

Flutter · Stable · 操作元件

## 主要職責

依產品指定次序呈現已註冊命令，將原執行結果交回 caller。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpRegisteredCommandToolbar<C> createExample<C>(KlpCommandRegistry<C> registry, C Function() getContext, List<KlpCommandReference> items, String label, void Function(KlpCommandExecutionResult) onResult) => KlpRegisteredCommandToolbar<C>(registry: registry, getContext: getContext, items: items, label: label, onResult: onResult);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpRegisteredCommandToolbar<C> extends StatelessWidget
```

## 建構子 KlpRegisteredCommandToolbar



```dart
const KlpRegisteredCommandToolbar<C>({
	Key? key,
	required KlpCommandRegistry<C> registry,
	required C Function() getContext,
	required List<KlpCommandReference> items,
	required String label,
	required ValueChanged<KlpCommandExecutionResult> onResult,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `registry` | `KlpCommandRegistry<C>` | 是 | — | 借用共用命令登錄表。 |
| `getContext` | `C Function()` | 是 | — | 取得當次產品執行上下文。 |
| `items` | `List<KlpCommandReference>` | 是 | — | 由產品提供的項目。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `onResult` | `void Function(KlpCommandExecutionResult)` | 是 | — | 接收執行結果。 |


## 成員與方法

### build

```dart
Widget build(BuildContext context)
```

由 Flutter 依目前 context 建構畫面。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [Registered 命令工具列與選單](../../../../guides/flutter/11-klp-registered-command-toolbar.md)：跨元件使用流程。
- 框架繼承成員：[StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)。
- [KlpCommandExecutionResult](../../types/klp-command-execution-result.md)
- [KlpCommandReference](../../types/klp-command-reference.md)
- [KlpCommandRegistry](../../controllers/klp-command-registry.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/actions/command_entries/klp_command_entries.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/command_entries/klp_command_entries.dart`。
