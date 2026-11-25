# KlpCommandShortcutHost

Flutter · Stable · 操作元件

## 主要職責

將 focused descendant 未處理的原生按鍵交同 keymap，不接管產品文字或命令權威。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpCommandShortcutHost<C> createExample<C>(KlpCommandKeymap<C> keymap, C Function() getContext, KlpShortcutFocus Function() getFocus, bool Function() getIsComposing, void Function(KlpShortcutHandling) onHandling, void Function(KlpCommandExecutionResult) onResult, Widget child) => KlpCommandShortcutHost<C>(keymap: keymap, getContext: getContext, getFocus: getFocus, getIsComposing: getIsComposing, onHandling: onHandling, onResult: onResult, child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpCommandShortcutHost<C> extends StatefulWidget
```

## 建構子 KlpCommandShortcutHost



```dart
const KlpCommandShortcutHost<C>({
	Key? key,
	required KlpCommandKeymap<C> keymap,
	required C Function() getContext,
	required KlpShortcutFocus Function() getFocus,
	required bool Function() getIsComposing,
	required ValueChanged<KlpShortcutHandling> onHandling,
	required ValueChanged<KlpCommandExecutionResult> onResult,
	required Widget child,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `keymap` | `KlpCommandKeymap<C>` | 是 | — | 依公開型別提供此輸入。 |
| `getContext` | `C Function()` | 是 | — | 取得當次產品執行上下文。 |
| `getFocus` | `KlpShortcutFocus Function()` | 是 | — | 依公開型別提供此輸入。 |
| `getIsComposing` | `bool Function()` | 是 | — | 依公開型別提供此輸入。 |
| `onHandling` | `void Function(KlpShortcutHandling)` | 是 | — | 依公開型別提供此輸入。 |
| `onResult` | `void Function(KlpCommandExecutionResult)` | 是 | — | 接收執行結果。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |


## 成員與方法

### createState

```dart
State<KlpCommandShortcutHost<C>> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- [原生快捷鍵宿主](../../../../guides/flutter/15-klp-command-shortcut-host.md)：跨元件使用流程。
- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- [KlpCommandExecutionResult](../../types/klp-command-execution-result.md)
- [KlpCommandKeymap](../../controllers/klp-command-keymap.md)
- [KlpShortcutFocus](../../types/klp-shortcut-focus.md)
- [KlpShortcutHandling](../../types/klp-shortcut-handling.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/actions/command_shortcut_host/klp_command_shortcut_host.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/command_shortcut_host/klp_command_shortcut_host.dart`。
