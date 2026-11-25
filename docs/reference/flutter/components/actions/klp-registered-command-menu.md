# KlpRegisteredCommandMenu

Flutter · Stable · 操作元件

## 主要職責

呈現已註冊命令清單與空內容文案，不擁有產品命令或選取資料。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpRegisteredCommandMenu<C> createExample<C>(KlpCommandRegistry<C> registry, C Function() getContext, List<KlpCommandReference> items, String label, String emptyLabel, void Function(KlpCommandExecutionResult) onResult) => KlpRegisteredCommandMenu<C>(registry: registry, getContext: getContext, items: items, label: label, emptyLabel: emptyLabel, onResult: onResult);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpRegisteredCommandMenu<C> extends StatelessWidget
```

## 建構子 KlpRegisteredCommandMenu



```dart
const KlpRegisteredCommandMenu<C>({
	Key? key,
	required KlpCommandRegistry<C> registry,
	required C Function() getContext,
	required List<KlpCommandReference> items,
	required String label,
	required String emptyLabel,
	required ValueChanged<KlpCommandExecutionResult> onResult,
	bool autoFocus = false,
	VoidCallback? onDismiss,
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
| `onResult` | `void Function(KlpCommandExecutionResult)` | 是 | — | 接收執行結果。 |
| `autoFocus` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `onDismiss` | `void Function()?` | 否 | null | 向產品提出關閉意圖。 |


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
