# KlpWorkflowState

Flutter · Stable · 資料與型別

## 主要職責

有限工作流的語意狀態；狀態轉移仍由呼叫端控制。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpWorkflowState.applied;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpWorkflowState
```

## 建構子 KlpWorkflowState



```dart
const KlpWorkflowState()
```



## 成員與方法

### applied

```dart
static const KlpWorkflowState applied
```



### applying

```dart
static const KlpWorkflowState applying
```



### collecting

```dart
static const KlpWorkflowState collecting
```



### empty

```dart
static const KlpWorkflowState empty
```



### failed

```dart
static const KlpWorkflowState failed
```



### ready

```dart
static const KlpWorkflowState ready
```



### reviewing

```dart
static const KlpWorkflowState reviewing
```



### stale

```dart
static const KlpWorkflowState stale
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/feedback/workflow/klp_finite_workflow.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/feedback/workflow/klp_finite_workflow.dart`。
