# KlpAppLayout

Flutter · Stable · 工作區元件

## 主要職責

組合產品應用的主要布局區域，由產品提供各區內容。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpAppLayout createExample(KlpLayoutNode child) => KlpAppLayout(child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpAppLayout extends StatelessWidget
```

## 建構子 KlpAppLayout



```dart
const KlpAppLayout({
	Key? key,
	required KlpLayoutNode child,
	Widget? floatingAction,
	KlpAppLayoutInset inset = KlpAppLayoutInset.standard,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `child` | `KlpLayoutNode` | 是 | — | 產品提供的內容。 |
| `floatingAction` | `Widget?` | 否 | null | 依公開型別提供此輸入。 |
| `inset` | `KlpAppLayoutInset` | 否 | KlpAppLayoutInset.standard | 依公開型別提供此輸入。 |


## 成員與方法

### build

```dart
Widget build(BuildContext context)
```

由 Flutter 依目前 context 建構畫面。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)。
- [KlpAppLayoutInset](../../types/klp-app-layout-inset.md)
- [KlpLayoutNode](../../types/klp-layout-node.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/layout/klp_app_layout.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/layout/klp_app_layout.dart`。
