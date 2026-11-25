# KlpComponentLibraryGrid

Flutter · Experimental · 布局元件

## 主要職責

元件定義的響應式預覽網格。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpComponentLibraryGrid createExample(List<KlpComponentDefinitionData> components) => KlpComponentLibraryGrid(components: components);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpComponentLibraryGrid extends StatelessWidget
```

## 建構子 KlpComponentLibraryGrid



```dart
const KlpComponentLibraryGrid({
	Key? key,
	required List<KlpComponentDefinitionData> components,
	ValueChanged<String>? onSelected,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `components` | `List<KlpComponentDefinitionData>` | 是 | — | 依公開型別提供此輸入。 |
| `onSelected` | `void Function(String)?` | 否 | null | 將選取意圖交回產品。 |


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
- [KlpComponentDefinitionData](../../types/klp-component-definition-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/artifact/klp_artifact_workspace.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/artifact/klp_artifact_workspace.dart`。
