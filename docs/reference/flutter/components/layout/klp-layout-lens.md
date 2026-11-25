# KlpLayoutLens

Flutter · Experimental · 布局元件

## 主要職責

顯示 layout、size、padding、gap 與 parent 關係，不推導文件狀態。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpLayoutLens createExample(String label, List<KlpLayoutDiagnosticData> diagnostics) => KlpLayoutLens(label: label, diagnostics: diagnostics);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpLayoutLens extends StatelessWidget
```

## 建構子 KlpLayoutLens



```dart
const KlpLayoutLens({
	Key? key,
	required String label,
	required List<KlpLayoutDiagnosticData> diagnostics,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `diagnostics` | `List<KlpLayoutDiagnosticData>` | 是 | — | 依公開型別提供此輸入。 |


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
- [KlpLayoutDiagnosticData](../../types/klp-layout-diagnostic-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/infinite_canvas/klp_canvas_workspace.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/infinite_canvas/klp_canvas_workspace.dart`。
