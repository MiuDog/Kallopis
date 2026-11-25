# KlpWorkspaceCommandResult

Flutter · Stable · 資料與型別

## 主要職責

呈現流程的結果；不宣稱產品資料已提交或持久化。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpWorkspaceCommandResult createExample() => KlpWorkspaceCommandResult.canceled();
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpWorkspaceCommandResult
```

## 建構子 KlpWorkspaceCommandResult.canceled



```dart
const KlpWorkspaceCommandResult.canceled()
```



## 建構子 KlpWorkspaceCommandResult.completed



```dart
const KlpWorkspaceCommandResult.completed()
```



## 建構子 KlpWorkspaceCommandResult.failed



```dart
const KlpWorkspaceCommandResult.failed(Object? error, StackTrace? stackTrace)
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `error` | `Object?` | 是 | — | 依公開型別提供此輸入。 |
| `stackTrace` | `StackTrace?` | 是 | — | 依公開型別提供此輸入。 |


## 成員與方法

### status

```dart
final KlpWorkspaceCommandStatus status
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpWorkspaceCommandStatus](klp-workspace-command-status.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/anchored_popup/klp_anchored_popup.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/anchored_popup/klp_anchored_popup.dart`。
