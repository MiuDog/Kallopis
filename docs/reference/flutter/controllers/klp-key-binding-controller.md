# KlpKeyBindingController

Flutter · Stable · 控制與生命週期

## 主要職責

App 內唯一的快捷鍵註冊與 scope 解析器。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpKeyBindingController createExample() => KlpKeyBindingController();
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpKeyBindingController extends ChangeNotifier
```

## 建構子 KlpKeyBindingController



```dart
KlpKeyBindingController()
```



## 成員與方法

### actions

```dart
Map<Type, Action<Intent>> get actions
```



### activatePage

```dart
void activatePage(String? pageId)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `pageId` | `String?` | 是 | — | 依公開型別提供此輸入。 |


### activateRegion

```dart
void activateRegion({required String regionId, String? pageId})
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `regionId` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `pageId` | `String?` | 否 | null | 依公開型別提供此輸入。 |


### activePageId

```dart
String? get activePageId
```



### activeRegionId

```dart
String? get activeRegionId
```



### clearRegion

```dart
void clearRegion(String regionId)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `regionId` | `String` | 是 | — | 依公開型別提供此輸入。 |


### invoke

```dart
void invoke(String commandId)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `commandId` | `String` | 是 | — | 依公開型別提供此輸入。 |


### register

```dart
VoidCallback register({required KlpKeyBinding binding, required KlpKeyBindingAction action})
```

註冊快捷鍵，回傳可保存的解除註冊函式。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `binding` | `KlpKeyBinding` | 是 | — | 依公開型別提供此輸入。 |
| `action` | `void Function()` | 是 | — | 依公開型別提供此輸入。 |


### shortcuts

```dart
Map<ShortcutActivator, Intent> get shortcuts
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[ChangeNotifier](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html)。
- [KlpKeyBinding](../types/klp-key-binding.md)
- [KlpKeyBindingAction](../types/klp-key-binding-action.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/interaction/keybinding/klp_key_binding_controller.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/interaction/keybinding/klp_key_binding_controller.dart`。
