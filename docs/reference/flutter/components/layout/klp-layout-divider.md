# KlpLayoutDivider

Flutter · Stable · 布局元件

## 主要職責

不含拖曳手勢的顯式間距槽。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpLayoutDivider createExample() => KlpLayoutDivider();
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpLayoutDivider extends KlpLayoutNode
```

## 建構子 KlpLayoutDivider



```dart
const KlpLayoutDivider({Key? key})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |


## 成員與方法

### build

```dart
Widget build(BuildContext context)
```

由 Flutter 依目前 context 建構畫面。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


### flex

```dart
int get flex
```



<!-- reference-api:end -->

## 使用限制與關聯

- [一般布局 bounds 與 divider](../../../../guides/flutter/08-klp-layout-pane.md)：跨元件使用流程。
- 繼承／實作：[KlpLayoutNode](../../types/klp-layout-node.md)。
- [KlpLayoutNode](../../types/klp-layout-node.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/layout/klp_app_layout.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/layout/klp_app_layout.dart`。
