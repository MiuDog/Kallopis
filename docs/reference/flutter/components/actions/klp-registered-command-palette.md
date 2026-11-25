# KlpRegisteredCommandPalette

Flutter · Stable · 操作元件

## 主要職責

使用同命令清冊的原生搜尋面板；產品持有 context、open 與結果。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpRegisteredCommandPalette<C> createExample<C>(KlpCommandRegistry<C> registry, C Function() getContext, bool open, String label, String searchLabel, String emptyLabel, void Function(KlpCommandExecutionResult) onResult, void Function(KlpCommandDismissReason) onDismiss) => KlpRegisteredCommandPalette<C>(registry: registry, getContext: getContext, open: open, label: label, searchLabel: searchLabel, emptyLabel: emptyLabel, onResult: onResult, onDismiss: onDismiss);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpRegisteredCommandPalette<C> extends StatefulWidget
```

## 建構子 KlpRegisteredCommandPalette



```dart
const KlpRegisteredCommandPalette<C>({
	Key? key,
	required KlpCommandRegistry<C> registry,
	required C Function() getContext,
	required bool open,
	required String label,
	required String searchLabel,
	required String emptyLabel,
	required ValueChanged<KlpCommandExecutionResult> onResult,
	required ValueChanged<KlpCommandDismissReason> onDismiss,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `registry` | `KlpCommandRegistry<C>` | 是 | — | 借用共用命令登錄表。 |
| `getContext` | `C Function()` | 是 | — | 取得當次產品執行上下文。 |
| `open` | `bool` | 是 | — | 產品持有的開啟狀態。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `searchLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `emptyLabel` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `onResult` | `void Function(KlpCommandExecutionResult)` | 是 | — | 接收執行結果。 |
| `onDismiss` | `void Function(KlpCommandDismissReason)` | 是 | — | 向產品提出關閉意圖。 |


## 成員與方法

### createState

```dart
State<KlpRegisteredCommandPalette<C>> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- [Registered 命令面板](../../../../guides/flutter/12-klp-registered-command-palette.md)：跨元件使用流程。
- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- [KlpCommandDismissReason](../../types/klp-command-dismiss-reason.md)
- [KlpCommandExecutionResult](../../types/klp-command-execution-result.md)
- [KlpCommandRegistry](../../controllers/klp-command-registry.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/actions/command_palette/klp_command_palette.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/command_palette/klp_command_palette.dart`。
