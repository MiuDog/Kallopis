# KlpWindowAction

Flutter · Stable · 資料與型別

## 主要職責

桌面平台視窗控制操作。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
void acceptValue(KlpWindowAction value) {
	// 產品接收此抽象契約；請使用公開子型別或靜態方法。
}
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract final class KlpWindowAction
```

## 建構子 KlpWindowAction



```dart
KlpWindowAction()
```



## 成員與方法

### checkIsMaximized

```dart
static Future<bool> checkIsMaximized()
```

查詢目前視窗是否處於最大化狀態。

### close

```dart
static Future<void> close()
```

關閉目前視窗。

### drag

```dart
static Future<void> drag()
```

開始拖曳目前視窗。

### maximize

```dart
static Future<void> maximize()
```

確保目前視窗最大化。

### minimize

```dart
static Future<void> minimize()
```

最小化目前視窗。

### setMinSize

```dart
static Future<void> setMinSize({double? minWidth, double? minHeight})
```

設定視窗最小寬高限制。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `minWidth` | `double?` | 否 | null | 依公開型別提供此輸入。 |
| `minHeight` | `double?` | 否 | null | 依公開型別提供此輸入。 |


### toggleMaximize

```dart
static Future<void> toggleMaximize()
```

切換最大化或還原目前視窗。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/window/klp_window_action.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/window/klp_window_action.dart`。
