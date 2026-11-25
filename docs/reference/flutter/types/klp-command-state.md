# KlpCommandState

Flutter · Stable · 資料與型別

## 主要職責

一次 context 解析的不可變命令呈現快照，不複製產品業務狀態。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 在產品介面沿用公開型別；實例由其擁有者提供。
void acceptValue(KlpCommandState value) {
	// 接入產品的資料處理。
}
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpCommandState
```

## 成員與方法

### category

```dart
final String? category
```

分類資訊。

### checked

```dart
final bool checked
```



### conditionError

```dart
final KlpCommandConditionError? conditionError
```



### description

```dart
final String? description
```

補充描述。

### enabled

```dart
final bool enabled
```



### icon

```dart
final KlpIconData? icon
```

操作或內容圖示。

### id

```dart
final String id
```

穩定識別，用於查詢或回報。

### keywords

```dart
final List<String> keywords
```

搜尋關鍵字。

### label

```dart
final String label
```

顯示標籤。

### running

```dart
final bool running
```



### visible

```dart
final bool visible
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpCommandConditionError](klp-command-condition-error.md)
- [KlpIconData](klp-icon-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/actions/command_registry/klp_command_registry.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/command_registry/klp_command_registry.dart`。
