# KlpShortcutBinding

Flutter · Stable · 資料與型別

## 主要職責

註冊 token、命令引用與不可變序列；業務 handler 由 registry 擁有。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpShortcutBinding<C> createExample<C>(String id, String commandId, List<KlpShortcutStroke> sequence, KlpShortcutScope scope) => KlpShortcutBinding<C>(id: id, commandId: commandId, sequence: sequence, scope: scope);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpShortcutBinding<C>
```

## 建構子 KlpShortcutBinding



```dart
KlpShortcutBinding<C>({
	required String id,
	required String commandId,
	required List<KlpShortcutStroke> sequence,
	required KlpShortcutScope scope,
	String? scopeId,
	int priority = 0,
	bool allowRepeat = false,
	bool allowInEditable = false,
	bool Function(C)? when,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |
| `commandId` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `sequence` | `List<KlpShortcutStroke>` | 是 | — | 依公開型別提供此輸入。 |
| `scope` | `KlpShortcutScope` | 是 | — | 依公開型別提供此輸入。 |
| `scopeId` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `priority` | `int` | 否 | 0 | 依公開型別提供此輸入。 |
| `allowRepeat` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `allowInEditable` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `when` | `bool Function(C)?` | 否 | null | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [Registered 快捷鍵純核心](../../../guides/flutter/14-klp-command-keymap.md)：跨元件使用流程。
- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpShortcutScope](klp-shortcut-scope.md)
- [KlpShortcutStroke](klp-shortcut-stroke.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/actions/command_keymap/klp_command_keymap.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/command_keymap/klp_command_keymap.dart`。
