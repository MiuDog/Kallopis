# KlpCommandRegistry

Flutter · Stable · 控制與生命週期

## 主要職責

集中命令狀態與執行入口，不擁有產品 context、持久化或業務副作用。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpCommandRegistry<C> createExample<C>() => KlpCommandRegistry<C>();
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpCommandRegistry<C> extends ChangeNotifier
```

## 建構子 KlpCommandRegistry



```dart
KlpCommandRegistry<C>()
```



## 成員與方法

### addListener

```dart
void addListener(VoidCallback listener)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `listener` | `void Function()` | 是 | — | 依公開型別提供此輸入。 |


### dispose

```dart
void dispose()
```

釋放此物件擁有的資源；由建立者管理生命週期。

### execute

```dart
Future<KlpCommandExecutionResult> execute(String id, C context)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |
| `context` | `C` | 是 | — | 依公開型別提供此輸入。 |


### getState

```dart
KlpCommandState? getState(String id, C context)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |
| `context` | `C` | 是 | — | 依公開型別提供此輸入。 |


### isDisposed

```dart
bool get isDisposed
```



### list

```dart
List<KlpCommandState> list(C context)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `C` | 是 | — | 依公開型別提供此輸入。 |


### notifyListeners

```dart
void notifyListeners()
```



### refresh

```dart
void refresh()
```



### register

```dart
VoidCallback register(KlpCommandDefinition<C> definition)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `definition` | `KlpCommandDefinition<C>` | 是 | — | 依公開型別提供此輸入。 |


### removeListener

```dart
void removeListener(VoidCallback listener)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `listener` | `void Function()` | 是 | — | 依公開型別提供此輸入。 |


### subscribe

```dart
VoidCallback subscribe(VoidCallback listener)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `listener` | `void Function()` | 是 | — | 依公開型別提供此輸入。 |


### version

```dart
int get version
```



<!-- reference-api:end -->

## 使用限制與關聯

- [Dock 受控操作](../../../guides/flutter/10-apply-klp-dock-action.md)：跨元件使用流程。
- 框架繼承成員：[ChangeNotifier](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html)。
- [KlpCommandDefinition](../types/klp-command-definition.md)
- [KlpCommandExecutionResult](../types/klp-command-execution-result.md)
- [KlpCommandState](../types/klp-command-state.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/actions/command_registry/klp_command_registry.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/command_registry/klp_command_registry.dart`。
