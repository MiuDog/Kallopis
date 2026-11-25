# KlpFileExplorerItemView

Flutter · Stable · 工作區元件

## 主要職責

一般檔案項目視圖（含檔案圖示、文字標題、選取高亮與 Hover 回饋）。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpFileExplorerItemView createExample(KlpFileExplorerItem item, int level, bool isSelected, void Function() onTap) => KlpFileExplorerItemView(item: item, level: level, isSelected: isSelected, onTap: onTap);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpFileExplorerItemView extends StatefulWidget
```

## 建構子 KlpFileExplorerItemView



```dart
const KlpFileExplorerItemView({
	Key? key,
	required KlpFileExplorerItem item,
	required int level,
	required bool isSelected,
	required VoidCallback onTap,
	KlpFileExplorerSpacing spacing = KlpFileExplorerSpacing.standard,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `item` | `KlpFileExplorerItem` | 是 | — | 依公開型別提供此輸入。 |
| `level` | `int` | 是 | — | 依公開型別提供此輸入。 |
| `isSelected` | `bool` | 是 | — | 依公開型別提供此輸入。 |
| `onTap` | `void Function()` | 是 | — | 依公開型別提供此輸入。 |
| `spacing` | `KlpFileExplorerSpacing` | 否 | KlpFileExplorerSpacing.standard | 依公開型別提供此輸入。 |


## 成員與方法

### createState

```dart
State<KlpFileExplorerItemView> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- [KlpFileExplorerItem](../../types/klp-file-explorer-item.md)
- [KlpFileExplorerSpacing](../../types/klp-file-explorer-spacing.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/explorer/klp_file_explorer.dart`。
