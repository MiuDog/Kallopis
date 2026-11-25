# KlpCommandKeymap

Flutter · Stable · 控制與生命週期

## 主要職責

解析已註冊快捷鍵；產品 registry 仍是條件、handler 與執行結果的唯一權威。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpCommandKeymap<C> createExample<C>(KlpCommandRegistry<C> registry) => KlpCommandKeymap<C>(registry: registry);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpCommandKeymap<C>
```

## 建構子 KlpCommandKeymap



```dart
KlpCommandKeymap<C>({
	required KlpCommandRegistry<C> registry,
	KlpShortcutPlatform platform = KlpShortcutPlatform.other,
	int chordTimeoutMs = 1000,
	double Function()? now,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `registry` | `KlpCommandRegistry<C>` | 是 | — | 借用共用命令登錄表。 |
| `platform` | `KlpShortcutPlatform` | 否 | KlpShortcutPlatform.other | 依公開型別提供此輸入。 |
| `chordTimeoutMs` | `int` | 否 | 1000 | 依公開型別提供此輸入。 |
| `now` | `double Function()?` | 否 | null | 依公開型別提供此輸入。 |


## 成員與方法

### beginRecording

```dart
void beginRecording(String focusId)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `focusId` | `String` | 是 | — | 依公開型別提供此輸入。 |


### cancelChord

```dart
bool cancelChord()
```



### cancelRecording

```dart
void cancelRecording()
```



### conflicts

```dart
List<KlpShortcutConflict> conflicts(KlpShortcutFocus focus, C context)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `focus` | `KlpShortcutFocus` | 是 | — | 依公開型別提供此輸入。 |
| `context` | `C` | 是 | — | 依公開型別提供此輸入。 |


### dispose

```dart
void dispose()
```

釋放此物件擁有的資源；由建立者管理生命週期。

### expireChord

```dart
bool expireChord()
```



### exportOverrides

```dart
Map<String, Object?> exportOverrides()
```



### finishRecording

```dart
List<KlpShortcutStroke> finishRecording()
```



### handle

```dart
KlpShortcutHandling handle(
	KlpShortcutInput input,
	KlpShortcutFocus focus,
	C context,
)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `input` | `KlpShortcutInput` | 是 | — | 依公開型別提供此輸入。 |
| `focus` | `KlpShortcutFocus` | 是 | — | 依公開型別提供此輸入。 |
| `context` | `C` | 是 | — | 依公開型別提供此輸入。 |


### importOverrides

```dart
void importOverrides(Object? value)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `value` | `Object?` | 是 | — | 目前值。 |


### isDisposed

```dart
bool get isDisposed
```



### isRecording

```dart
bool get isRecording
```



### pendingSequence

```dart
List<KlpShortcutStroke> get pendingSequence
```



### recordedSequence

```dart
List<KlpShortcutStroke> get recordedSequence
```



### register

```dart
VoidCallback register(KlpShortcutBinding<C> binding)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `binding` | `KlpShortcutBinding<C>` | 是 | — | 依公開型別提供此輸入。 |


### restore

```dart
void restore(String id)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |


### setOverride

```dart
void setOverride(String id, List<KlpShortcutStroke>? sequence)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |
| `sequence` | `List<KlpShortcutStroke>?` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [Registered 快捷鍵純核心](../../../guides/flutter/14-klp-command-keymap.md)：跨元件使用流程。
- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpCommandRegistry](klp-command-registry.md)
- [KlpShortcutBinding](../types/klp-shortcut-binding.md)
- [KlpShortcutConflict](../types/klp-shortcut-conflict.md)
- [KlpShortcutFocus](../types/klp-shortcut-focus.md)
- [KlpShortcutHandling](../types/klp-shortcut-handling.md)
- [KlpShortcutInput](../types/klp-shortcut-input.md)
- [KlpShortcutPlatform](../types/klp-shortcut-platform.md)
- [KlpShortcutStroke](../types/klp-shortcut-stroke.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/actions/command_keymap/klp_command_keymap.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/command_keymap/klp_command_keymap.dart`。
