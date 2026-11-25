# KlpCommandMenu

Flutter · Experimental · 操作元件

## 主要職責

命令面板：分組的指令清單，存在的意義就是不用滑鼠也能操作。

*鍵盤**：`↓`／`↑` 在（跨分組攤平後的）項目間移動高亮，跳過
[KlpCommandItemData.onPressed] 為 `null`（停用）的項目，並在頭尾之間循環；
`Home`／`End` 跳到第一／最後一個可用項目；`Enter`／`Space` 觸發目前高亮的
項目；`Escape` 呼叫 [onEscape]。索引移動規則沿用 [KlpRovingIndex]，與
[KlpMenu]、[KlpCombobox] 共用同一套實作。

面板預設會在出現時自動取得鍵盤焦點（[autofocus]），因為命令面板通常是剛彈出
的 overlay。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpCommandMenu createExample(List<KlpCommandSectionData> sections) => KlpCommandMenu(sections: sections);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpCommandMenu extends StatefulWidget
```

## 建構子 KlpCommandMenu



```dart
const KlpCommandMenu({
	Key? key,
	required List<KlpCommandSectionData> sections,
	bool framed = true,
	bool autofocus = true,
	VoidCallback? onEscape,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `sections` | `List<KlpCommandSectionData>` | 是 | — | 產品投影的區段資料。 |
| `framed` | `bool` | 否 | true | 依公開型別提供此輸入。 |
| `autofocus` | `bool` | 否 | true | 是否在面板出現時自動取得鍵盤焦點。預設 `true`。 |
| `onEscape` | `void Function()?` | 否 | null | 按下 `Escape` 時呼叫，通常由呼叫端用來關閉面板；未提供時無效果。 |


## 成員與方法

### createState

```dart
State<KlpCommandMenu> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- [KlpCommandSectionData](../../types/klp-command-section-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/actions/command_menu/klp_command_menu.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/command_menu/klp_command_menu.dart`。
